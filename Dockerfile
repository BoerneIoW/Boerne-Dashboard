FROM nginx:latest

COPY nc-water-supply /usr/share/nginx/html

#COPY nginx/default.conf /etc/nginx/conf.d/default.conf
