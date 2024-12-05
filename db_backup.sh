#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# Debugging: Show MySQL Password to ensure it's set
echo "Using MySQL Password: $MYSQL_ROOT_PASSWORD"

# Variables (will be pulled from the .env file)
CONTAINER_NAME="${PROJECT_NAME}-db"
DB_NAME="${DB_NAME}"  # Use your DB_NAME variable
MYSQL_USER="root"  # Using root user for backup
BACKUP_DIR="./backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Define backup file names
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_${TIMESTAMP}.sql"
BACKUP_FILE_GZ="$BACKUP_DIR/${DB_NAME}_backup_${TIMESTAMP}.sql.gz"

# Run mysqldump inside the Docker container to backup the database (Uncompressed)
docker exec -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$CONTAINER_NAME" /usr/bin/mysqldump -u"$MYSQL_USER" --databases "$DB_NAME" > "$BACKUP_FILE"

# Check if mysqldump command was successful
if [ $? -eq 0 ]; then
    echo "Backup of database '$DB_NAME' completed successfully."

    # Compress the backup file (Uncompressed to .sql.gz)
    gzip -c "$BACKUP_FILE" > "$BACKUP_FILE_GZ"
    echo "Backup compressed to: $BACKUP_FILE_GZ"
else
    echo "Error: Backup failed."
    exit 1
fi

# Display both files
echo "Uncompressed backup is saved as: $BACKUP_FILE"
echo "Compressed backup is saved as: $BACKUP_FILE_GZ"

