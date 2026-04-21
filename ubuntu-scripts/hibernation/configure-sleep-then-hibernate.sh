#!/bin/bash
# =============================================================================
# configure-sleep-then-hibernate.sh
# Configura "Suspend then Hibernate" em distros Ubuntu/Debian-based
# Suporta: GNOME, KDE Plasma (PowerDevil), e configuração base via systemd
# Pré-requisito: hibernate já habilitado (swap configurada, etc.)
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# PARÂMETROS (edite conforme sua preferência)
# -----------------------------------------------------------------------------
HIBERNATE_DELAY=1800    # segundos antes de hibernar após suspend (30 minutos)

# Para GNOME: tempo de inatividade antes de suspender (em segundos)
GNOME_IDLE_AC=1800      # 30 minutos na tomada
GNOME_IDLE_BATTERY=900  # 15 minutos na bateria

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
require_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Este script precisa ser executado como root (use sudo)."
        exit 1
    fi
}

detect_environment() {
    section "Detectando ambiente"

    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        info "Distro: ${NAME:-Desconhecida} ${VERSION_ID:-?}"
    fi

    DE="${XDG_CURRENT_DESKTOP:-}"
    if [[ -z "$DE" ]]; then
        pgrep -x "plasmashell" &>/dev/null && DE="KDE" || true
        pgrep -x "gnome-shell" &>/dev/null && DE="GNOME" || true
    fi
    DE="${DE,,}"
    info "Desktop Environment: ${DE:-não detectado}"

    HAS_POWERDEVIL=false
    if command -v plasma-powerdevil &>/dev/null \
    || [[ -f "/usr/lib/x86_64-linux-gnu/libexec/org_kde_powerdevil" ]] \
    || [[ -f "/usr/libexec/org_kde_powerdevil" ]]; then
        HAS_POWERDEVIL=true
    fi
    info "PowerDevil (KDE): ${HAS_POWERDEVIL}"

    HAS_GNOME=false
    if command -v gsettings &>/dev/null && [[ "$DE" == *"gnome"* ]]; then
        HAS_GNOME=true
    fi
    info "GNOME settings: ${HAS_GNOME}"

    REAL_USER="${SUDO_USER:-${USER}}"
    REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
    info "Usuário: ${REAL_USER} (home: ${REAL_HOME})"
}

# -----------------------------------------------------------------------------
# CONFIGURAÇÃO DO SYSTEMD SLEEP
# -----------------------------------------------------------------------------
configure_systemd_sleep() {
    section "Configurando systemd-sleep"

    CONF_DIR="/etc/systemd/sleep.conf.d"
    CONF_FILE="${CONF_DIR}/suspend-then-hibernate.conf"

    # Verifica se as chaves relevantes já estão ativas (descomentadas) em qualquer lugar
    ALREADY_CONFIGURED=true
    for key in AllowSuspendThenHibernate HibernateDelaySec; do
        if ! grep -rh "^${key}=" /etc/systemd/sleep.conf /etc/systemd/sleep.conf.d/ 2>/dev/null | grep -q .; then
            ALREADY_CONFIGURED=false
            break
        fi
    done

    if [[ "$ALREADY_CONFIGURED" == "true" ]]; then
        CURRENT_DELAY=$(grep -rh "^HibernateDelaySec=" /etc/systemd/sleep.conf /etc/systemd/sleep.conf.d/ 2>/dev/null | tail -1 | cut -d= -f2)
        if [[ "$CURRENT_DELAY" == "$HIBERNATE_DELAY" ]]; then
            ok "sleep.conf já configurado corretamente (HibernateDelaySec=${HIBERNATE_DELAY}). Nada a fazer."
            return
        else
            info "Configuração encontrada, mas HibernateDelaySec=${CURRENT_DELAY}. Atualizando para ${HIBERNATE_DELAY}."
        fi
    fi

    mkdir -p "$CONF_DIR"
    cat > "$CONF_FILE" <<EOF
# Gerado por configure-sleep.sh
[Sleep]
AllowSuspend=yes
AllowHibernation=yes
AllowSuspendThenHibernate=yes
AllowHybridSleep=yes
HibernateDelaySec=${HIBERNATE_DELAY}
EOF

    ok "Criado: ${CONF_FILE} (delay: ${HIBERNATE_DELAY}s = $(( HIBERNATE_DELAY / 60 )) min)"
}

# -----------------------------------------------------------------------------
# CONFIGURAÇÃO DO LOGIND (tampa, botão de energia)
# -----------------------------------------------------------------------------
configure_logind() {
    section "Configurando systemd-logind"

    CONF_DIR="/etc/systemd/logind.conf.d"
    CONF_FILE="${CONF_DIR}/suspend-then-hibernate.conf"

    # Verifica se já está configurado corretamente
    if grep -rh "^HandleLidSwitch=suspend-then-hibernate" /etc/systemd/logind.conf /etc/systemd/logind.conf.d/ 2>/dev/null | grep -q .; then
        ok "logind.conf já configurado corretamente. Nada a fazer."
        return
    fi

    mkdir -p "$CONF_DIR"
    cat > "$CONF_FILE" <<EOF
# Gerado por configure-sleep.sh
[Login]
HandleLidSwitch=suspend-then-hibernate
HandleLidSwitchExternalPower=suspend-then-hibernate
HandleLidSwitchDocked=ignore
HandleSuspendKey=suspend-then-hibernate
EOF

    ok "Criado: ${CONF_FILE}"
    warn "As configurações do logind entram em vigor após reiniciar o sistema."
}

