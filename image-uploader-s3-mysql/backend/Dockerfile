FROM node:12.12.0-alpine
WORKDIR /app
COPY . .
RUN npm install
ENTRYPOINT ["npm", "start"]
EXPOSE 8080
