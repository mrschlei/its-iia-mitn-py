FROM debian:latest

RUN apt-get update && apt-get install -y apache2 \
    libapache2-mod-wsgi \
    build-essential \
    python \
    python-dev\
    python-pip \
    vim \
 && apt-get clean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

# all because of some error
RUN mkdir /var/lib/apache2/module/enabled_by_admin
RUN chown root:root /var/lib/apache2/site/enabled_by_admin/default-ssl
RUN chmod g+rw /var/lib/apache2/site/enabled_by_admin/default-ssl
RUN rm /var/lib/apache2/site/enabled_by_admin/default-ssl
COPY . /etc/apache2

# Section that sets up Apache and Cosign to run as non-root user.
EXPOSE 8080
EXPOSE 8443
### change directory owner, as openshift user is in root group.
RUN chown -R root:root /etc/apache2 \
	/etc/ssl/certs /etc/ssl/private \
	/var/lib/apache2/module/enabled_by_admin \
	/var/lock/apache2 /var/log/apache2 /var/run/apache2 \
	/var/www/html \
	/usr/local/bin

### Modify perms for the openshift user, who is not root, but part of root group.
RUN chmod -R g+rw /etc/apache2 \
	/etc/ssl/certs /etc/ssl/private \
	/var/lib/apache2/module/enabled_by_admin \
	/var/lock/apache2 /var/log/apache2 /var/run/apache2 \
	/var/www/html \
	/usr/local/bin

RUN chmod g+x /etc/ssl/private

#RUN apt-get install -y autoconf gzip libxml2-dev make
RUN a2enmod headers
COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh

