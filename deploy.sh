#!/bin/bash

# Script de déploiement pour Artisan'IA Website
# Usage: ./deploy.sh

set -e

echo "🚀 Déploiement d'Artisan'IA Website..."

# Variables
PROJECT_DIR="/home/ubuntu/artisan-ia-website"
BACKUP_DIR="/home/ubuntu/backups/artisan-ia-website"
DATE=$(date +%Y%m%d_%H%M%S)

# Créer le répertoire de sauvegarde s'il n'existe pas
mkdir -p $BACKUP_DIR

# Sauvegarder l'ancienne version si elle existe
if [ -d "$PROJECT_DIR" ]; then
    echo "📦 Sauvegarde de l'ancienne version..."
    tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" -C /home/ubuntu artisan-ia-website
    echo "✅ Sauvegarde créée: backup_$DATE.tar.gz"
fi

# Créer le répertoire du projet
mkdir -p $PROJECT_DIR

# Copier les fichiers
echo "📁 Copie des fichiers..."
cp -r . $PROJECT_DIR/

# Définir les permissions
echo "🔐 Configuration des permissions..."
chown -R ubuntu:ubuntu $PROJECT_DIR
chmod -R 755 $PROJECT_DIR

# Arrêter le conteneur existant s'il existe
echo "🛑 Arrêt du conteneur existant..."
docker-compose -f $PROJECT_DIR/docker-compose.yml down || true

# Construire et démarrer le nouveau conteneur
echo "🔨 Construction et démarrage du conteneur..."
cd $PROJECT_DIR
docker-compose up -d --build

# Vérifier le statut
echo "✅ Vérification du déploiement..."
sleep 5
if docker-compose ps | grep -q "Up"; then
    echo "🎉 Déploiement réussi !"
    echo "🌐 Site accessible sur: http://$(curl -s ifconfig.me)"
else
    echo "❌ Erreur lors du déploiement"
    docker-compose logs
    exit 1
fi

# Nettoyer les anciennes images Docker
echo "🧹 Nettoyage des anciennes images..."
docker image prune -f

echo "✨ Déploiement terminé avec succès !"
