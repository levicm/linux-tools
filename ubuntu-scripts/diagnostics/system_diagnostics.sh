#!/bin/bash

# Script de Diagnóstico de Performance do Sistema
# Uso: sudo ./system_diagnostics.sh

OUTPUT_FILE="diagnostico_$(hostname)_$(date +%Y%m%d_%H%M%S).txt"

echo "========================================" | tee "$OUTPUT_FILE"
echo "DIAGNÓSTICO DE PERFORMANCE DO SISTEMA" | tee -a "$OUTPUT_FILE"
echo "========================================" | tee -a "$OUTPUT_FILE"
echo "Data: $(date)" | tee -a "$OUTPUT_FILE"
echo "Hostname: $(hostname)" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Informações do Sistema
echo "=== INFORMAÇÕES DO SISTEMA ===" | tee -a "$OUTPUT_FILE"
echo "Versão do Ubuntu:" | tee -a "$OUTPUT_FILE"
lsb_release -a 2>/dev/null | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Kernel:" | tee -a "$OUTPUT_FILE"
uname -r | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# CPU
echo "=== INFORMAÇÕES DE CPU ===" | tee -a "$OUTPUT_FILE"
echo "Modelo da CPU:" | tee -a "$OUTPUT_FILE"
lscpu | grep "Model name" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Uso de CPU (top 20 processos):" | tee -a "$OUTPUT_FILE"
ps aux --sort=-%cpu | head -21 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Load Average:" | tee -a "$OUTPUT_FILE"
uptime | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Memória
echo "=== MEMÓRIA ===" | tee -a "$OUTPUT_FILE"
free -h | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Top 20 processos por uso de memória:" | tee -a "$OUTPUT_FILE"
ps aux --sort=-%mem | head -21 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Swap
echo "=== SWAP ===" | tee -a "$OUTPUT_FILE"
swapon --show | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Swappiness:" | tee -a "$OUTPUT_FILE"
cat /proc/sys/vm/swappiness | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Disco
echo "=== DISCO E I/O ===" | tee -a "$OUTPUT_FILE"
echo "Uso de disco:" | tee -a "$OUTPUT_FILE"
df -h | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "I/O stats (se disponível):" | tee -a "$OUTPUT_FILE"
if command -v iostat &> /dev/null; then
    iostat -x 1 3 | tee -a "$OUTPUT_FILE"
else
    echo "iostat não instalado. Instale com: sudo apt install sysstat" | tee -a "$OUTPUT_FILE"
fi
echo "" | tee -a "$OUTPUT_FILE"

# Processos Trend Micro
echo "=== PROCESSOS TREND MICRO ===" | tee -a "$OUTPUT_FILE"
ps aux | grep -i trend | grep -v grep | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Serviços Trend Micro:" | tee -a "$OUTPUT_FILE"
systemctl list-units | grep -i trend | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Processos em geral
echo "=== ESTATÍSTICAS DE PROCESSOS ===" | tee -a "$OUTPUT_FILE"
echo "Total de processos:" | tee -a "$OUTPUT_FILE"
ps aux | wc -l | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Processos em estado D (uninterruptible sleep):" | tee -a "$OUTPUT_FILE"
ps aux | awk '$8 ~ /D/ {print}' | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Context switches e interrupts
echo "=== CONTEXT SWITCHES E INTERRUPTS ===" | tee -a "$OUTPUT_FILE"
if [ -f /proc/stat ]; then
    grep -E "^(ctxt|intr)" /proc/stat | tee -a "$OUTPUT_FILE"
fi
echo "" | tee -a "$OUTPUT_FILE"

# Tempo de boot
echo "=== TEMPO DE BOOT ===" | tee -a "$OUTPUT_FILE"
systemd-analyze | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"
echo "Serviços mais lentos na inicialização:" | tee -a "$OUTPUT_FILE"
systemd-analyze blame | head -20 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Módulos do kernel carregados
echo "=== MÓDULOS DO KERNEL ===" | tee -a "$OUTPUT_FILE"
echo "Número de módulos carregados:" | tee -a "$OUTPUT_FILE"
lsmod | wc -l | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Logs do kernel (últimas 50 linhas)
echo "=== LOGS DO KERNEL (últimas 50 linhas) ===" | tee -a "$OUTPUT_FILE"
dmesg | tail -50 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Verificar journalctl por erros recentes
echo "=== ERROS RECENTES (journalctl) ===" | tee -a "$OUTPUT_FILE"
journalctl -p err -b --no-pager | tail -30 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Temperatura (se disponível)
echo "=== TEMPERATURA ===" | tee -a "$OUTPUT_FILE"
if command -v sensors &> /dev/null; then
    sensors | tee -a "$OUTPUT_FILE"
else
    echo "sensors não instalado. Instale com: sudo apt install lm-sensors" | tee -a "$OUTPUT_FILE"
fi
echo "" | tee -a "$OUTPUT_FILE"

# Network
echo "=== ESTATÍSTICAS DE REDE ===" | tee -a "$OUTPUT_FILE"
netstat -s | head -50 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Configurações de escalonamento de CPU
echo "=== ESCALONADOR DE CPU ===" | tee -a "$OUTPUT_FILE"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | sort | uniq -c | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Verificar se há processos de antivírus escaneando
echo "=== ATIVIDADE DE SCAN (lsof) ===" | tee -a "$OUTPUT_FILE"
echo "Arquivos abertos por processos Trend (amostra):" | tee -a "$OUTPUT_FILE"
lsof 2>/dev/null | grep -i trend | head -30 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Resumo de performance em tempo real (5 segundos)
echo "=== SNAPSHOT DE PERFORMANCE (5 segundos) ===" | tee -a "$OUTPUT_FILE"
echo "Coletando dados em tempo real..." | tee -a "$OUTPUT_FILE"
top -b -n 2 -d 2 | head -50 | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

echo "========================================" | tee -a "$OUTPUT_FILE"
echo "Diagnóstico completo salvo em: $OUTPUT_FILE" | tee -a "$OUTPUT_FILE"
echo "========================================" | tee -a "$OUTPUT_FILE"

# Criar um resumo comparativo
echo "" | tee -a "$OUTPUT_FILE"
echo "=== RESUMO RÁPIDO ===" | tee -a "$OUTPUT_FILE"
echo "CPU Load: $(uptime | awk -F'load average:' '{print $2}')" | tee -a "$OUTPUT_FILE"
echo "Memória usada: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')" | tee -a "$OUTPUT_FILE"
echo "Swap usado: $(free -h | awk '/^Swap:/ {print $3 "/" $2}')" | tee -a "$OUTPUT_FILE"
echo "Processos Trend ativos: $(ps aux | grep -i trend | grep -v grep | wc -l)" | tee -a "$OUTPUT_FILE"
echo "Total de processos: $(ps aux | wc -l)" | tee -a "$OUTPUT_FILE"
