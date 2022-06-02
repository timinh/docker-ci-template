## Compilation js/css
FROM node:16.15.0 as frontend

WORKDIR /app

COPY package*.json ./
RUN yarn

COPY assets/ ./assets/
COPY vite.config.js ./

RUN yarn build

## Build image pour prod
FROM timinh/php8.1-apache

COPY docker/apache/vhosts-prod.conf /etc/apache2/sites-enabled/000-default.conf
COPY docker/php/php.ini /usr/local/etc/php/conf.d/app.ini
COPY . /var/www/html

## copie fichiers js/css
COPY --from=frontend /app/public/assets/ /var/www/html/public/assets/
RUN rm yarn.lock package*.json vite.config.js

WORKDIR /var/www/html

RUN chmod +x ./docker/scripts/entrypoint.sh

CMD ["apache2-foreground"]

ENTRYPOINT ["./docker/scripts/entrypoint.sh"]