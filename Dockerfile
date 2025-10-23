FROM php:8.2-apache

# Installer msmtp et ses dépendances
RUN apt-get update && apt-get install -y msmtp msmtp-mta ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Activer msmtp comme mailer PHP
RUN echo "sendmail_path = /usr/bin/msmtp -t" >> /usr/local/etc/php/php.ini

# Copier la configuration msmtp dans le conteneur
COPY msmtprc /etc/msmtprc

# Créer le fichier de log
RUN touch /var/log/msmtp.log && chmod 666 /var/log/msmtp.log

# Copier les fichiers du site
COPY . /var/www/html

# Donne les bons droits à Apache
RUN chown -R www-data:www-data /var/www/html
