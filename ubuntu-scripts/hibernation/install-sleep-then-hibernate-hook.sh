#!/bin/bash
# =============================================================================
# Implementa "suspend then hibernate" via sleep hook do systemd.
# Necessário em ambientes GNOME, onde o gsd-power intercepta as ações de
# suspensão e não delega ao systemd-logind o suspend-then-hibernate nativo.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# PARÂMETROS
# -----------------------------------------------------------------------------
# Pode ser sobrescrito via variável de ambiente ao chamar este script,
# por exemplo: HIBERNATE_DELAY=900 bash install-sleep-then-hibernate-hook.sh
HIBERNATE_DELAY="${HIBERNATE_DELAY:-1800}"   # segundos em suspend antes de hibernar

# -----------------------------------------------------------------------------
# CORES
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()      { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERRO]${NC} $*"; }
section() { echo -e "\n${BOLD}${BLUE}==> $*${NC}"; }

# -----------------------------------------------------------------------------
# VERIFICAÇÕES INICIAIS
# -----------------------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    error "Este script precisa ser executado como root (use sudo)."
    exit 1
fi

if ! systemctl hibernate --dry-run &>/dev/null; then
    error "Hibernate não está habilitado. Execute enable-hibernation.sh primeiro."
    exit 1
fi

# -----------------------------------------------------------------------------
# SLEEP HOOK
# -----------------------------------------------------------------------------
section "Instalando sleep hook"

HOOK_FILE="/usr/lib/systemd/system-sleep/suspend-then-hibernate"
TIMESTAMP_FILE="/run/suspend-started-at"

cat > "$HOOK_FILE" <<EOF
#!/bin/bash
# Sleep hook: implementa suspend-then-hibernate para ambientes
# onde o gsd-power (GNOME) intercepta as ações antes do logind.

HIBERNATE_DELAY=${HIBERNATE_DELAY}
TIMESTAMP_FILE="${TIMESTAMP_FILE}"

case "\$1/\$2" in
    pre/suspend|pre/suspend-then-hibernate)
        # Registra o momento em que o suspend começou
        date +%s > "\$TIMESTAMP_FILE"
        # Programa alarme RTC para acordar o sistema após HIBERNATE_DELAY segundos.
        # O RTC continua funcionando mesmo com o sistema suspenso, ao contrário
        # de timers do systemd que ficam congelados durante o suspend.
        echo 0 > /sys/class/rtc/rtc0/wakealarm
        echo "+\${HIBERNATE_DELAY}" > /sys/class/rtc/rtc0/wakealarm
        logger -t suspend-then-hibernate "Suspend iniciado. Alarme RTC em \${HIBERNATE_DELAY}s."
        ;;

    post/suspend)
        # Ao acordar de um suspend simples, verifica quanto tempo ficou suspenso
        if [[ -f "\$TIMESTAMP_FILE" ]]; then
            STARTED_AT=\$(cat "\$TIMESTAMP_FILE")
            NOW=\$(date +%s)
            ELAPSED=\$(( NOW - STARTED_AT ))

            logger -t suspend-then-hibernate "Acordou após \${ELAPSED}s (limite: \${HIBERNATE_DELAY}s)."

            if [[ "\$ELAPSED" -ge "\$HIBERNATE_DELAY" ]]; then
                logger -t suspend-then-hibernate "Limite atingido. Hibernando..."
                # Dispara o hibernate fora do contexto do hook (evita conflito com suspend em andamento)
                systemd-run --no-block bash -c "sleep 3 && systemctl hibernate"
            fi
        fi
        ;;

    post/hibernate|post/suspend-then-hibernate)
        # Limpa o timestamp e cancela alarme RTC ao acordar do hibernate
        rm -f "\$TIMESTAMP_FILE"
        echo 0 > /sys/class/rtc/rtc0/wakealarm
        logger -t suspend-then-hibernate "Retornou do hibernate. Timestamp e alarme RTC removidos."
        ;;
esac
EOF

chmod +x "$HOOK_FILE"
ok "Hook instalado: ${HOOK_FILE}"
info "Delay configurado: ${HIBERNATE_DELAY}s"

# -----------------------------------------------------------------------------
# RESUMO
# -----------------------------------------------------------------------------
echo -e "
${BOLD}${BLUE}==> Resumo${NC}

${BOLD}Fluxo configurado:${NC}
  Sistema suspende (por qualquer motivo: tampa, inatividade, menu)
         ↓
     ${GREEN}SUSPEND${NC}  ← timestamp registrado em ${TIMESTAMP_FILE}
         ↓
  (acorda após ${HIBERNATE_DELAY}s = $(( HIBERNATE_DELAY / 60 ))min$(( HIBERNATE_DELAY % 60 ))s)
         ↓
    ${GREEN}HIBERNATE${NC}  ← se tempo suspenso >= ${HIBERNATE_DELAY}s
         ↓
  Liga → restaura do ponto que parou

${BOLD}Para testar:${NC}
  Suspenda o sistema e aguarde $((HIBERNATE_DELAY + 5))s — ele deve hibernar ao acordar.

${BOLD}Para monitorar:${NC}
  journalctl -f -t suspend-then-hibernate

${BOLD}Para ajustar o delay:${NC}
  Edite HIBERNATE_DELAY neste script e execute novamente.

${BOLD}Para remover:${NC}
  sudo rm ${HOOK_FILE}
"

ok "Concluído!"