name: 🚀 Deploy to VPS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      # 1️⃣ Clone ton repo GitHub
      - name: Checkout code
        uses: actions/checkout@v4

      # 2️⃣ Envoie les fichiers sur ton VPS
      - name: Deploy files via SCP
        uses: appleboy/scp-action@master
        with:
          host: ${{ secrets.VPS_HOST }}
          port: ${{ secrets.VPS_PORT }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          source: "."
          target: "/home/ubuntu/artisan-ia-website"

      # 3️⃣ Redémarre le site proprement
      - name: Restart Docker container
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.VPS_HOST }}
          port: ${{ secrets.VPS_PORT }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: |
            cd /home/ubuntu/artisan-ia-website
            echo "🔄 Forcing sync with GitHub main branch..."
            git fetch origin main || true
            git reset --hard origin/main || true
            echo "🐳 Restarting Docker..."
            sudo docker compose down || true
            sudo docker compose up -d --build
            echo "✅ Deployment complete!"
