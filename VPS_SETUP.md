# Configuration VPS pour Artisan'IA

## 🚀 Étapes d'installation sur votre VPS

### 1. Connexion à votre VPS
```bash
ssh root@votre-ip-vps
# ou
ssh utilisateur@votre-ip-vps
```

### 2. Mise à jour du système
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Installation des services nécessaires
```bash
# Installer Nginx, PHP et les modules
sudo apt install nginx php8.1-fpm php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath -y

# Installer certbot pour SSL
sudo apt install certbot python3-certbot-nginx -y
```

### 4. Créer le répertoire du site
```bash
sudo mkdir -p /var/www/artisan-ia
sudo chown -R www-data:www-data /var/www/artisan-ia
sudo chmod -R 755 /var/www/artisan-ia
```

### 5. Copier vos fichiers
```bash
# Copier tous vos fichiers dans le répertoire
sudo cp index.html /var/www/artisan-ia/
sudo cp contact.php /var/www/artisan-ia/
sudo cp -r assets /var/www/artisan-ia/
sudo cp style.css /var/www/artisan-ia/
```

### 6. Configuration Nginx
```bash
# Créer le fichier de configuration
sudo nano /etc/nginx/sites-available/artisan-ia
```

**Contenu du fichier `/etc/nginx/sites-available/artisan-ia` :**
```nginx
server {
    listen 80;
    server_name artisan-ia.fr www.artisan-ia.fr;
    
    root /var/www/artisan-ia;
    index index.html index.php;
    
    # Configuration pour les fichiers statiques
    location / {
        try_files $uri $uri/ /index.html;
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
}
```

### 7. Activer le site
```bash
# Activer le site
sudo ln -sf /etc/nginx/sites-available/artisan-ia /etc/nginx/sites-enabled/

# Supprimer le site par défaut
sudo rm -f /etc/nginx/sites-enabled/default

# Tester la configuration
sudo nginx -t

# Redémarrer Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### 8. Configuration du pare-feu
```bash
# Ouvrir les ports nécessaires
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable
```

### 9. Configuration SSL (Let's Encrypt)
```bash
# Obtenir le certificat SSL
sudo certbot --nginx -d artisan-ia.fr -d www.artisan-ia.fr

# Vérifier le renouvellement automatique
sudo certbot renew --dry-run
```

### 10. Configuration PHP pour l'envoi d'emails
```bash
# Éditer la configuration PHP
sudo nano /etc/php/8.1/fpm/php.ini
```

**Rechercher et modifier :**
```ini
sendmail_path = /usr/sbin/sendmail -t -i
mail.add_x_header = On
```

### 11. Redémarrer tous les services
```bash
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
```

### 12. Vérifier que tout fonctionne
```bash
# Vérifier le statut des services
sudo systemctl status nginx
sudo systemctl status php8.1-fpm

# Tester le site
curl -I http://artisan-ia.fr
```

## 🔧 Configuration DNS

Dans votre panneau DNS, ajoutez :
```
A    artisan-ia.fr        VOTRE_IP_VPS
A    www.artisan-ia.fr    VOTRE_IP_VPS
```

## 📧 Test du formulaire

1. Allez sur https://artisan-ia.fr
2. Remplissez le formulaire de contact
3. Vérifiez que l'email arrive sur victorienbinant@artisan-ia.fr

## 🚨 En cas de problème

### Vérifier les logs
```bash
# Logs Nginx
sudo tail -f /var/log/nginx/error.log

# Logs PHP
sudo tail -f /var/log/php8.1-fpm.log
```

### Tester PHP
```bash
# Créer un fichier de test
echo "<?php phpinfo(); ?>" | sudo tee /var/www/artisan-ia/info.php

# Tester : https://artisan-ia.fr/info.php
# Supprimer après test : sudo rm /var/www/artisan-ia/info.php
```

## ✅ Votre site sera accessible sur :
- https://artisan-ia.fr
- https://www.artisan-ia.fr
