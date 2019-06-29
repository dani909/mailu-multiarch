#!/usr/bin/env bash
set -e

. "utils.sh"
source

build core/admin
build core/dovecot
build core/nginx
build core/none
build core/postfix
build optional/clamav
build optional/postgresql
build optional/radicale
build optional/traefik-certdumper
build services/fetchmail
build services/rspamd
build services/unbound
build webmails/rainloop
build webmails/roundcube
