# wp-docker-compose

Simple Wordpress development with Docker and Docker Compose using **WordPress**, **phpMyAdmin** and **MySQL** and is slightly based on [WPDC](https://github.com/nezhar/wordpress-docker-compose).

## Status

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/rolodoom/wp-docker-compose/master/LICENSE)

## Contents:

- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Installation](#installation)
- [Usage](#usage)
  - [Starting containers](#starting-containers)
  - [Stopping containers](#stopping-containers)
  - [Removing containers](#removing-containers)
  - [Developing a Theme](#developing-a-theme)
  - [Developing a Plugin](#developing-a-plugin)
- [phpMyAdmin](#phpmyadmin)
- [Backup Script](#using-the-backup-script)
- [Troubleshooting](#troubleshooting)
- [Bugs and Issues](#bugs-and-issues)
- [License](#license)

## Prerequisites

Before you begin, ensure that you have the following installed on your machine:

- **Bash**: For running the backup script.
- **Docker**: To run the containers.
- **Docker Compose**: For managing multi-container applications.
- On Linux you need [to add your user to the docker group](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

## Configuration

### 1. Clone or Download the Project

Clone or download this repository to your local machine.

```bash
git clone YOUR_REPOSITORY_URL
cd YOUR_REPOSITORY_FOLDER
```

### 2. Modify the `.env` file

In the root of the project, create or modify the `.env` file to set the environment variables for your project. You can copy the example environment into `.env`

```bash
cp env.example .env
```

Make sure to replace the placeholders in the `.env` file with your actual values.

```ini
# GENERAL
PROJECT_NAME=your_project_name
DB_NAME=your_project_name

#MYSQL
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_PORT=3306
TZ=America/New_York

# WORDPRESS
WORDPRESS_TABLE_PREFIX=wp_
WORDPRESS_PORT=80
WORDPRESS_URL=http://localhost

# PHPMYADMIN
PHPMYADMIN_PORT=8080
```

### 3. Modify the Custom php.ini File for File Upload Limits

If you need to increase the maximum allowed file upload size for WordPress, you can use the provided `php.ini` file. This is particularly useful if you plan to upload larger media files, themes, or plugins.

```ini
upload_max_filesize = 16M
post_max_size = 16M
```

This will increase the file upload limit to 16MB. You can adjust the values as needed.

## Installation

Run the following command to start the containers using Docker Compose:

```bash
docker-compose up -d
```

This will start the following containers:

- **WordPress** (`your_project_name-web`): The WordPress container.
- **MySQL** (`your_project_name-db`): The MySQL database container.
- **phpMyAdmin** (`your_project_name-admin`): The phpMyAdmin container for database management.

This also creates the new folder `wp-content` next to your `docker-compose.yml` file, used to store all user-uploaded content, including themes, plugins, and media files, allowing customization and functionality of the WordPress site.

The containers are now built and running. You should be able to access the WordPress installation in the browser using [http://localhost/](http://localhost/).

## Usage

### Starting containers:

You can start the containers with the `up` command in daemon mode (by adding `-d` as an argument):

```
docker-compose up -d
```

### Stopping containers

You can stop the containers with the `stop` command in daemon mode:

```
docker-compose stop
```

### Removing containers

To stop and remove all the containers use the `down` command:

```
docker-compose down
```

### Persistant removing containers

Use `-v` if you need to remove the database volume which is used to persist the database:

```
docker-compose down -v
```

### Developing a Theme

Configure the volume to load the theme in the container in the `docker-compose.yml`:

```
volumes:
  - ./theme-name/trunk/:/var/www/html/wp-content/themes/theme-name
```

### Developing a Plugin

Configure the volume to load the plugin in the container in the `docker-compose.yml`:

```
volumes:
  - ./plugin-name/trunk/:/var/www/html/wp-content/plugins/plugin-name
```

## phpMyAdmin

You can also visit [http://localhost:8080](http://localhost:8080) to access phpMyAdmin after starting the containers.

The default username is `root`, and the password is the same as supplied in the `.env` file.

## Using the Backup Script

The provided `db_backup.sh` script allows you to easily back up your MySQL database into both a compressed (`.sql.gz`) and uncompressed (`.sql`) file.

### 1. Ensure the Script is Executable

First, ensure that the `db_backup.sh` script has executable permissions:

```bash
chmod +x db_backup.sh
```

### 2. Run the Script

Execute the script to create a backup of your MySQL database. It will create both compressed and uncompressed SQL backup files.

```bash
./db_backup.sh
```

The script performs the following actions:

- **Creates a non-compressed SQL dump** of your database.
- **Creates a compressed version** of the SQL dump (`.sql.gz`).
- Ensures the database dump is properly formatted for importing into phpMyAdmin.

The backups are stored in the `./backup` folder by default. The filenames include the database name and timestamp, such as:

- `your_database_backup_YYYYMMDD_HHMMSS.sql`
- `your_database_backup_YYYYMMDD_HHMMSS.sql.gz`

### 3. Importing the Backup

Once the backup is created, you can import the SQL file into your MySQL database using phpMyAdmin.

- Log into phpMyAdmin using the URL http://localhost:8080 (or the port you configured in the `.env` file).
- **Select your database** from the left sidebar.
- **Click on the "Import" tab**.
- **Choose the SQL file** you want to import (either `.sql` or `.sql.gz`).
- Click **"Go"** to start the import.

If the backup file is too large to import directly through phpMyAdmin, you can use a different method, such as uploading the file directly to the MySQL container.

## Troubleshooting

- If you encounter any issues with Docker containers not starting, check the logs of the specific container:

```bash
docker logs your_project_name-db
docker logs your_project_name-web
docker logs your_project_name-admin
```

- Ensure that your `.env` file is correctly set up and there are no conflicting environment variables.
- If the `db_backup.sh` script doesn’t create backups or you get permission errors, ensure that the script has executable permissions.

## Bugs and Issues

Have a bug or an issue with this template? [Open a new issue](https://github.com/rolodoom/wp-docker-compose/issues) here on GitHub.

## License

This code in this repository is released under the [MIT](https://raw.githubusercontent.com/rolodoom/wp-docker-compose/master/LICENSE) license, which means you can use it for any purpose, even for commercial projects. In other words, do what you want with it. The only requirement with the MIT License is that the license and copyright notice must be provided with the software.
