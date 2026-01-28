# transit — временный проброс RS-485 по TCP

`transit` — CLI-утилита для временного предоставления прямого TCP-доступа
к RS-485 устройствам (`/dev/ttyUSB*`) на Linux с эксклюзивной блокировкой порта.

Используется для отладки, диагностики и ручного доступа к оборудованию,
когда основной сервис уже работает с RS-485.

---

## Возможности

- Проброс `/dev/ttyUSB*` по TCP
- Эксклюзивная блокировка порта (`flock`)
- Управление через одну команду (`start / status / stop`)
- Работа через SSH
- Не требует пересборки сервисов

---

## Требования

- Ubuntu / Debian
- systemd
- root или sudo
- USB → RS-485 адаптеры (`/dev/ttyUSB*`)
- SSH-доступ к серверу

---

## Установка

### 1. Установка зависимостей

```bash
sudo apt update
sudo apt install -y socat util-linux
```

- `socat` — TCP ↔ Serial
- `flock` (util-linux) — блокировка порта

---

### 2. Установка `transit`

```bash
sudo wget -O /usr/local/bin/transit \
https://raw.githubusercontent.com/SnowWoolf/persay-update/main/transit

sudo chmod +x /usr/local/bin/transit
```

Проверка:

```bash
transit
```

---

## ВАЖНО: взаимодействие с основным RS-485 сервисом

Если на сервере работает сервис, который использует RS-485,
он **должен соблюдать блокировку `flock`**, иначе эксклюзивный доступ
гарантировать невозможно.

### Рекомендуемый вариант (через flock)

Пример `systemd` unit-файла:

```ini
ExecStart=/usr/bin/flock /var/lock/transit/ttyUSB3.lock /usr/bin/rs485-service
```

---

### systemd-сервис `rs485.service`

Скрипт `transit` пытается остановить сервис `rs485.service`, если он существует.

Если у вас **нет** такого сервиса, сообщение вида:

```text
Failed to stop rs485.service: Unit rs485.service not loaded.
```

**не является ошибкой** и не мешает работе транзита.

При необходимости:
- переименуйте сервис в скрипте
- или закомментируйте строки `systemctl stop/start`

---

## Использование

### Включить транзит

```bash
transit -ttyUSB3
```

Вывод:

```text
Включен транзитный режим RS485 на /dev/ttyUSB3
Доступ по <IP-адрес сервера>:777
```

---

### Проверить статус

```bash
transit -status
```

Пример:

```text
Включен транзитный режим RS485 на /dev/ttyUSB3.
Доступ по 192.168.0.10:777
```

---

### Отключить транзит

```bash
transit -stop
```

После этого:
- TCP-доступ закрыт
- порт освобождён
- основной сервис запущен обратно

---

## Подключение клиента

### Через `socat`

```bash
socat TCP:<server_ip>:777 -
```

---

### Через SCADA / Modbus / Serial-over-TCP ПО

Указать:
- IP сервера
- TCP порт: `777`

---

## Безопасность (рекомендуется)

### Вариант 1: только через SSH-туннель

Изменить `socat` на `bind=127.0.0.1` и подключаться через:

```bash
ssh -L 777:localhost:777 user@server
```

---

### Вариант 2: firewall

Ограничить доступ по IP:

```bash
iptables -A INPUT -p tcp --dport 777 -s <your_ip> -j ACCEPT
iptables -A INPUT -p tcp --dport 777 -j DROP
```

---

## Ограничения

- В один момент времени — один транзит на порт
- TCP-порт по умолчанию: `777`
- Блокировка работает только для процессов, использующих `flock`

---

## Устранение проблем

### Проверить, кто держит порт

```bash
lsof /dev/ttyUSB3
```

---

### Убить зависший транзит

```bash
sudo pkill socat
sudo rm -rf /run/transit/*
```

---

## Удаление

```bash
sudo rm /usr/local/bin/transit
sudo rm -rf /run/transit /var/lock/transit
```

---

## Идеи для развития

- параметр `--port`
- таймаут транзита
- поддержка нескольких портов
- systemd template: `transit@ttyUSB3.service`
- `.deb` пакет
- `man transit`

---

## Лицензия

MIT
