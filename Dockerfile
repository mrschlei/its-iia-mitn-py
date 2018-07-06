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

##### Cosign Pre-requisites #####
WORKDIR /usr/lib/apache2/modules

ENV COSIGN_URL https://github.com/umich-iam/cosign/archive/cosign-3.4.0.tar.gz
ENV CPPFLAGS="-I/usr/kerberos/include"
ENV OPENSSL_VERSION 1.0.1t-1+deb8u7
ENV APACHE2=/usr/sbin/apache2

# install PHP and Apache2 here
RUN apt-get update \
	&& apt-get install -y apache2-dev autoconf \
	gcc gzip libssl-dev \
	openssl wget 

##### Build Cosign #####
RUN wget "$COSIGN_URL" \
	&& mkdir -p src/cosign \
	&& tar -xvf cosign-3.4.0.tar.gz -C src/cosign --strip-components=1 \
	&& rm cosign-3.4.0.tar.gz \
	&& cd src/cosign \
	&& autoconf \
	&& ./configure --enable-apache2=/usr/bin/apxs \
	&& make \
	&& make install \
	&& cd ../../ \
	&& rm -r src/cosign \
	&& mkdir -p /var/cosign/filter \
	&& chmod 777 /var/cosign/filter
#####

COPY test.py /var/www/html

# Section that sets up Apache and Cosign to run as non-root user.
EXPOSE 8080
EXPOSE 8443

### change directory owner, as openshift user is in root group.
RUN chown -R root:root /etc/apache2 \
	/etc/ssl/certs /etc/ssl/private \
	/var/lib/apache2/module/enabled_by_admin \
	/var/lib/apache2/site/enabled_by_admin \
	/var/lock/apache2 /var/log/apache2 /var/run/apache2 \
	/var/www/html \
	/usr/local/bin

### Modify perms for the openshift user, who is not root, but part of root group.
RUN chmod -R g+rw /etc/apache2 \
	/etc/ssl/certs /etc/ssl/private \
	/var/lib/apache2/module/enabled_by_admin \
	/var/lib/apache2/site/enabled_by_admin \
	/var/lock/apache2 /var/log/apache2 /var/run/apache2 \
	/var/www/html \
	/usr/local/bin

RUN chmod g+x /etc/ssl/private

COPY start.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh
