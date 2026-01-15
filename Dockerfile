FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    nginx zip unzip git libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN mkdir -p /run/php && chmod 777 /run/php
RUN chmod -R 775 storage bootstrap/cache

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD php-fpm -D && nginx -g 'daemon off;'
