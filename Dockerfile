FROM python:2.7
MAINTAINER Chris Kretler "ckretler@umich.edu"

RUN apt-get update -y

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

#RUN chown -R www-data /app
#USER www-data
RUN chmod g+r -R wsgi.py ./welcome

RUN chown root:root /etc/ssl/certs /etc/ssl/private
RUN chmod -R g+rw /etc/ssl/certs 
RUN chmod g+rwx /etc/ssl/private

EXPOSE 8000
EXPOSE 8080
EXPOSE 8443

COPY start.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh

#CMD ["gunicorn", "-c", "guniconf", "wsgi:application"]
