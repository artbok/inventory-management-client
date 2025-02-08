FROM nginx:alpine

COPY build/web /usr/share/nginx/html

ENV SERVER=server

EXPOSE 80
