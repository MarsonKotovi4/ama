#!/bin/bash
# Установка AMA-майнера в /home/user/ama_miner + автозапуск (systemd)

set -e
echo "=== AMA miner full installer ==="

WORKDIR="/home/user/ama_miner"
BIN_URL="https://poolama.com/dl/gpu"
START_URL="https://raw.githubusercontent.com/MarsonKotovi4/ama/refs/heads/main/start_ama.sh"
SERVICE_FILE="/etc/systemd/system/ama_autostart.service"

mkdir -p "$WORKDIR"
cd "$WORKDIR"
echo "[+] Рабочая папка: $WORKDIR"

# 1. Бинарь
if [ ! -f "$WORKDIR/gpu" ]; then
  echo "[+] Скачиваем бинарь майнера..."
  wget -O gpu "$BIN_URL"
  chmod +x gpu
else
  echo "[i] Бинарь уже существует, пропускаем."
fi

# 2. Скрипт старта
echo "[+] Скачиваем start_ama.sh..."
wget -O start_ama.sh "$START_URL"
chmod +x start_ama.sh

# 3. systemd unit
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

# 4. Активация автозапуска
echo "[+] Активируем сервис..."
systemctl daemon-reload
systemctl enable ama_autostart.service
systemctl restart ama_autostart.service

echo "✅ Установка завершена."
echo " Проверить: systemctl status ama_autostart"
echo " Лог: tail -f $WORKDIR/ama.log"
