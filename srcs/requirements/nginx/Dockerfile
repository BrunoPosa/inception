# alpine:3.21.3 digest
# FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
FROM alpine:3.21.3

RUN apk add --no-cache \
		nginx=1.26.3-r0 \
		openssl=3.3.3-r0 \
	&& adduser -D -H -s /sbin/nologin -g www-data -G www-data www-data

COPY --chmod=0644 ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]