FROM php:8.4-apache

# Устанавливаем расширения PHP и необходимые пакеты
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite

RUN apt-get update && \
    apt-get install -y git zip unzip libzip-dev && \
    docker-php-ext-install pdo pdo_mysql mysqli zip && \
    a2enmod rewrite

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html/public
COPY . /var/www/html/public

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY apache.conf /etc/apache2/sites-available/000-default.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
