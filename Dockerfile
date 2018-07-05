FROM httpd:2.4
#COPY ./public-html/ /usr/local/apache2/htdocs/


FROM python:2.7
#reminder - add start.sh and secrets later
COPY . /var/www/html/