# -----------------------------------------------------------------------------
# CONFIGURAÇÃO KDE / POWERDEVIL
# -----------------------------------------------------------------------------
configure_kde() {
    section "Configurando KDE PowerDevil"

    POWERDEVIL_RC="${REAL_HOME}/.config/powerdevilrc"
    [[ -f "$POWERDEVIL_RC" ]] && cp "$POWERDEVIL_RC" "${POWERDEVIL_RC}.bak" && info "Backup: ${POWERDEVIL_RC}.bak"

    touch "$POWERDEVIL_RC"

    set_kde_key() {
        local section="$1" key="$2" value="$3"
        if grep -q "^\[${section}\]" "$POWERDEVIL_RC" 2>/dev/null; then
            if grep -A5 "^\[${section}\]" "$POWERDEVIL_RC" | grep -q "^${key}="; then
                sed -i "/^\[${section}\]/,/^\[/ s/^${key}=.*/${key}=${value}/" "$POWERDEVIL_RC"
            else
                sed -i "/^\[${section}\]/ a ${key}=${value}" "$POWERDEVIL_RC"
            fi
        else
            printf '\n[%s]\n%s=%s\n' "$section" "$key" "$value" >> "$POWERDEVIL_RC"
        fi
    }

    set_kde_key "AC][SuspendAndShutdown"        "SleepMode" "3"
    set_kde_key "Battery][SuspendAndShutdown"    "SleepMode" "3"
    set_kde_key "LowBattery][SuspendAndShutdown" "SleepMode" "3"

    chown "${REAL_USER}:${REAL_USER}" "$POWERDEVIL_RC"
    ok "powerdevilrc: SleepMode=3 definido para AC, Battery e LowBattery."

    sudo -u "$REAL_USER" systemctl --user restart plasma-powerdevil 2>/dev/null \
        && ok "plasma-powerdevil reiniciado." \
        || warn "Não foi possível reiniciar plasma-powerdevil (normal se a sessão não estiver ativa)."
}

# -----------------------------------------------------------------------------
# CONFIGURAÇÃO GNOME
# -----------------------------------------------------------------------------
configure_gnome() {
    section "Configurando GNOME"

    run_gsettings() {
        sudo -u "$REAL_USER" \
            DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u "$REAL_USER")/bus" \
            gsettings "$@"
    }

    run_gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type        'suspend'
    run_gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type   'suspend'
    run_gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout      "${GNOME_IDLE_AC}"
    run_gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout "${GNOME_IDLE_BATTERY}"
    run_gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action      'suspend' 2>/dev/null || true
    run_gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'suspend' 2>/dev/null || true

    ok "GNOME configurado: idle ${GNOME_IDLE_BATTERY}s bateria / ${GNOME_IDLE_AC}s tomada."
    info "O suspend-then-hibernate é gerenciado pelo systemd-logind, não pelo GNOME."
}

# -----------------------------------------------------------------------------
# RESUMO FINAL
# -----------------------------------------------------------------------------
print_summary() {
    section "Resumo"
    echo -e "
${BOLD}Fluxo configurado:${NC}
  Tampa fecha / inatividade
         ↓
     ${GREEN}SUSPEND${NC}
         ↓
  (${HIBERNATE_DELAY}s = $(( HIBERNATE_DELAY / 60 )) minutos)
         ↓
    ${GREEN}HIBERNATE${NC}
         ↓
  Liga → restaura do ponto que parou

${YELLOW}⚠ Reinicie o sistema${NC} para que as configurações do logind
  (tampa, botão de energia) entrem em vigor.

${BOLD}Para testar após reiniciar:${NC}
  sudo systemctl suspend-then-hibernate

${BOLD}Para ajustar o delay:${NC}
  Edite HIBERNATE_DELAY no topo deste script e execute novamente, ou:
  sudo nano /etc/systemd/sleep.conf.d/suspend-then-hibernate.conf
"
}

# -----------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------
main() {
    echo -e "${BOLD}${BLUE}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║       configure-sleep.sh — Suspend then Hibernate    ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    require_root
    detect_environment
    configure_systemd_sleep
    configure_logind

    [[ "$HAS_POWERDEVIL" == "true" ]] && configure_kde   || info "PowerDevil não detectado — pulando configuração KDE."
    [[ "$HAS_GNOME"      == "true" ]] && configure_gnome || info "GNOME não detectado — pulando configuração GNOME."

    print_summary
    ok "Concluído!"
}

main "$@"