# alpine:3.21.3 digest
# FROM alpine@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
FROM alpine:3.21.3

RUN apk add --no-cache \
		nodejs \
		npm \
		curl \
	&& npm install -g http-server

WORKDIR /usr/src/app

COPY ./src/ ./

EXPOSE 8080

CMD ["http-server", ".", "-p", "8080", "-a", "0.0.0.0"]