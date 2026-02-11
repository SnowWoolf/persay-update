# SMART PERSAY — установка и обновление

Все команды выполняются **по SSH от имени `root`**.

---

## Первоначальная установка

Подключиться по SSH и выполнить 1 команду:
```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/persay-update/main/install_persay.sh | bash
```

### Дополнительно: установить MQTT-брокер:
```bash
apt install mosquitto
```
Открываем брокеру дыру в сеть:
```bash
rm /etc/mosquitto/conf.d/10-localhost-only.conf
nano /etc/mosquitto/conf.d/20-external.conf

Вставить строки:
    listener 1883
    allow_anonymous true

systemctl restart mosquitto
```

Проверка статуса (должен быть active (running)):
```bash
systemctl status mosquitto
```
Проверяем: mosquitto слушает порт 1883
```bash
ss -lntp | grep 1883
```
---

## Обновление

### 1. Скачивание скрипта обновления

Этот шаг необходим **только если команда `persay-update` не работает**.

Если первоначальная установка выполнялась скриптом выше  
или система уже обновлялась ранее, выполнять этот шаг **не нужно**.

```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/persay-update/main/persay-update \
-o /usr/local/bin/persay-update && chmod +x /usr/local/bin/persay-update
```

---

### 2. Запуск обновления

```bash
persay-update
```

---

## Замена `config.yaml`

### 📥 Копирование `config.yaml` с УМ на ПК

Запустить **PowerShell**:

    scp root@192.168.0.1:/home/persay/config.yaml C:\PersayConf

Ввести пароль пользователя `root`.  
Файл будет сохранён в:

    C:\PersayConf\config.yaml

### 📤 Копирование `config.yaml` с ПК на УМ

Запустить **PowerShell**:

    scp C:\PersayConf\config.yaml root@192.168.0.1:/home/persay/

Ввести пароль пользователя `root`.  
Файл будет загружен в:

    /home/persay/config.yaml

Для применения нового конфига необходимо перезапустить сервис (кнопкой в веб-интерфейсе)



##Читать журнал сервиса:
```
journalctl -u persay -f
```

