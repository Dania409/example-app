#!/bin/bash
set -e

# Корневая директория
cd /var/www/html

# 1. Установка зависимостей, если их нет
if [ ! -d vendor ]; then
    echo "==> Устанавливаем composer-зависимости"
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

# 2. Копирование .env
if [ ! -f .env ]; then
    echo "==> Копируем .env"
    cp .env.example .env
fi

# 3. Генерация ключа приложения
if ! grep -q "APP_KEY=" .env || grep -q "APP_KEY=$" .env || php artisan key:generate --show | grep -q "base64:"; then
    echo "==> Генерируем Laravel ключ"
    php artisan key:generate --force
fi

# 4. Миграция базы данных (можно закомментировать, если не нужно автоматом)
echo "==> Миграция БД"
php artisan migrate --force || echo "Миграции не выполнены (ошибка не критична)"

# 5. Линковка storage, если не сделана
if [ ! -L public/storage ]; then
    echo "==> Линкуем storage"
    php artisan storage:link
fi

# 6. Очистка и кэширование
echo "==> Кэшируем конфиги и чистим кэш"
php artisan config:cache
php artisan route:cache || true
php artisan view:cache || true
php artisan cache:clear || true

# 7. Установка прав (для разработки)
chown -R www-data:www-data storage bootstrap/cache
chmod -R 777 storage bootstrap/cache

# 8. Запуск Apache
echo "==> Запускаем Apache"
exec apache2-foreground
