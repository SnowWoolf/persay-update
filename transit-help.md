# transit — быстрый доступ к RS-485 по TCP

Утилита `transit` позволяет временно открыть прямой доступ к устройству  
`/dev/ttyUSB*` по сети (TCP), автоматически приостанавливая мешающие сервисы.

Подходит для диагностики и отладки оборудования по SSH.

---

## Быстрая установка

Подключитесь к серверу по SSH и выполните команды:

### 1. Установка зависимостей

```bash
sudo apt update
sudo apt install -y socat ca-certificates wget
```

---

### 2. Загрузка скрипта

```bash
sudo wget -O /usr/local/bin/transit \
https://raw.githubusercontent.com/SnowWoolf/persay-update/main/transit
```

---

### 3. Сделать исполняемым

```bash
sudo chmod +x /usr/local/bin/transit
```

---

### 4. Проверка

```bash
transit
```

Если всё установлено правильно — появится краткая справка.

---

## Как узнать имя порта USB-RS485

Чтобы определить, к какому устройству `/dev/ttyUSB*` относится ваш
USB-RS485 преобразователь, выполните:

```bash
ls -l /dev/serial/by-id/
```

В выводе будут отображены символьные ссылки вида:

```
usb-FTDI_FT232R_USB_UART_AB0XYZ12-if00-port0 -> ../../ttyUSB3
```

В данном примере фактическое имя порта — **`ttyUSB3`**.  
Именно его нужно использовать в команде `transit`.

---

## Использование

### Включить транзит (пример для `/dev/ttyUSB3`)

```bash
transit -ttyUSB3
```

Пример вывода:

```text
Включен транзитный режим RS485 на /dev/ttyUSB3
Доступ по 192.168.0.10:777
```

---

### Проверить статус

```bash
transit -status
```

---

### Отключить транзит

```bash
transit -stop
```

После этого:
- сетевой доступ закроется
- остановленные сервисы будут запущены обратно

---

## Подключение с другого компьютера

### Через socat

```bash
socat TCP:<IP_СЕРВЕРА>:777 -
```

---

### Через SCADA / Modbus / Serial-over-TCP ПО

Указать:
- IP сервера
- TCP порт: `777`

---

## Возможные проблемы

### Ошибка SSL при загрузке скрипта

Если `wget` пишет:

```text
Unable to locally verify the issuer's authority
```

Выполните:

```bash
sudo apt install -y ca-certificates
sudo update-ca-certificates
```

и повторите загрузку.

---

### Порт занят

Проверить кто использует устройство:

```bash
lsof /dev/ttyUSB3
```

---

### Зависший транзит

```bash
sudo pkill socat
sudo rm -rf /run/transit/*
```

---

## Удаление

```bash
sudo rm /usr/local/bin/transit
sudo rm -rf /run/transit
```

---

## По умолчанию

- TCP порт: `777`
- Поддерживаются устройства `/dev/ttyUSB*`
- Требуются права `sudo` или `root`
