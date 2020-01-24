FROM yannickvh/php:5.6-apache
LABEL maintainer="Yannick Vanhaeren"

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
        git \
        vim \
        openssh-client \
        libsybdb5 \
        freetds-bin; \
        freetds-common; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*

# Add php extensions
RUN set -eux; \
    PHP_BUILD_DEPS=" \
        libldap2-dev \
        libsasl2-dev \
        freetds-dev \
    "; \
    apt-get update && apt-get install -y --no-install-recommends $PHP_BUILD_DEPS; \
    ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so; \
    ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu --with-ldap-sasl; \
    docker-php-ext-configure mssql; \
    docker-php-ext-install -j$(nproc) ldap mssql; \
    pecl install apcu-4.0.11; \
    docker-php-ext-enable apcu; \
    pecl clear-cache; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHP_BUILD_DEPS

RUN set -eux; \
    cd /usr/local/etc/php; \
    sed -i -e "s|;date.timezone =|date.timezone = Europe/Brussels|" php.ini; \
    sed -i -e "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" php.ini; \
    sed -i -e "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" php.ini; \
    sed -i -e "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" php.ini

RUN set -eux; \
    cd /usr/local/etc/php/conf.d; \
    echo "apc.enabled=1" >> docker-php-ext-apcu.ini; \
    echo "apc.shm_segments=1" >> docker-php-ext-apcu.ini; \
    echo "apc.shm_size=128M" >> docker-php-ext-apcu.ini; \
    echo "apc.ttl=7200" >> docker-php-ext-apcu.ini; \
    echo "apc.enable_cli=0" >> docker-php-ext-apcu.ini

RUN set -eux; \
    cd /usr/local/etc/php/conf.d; \
    echo "opcache.enable=1" >> docker-php-ext-opcache.ini; \
    echo "opcache.enable_cli=1" >> docker-php-ext-opcache.ini; \
    echo "opcache.validate_timestamps=0" >> docker-php-ext-opcache.ini; \
    echo "opcache.interned_strings_buffer=16" >> docker-php-ext-opcache.ini; \
    echo "opcache.max_accelerated_files = 20000" >> docker-php-ext-opcache.ini
