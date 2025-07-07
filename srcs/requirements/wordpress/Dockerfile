# alpine:3.21.3 digest
FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

RUN apk add --no-cache \
		mariadb-client=11.4.5-r0 \
		php83=8.3.19-r0 \
		php83-fpm=8.3.19-r0 \
		php83-phar=8.3.19-r0 \
		php83-curl=8.3.19-r0 \
		php83-mysqli=8.3.19-r0 \
		php83-iconv=8.3.19-r0 \
		wget=1.25.0-r0 \
	&& adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data \
	&& mkdir -p /var/www/wp /var/www/html \
	&& chown -R www-data:www-data /var/www/wp /var/www/html

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY --chmod=755 ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh

EXPOSE 9000

ENTRYPOINT ["wordpress-script.sh"]