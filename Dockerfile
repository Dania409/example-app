FROM php:8.4-apache

# Устанавливаем расширения PHP и необходимые пакеты
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite

WORKDIR /var/www/html/example-app/public
COPY . /var/www/html/example-app/public

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY apache.conf /etc/apache2/sites-available/000-default.conf
