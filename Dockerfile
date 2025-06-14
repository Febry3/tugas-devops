FROM composer:lts AS test
WORKDIR /app
RUN --mount=type=bind,source=composer.json,target=composer.json \
 --mount=type=bind,source=composer.lock,target=composer.lock \
 --mount=type=cache,target=/tmp/cache \
 composer install --no-dev --no-interaction
FROM php:8.2-apache AS final
RUN docker-php-ext-install pdo pdo_mysql
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --from=test app/vendor/ /var/www/html/vendor
COPY ./src /var/www/html
USER www-data

