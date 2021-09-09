# Custom build of PHP for production.

See repository on [Docker Hub](https://hub.docker.com/r/brabholdsa/php)

# Supported tags and respective `Dockerfile` links

- [ `8.0-apache` (*8.0/apache/Dockerfile*)](https://github.com/brabhold/docker-php/blob/main/apache/Dockerfile)
- [ `8.0-cli` (*8.0/cli/Dockerfile*)](https://github.com/brabhold/docker-php/blob/main/cli/Dockerfile)
- [ `8.0-fpm` (*8.0/fpm/Dockerfile*)](https://github.com/brabhold/docker-php/blob/main/fpm/Dockerfile)
- [ `7.4-apache` (*7.4/apache/Dockerfile*)](https://github.com/brabhold/docker-php/blob/7.4/apache/Dockerfile)
- [ `7.4-cli` (*7.4/cli/Dockerfile*)](https://github.com/brabhold/docker-php/blob/7.4/cli/Dockerfile)
- [ `7.4-fpm` (*7.4/fpm/Dockerfile*)](https://github.com/brabhold/docker-php/blob/7.4/fpm/Dockerfile)
- [ `7.3-apache` (*7.3/apache/Dockerfile*)](https://github.com/brabhold/docker-php/blob/7.3/apache/Dockerfile)
- [ `7.3-cli` (*7.3/cli/Dockerfile*)](https://github.com/brabhold/docker-php/blob/7.3/cli/Dockerfile)
- [ `7.3-fpm` (*7.3/fpm/Dockerfile*)](https://github.com/brabhold/docker-php/blob/7.3/fpm/Dockerfile)
- [ `5.6-apache` (*5.6/apache/Dockerfile*)](https://github.com/brabhold/docker-php/blob/5.6/apache/Dockerfile)
- [ `5.6-cli` (*5.6/cli/Dockerfile*)](https://github.com/brabhold/docker-php/blob/5.6/cli/Dockerfile)
- [ `5.6-fpm` (*5.6/fpm/Dockerfile*)](https://github.com/brabhold/docker-php/blob/5.6/fpm/Dockerfile)

# Additional environment variables

`SERVER_NAME`

Define server name for apache

`SERVER_ALIAS`

Define server alias for apache

`WEB_DIR`

Define web directory for apache

`INSTALL_WP_CLI`

Install the last version of wp-cli

`INSTALL_COMPOSER`

Install the last version of composer

`COMPOSER_VERSION`

Version of composer (default: <=5.6: `--1`, >=7.0: `--2`)
