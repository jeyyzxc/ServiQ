FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    nodejs \
    npm

RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /app

RUN composer install --optimize-autoloader --no-dev

RUN npm ci && npm run build

RUN touch database/database.sqlite && chmod 777 database/database.sqlite

RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

RUN php artisan migrate --force

RUN php artisan db:seed --force

RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

EXPOSE 8000

CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
