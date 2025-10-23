name: 🚀 Deploy to VPS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      # 1️⃣ Récupère ton code depuis GitHub
      - name: Checkout code
        uses: actions/checkout@v4

      # 2️⃣ Envoie tous les fichiers sur ton VPS
      - name: Deploy files via SCP
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.VPS_HOST }}
          port: ${{ secrets.VPS_PORT }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          source: "."
          target: "/home/ubuntu/artisan-ia-website"

      # 3️⃣ Redémarre ton site sur le VPS
      - name: Restart Docker container
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.VPS_HOST }}
          port: ${{ secrets.VPS_PORT }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /home/ubuntu/artisan-ia-website
            # 🔥 Récupère la dernière version GitHub
            git fetch origin main || true
            # 💥 Écrase tout et remet la version GitHub
            git reset --hard origin/main || true
            # 🐳 Redémarre Docker proprement
            sudo docker compose down || true
            sudo docker compose up -d --build
            echo "✅ Déploiement terminé avec succès !"
