FROM python:2.7.15-stretch
#reminder - add start.sh and secrets later
COPY . /var/www/html/


COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh
