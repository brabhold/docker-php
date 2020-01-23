FROM yannickvh/php:7.4-fpm
LABEL maintainer="Yannick Vanhaeren"

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
        git \
        vim \
        openssh-client; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*

# Add php extensions
RUN set -eux; \
    PHP_BUILD_DEPS=" \
        libldap2-dev \
        libsasl2-dev \
    "; \
    apt-get update && apt-get install -y --no-install-recommends $PHP_BUILD_DEPS; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu --with-ldap-sasl; \
    docker-php-ext-install -j$(nproc) ldap; \
    pecl install apcu; \
    docker-php-ext-enable apcu; \
    pecl clear-cache; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHP_BUILD_DEPS

# Add MSSQL drivers
RUN set -eux; \
    MSSQL_BUILD_DEPS=" \
        gnupg2 \
        unixodbc-dev \
    "; \
    apt-get update && apt-get install -y --no-install-recommends $MSSQL_BUILD_DEPS; \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
    apt-get update && ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql17 libgssapi-krb5-2; \
    pecl install sqlsrv pdo_sqlsrv; \
    docker-php-ext-enable sqlsrv pdo_sqlsrv; \
    pecl clear-cache; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $MSSQL_BUILD_DEPS

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
