#!/bin/sh

# Démarrer PHP-FPM en arrière-plan
php-fpm -D

# Démarrer Nginx
nginx -g "daemon off;"
