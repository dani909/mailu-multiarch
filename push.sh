#!/usr/bin/env bash
set -e

. "utils.sh"
if [ "$TRAVIS" != "" ]; then
  login
fi

if [ "$IMAGE" != "" ]; then
  push "$IMAGE"
else
  push core/admin
  push core/dovecot
  push core/nginx
  push core/none
  push core/postfix
  push optional/clamav
  push optional/postgresql
  push optional/radicale
  push optional/traefik-certdumper
  push services/fetchmail
  push services/rspamd
  push services/unbound
  push webmails/rainloop
  push webmails/roundcube
fi
