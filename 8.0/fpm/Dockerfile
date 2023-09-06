FROM yannickvh/php-prod:8.0-fpm
LABEL maintainer="Yannick Vanhaeren"

ENV TZ="Europe/Brussels"

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
        git \
        less \
        vim \
        unzip \
        openssh-client \
        libssh2-1 \
        unixodbc \
        pwgen \
        msmtp \
        mariadb-client; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*; \
    cd /usr/local/etc/php; \
    sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini; \
    sed -i -e "s|memory_limit = 128M|memory_limit = 1024M|" php.ini; \
    sed -i -e "s|;max_input_vars = 1000|max_input_vars = 3000|" php.ini; \
    sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini; \
    sed -i -e "s|;sendmail_path =|sendmail_path = /usr/bin/msmtp -t|" php.ini

COPY msmtprc /etc/msmtprc

# Add php extensions
RUN set -eux; \
    PHP_BUILD_DEPS=" \
        libssh2-1-dev \
        libldap2-dev \
        libsasl2-dev \
    "; \
    apt-get update && apt-get install -y --no-install-recommends $PHP_BUILD_DEPS; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu --with-ldap-sasl; \
    docker-php-ext-install -j$(nproc) ldap; \
    pecl install ssh2-1.3.1; \
    pecl clear-cache; \
    docker-php-ext-enable ssh2; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHP_BUILD_DEPS; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*

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
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $MSSQL_BUILD_DEPS; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*
