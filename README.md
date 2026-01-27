**1. Положить скрипт обновления в /usr/local/bin**

   sudo nano /usr/local/bin/andromeda-update -> вставить код

   или загрузить из C:/PersayFiles командой в PowerShell:
   
   scp C:/PersayFiles/andromeda-update root@192.168.0.1:/usr/local/bin/andromeda-update

**2. Сделать файл исполняемым:**

   chmod +x /usr/local/bin/andromeda-update

**3. Запустить обновление:**

   andromeda-update
