#!/bin/bash
# Запуск AMA/Poolama-майнера на физических GPU 6–11 в screen "ama"

export RIG="NAME"
export SECRET="cryptoAMA"
export WALLET="7Y18PG1kYxnwuNajvxc5LpHS3WKdznFJNfbzC5PxZJNLu24UDBjpYfWAW34RjKnNza"
export CUDA_VISIBLE_DEVICES=6,7,8,9,10,11

GPU_BIN="/home/user/gpu"
LOG="/home/user/ama.log"

if [ ! -x "$GPU_BIN" ]; then
  echo "[!] Не найден исполняемый $GPU_BIN"
  echo "    Скачай его:  wget -O $GPU_BIN https://poolama.com/dl/gpu && chmod +x $GPU_BIN"
  exit 1
fi

# убиваем старую сессию, если была
if screen -list | grep -q "\.ama"; then
  screen -S ama -X quit || true
  sleep 1
fi

# стартуем в screen
screen -dmS ama bash -lc "nohup \"$GPU_BIN\" >> \"$LOG\" 2>&1"

echo "✅ Майнер запущен в screen 'ama'. Лог: $LOG"
echo "  Подключиться:  screen -r ama    | Выйти не останавливая: Ctrl+A D"
echo "  Смотреть лог:   tail -f $LOG"
