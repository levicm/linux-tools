#!/bin/bash

# Script de Comparação entre Diagnósticos
# Uso: ./compare_diagnostics.sh diagnostico_maquina1.txt diagnostico_maquina2.txt

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <diagnostico_ubuntu_24.04.txt> <diagnostico_ubuntu_25.10.txt>"
    exit 1
fi

FILE1="$1"
FILE2="$2"

if [ ! -f "$FILE1" ] || [ ! -f "$FILE2" ]; then
    echo "Erro: Um ou ambos os arquivos não existem"
    exit 1
fi

OUTPUT="comparacao_$(date +%Y%m%d_%H%M%S).txt"

echo "========================================" | tee "$OUTPUT"
echo "COMPARAÇÃO DE DIAGNÓSTICOS" | tee -a "$OUTPUT"
echo "========================================" | tee -a "$OUTPUT"
echo "Arquivo 1 (24.04): $FILE1" | tee -a "$OUTPUT"
echo "Arquivo 2 (25.10): $FILE2" | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Função para extrair valor
extract_value() {
    local file="$1"
    local pattern="$2"
    grep "$pattern" "$file" | head -1
}

# Comparar Load Average
echo "=== LOAD AVERAGE ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
extract_value "$FILE1" "load average" | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
extract_value "$FILE2" "load average" | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Comparar uso de memória
echo "=== USO DE MEMÓRIA ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
grep "^Mem:" "$FILE1" | head -1 | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
grep "^Mem:" "$FILE2" | head -1 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Comparar SWAP
echo "=== USO DE SWAP ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
grep "^Swap:" "$FILE1" | head -1 | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
grep "^Swap:" "$FILE2" | head -1 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Comparar número de processos
echo "=== NÚMERO DE PROCESSOS ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
grep "Total de processos:" "$FILE1" | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
grep "Total de processos:" "$FILE2" | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Processos Trend Micro
echo "=== PROCESSOS TREND MICRO ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
grep "Processos Trend ativos:" "$FILE1" | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
grep "Processos Trend ativos:" "$FILE2" | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Tempo de boot
echo "=== TEMPO DE BOOT ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
grep -A 1 "TEMPO DE BOOT" "$FILE1" | grep -v "TEMPO DE BOOT" | head -1 | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
grep -A 1 "TEMPO DE BOOT" "$FILE2" | grep -v "TEMPO DE BOOT" | head -1 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Top 10 processos por CPU
echo "=== TOP 10 PROCESSOS POR CPU ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
awk '/Uso de CPU \(top 20 processos\)/,/^$/' "$FILE1" | head -12 | tail -10 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
awk '/Uso de CPU \(top 20 processos\)/,/^$/' "$FILE2" | head -12 | tail -10 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Top 10 processos por memória
echo "=== TOP 10 PROCESSOS POR MEMÓRIA ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
awk '/Top 20 processos por uso de memória/,/^$/' "$FILE1" | head -12 | tail -10 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
awk '/Top 20 processos por uso de memória/,/^$/' "$FILE2" | head -12 | tail -10 | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Context switches
echo "=== CONTEXT SWITCHES ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
grep "^ctxt" "$FILE1" | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
grep "^ctxt" "$FILE2" | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

# Erros recentes
echo "=== CONTAGEM DE ERROS RECENTES ===" | tee -a "$OUTPUT"
echo "Ubuntu 24.04:" | tee -a "$OUTPUT"
awk '/ERROS RECENTES/,/^==/' "$FILE1" | grep -v "^==" | wc -l | awk '{print "Linhas de erro: " $1}' | tee -a "$OUTPUT"
echo "Ubuntu 25.10:" | tee -a "$OUTPUT"
awk '/ERROS RECENTES/,/^==/' "$FILE2" | grep -v "^==" | wc -l | awk '{print "Linhas de erro: " $1}' | tee -a "$OUTPUT"
echo "" | tee -a "$OUTPUT"

echo "========================================" | tee -a "$OUTPUT"
echo "Comparação salva em: $OUTPUT" | tee -a "$OUTPUT"
echo "========================================" | tee -a "$OUTPUT"
