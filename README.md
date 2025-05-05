[![7.4](https://github.com/brabhold/docker-php/actions/workflows/7.4.yaml/badge.svg)](https://github.com/brabhold/docker-php/actions/workflows/7.4.yaml)
[![8.0](https://github.com/brabhold/docker-php/actions/workflows/8.0.yaml/badge.svg)](https://github.com/brabhold/docker-php/actions/workflows/8.0.yaml)
[![8.1](https://github.com/brabhold/docker-php/actions/workflows/8.1.yaml/badge.svg)](https://github.com/brabhold/docker-php/actions/workflows/8.1.yaml)
[![8.2](https://github.com/brabhold/docker-php/actions/workflows/8.2.yaml/badge.svg)](https://github.com/brabhold/docker-php/actions/workflows/8.2.yaml)
[![8.3](https://github.com/brabhold/docker-php/actions/workflows/8.3.yaml/badge.svg)](https://github.com/brabhold/docker-php/actions/workflows/8.3.yaml)
[![8.4](https://github.com/brabhold/docker-php/actions/workflows/8.4.yaml/badge.svg)](https://github.com/brabhold/docker-php/actions/workflows/8.4.yaml)

# Custom build of PHP for production.

Docker repository `brabholdsa/php`

See repository on [Docker Hub](https://hub.docker.com/r/brabholdsa/php)

# Supported tags

- `8.4-apache`, `8.4-apache-imagick`, `8.4-cli`, `8.4-cli-imagick`
- `8.3-apache`, `8.3-apache-imagick`, `8.3-cli`, `8.3-cli-imagick`
- `8.2-apache`, `8.2-apache-imagick`, `8.2-cli`, `8.2-cli-imagick`
- `8.1-apache`, `8.1-apache-imagick`, `8.1-cli`, `8.1-cli-imagick`
- `8.0-apache`, `8.0-apache-imagick`, `8.0-cli`, `8.0-cli-imagick`
- `7.4-apache`, `7.4-apache-imagick`, `7.4-cli`, `7.4-cli-imagick`

## Available but not maintained
- `7.3-apache`, `7.3-cli`
- `5.6-apache`, `5.6-cli`

# Extention installation

To install extension, don't forget to use php version for the package manager => `phpVERSION-EXTENSION`

ex: 
- php7.4-imagick
- php8.1-xdebug
- php8.4-soap
- ...

```docker
RUN apt update && apt install --assume-yes --no-install-recommends \
        php7.4-xdebug && \
    apt clean && \
    rm --recursive /var/lib/apt/lists/*
```

# Additional environment variables

- `SERVER_NAME`
- `SERVER_ALIAS`
- `WEB_DIR`

# Manually build images

Please use the build.sh on Github project [docker-php-build](https://github.com/brabhold/docker-php-build)
