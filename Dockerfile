# Utilise PHP-FPM avec Nginx
FROM php:8.2-fpm-alpine

# Installer msmtp pour l'envoi d'emails via OVH
RUN apk update && apk add --no-cache msmtp ca-certificates && \
    rm -rf /var/cache/apk/*

# Copier la config msmtp dans le conteneur
COPY msmtprc /etc/msmtprc

# Définir le chemin d'envoi pour PHP
RUN echo "sendmail_path = /usr/bin/msmtp -t" >> /usr/local/etc/php/php.ini

# Installer Nginx
RUN apk add --no-cache nginx

# Copier les fichiers du site
COPY . /var/www/html

# Copier la configuration Nginx
COPY nginx-config.conf /etc/nginx/conf.d/default.conf

# Donner les permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose les ports
EXPOSE 80
EXPOSE 443

# Script de démarrage
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
