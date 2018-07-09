#!/bin/sh

#ln -sf /dev/stdout /var/log/apache2/access_log
#ln -sf /dev/stderr /var/log/apache2/error_log

# apache and virtual host secrets
#ln -sf /secrets/apache2/apache2.conf /etc/apache2/apache2.conf
#ln -sf /secrets/apache2/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
#ln -sf /secrets/apache2/cosign.conf /etc/apache2/mods-available/cosign.conf
#ln -sf /secrets/apache2/ports.conf /etc/apache2/ports.conf

# SSL secrets
ln -sf /secrets/ssl/USERTrustRSACertificationAuthority.pem /etc/ssl/certs/USERTrustRSACertificationAuthority.pem
ln -sf /secrets/ssl/AddTrustExternalCARoot.pem /etc/ssl/certs/AddTrustExternalCARoot.pem
ln -sf /secrets/ssl/sha384-Intermediate-cert.pem /etc/ssl/certs/sha384-Intermediate-cert.pem

if [ -f /secrets/app/local.start.sh ]
then
  /bin/sh /secrets/app/local.start.sh
fi

## Rehash command needs to be run before starting apache.
c_rehash /etc/ssl/certs >/dev/null

#a2enmod ssl
#a2enmod include
#a2ensite default-ssl 

#a2enmod expires
#a2enmod headers
#a2enmod rewrite 

#/usr/local/bin/apache2-foreground
#/usr/sbin/apachectl -f /etc/apache2/apache2.conf -k start

gunicorn -c guniconf wsgi:application
