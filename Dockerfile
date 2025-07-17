FROM amd64/debian:bookworm-slim AS debian

LABEL maintainer="Yannick Vanhaeren"

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION

ENV TZ="Europe/Brussels"

RUN apt update && \
    apt install --assume-yes \
        lsb-release \
        ca-certificates \
        curl \
        msmtp && \
    curl --silent --show-error --location --output /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    apt install /tmp/debsuryorg-archive-keyring.deb && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    apt clean && \
    rm --recursive /var/lib/apt/lists/*

RUN apt update && \
    WKHTMLTOPDF_TEMP_DEB="$(mktemp).deb" && \
    curl --silent --show-error --location "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb" --output ${WKHTMLTOPDF_TEMP_DEB} && \
    apt install --assume-yes ${WKHTMLTOPDF_TEMP_DEB} && \
    rm ${WKHTMLTOPDF_TEMP_DEB} && \
    apt clean && \
    rm --recursive /var/lib/apt/lists/*

COPY msmtprc /etc/msmtprc

RUN { \
        echo 'Package: php${PHP_VERSION}*'; \
        echo 'Pin: version ${PHP_VERSION}*'; \
        echo 'Pin-Priority: 1001'; \
    } > /etc/apt/preferences.d/php

WORKDIR /var/www/html

FROM debian AS cli

RUN apt update && \
    apt install --assume-yes php${PHP_VERSION}-{apcu,bz2,cli,curl,gd,intl,ldap,mbstring,mysql,opcache,soap,solr,ssh2,readline,redis,xml,xsl,zip} && \
    apt clean && \
    rm --recursive /var/lib/apt/lists/*

ENV PHP_INI_DIR=/etc/php/${PHP_VERSION}

RUN php_ini=${PHP_INI_DIR}/cli/php.ini && \
    sed --in-place "s|max_execution_time = 30|max_execution_time = 60|" $php_ini && \
    sed --in-place "s|post_max_size = 8M|post_max_size = 55M|" $php_ini && \
    sed --in-place "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" $php_ini && \
    sed --in-place "s|;date.timezone =|date.timezone = Europe/Brussels|" $php_ini && \
    sed --in-place "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" $php_ini && \
    sed --in-place "s|;max_input_vars = 1000|max_input_vars = 3000|" $php_ini && \
    sed --in-place "s|;sendmail_path =|sendmail_path = /usr/bin/msmtp -t|" $php_ini && \
    sed --in-place "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" $php_ini && \
    sed --in-place "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" $php_ini && \
    ini_path=${PHP_INI_DIR}/mods-available && \
    echo "apc.enabled=1" >> $ini_path/apcu.ini && \
    echo "apc.shm_segments=1" >> $ini_path/apcu.ini && \
    echo "apc.shm_size=128M" >> $ini_path/apcu.ini && \
    echo "apc.ttl=7200" >> $ini_path/apcu.ini && \
    echo "apc.enable_cli=0" >> $ini_path/apcu.ini && \
    echo "opcache.enable=1" >> $ini_path/opcache.ini && \
    echo "opcache.enable_cli=1" >> $ini_path/opcache.ini && \
    echo "opcache.validate_timestamps=0" >> $ini_path/opcache.ini && \
    echo "opcache.interned_strings_buffer=16" >> $ini_path/opcache.ini && \
    echo "opcache.max_accelerated_files = 20000" >> $ini_path/opcache.ini

CMD ["php", "-a"]

FROM cli AS apache

ENV SERVER_NAME=localhost
ENV SERVER_ALIAS=''
ENV WEB_DIR=/var/www/html

RUN apt update && \
    apt install --assume-yes apache2 php${PHP_VERSION} && \
    apt clean && \
    rm --recursive /var/lib/apt/lists/* && \
    echo "ServerName ${SERVER_NAME}" > /etc/apache2/conf-available/fqdn.conf && \
    a2enconf fqdn && \
    a2enmod rewrite && \
    chown --recursive www-data: /var/www/html && \
    . "/etc/apache2/envvars" && \
    ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" && \
    ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" && \
    php_ini=${PHP_INI_DIR}/apache2/php.ini && \
    sed --in-place "s|max_execution_time = 30|max_execution_time = 60|" $php_ini && \
    sed --in-place "s|memory_limit = 128M|memory_limit = 2048M|" $php_ini && \
    sed --in-place "s|post_max_size = 8M|post_max_size = 55M|" $php_ini && \
    sed --in-place "s|upload_max_filesize = 2M|upload_max_filesize = 50M|" $php_ini && \
    sed --in-place "s|;date.timezone =|date.timezone = Europe/Brussels|" $php_ini && \
    sed --in-place "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo = 0|" $php_ini && \
    sed --in-place "s|;max_input_vars = 1000|max_input_vars = 3000|" $php_ini && \
    sed --in-place "s|;sendmail_path =|sendmail_path = /usr/bin/msmtp -t|" $php_ini && \
    sed --in-place "s|;realpath_cache_ttl = 120|realpath_cache_ttl = 600|" $php_ini && \
    sed --in-place "s|;realpath_cache_size = 4096k|realpath_cache_size = 4096K|" $php_ini

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN usermod --uid 1000 www-data && \
    groupmod --gid 1000 www-data && \
    chown www-data:www-data /var/www

# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL SIGWINCH

COPY apache2-foreground /usr/local/bin/

EXPOSE 80

CMD ["apache2-foreground"] 
