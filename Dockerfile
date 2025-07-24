FROM php:8.4-apache

# Установка расширений
RUN apt-get update && apt-get install -y \
    zip unzip libzip-dev libpng-dev libonig-dev libxml2-dev curl git \
    && docker-php-ext-install pdo_mysql zip

# Включаем mod_rewrite
RUN a2enmod rewrite

# Настройка Apache — путь к public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Права на проект
RUN chown -R www-data:www-data /var/www/html

# Рабочая директория
WORKDIR /var/www/html
