FROM python:2.7
MAINTAINER Chris Kretler "ckretler@umich.edu"

RUN apt-get update -y

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

#RUN chown -R www-data /app
#USER www-data
RUN chmod g+r -R wsgi.py ./welcome

EXPOSE 8080
EXPOSE 8443

CMD ["gunicorn", "-c", "guniconf", "wsgi:application"]
