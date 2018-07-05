FROM python:2.7

COPY config/php.ini /usr/local/etc/php/
COPY src/ /var/www/html/