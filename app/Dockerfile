# Build stage
FROM node:20-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Production stage: serve with nginx
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
