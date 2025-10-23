FROM php:8.2-fpm-alpine

# Installer msmtp et Nginx
RUN apk update && apk add --no-cache msmtp ca-certificates nginx && \
    rm -rf /var/cache/apk/*

# Configurer PHP pour utiliser msmtp
RUN echo "sendmail_path = /usr/bin/msmtp -t" >> /usr/local/etc/php/php.ini

# Copier la config msmtp
COPY msmtprc /etc/msmtprc

# Créer le fichier de log msmtp
RUN touch /var/log/msmtp.log && chmod 666 /var/log/msmtp.log

# ⚠️ SUPPRESSION de la ligne COPY . /var/www/html
# (on ne copie plus les fichiers ici — ils viendront du volume Docker)

# Configuration Nginx pour PHP
RUN echo 'server {' > /etc/nginx/http.d/default.conf && \
    echo '    listen 80;' >> /etc/nginx/http.d/default.conf && \
    echo '    root /var/www/html;' >> /etc/nginx/http.d/default.conf && \
    echo '    index index.html index.php;' >> /etc/nginx/http.d/default.conf && \
    echo '    location / {' >> /etc/nginx/http.d/default.conf && \
    echo '        try_files $uri $uri/ /index.html;' >> /etc/nginx/http.d/default.conf && \
    echo '    }' >> /etc/nginx/http.d/default.conf && \
    echo '    location ~ \.php$ {' >> /etc/nginx/http.d/default.conf && \
    echo '        fastcgi_pass 127.0.0.1:9000;' >> /etc/nginx/http.d/default.conf && \
    echo '        fastcgi_index index.php;' >> /etc/nginx/http.d/default.conf && \
    echo '        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/http.d/default.conf && \
    echo '        include fastcgi_params;' >> /etc/nginx/http.d/default.conf && \
    echo '    }' >> /etc/nginx/http.d/default.conf && \
    echo '}' >> /etc/nginx/http.d/default.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Script de démarrage
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'php-fpm -D' >> /start.sh && \
    echo 'nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
