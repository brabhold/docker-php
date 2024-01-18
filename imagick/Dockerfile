ARG PHP_BASE_IMAGE=

FROM $PHP_BASE_IMAGE

RUN set -e; \
    apt-get update && apt-get install -y --no-install-recommends \
        libmagickwand-dev; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*; \
    pecl install imagick; \
    docker-php-ext-enable imagick; \
    sed -i '/disable ghostscript format types/,+6d' /etc/ImageMagick-6/policy.xml
