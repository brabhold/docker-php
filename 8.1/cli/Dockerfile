FROM yannickvh/php-prod:8.1-cli
LABEL maintainer="Yannick Vanhaeren"

ENV TZ="Europe/Brussels"

ARG DEBIAN_FRONTEND=noninteractive

RUN set -e; \
    apt-get update && apt-get install -y --no-install-recommends \
        libssh2-1 \
        msmtp; \
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
RUN set -e; \
    PHP_BUILD_DEPS=" \
        libssh2-1-dev \
        libldap2-dev \
        libsasl2-dev \
    "; \
    apt-get update && apt-get install -y --no-install-recommends $PHP_BUILD_DEPS; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu --with-ldap-sasl; \
    docker-php-ext-install -j$(nproc) ldap; \
    pecl install ssh2; \
    pecl clear-cache; \
    docker-php-ext-enable ssh2; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHP_BUILD_DEPS; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*

# Add wkhtml2pdf
RUN set -e; \
    apt-get update; \
    curl -L "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb" -o wkhtmltox_0.12.6-1.buster_amd64.deb; \
    apt install -y ./wkhtmltox_0.12.6-1.buster_amd64.deb; \
    rm wkhtmltox_0.12.6-1.buster_amd64.deb; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*
