#!/bin/sh

if [ -n $POSTFIX_RELAY_AUTH ]; then
  echo "$POSTFIX_RELAY $POSTFIX_RELAY_AUTH" > /etc/postfix/saslpasswd
  postmap /etc/postfix/saslpasswd
fi

exec "$@"
