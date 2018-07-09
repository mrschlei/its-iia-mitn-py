FROM python:2.7
MAINTAINER Chris Kretler "ckretler@umich.edu"

RUN apt-get update -y

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

#RUN chown -R www-data /app
#USER www-data
RUN chmod g+r -R wsgi.py ./welcome

EXPOSE 8000
EXPOSE 8080
EXPOSE 8443

## Rehash command needs to be run before starting apache.
RUN c_rehash /etc/pki/tls/certs >/dev/null

COPY start.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/start.sh
RUN /usr/local/bin/start.sh

CMD ["gunicorn", "-c", "guniconf", "wsgi:application"]
