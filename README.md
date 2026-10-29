# mysql

Unofficial Debian-based Docker images for MySQL Community Server LTS releases (8.4, 9.7), plus slimmed-down Oracle Linux variants of both LTS lines for arm64 users.

## Background

The [official docker-library/mysql](https://github.com/docker-library/mysql) images dropped Debian support starting from MySQL 8.4, providing only OracleLinux-based images. This project fills that gap by maintaining Debian (trixie) variants for the current MySQL LTS lines.

MySQL only publishes amd64 packages to its Debian APT repository, so those variants cannot offer arm64. For arm64 users, this project also maintains Oracle Linux variants of 8.4 and 9.7 that leave out the ~580 MB mysql-shell bundled into the official image.

## Supported Tags

| Tag | MySQL Version | Base OS | Architectures |
|-----|--------------|---------|---------------|
| `8.4`, `8.4-trixie`, `latest` | latest 8.4 LTS patch | debian:trixie-slim | amd64 |
| `8.4-oraclelinux9` | latest 8.4 LTS patch | oraclelinux:9-slim | **amd64, arm64** |
| `9.7`, `9.7-trixie` | latest 9.7 LTS patch | debian:trixie-slim | amd64 |
| `9.7-oraclelinux9` | latest 9.7 LTS patch | oraclelinux:9-slim | **amd64, arm64** |

- Each image installs the **latest patch** of its MySQL LTS line from the
  corresponding MySQL repository (the `mysql-8.4-lts` / `mysql-9.7-lts` APT
  components, or the 8.4 / 9.7 yum repositories for Oracle Linux), so a rebuild
  always picks up the newest patch and security fixes. Images are **not** pinned
  to an exact patch version.
- **`8.4`** is the more mature LTS line and holds the `latest` tag.
- **`9.7`** is the newest LTS (released 2026-04-21, the first LTS after 8.4). It
  tracks the frontier but is **not** tagged `latest`; pull it explicitly via `:9.7`.
- **trixie** (Debian 13, the current stable release) is the only Debian base;
  the unsuffixed tags point to it.
- **oraclelinux9** is the variant to use on **arm64** (e.g. Apple Silicon, AWS
  Graviton). It is built the same way as the official `mysql:8.4` / `mysql:9.7`
  images, but without mysql-shell, which the entrypoint never uses. If you need
  `mysqlsh`, install it at runtime from MySQL's `mysql-tools-8.4-community` /
  `mysql-tools-9.7-community` yum repository, or use the official image. Its package manager is `microdnf`, not `apt-get`.

## Usage

```bash
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  ghcr.io/tasty0tomato/mysql:8.4
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
docker build -f 8.4/Dockerfile 8.4/ -t mysql:8.4-trixie
```

Substitute `9.7/` for `8.4/` to build the 9.7 LTS variants.

The Oracle Linux variants have their own Dockerfiles and no build arguments. They
build natively on either amd64 or arm64:

```bash
docker build -f 8.4/Dockerfile.oracle 8.4/ -t mysql:8.4-oraclelinux9
docker build -f 9.7/Dockerfile.oracle 9.7/ -t mysql:9.7-oraclelinux9
```

## Notes

- The Debian images support `linux/amd64` only, because MySQL only publishes amd64 packages to its Debian APT repository. The `-oraclelinux9` images support both `linux/amd64` and `linux/arm64`.
- MySQL itself is licensed under [GPLv2](LICENSE). The Dockerfiles and scripts in this repository are also distributed under GPLv2 to maintain consistency with the upstream project.
- The two notes below apply to the Debian images.
- The MeCab Japanese dictionary (`mecab-ipadic`) is removed to reduce image size (~50 MB). If you require Japanese full-text search with the MeCab parser, install it manually at runtime: `apt-get install mecab-ipadic-utf8`.
- The full `perl` package is not installed (~49 MB saved). MySQL's own perl scripts, `mysqldumpslow` and `mysqld_multi`, work as usual because they only need modules from `perl-base`, which is Essential on Debian. If your own init scripts require additional Perl modules, install `perl` at runtime: `apt-get install perl`.

## Relationship to Upstream

This is a fork of [docker-library/mysql](https://github.com/docker-library/mysql). It is **not** an official Docker image and has no affiliation with Oracle or the MySQL team.
