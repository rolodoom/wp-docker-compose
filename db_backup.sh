#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | grep -v -E '^(UID|GID)=' | xargs)
fi

# Variables (pulled from the .env file)
CONTAINER_NAME="${PROJECT_NAME}-db"
DB_NAME="${DB_NAME}"
MYSQL_USER="root"
BACKUP_DIR="./backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Define backup file names
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_${TIMESTAMP}.sql"
BACKUP_FILE_GZ="$BACKUP_DIR/${DB_NAME}_backup_${TIMESTAMP}.sql.gz"

# Detect the database dump command inside the container
if docker exec "$CONTAINER_NAME" test -x /usr/bin/mariadb-dump; then
    DUMP_COMMAND="/usr/bin/mariadb-dump"
elif docker exec "$CONTAINER_NAME" test -x /usr/bin/mysqldump; then
    DUMP_COMMAND="/usr/bin/mysqldump"
else
    echo "Error: Neither /usr/bin/mariadb-dump nor /usr/bin/mysqldump exists in container '$CONTAINER_NAME'."
    exit 1
fi

echo "Using dump command: $DUMP_COMMAND"

# Run the database backup
if docker exec -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" "$CONTAINER_NAME" \
    "$DUMP_COMMAND" -u"$MYSQL_USER" --databases "$DB_NAME" > "$BACKUP_FILE"; then

    echo "Backup of database '$DB_NAME' completed successfully."

    # Compress the backup
    if gzip -c "$BACKUP_FILE" > "$BACKUP_FILE_GZ"; then
        echo "Backup compressed to: $BACKUP_FILE_GZ"
    else
        echo "Error: Compression failed."
        exit 1
    fi
else
    echo "Error: Backup failed."
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Display both files
echo "Uncompressed backup is saved as: $BACKUP_FILE"
echo "Compressed backup is saved as: $BACKUP_FILE_GZ"
