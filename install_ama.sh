#!/bin/bash
set -e
echo "=== AMA miner clean installer ==="

WORKDIR="/home/user/ama_miner"
BIN_URL="https://poolama.com/dl/gpu"
START_URL="https://raw.githubusercontent.com/MarsonKotovi4/ama/refs/heads/main/start_ama.sh"

mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "[+] Рабочая папка: $WORKDIR"

echo "[+] Скачиваем бинарь..."
wget -O gpu "$BIN_URL"
chmod +x gpu

echo "[+] Скачиваем стартовый скрипт..."
wget -O start_ama.sh "$START_URL"
chmod +x start_ama.sh

echo "✅ Установка завершена. Запуск вручную: cd $WORKDIR && ./start_ama.sh"
