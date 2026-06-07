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
# ÉTAPE 2 : La Production (Environnement léger et sécurisé)
# ==========================================
FROM nginxinc/nginx-unprivileged:1-alpine-slim

# On supprime la conf par défaut de l'image unprivileged et on met la nôtre
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copie des fichiers compilés Angular
COPY --from=build /app/dist/MyAria/browser /usr/share/nginx/html

EXPOSE 8080

# Plus besoin de forcer les chemins avec -g, l'image le fait nativement de son côté !
CMD ["nginx", "-g", "daemon off;"]