#!/bin/bash
# Установка AMA майнера в /home/user/ama_miner + автозапуск

set -e

echo "=== AMA miner full installer ==="

# --- Пути и ссылки ---
WORKDIR="/home/user/ama_miner"
BIN_URL="https://poolama.com/dl/gpu"
START_URL="https://raw.githubusercontent.com/MarsonKotovi4/ama/refs/heads/main/start_ama.sh"
SERVICE_FILE="/etc/systemd/system/ama_autostart.service"

# --- 1. Создаём директорию ---
mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "[+] Рабочая папка: $WORKDIR"

# --- 2. Скачиваем бинарь ---
if [ ! -f "$WORKDIR/gpu" ]; then
  echo "[+] Скачиваем бинарь майнера..."
  wget -O gpu "$BIN_URL"
  chmod +x gpu
else
  echo "[i] Бинарь уже существует, пропускаем."
fi

# --- 3. Скачиваем стартовый скрипт ---
echo "[+] Скачиваем start_ama.sh..."
wget -O start_ama.sh "$START_URL"
chmod +x start_ama.sh

# --- 4. Создаём systemd unit ---
echo "[+] Создаём systemd unit..."

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=AMA miner autostart
After=network.target

[Service]
Type=forking
ExecStart=$WORKDIR/start_ama.sh
Restart=always
User=root
WorkingDirectory=$WORKDIR

[Install]
WantedBy=multi-user.target
EOF

# --- 5. Перезагружаем и активируем сервис ---
echo "[+] Активируем сервис автозапуска..."
systemctl daemon-reload
systemctl enable ama_autostart.service
systemctl restart ama_autostart.service

echo "✅ Установка завершена!"
echo "Файлы: $WORKDIR"
echo "Проверка статуса: systemctl status ama_autostart"
echo "Лог: tail -f $WORKDIR/ama.log"
