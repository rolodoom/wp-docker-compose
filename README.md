# wp-docker-compose

Simple Wordpress development with Docker and Docker Compose using **WordPress**, **phpMyAdmin** and **MySQL** and is slightly based on [WPDC](https://github.com/nezhar/wordpress-docker-compose).

## Status

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/rolodoom/wp-docker-compose/master/LICENSE)

## Contents:

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Installation](#installation)
- [Usage](#usage)
  - [Starting containers](#starting-containers)
  - [Stopping containers](#stopping-containers)
  - [Removing containers](#removing-containers)
  - [Developing a Theme](#developing-a-theme)
  - [Developing a Plugin](#developing-a-plugin)
  - [phpMyAdmin](#phpmyadmin)
- [Bugs and Issues](#bugs-and-issues)
- [License](#license)

## Requirements

- Latest versions of **Docker** and **Docker Compose** installed.
- On Linux you need [to add your user to the docker group](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

## Configuration

Copy the example environment into `.env`

```
cp env.example .env
```

In the .env file you can change the project name, ports, database name and password.

## Installation

Open a terminal and `cd` to the folder in which `docker-compose.yml` is saved and run:

```
docker-compose up -d
```

This creates two new folders next to your `docker-compose.yml` file.

- `wp-data` – used to store and restore database dumps
- `wp-app` – the location of your WordPress application

The containers are now built and running. You should be able to access the WordPress installation in the browser using [http://localhost/](http://localhost/).

## Usage

### Starting containers

You can start the containers with the `up` command in daemon mode (by adding `-d` as an argument):

```
docker-compose up -d
```

### Stopping containers

```
docker-compose stop
```

### Removing containers

To stop and remove all the containers use thedown command:

```
docker-compose down
```

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

### phpMyAdmin

You can also visit [http://localhost:8080](http://localhost:8080) to access phpMyAdmin after starting the containers.

The default username is `root`, and the password is the same as supplied in the `.env` file.

## Bugs and Issues

Have a bug or an issue with this template? [Open a new issue](https://github.com/rolodoom/wp-docker-compose/issues) here on GitHub.

## License

This code in this repository is released under the [MIT](https://raw.githubusercontent.com/rolodoom/wp-docker-compose/master/LICENSE) license, which means you can use it for any purpose, even for commercial projects. In other words, do what you want with it. The only requirement with the MIT License is that the license and copyright notice must be provided with the software.
