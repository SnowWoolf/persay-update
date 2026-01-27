**Первоначальная установка:**
```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/andromeda-update/main/install_andromeda.sh | bash
```



**Обновление:**

**1. Подключиться по SSH от имени root**

**2. Скачать скрипт обновления:**
Этот шаг необходим только если команда andromeda-update не работает!
Если первоначальная установка производилась скриптом (см. выше), или Персей уже обновлялся ранее скриптом обновления, то выполнять этот шаг не надо.

```bash
curl -fsSL https://raw.githubusercontent.com/SnowWoolf/andromeda-update/main/andromeda-update \
-o /usr/local/bin/andromeda-update && chmod +x /usr/local/bin/andromeda-update
```

**3. Запустить обновление:**
```bash
sudo andromeda-update
```
