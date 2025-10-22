#!/bin/bash

echo "🚀 Installation automatique d'Artisan'IA sur VPS"
echo "================================================"

# Vérifier que l'utilisateur est root ou sudo
if [ "$EUID" -ne 0 ]; then
    echo "❌ Veuillez exécuter ce script en tant que root ou avec sudo"
    echo "Usage: sudo ./install-vps.sh"
    exit 1
fi

# Mise à jour du système
echo "📦 Mise à jour du système..."
apt update && apt upgrade -y

# Installation des paquets nécessaires
echo "🌐 Installation de Nginx, PHP et dépendances..."
apt install nginx php8.1-fpm php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath certbot python3-certbot-nginx -y

# Créer le répertoire du site
echo "📁 Création du répertoire du site..."
mkdir -p /var/www/artisan-ia
chown -R www-data:www-data /var/www/artisan-ia
chmod -R 755 /var/www/artisan-ia

# Copier les fichiers (supposant qu'ils sont dans le répertoire courant)
echo "📋 Copie des fichiers..."
if [ -f "index.html" ]; then
    cp index.html /var/www/artisan-ia/
else
    echo "❌ Fichier index.html non trouvé. Veuillez vous assurer que tous les fichiers sont dans le répertoire courant."
    exit 1
fi

if [ -f "contact.php" ]; then
    cp contact.php /var/www/artisan-ia/
else
    echo "❌ Fichier contact.php non trouvé."
    exit 1
fi

if [ -d "assets" ]; then
    cp -r assets /var/www/artisan-ia/
else
    echo "⚠️  Dossier assets non trouvé."
fi

if [ -f "style.css" ]; then
    cp style.css /var/www/artisan-ia/
else
    echo "⚠️  Fichier style.css non trouvé."
fi

# Configuration Nginx
echo "⚙️ Configuration de Nginx..."
cat > /etc/nginx/sites-available/artisan-ia << 'EOF'
server {
    listen 80;
    server_name artisan-ia.fr www.artisan-ia.fr;
    
    root /var/www/artisan-ia;
    index index.html index.php;
    
    # Configuration pour les fichiers statiques
    location / {
        try_files $uri $uri/ /index.html;
        
        # Headers de sécurité
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;
    }
    
    # Configuration pour le formulaire PHP
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    # Configuration pour les images et assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Sécurité - bloquer l'accès aux fichiers sensibles
    location ~ /\. {
        deny all;
    }
}
EOF

# Activer le site
echo "🔗 Activation du site..."
ln -sf /etc/nginx/sites-available/artisan-ia /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Tester la configuration Nginx
echo "🔍 Test de la configuration Nginx..."
nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Configuration Nginx valide"
else
    echo "❌ Erreur dans la configuration Nginx"
    exit 1
fi

# Redémarrer les services
echo "🔄 Redémarrage des services..."
systemctl restart nginx
systemctl restart php8.1-fpm
systemctl enable nginx
systemctl enable php8.1-fpm

# Configuration du pare-feu
echo "🔥 Configuration du pare-feu..."
ufw allow 'Nginx Full'
ufw allow ssh
ufw --force enable

# Configuration PHP pour l'envoi d'emails
echo "📧 Configuration PHP pour l'envoi d'emails..."
sed -i 's/;sendmail_path =/sendmail_path = \/usr\/sbin\/sendmail -t -i/' /etc/php/8.1/fpm/php.ini
sed -i 's/;mail.add_x_header = On/mail.add_x_header = On/' /etc/php/8.1/fpm/php.ini

# Redémarrer PHP-FPM
systemctl restart php8.1-fpm

echo ""
echo "✅ Installation terminée !"
echo "=========================="
echo "🌐 Votre site est accessible sur : http://artisan-ia.fr"
echo "📧 Les emails du formulaire arrivent sur : victorienbinant@artisan-ia.fr"
echo ""
echo "🔧 Prochaines étapes :"
echo "1. Configurez votre DNS pour pointer vers cette IP"
echo "2. Obtenez un certificat SSL :"
echo "   sudo certbot --nginx -d artisan-ia.fr -d www.artisan-ia.fr"
echo ""
echo "📊 Vérification des services :"
systemctl status nginx --no-pager -l
echo ""
systemctl status php8.1-fpm --no-pager -l
