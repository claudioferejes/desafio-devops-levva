FROM nginx:alpine
LABEL Desafio="Levva-DevOps"

RUN rm /usr/share/nginx/html/*

COPY ./site /usr/share/nginx/html/

CMD [ "nginx", "-g", "daemon off;" ]