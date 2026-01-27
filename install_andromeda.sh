#!/bin/bash
set -e

APP_DIR="/home/persay"
REPO_URL="https://github.com/s-nosonov-chernomor/andromeda_SMART.git"
SERVICE_FILE="/etc/systemd/system/andromeda.service"

UPDATE_URL="https://raw.githubusercontent.com/SnowWoolf/andromeda-update/main/andromeda-update"
UPDATE_BIN="/usr/local/bin/andromeda-update"

REQUIRED_PACKAGES="git curl python3 python3-venv python3-pip"

echo "[INFO] Проверка системы"

# Проверка на root
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Скрипт должен быть запущен от root"
  exit 1
fi

# Проверка битых пакетов
if dpkg --audit | grep -q .; then
  echo "[WARN] В системе есть незавершенные или битые пакеты:"
  dpkg --audit
  echo "[WARN] Рекомендуется выполнить: apt --fix-broken install"
fi

echo "[INFO] Проверка и установка необходимых пакетов"

for pkg in $REQUIRED_PACKAGES; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "[INFO] Пакет уже установлен: $pkg"
  else
    echo "[INFO] Установка пакета: $pkg"
    apt update
    apt install -y "$pkg"
  fi
done

echo "[INFO] Подготовка директории приложения"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

if [ ! -d ".git" ]; then
  echo "[INFO] Клонирование репозитория Andromeda"
  git clone "$REPO_URL" .
else
  echo "[INFO] Репозиторий уже существует, пропуск клонирования"
fi

echo "[INFO] Создание виртуального окружения Python"
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

echo "[INFO] Установка Python-зависимостей"
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt

if [ ! -f "$APP_DIR/config.yaml" ]; then
  echo "[INFO] config.yaml не найден, создаём пустой файл"
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

echo "[INFO] Запуск сервиса Andromeda"
systemctl restart andromeda

echo "[INFO] Установка команды andromeda-update"
if [ ! -x "$UPDATE_BIN" ]; then
  curl -fsSL "$UPDATE_URL" -o "$UPDATE_BIN"
  chmod +x "$UPDATE_BIN"
else
  echo "[INFO] andromeda-update уже установлен"
fi

echo "[OK] Установка Andromeda SMART завершена успешно"
echo "[OK] Для обновления используйте команду: andromeda-update"
