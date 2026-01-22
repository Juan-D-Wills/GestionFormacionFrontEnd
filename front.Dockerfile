FROM node:25-alpine AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .

FROM base AS dev
EXPOSE 8080
CMD ["npm", "run", "dev", "--", "--host", "--port", "8080"]

FROM base AS build
RUN npm run build

FROM nginx:alpine AS prod
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]