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

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copie des fichiers compilés
COPY --from=build /app/dist/MyAria/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
