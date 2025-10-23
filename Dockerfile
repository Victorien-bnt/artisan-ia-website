FROM php:8.2-apache

# Installer msmtp
RUN apt-get update && apt-get install -y msmtp ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Configurer PHP pour utiliser msmtp
RUN echo "sendmail_path = /usr/bin/msmtp -t" >> /usr/local/etc/php/php.ini

# Copier la config msmtp
COPY msmtprc /etc/msmtprc

# Créer le fichier de log msmtp
RUN touch /var/log/msmtp.log && chmod 666 /var/log/msmtp.log

# Copier ton site
COPY . /var/www/html

# Permissions Apache
RUN chown -R www-data:www-data /var/www/html

# Activer mod_rewrite
RUN a2enmod rewrite

# Configuration Apache pour PHP
RUN echo '<Directory /var/www/html>' > /etc/apache2/conf-available/php.conf && \
    echo '    Options Indexes FollowSymLinks' >> /etc/apache2/conf-available/php.conf && \
    echo '    AllowOverride All' >> /etc/apache2/conf-available/php.conf && \
    echo '    Require all granted' >> /etc/apache2/conf-available/php.conf && \
    echo '</Directory>' >> /etc/apache2/conf-available/php.conf && \
    a2enconf php

# Exposer le port 80
EXPOSE 80

# Démarrer Apache
CMD ["apache2-foreground"]