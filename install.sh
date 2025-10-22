#!/bin/bash

echo "🚀 Installation d'Artisan'IA sur votre VPS..."

# Mettre à jour le système
echo "📦 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installer Nginx et PHP
echo "🌐 Installation de Nginx et PHP..."
sudo apt install nginx php8.1-fpm php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath -y

# Créer le répertoire du site
echo "📁 Création du répertoire du site..."
sudo mkdir -p /var/www/artisan-ia
sudo chown -R www-data:www-data /var/www/artisan-ia
sudo chmod -R 755 /var/www/artisan-ia

# Copier les fichiers
echo "📋 Copie des fichiers..."
sudo cp index.html /var/www/artisan-ia/
sudo cp contact.php /var/www/artisan-ia/
sudo cp -r assets /var/www/artisan-ia/
sudo cp style.css /var/www/artisan-ia/

# Configurer Nginx
echo "⚙️ Configuration de Nginx..."
sudo cp nginx-config.conf /etc/nginx/sites-available/artisan-ia
sudo ln -sf /etc/nginx/sites-available/artisan-ia /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Tester la configuration Nginx
echo "🔍 Test de la configuration Nginx..."
sudo nginx -t

# Redémarrer les services
echo "🔄 Redémarrage des services..."
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
sudo systemctl enable nginx
sudo systemctl enable php8.1-fpm

# Configurer le pare-feu
echo "🔥 Configuration du pare-feu..."
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable

echo "✅ Installation terminée !"
echo "🌐 Votre site est accessible sur : https://artisan-ia.fr"
echo "📧 Les emails du formulaire arrivent sur : victorienbinant@artisan-ia.fr"
echo ""
echo "🔧 Pour configurer SSL avec Let's Encrypt :"
echo "sudo apt install certbot python3-certbot-nginx"
echo "sudo certbot --nginx -d artisan-ia.fr -d www.artisan-ia.fr"
