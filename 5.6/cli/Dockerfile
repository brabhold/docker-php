FROM yannickvh/php-prod:5.6-cli
LABEL maintainer="Yannick Vanhaeren"

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN set -e; \
    apt-get update && apt-get install -y --no-install-recommends \
        libssh2-1 \
        pwgen \
        msmtp \
        mariadb-client \
        libsybdb5 \
        freetds-bin \
        freetds-common; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*; \
    cd /usr/local/etc/php; \
    sed -i -e "s|post_max_size = 8M|post_max_size = 55M|" php.ini; \
    sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" php.ini; \
    sed -i -e "s|;sendmail_path =|sendmail_path = /usr/bin/msmtp -t|" php.ini

COPY msmtprc /etc/msmtprc

# Add php extensions
RUN set -e; \
    PHP_BUILD_DEPS=" \
        libssh2-1-dev \
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
    pecl install ssh2; \
    pecl clear-cache; \
    docker-php-ext-enable ssh2; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHP_BUILD_DEPS; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*

ENV COMPOSER_VERSION --1
