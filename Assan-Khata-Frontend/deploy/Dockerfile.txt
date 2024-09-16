FROM node:lts-alpine

RUN npm -y -g install serve

WORKDIR /app/

copy . .

EXPOSE 3000

CMD ["serve", "web"]