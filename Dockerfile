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
    ca-certificates \
    gnupg

RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs

RUN docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY package*.json /app/
RUN npm ci

COPY . /app

RUN composer install --optimize-autoloader --no-dev

RUN rm -rf bootstrap/cache/*.php || true

RUN echo "Building frontend assets..." && \
    npm run build && \
    echo "Verifying build output..." && \
    ls -la public/build/ && \
    cat public/build/manifest.json | head -20

RUN test -f public/build/manifest.json || (echo "ERROR: Vite manifest not found!" && exit 1)

RUN mkdir -p database && touch database/database.sqlite && chmod 777 database/database.sqlite && chmod 777 database

RUN mkdir -p storage/framework/{sessions,views,cache} && \
    mkdir -p storage/logs && \
    mkdir -p bootstrap/cache && \
    chmod -R 777 storage bootstrap/cache

RUN php artisan package:discover --ansi || true

RUN php artisan key:generate --force || echo "APP_KEY will be set via environment"

RUN php artisan migrate --force || true

RUN php artisan db:seed --force || true

RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache /app/database /app/public/build

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8000

CMD ["/app/start.sh"]
