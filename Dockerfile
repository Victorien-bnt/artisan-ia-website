# Utilise Nginx comme base
FROM nginx:alpine

# Copie les fichiers de ton site vers le dossier web de Nginx
COPY . /usr/share/nginx/html

# Expose les ports 80 et 443 (cohérent avec ton docker-compose.yml)
EXPOSE 80
EXPOSE 443

# Démarre Nginx
CMD ["nginx", "-g", "daemon off;"]
