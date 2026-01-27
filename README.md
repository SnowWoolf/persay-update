# Andromeda SMART — установка и обновление

Все команды выполняются **по SSH от имени `root`**.

---

## Первоначальная установка

Подключиться по SSH и выполнить 1 команду:
```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/persay-update/main/install_persay.sh | bash
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
