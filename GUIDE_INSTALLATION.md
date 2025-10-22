# 🚀 Guide d'installation Artisan'IA sur VPS

## 📋 Fichiers à transférer sur votre VPS

**Copiez ces fichiers sur votre VPS :**
- `index.html`
- `contact.php` 
- `style.css`
- `assets/` (dossier complet)
- `install-vps.sh`

## 🔧 Installation en 3 étapes

### 1. Connexion à votre VPS
```bash
ssh root@votre-ip-vps
```

### 2. Transfert des fichiers
```bash
# Créer le répertoire
mkdir artisan-ia
cd artisan-ia

# Transférer vos fichiers (avec WinSCP, FileZilla, ou scp)
# Ou copier-coller le contenu des fichiers
```

### 3. Installation automatique
```bash
# Rendre le script exécutable
chmod +x install-vps.sh

# Lancer l'installation
sudo ./install-vps.sh
```

## ⚡ Installation manuelle (si le script ne fonctionne pas)

### 1. Mise à jour du système
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Installation des services
```bash
sudo apt install nginx php8.1-fpm php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath certbot python3-certbot-nginx -y
```

### 3. Créer le répertoire
```bash
sudo mkdir -p /var/www/artisan-ia
sudo chown -R www-data:www-data /var/www/artisan-ia
sudo chmod -R 755 /var/www/artisan-ia
```

### 4. Copier les fichiers
```bash
sudo cp index.html /var/www/artisan-ia/
sudo cp contact.php /var/www/artisan-ia/
sudo cp style.css /var/www/artisan-ia/
sudo cp -r assets /var/www/artisan-ia/
```

### 5. Configuration Nginx
```bash
sudo nano /etc/nginx/sites-available/artisan-ia
```

**Coller cette configuration :**
```nginx
server {
    listen 80;
    server_name artisan-ia.fr www.artisan-ia.fr;
    
    root /var/www/artisan-ia;
    index index.html index.php;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

### 6. Activer le site
```bash
sudo ln -sf /etc/nginx/sites-available/artisan-ia /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
```

### 7. Configuration du pare-feu
```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw --force enable
```

### 8. SSL (optionnel mais recommandé)
```bash
sudo certbot --nginx -d artisan-ia.fr -d www.artisan-ia.fr
```

## 🌐 Configuration DNS

Dans votre panneau DNS, ajoutez :
```
A    artisan-ia.fr        VOTRE_IP_VPS
A    www.artisan-ia.fr    VOTRE_IP_VPS
```

## ✅ Vérification

1. **Test du site :** https://artisan-ia.fr
2. **Test du formulaire :** Remplissez et envoyez
3. **Vérification email :** Vérifiez victorienbinant@artisan-ia.fr

## 🚨 En cas de problème

### Vérifier les logs
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/php8.1-fpm.log
```

### Tester PHP
```bash
echo "<?php phpinfo(); ?>" | sudo tee /var/www/artisan-ia/info.php
# Tester : https://artisan-ia.fr/info.php
sudo rm /var/www/artisan-ia/info.php
```

## 📞 Support

Si vous avez des problèmes :
1. Vérifiez les logs d'erreur
2. Testez le formulaire
3. Contactez-moi par WhatsApp : 0664156439
