# ==========================================
# ÉTAPE 1 : Le Build (Environnement de développement)
# ==========================================
FROM node:20-alpine AS build
WORKDIR /app

# Copie des fichiers de configuration des dépendances
COPY package*.json ./

# Installation propre des dépendances avec les peer dependencies Angular résolues
RUN npm ci

# Copie du reste du code source (Le .dockerignore bloquera le node_modules local)
COPY . .

# Compilation du projet Angular
RUN npm run build

# ==========================================
# ÉTAPE 2 : La Production (Environnement léger)
# ==========================================
FROM nginx:1-alpine-slim

# On supprime la conf par défaut et on copie notre bloc "server" propre
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copie des fichiers compilés Angular
COPY --from=build /app/dist/MyAria/browser /usr/share/nginx/html

# Exposer le port non-root pour la visibilité
EXPOSE 8080

# Injection magique DevSecOps : on configure Nginx pour tourner dans /tmp à la volée !
CMD ["nginx", "-g", "daemon off; pid /tmp/nginx.pid; client_body_temp_path /tmp/client_temp; proxy_temp_path /tmp/proxy_temp_path; fastcgi_temp_path /tmp/fastcgi_temp; uwsgi_temp_path /tmp/uwsgi_temp; scgi_temp_path /tmp/scgi_temp;"]
