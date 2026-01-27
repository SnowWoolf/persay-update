# Andromeda SMART — установка и обновление

Все команды выполняются **по SSH от имени `root`**.

---

## Первоначальная установка

Подключиться по SSH и выполнить 1 команду:
```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/andromeda-update/main/install_andromeda.sh | bash
```

---

## Обновление

### 1. Скачивание скрипта обновления

Этот шаг необходим **только если команда `andromeda-update` не работает**.

Если первоначальная установка выполнялась скриптом выше  
или система уже обновлялась ранее, выполнять этот шаг **не нужно**.

```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/andromeda-update/main/andromeda-update \
-o /usr/local/bin/andromeda-update && chmod +x /usr/local/bin/andromeda-update
```

---

### 2. Запуск обновления

```bash
andromeda-update
```
