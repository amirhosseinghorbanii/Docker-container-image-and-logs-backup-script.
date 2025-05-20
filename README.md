# Docker Container Backup Script

This script backs up Docker container images and logs to a specified directory. It saves:

- The container image (`.tar` file)
- Container logs (`logs-<timestamp>.txt`)

## 📦 Features

- Saves Docker images using `docker save`
- Collects logs for all running and stopped containers
- Compresses log files larger than ~4MB
- Automatically deletes compressed logs older than 3 days
- Organized backups per container in `/root/docker-backup/<container-name>/`

## 📂 Example Backup Structure

```
/root/docker-backup/
├── container1/
│   ├── container1-2024-05-20-12:30:15.tar
│   ├── logs-2024-05-20-12:30:15.txt
├── container2/
│   ├── container2-2024-05-20-12:30:15.tar
│   ├── logs-2024-05-20-12:30:15.txt
```

## ⚙️ Usage

1. Save the script as `backup-docker.sh`
2. Make it executable:

```bash
chmod +x backup-docker.sh
```

3. Run it as root or with sudo:

```bash
./backup-docker.sh
```

You can also schedule it via cron:

```bash
0 2 * * * /root/backup-docker.sh
```

## 🔐 Requirements

- Docker installed and running
- Script must be run with root or a user with Docker access

---

Author: Amirhossein Ghorbani  
License: MIT
