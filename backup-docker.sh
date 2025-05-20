#!/bin/bash

# Spinner (optional visual)
spinner="/-\|"

# Current timestamp
time=$(date +"%Y-%m-%d-%H:%M:%S")

# Backup base directory
backup_base="/root/docker-backup"

# Ensure base directory exists
mkdir -p "$backup_base"

# Loop spinner for animation
for i in {0..15}; do
  printf "\r%s" "${spinner:$i:1}"
  sleep 0.1
done
echo ""

# List containers
containers=$(docker ps -a --format '{{.ID}} {{.Names}}')

# Backup each container
while read -r container; do
  container_id=$(echo $container | awk '{print $1}')
  container_name=$(echo $container | awk '{print $2}')
  backup_dir="$backup_base/$container_name"

  mkdir -p "$backup_dir"

  # Get full image ID and save it
  container_image=$(docker inspect -f '{{.Image}}' "$container_id")
  docker save "$container_image" -o "$backup_dir/${container_name}-${time}.tar"

  # Save logs
  docker logs "$container_id" &> "$backup_dir/logs-${time}.txt"
done <<< "$containers"

# Log rotation for each container log
for log_file in "$backup_base"/*/logs-*.txt; do
  log_size=$(stat -c%s "$log_file")
  if [[ $log_size -gt 4096000 ]]; then
    gzip "$log_file"
  fi
done

# Cleanup old backups (older than 3 days)
find "$backup_base" -name "*.gz" -mtime +3 -exec rm -f {} \;
