# 🚀 Guide de Déploiement - Artisan'IA Website

## 📋 Prérequis

- Docker et Docker Compose installés
- Accès SSH au serveur VPS
- Domaine configuré (optionnel)

## 🐳 Déploiement avec Docker

### 1. Préparation du serveur

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation de Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Installation de Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Ajouter l'utilisateur au groupe docker
sudo usermod -aG docker $USER
```

### 2. Déploiement automatique

```bash
# Cloner ou copier les fichiers
git clone <repository-url> /home/ubuntu/artisan-ia-website
cd /home/ubuntu/artisan-ia-website

# Rendre le script exécutable
chmod +x deploy.sh

# Lancer le déploiement
./deploy.sh
```

### 3. Déploiement manuel

```bash
# Construire l'image
docker build -t artisan-ia-website .

# Démarrer le conteneur
docker run -d -p 80:80 --name artisan-ia-website artisan-ia-website

# Ou utiliser Docker Compose
docker-compose up -d
```

## 🌐 Configuration Nginx (optionnel)

Si vous préférez utiliser Nginx directement :

```nginx
server {
    listen 80;
    server_name votre-domaine.com;
    root /home/ubuntu/artisan-ia-website;
    index index.html;

    # Compression gzip
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # Cache des assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Sécurité
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

## 🔧 Configuration SSL avec Let's Encrypt

```bash
# Installation de Certbot
sudo apt install certbot python3-certbot-nginx

# Génération du certificat
sudo certbot --nginx -d votre-domaine.com

# Renouvellement automatique
sudo crontab -e
# Ajouter : 0 12 * * * /usr/bin/certbot renew --quiet
```

## 📊 Monitoring et Logs

### Vérifier le statut

```bash
# Statut du conteneur
docker ps

# Logs du conteneur
docker logs artisan-ia-website

# Logs en temps réel
docker logs -f artisan-ia-website
```

### Monitoring des performances

```bash
# Utilisation des ressources
docker stats artisan-ia-website

# Espace disque
df -h

# Mémoire
free -h
```

## 🔄 Mise à jour

```bash
# Arrêter le conteneur
docker-compose down

# Mettre à jour les fichiers
git pull origin main

# Redémarrer
docker-compose up -d --build
```

## 🛠️ Dépannage

### Problèmes courants

1. **Port 80 déjà utilisé**
   ```bash
   sudo lsof -i :80
   sudo systemctl stop apache2  # ou nginx
   ```

2. **Permissions insuffisantes**
   ```bash
   sudo chown -R ubuntu:ubuntu /home/ubuntu/artisan-ia-website
   chmod -R 755 /home/ubuntu/artisan-ia-website
   ```

3. **Conteneur ne démarre pas**
   ```bash
   docker logs artisan-ia-website
   docker-compose logs
   ```

### Tests de validation

```bash
# Tester la connectivité
curl -I http://localhost

# Tester avec curl
curl -s -o /dev/null -w "%{http_code}" http://localhost

# Tester les performances
curl -w "@curl-format.txt" -o /dev/null -s http://localhost
```

## 📈 Optimisations

### Performance

- Activer la compression gzip
- Configurer le cache des assets
- Utiliser un CDN (Cloudflare, etc.)
- Optimiser les images

### Sécurité

- Configurer un firewall
- Utiliser HTTPS
- Mettre à jour régulièrement
- Surveiller les logs

## 🔍 Maintenance

### Sauvegardes

```bash
# Sauvegarde des fichiers
tar -czf backup-$(date +%Y%m%d).tar.gz /home/ubuntu/artisan-ia-website

# Sauvegarde de la base de données (si applicable)
# mysqldump -u user -p database > backup.sql
```

### Nettoyage

```bash
# Nettoyer les images Docker inutilisées
docker image prune -f

# Nettoyer les conteneurs arrêtés
docker container prune -f

# Nettoyer les volumes inutilisés
docker volume prune -f
```

## 📞 Support

En cas de problème :

1. Vérifier les logs : `docker logs artisan-ia-website`
2. Tester la connectivité : `curl -I http://localhost`
3. Vérifier les ressources : `docker stats`
4. Consulter la documentation Docker

---

**Note** : Ce guide suppose un déploiement sur Ubuntu/Debian. Adaptez les commandes selon votre distribution.
