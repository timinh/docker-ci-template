#!/usr/bin/env bash

# export HTTPS_PROXY=http://proxy.dsi.uca.fr:8080
# export HTTP_PROXY=http://proxy.dsi.uca.fr:8080
# export NO_PROXY=".uca.fr,localhost,gitlab.dsi.uca.fr"

# dépendances
composer install --no-interaction --no-dev --optimize-autoloader

# migrations
bin/console d:m:m --no-interaction

# fixtures
# bin/console d:f:l --no-interaction
 
exec "$@"