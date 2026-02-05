#!/usr/bin/env bash
set -e

echo "Starting deployment..."

echo "Clearing old cache files..."
rm -rf bootstrap/cache/*.php || true
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

echo "Installing composer dependencies..."
composer install --optimize-autoloader --no-dev --no-interaction

echo "Running package discovery..."
php artisan package:discover --ansi || true

echo "Installing npm dependencies..."
npm ci --prefer-offline --no-audit

echo "Building frontend assets..."
npm run build

echo "Verifying build output..."
if [ ! -f "public/build/manifest.json" ]; then
    echo "ERROR: Vite manifest not found!"
    ls -la public/build/ || echo "build directory not found"
    exit 1
fi
echo "Build manifest found:"
cat public/build/manifest.json

echo "Ensuring directories exist..."
mkdir -p database
mkdir -p storage/framework/{sessions,views,cache}
mkdir -p storage/logs
mkdir -p bootstrap/cache

echo "Creating SQLite database..."
touch database/database.sqlite
chmod 666 database/database.sqlite
chmod 777 database

echo "Running migrations..."
php artisan migrate --force --no-interaction || echo "Migration failed but continuing..."

echo "Creating admin and test users..."
php artisan db:seed --force --no-interaction || echo "Seeding failed but continuing..."

echo "Optimizing Laravel..."
php artisan config:cache || echo "Config cache failed"
php artisan route:cache || echo "Route cache failed"
php artisan view:cache || echo "View cache failed"

echo "Setting permissions..."
chmod -R 777 storage bootstrap/cache database

echo "Testing Laravel bootstrap..."
php artisan --version || echo "Laravel check failed"

echo "Deployment complete!"
