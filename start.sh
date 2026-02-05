#!/usr/bin/env bash
set -e

echo "=== ServiQ Startup Script ==="

echo "Setting HTTPS URL..."
export APP_URL="https://serviq-wmt2.onrender.com"
export ASSET_URL="https://serviq-wmt2.onrender.com"

echo "Clearing all caches..."
rm -rf bootstrap/cache/*.php
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

echo "Running package discovery..."
php artisan package:discover --ansi || true

echo "Checking APP_KEY..."
if [ -z "$APP_KEY" ]; then
    echo "WARNING: APP_KEY not set! Generating one..."
    php artisan key:generate --force
else
    echo "APP_KEY is set"
fi

echo "Ensuring directories exist..."
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
mkdir -p bootstrap/cache
chmod -R 777 storage bootstrap/cache

echo "Ensuring database exists..."
mkdir -p database
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
    chmod 777 database/database.sqlite
fi

echo "Running migrations..."
php artisan migrate --force || echo "Migration failed, continuing..."

echo "Seeding database..."
php artisan db:seed --force || echo "Seeding failed, continuing..."

echo "Optimizing for production..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

echo "Starting server on port ${PORT:-8000}..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
