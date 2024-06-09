ARG PHP_VERSION=8.3
FROM php:${PHP_VERSION}-fpm-alpine

RUN apk add --no-cache \
    tzdata \
    mysql-client \
    bash \
    curl \
    git \
    unzip \
    build-base \
    zlib-dev \
    oniguruma-dev \
    autoconf \
    zip \
    libzip-dev \
    freetype \
    libpng \
    libjpeg-turbo \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
  && apk add --update linux-headers \
  && docker-php-ext-configure zip \
  && docker-php-ext-install pdo_mysql exif zip

# GD
RUN apk add --update --no-cache \
    freetype libpng libjpeg-turbo \
    freetype-dev libpng-dev libjpeg-turbo-dev libwebp-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j$(nproc) gd \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

# Xdebug
ARG INSTALL_XDEBUG=false
ARG XDEBUG_VERSION=3.3.1
RUN if [ ${INSTALL_XDEBUG} = true ]; \
    then \
      git clone --branch ${XDEBUG_VERSION} --depth 1 https://github.com/xdebug/xdebug.git /usr/src/php/ext/xdebug \
        && docker-php-ext-configure xdebug --enable-xdebug-dev \
        && docker-php-ext-install xdebug \
        && docker-php-source delete; \
    fi

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

# Enable php fpm status page
RUN set -xe \
    && echo "pm.status_path = /status" >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY ./php/conf.d /usr/local/etc/php/conf.d

COPY --chmod=755 ./php/php-fpm-healthcheck /usr/local/bin

# Configure non-root user.
ARG HOST_USER_ID=1000
ARG HOST_GROUP_ID=1000
RUN apk --no-cache add shadow && \
    groupmod -o -g ${HOST_GROUP_ID} www-data && \
    usermod -o -u ${HOST_USER_ID} -g www-data www-data

# Source code
RUN mkdir /app \
  && chown www-data:www-data /app

WORKDIR /app

USER www-data
