#!/bin/bash
set -e

APP_DIR="/home/persay"
REPO_URL="https://github.com/s-nosonov-chernomor/andromeda_SMART.git"
SERVICE_FILE="/etc/systemd/system/andromeda.service"
UPDATE_URL="https://raw.githubusercontent.com/SnowWoolf/andromeda-update/main/andromeda-update"
UPDATE_BIN="/usr/local/bin/andromeda-update"

echo "[INFO] Установка системных пакетов"
apt update
apt install -y git curl python3 python3-venv python3-pip

echo "[INFO] Создание директории приложения"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

if [ ! -d ".git" ]; then
  echo "[INFO] Клонирование репозитория"
  git clone "$REPO_URL" .
else
  echo "[INFO] Репозиторий уже существует, пропуск клонирования"
fi

echo "[INFO] Создание виртуального окружения"
python3 -m venv venv

echo "[INFO] Установка Python-зависимостей"
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt

if [ ! -f "$APP_DIR/config.yaml" ]; then
  echo "[INFO] config.yaml не найден, создаём пустой"
  touch "$APP_DIR/config.yaml"
fi

echo "[INFO] Установка systemd-сервиса"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Andromeda SMART
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/persay
ExecStart=/home/persay/venv/bin/python run.py
Restart=always
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

echo "[INFO] Перезагрузка systemd"
systemctl daemon-reexec
systemctl daemon-reload

echo "[INFO] Включение сервиса Andromeda"
systemctl enable andromeda

ech
