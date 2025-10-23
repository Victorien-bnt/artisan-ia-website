FROM php:8.2-apache

# Installer msmtp pour envoyer des mails
RUN apt-get update && apt-get install -y msmtp msmtp-mta ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Configurer PHP pour utiliser msmtp
RUN echo "sendmail_path = /usr/bin/msmtp -t" >> /usr/local/etc/php/php.ini

# Copier la config msmtp dans le conteneur
COPY msmtprc /etc/msmtprc

# Créer le fichier de log msmtp
RUN touch /var/log/msmtp.log && chmod 666 /var/log/msmtp.log

# Copier ton site
COPY . /var/www/html

# Permissions Apache
RUN chown -R www-data:www-data /var/www/html
