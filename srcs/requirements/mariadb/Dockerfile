# alpine:3.21.3 digest
# FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
FROM alpine:3.21.3

RUN apk add --no-cache \
	mariadb=11.4.5-r0 \
	mariadb-client=11.4.5-r0

COPY --chmod=0644 ./conf/mariadb_config /etc/my.cnf.d/mariadb_config
COPY --chmod=0755 ./tools/mariadb-script.sh /usr/local/bin/mariadb-script.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb-script.sh"]