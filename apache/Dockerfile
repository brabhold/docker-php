FROM yannickvh/php-prod:5.6-apache
LABEL maintainer="Yannick Vanhaeren"

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
        libsybdb5 \
        freetds-bin \
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
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PHP_BUILD_DEPS
