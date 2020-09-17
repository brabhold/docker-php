FROM yannickvh/php-prod:7.4-fpm
LABEL maintainer="Yannick Vanhaeren"

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
        libssh2-1 \
        msmtp \
        mariadb-client; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/* ;\
    sed -i -e "s|;sendmail_path =|sendmail_path = /usr/bin/msmtp -t|" /usr/local/etc/php/php.ini

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
    pecl install ssh2-1.2; \
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
    pecl install sqlsrv-5.7.1preview pdo_sqlsrv-5.7.1preview; \
    docker-php-ext-enable sqlsrv pdo_sqlsrv; \
    pecl clear-cache; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $MSSQL_BUILD_DEPS; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*
