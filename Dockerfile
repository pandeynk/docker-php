FROM php:8.3-fpm-alpine

RUN docker-php-ext-install pdo pdo_mysql

# allow super user - set this if you use your Composer as a
# super user at all times like in docker containers
ENV COMPOSER_ALLOW_SUPERUSER=1

# obtain composer using multi-stage build
# https://docs.docker.com/build/building/multi-stage
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# here, we are only copying the composer.json and composer.lock (instead copying entire source)
# right before doing composer install
# this is enough to take advantage of docker cache and composer install will be excuted only when
# composer.json or composer.lock have indeed changed
# https://medium.com/@softius/faster-docker-builds-with-composer-install-b4d2b15d0fff
COPY ./composer.* ./

# install
RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --no-interaction

# copy application files to working directory
COPY ./app ./app
COPY ./public ./public

# run composer dump-autoload --optimize
RUN composer dump-autoload --optimize