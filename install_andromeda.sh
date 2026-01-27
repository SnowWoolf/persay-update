#!/bin/bash
set -e

APP_DIR="/home/persay"
REPO_URL="https://github.com/s-nosonov-chernomor/andromeda_SMART.git"
SERVICE_FILE="/etc/systemd/system/andromeda.service"

echo "[INFO] Install system packages"
apt update
apt install -y git python3 python3-venv python3-pip

echo "[INFO] Create application directory"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

echo "[INFO] Clone repository"
git clone "$REPO_URL" .
 
echo "[INFO] Create virtual environment"
python3 -m venv venv

echo "[INFO] Install python dependencies"
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt

if [ ! -f "$APP_DIR/config.yaml" ]; then
  echo "[INFO] config.yaml not found, create empty file"
  touch "$APP_DIR/config.yaml"
fi

echo "[INFO] Create systemd service"

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

echo "[INFO] Reload systemd"
systemctl daemon-reexec
systemctl daemon-reload

echo "[INFO] Enable Andromeda service"
systemctl enable andromeda

echo "[INFO] Start Andromeda service"
systemctl start andromeda

echo "[OK] Andromeda installation completed"
