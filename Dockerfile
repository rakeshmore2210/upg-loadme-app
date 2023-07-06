FROM node:20-alpine
WORKDIR /usr/src/app
COPY package*.json .
COPY server.js .
RUN npm install
RUN npm ci --omit=dev
EXPOSE 8080
CMD [ "node", "server.js" ]