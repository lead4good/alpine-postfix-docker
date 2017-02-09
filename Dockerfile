FROM alpine:edge

ENV DOCKERIZE_VERSION 0.2.0
RUN apk add --no-cache ca-certificates curl && \
    mkdir -p /usr/local/bin/ && \
    curl -SL https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz \
    | tar xzC /usr/local/bin

COPY . /root/
WORKDIR /root

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
		postfix \
		supervisor \
		rsyslog

EXPOSE 25

ENV POSTFIX_MYDESTINATION localhost
ENV POSTFIX_MYDOMAIN localhost.local
ENV POSTFIX_MYHOSTNAME localhost.local
ENV POSTFIX_RELAY ""
ENV POSTFIX_INET_INTERFACES loopback-only

RUN newaliases
RUN mkdir -p /var/mail
COPY ./supervisord.conf /etc/supervisor/supervisord.conf

CMD dockerize -template /root/main.tmpl:/etc/postfix/main.cf /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
