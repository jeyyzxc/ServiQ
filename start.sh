#!/usr/bin/env bash
set -e

echo "=== ServiQ Startup Script ==="
echo "Current directory: $(pwd)"
echo "PHP version: $(php -v | head -n 1)"
echo "Node version: $(node -v)"

echo "Setting HTTPS URL..."
export APP_URL="https://serviq-wmt2.onrender.com"
export ASSET_URL="https://serviq-wmt2.onrender.com"

echo "Checking environment variables..."
echo "APP_ENV: ${APP_ENV}"
echo "APP_DEBUG: ${APP_DEBUG}"
echo "DB_CONNECTION: ${DB_CONNECTION}"

echo "Clearing all caches..."
rm -rf bootstrap/cache/*.php || true
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

echo "Running package discovery..."
php artisan package:discover --ansi || echo "Package discovery failed but continuing..."

echo "Checking APP_KEY..."
if [ -z "$APP_KEY" ]; then
    echo "WARNING: APP_KEY not set! Generating one..."
    php artisan key:generate --force --show > /tmp/app_key.txt
    export APP_KEY=$(cat /tmp/app_key.txt)
    echo "Generated APP_KEY"
else
    echo "APP_KEY is set"
fi

echo "Ensuring directories exist..."
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
mkdir -p bootstrap/cache
mkdir -p database
chmod -R 777 storage bootstrap/cache database || true

echo "Ensuring database exists..."
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    chmod 777 database/database.sqlite
    echo "Database created"
else
    echo "Database already exists"
fi

echo "Running migrations..."
php artisan migrate --force || echo "Migration failed, continuing..."

echo "Seeding database..."
php artisan db:seed --force || echo "Seeding failed, continuing..."

echo "Testing database connection..."
php artisan tinker --execute="echo 'Database OK';" || echo "Database test failed"

echo "Optimizing for production..."
php artisan config:cache || echo "Config cache failed"
php artisan route:cache || echo "Route cache failed"
php artisan view:cache || echo "View cache failed"

echo "Checking if server can start..."
php artisan --version || echo "Artisan check failed"

echo "Starting server on port ${PORT:-8000}..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8000} --no-reload
