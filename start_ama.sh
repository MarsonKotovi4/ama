#!/bin/bash
# -------------------------------
#  AMA Miner manual start script
#  Без screen, без автозапуска
# -------------------------------

# Настройки
export RIG="NAME"
export SECRET="cryptoAMA"
export WALLET="7Y18PG1kYxnwuNajvxc5LpHS3WKdznFJNfbzC5PxZJNLu24UDBjpYfWAW34RjKnNza"

# Указываем какие карты использовать
export CUDA_VISIBLE_DEVICES=6,7,8,9,10,11

# Пути
WORKDIR="/home/user/ama_miner"
GPU_BIN="$WORKDIR/gpu"
LOG="$WORKDIR/ama.log"

# Проверяем, существует ли бинарь
if [ ! -x "$GPU_BIN" ]; then
  echo "[!] Не найден исполняемый файл $GPU_BIN"
  echo "    Скачай его командой:"
  echo "    wget -O $GPU_BIN https://poolama.com/dl/gpu && chmod +x $GPU_BIN"
  exit 1
fi

# Если уже запущен — останавливаем
if pgrep -f "$GPU_BIN" > /dev/null; then
  echo "[i] Уже запущен процесс майнера, останавливаем старый..."
  pkill -f "$GPU_BIN"
  sleep 2
fi

# Запуск майнера в фоне без screen
echo "[+] Запускаем AMA майнер..."
nohup "$GPU_BIN" > "$LOG" 2>&1 &

PID=$!
sleep 1

if ps -p $PID > /dev/null; then
  echo "✅ Майнер успешно запущен (PID $PID)"
  echo "   Лог: $LOG"
  echo "   Чтобы проверить: tail -f $LOG"
else
  echo "❌ Ошибка: процесс не запущен. Проверь $LOG"
fi
