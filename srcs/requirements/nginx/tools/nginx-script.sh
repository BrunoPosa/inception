#!/bin/sh

sed -i "s|DOMAIN_NAME|$DOMAIN_NAME|g" /etc/nginx/nginx.conf
sed -i "s|STATIC_SITE|$STATIC_SITE|g" /etc/nginx/nginx.conf

mkdir -p /var/lib/nginx/tmp/fastcgi
chown -R www-data:www-data /var/lib/nginx/tmp

exec nginx -c /etc/nginx/nginx.conf -g "daemon off;"