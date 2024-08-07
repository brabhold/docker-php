# Custom build of PHP for production.

Docker repository `brabholdsa/php`

See repository on [Docker Hub](https://hub.docker.com/r/brabholdsa/php)

# !!! To build the images, please use the build.sh on Github project [docker-php-build](https://github.com/brabhold/docker-php-build)

# Supported tags

- `8.3-apache`, `8.3-apache-imagick`, `8.3-cli`, `8.3-cli-imagick`
- `8.2-apache`, `8.2-apache-imagick`, `8.2-cli`, `8.2-cli-imagick`
- `8.1-apache`, `8.1-apache-imagick`, `8.1-cli`, `8.1-cli-imagick`
- `8.0-apache`, `8.0-apache-imagick`, `8.0-cli`, `8.0-cli-imagick`
- `7.4-apache`, `7.4-apache-imagick`, `7.4-cli`, `7.4-cli-imagick`

##  Available but not maintained
- `7.3-apache`, `7.3-cli`
- `5.6-apache`, `5.6-cli`

# Additional environment variables

`SERVER_NAME`

Define server name for apache

`SERVER_ALIAS`

Define server alias for apache

`WEB_DIR`
