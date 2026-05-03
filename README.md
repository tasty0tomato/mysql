# mysql-debian

Unofficial Debian-based Docker images for MySQL Community Server (8.4).

## Background

The [official docker-library/mysql](https://github.com/docker-library/mysql) images dropped Debian support starting from MySQL 8.4, providing only OracleLinux-based images. This project fills that gap by maintaining a Debian (trixie) variant for MySQL 8.4 LTS.

## Supported Tags

| Tag | MySQL Version | Base OS |
|-----|--------------|---------|
| `8.4`, `latest` | 8.4.9 | debian:trixie-slim |

## Usage

```bash
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  ghcr.io/<your-username>/mysql:8.4
```

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `MYSQL_ROOT_PASSWORD` | Yes (or use `ALLOW_EMPTY_PASSWORD`) | Root password |
| `MYSQL_DATABASE` | No | Create a database on startup |
| `MYSQL_USER` / `MYSQL_PASSWORD` | No | Create an additional user |
| `MYSQL_ALLOW_EMPTY_PASSWORD` | No | Allow empty root password |
| `MYSQL_RANDOM_ROOT_PASSWORD` | No | Generate a random root password |
| `MYSQL_ONETIME_PASSWORD` | No | Expire root password after first login |

### Initialization Scripts

Place `.sql`, `.sql.gz`, `.sql.xz`, `.sh` files in `/docker-entrypoint-initdb.d/` — they are executed once when the database is first initialized.

```bash
docker run -d \
  -v ./init:/docker-entrypoint-initdb.d \
  -e MYSQL_ROOT_PASSWORD=secret \
  ghcr.io/tasty0tomato/mysql:8.4
```

## Building Locally

```bash
docker build -f 8.4/Dockerfile.debian 8.4/ -t mysql-debian:8.4
```

## Notes

- Only `linux/amd64` is supported. MySQL 8.4 Debian packages are only available for amd64.
- MySQL itself is licensed under [GPLv2](LICENSE). The Dockerfiles and scripts in this repository are also distributed under GPLv2 to maintain consistency with the upstream project.
- The MeCab Japanese dictionary (`mecab-ipadic`) is removed to reduce image size (~50 MB). If you require Japanese full-text search with the MeCab parser, install it manually at runtime: `apt-get install mecab-ipadic-utf8`.

## Relationship to Upstream

This is a fork of [docker-library/mysql](https://github.com/docker-library/mysql). It is **not** an official Docker image and has no affiliation with Oracle or the MySQL team.
