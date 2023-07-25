FROM php:8.2-fpm-alpine

LABEL maintainer="omrqs <tech@omrqs.io>"
LABEL description="Image with PHP-FPM from Alpine with opcache, intl, git, libzip-dev, zip, pcntl, redis, curl, openssl, libcurl, apcu and amqp deps."

RUN apk add --virtual --update --no-cache $PHPIZE_DEPS \
    linux-headers \
    libzip-dev \
    zip \
    libcurl \
    curl \
    curl-dev \
    libintl \
    git \
    icu-dev \
    openssl \
    openssl-dev \
    rabbitmq-c-dev \
    && rm -rf /var/cache/apk/* /var/lib/apk/* or /etc/apk/cache/*

# >>>> Custom install amqp from source
ENV EXT_AMQP_VERSION=master
RUN docker-php-source extract \
    && git clone --depth 1 --branch $EXT_AMQP_VERSION https://github.com/php-amqp/php-amqp.git /usr/src/php/ext/amqp \
    && cd /usr/src/php/ext/amqp && git submodule update --init
# <<<< end

RUN docker-php-ext-install zip pcntl opcache intl amqp
RUN pecl install redis xdebug apcu

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" && \
    pecl config-set php_ini "$PHP_INI_DIR/php.ini"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY ./xdebug.php.ini /tmp

RUN cat /tmp/xdebug.php.ini | grep -v '^#' >> "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini" \
    && rm /tmp/xdebug.php.ini
    
RUN docker-php-ext-enable redis xdebug opcache apcu

WORKDIR /var/www
EXPOSE 9000
CMD ["php-fpm"]
