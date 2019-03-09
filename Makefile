PLATFORM = linux/amd64,linux/arm64,linux/arm/v6,linux/arm/v7
REPO = docker.io/dani09
PREFIX = mailu-multiarch-
VERSION = master
CACHE = # to be enabled by ci

USER =
PASSWORD =  # to be set by ci/user

FRONTEND = --frontend dockerfile.v0 --frontend-opt platform=$(PLATFORM)
C = ,
IMAGES = admin nginx dovecot none postfix clamav postgresql radicale traefik-certdumper fetchmail rspamd unbound rainloop roundcube

all: $(IMAGES)

source:
	$(if $(wildcard build/.git), @echo "Git repo already created", git clone https://github.com/Mailu/Mailu.git build)
	cd build && git fetch
	cd build && git checkout origin/$(VERSION)

push: all
	push = ctr -n buildkit image push $(REPO)/$(PREFIX)$(img):$(VERSION) $(if $(USER), -u $(USER):$(PASSWORD))
	$(foreach img, $(IMAGES), $(push))
push-%:
	 ctr -n buildkit image push $(REPO)/$(PREFIX)$(subst push-,,$@):$(VERSION) $(if $(USER), -u $(USER):$(PASSWORD))

# Core
admin: source
	buildctl build $(FRONTEND) --local dockerfile=build/core/admin --local \
	 context=build/core/admin --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)admin:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/admin/index.json)), --import-cache type=local$(C)store=cache/admin) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/admin$(C)mode=max)

dovecot: source
	sed "s/alpine:3.8/alpine:edge/g" -i  build/core/dovecot/Dockerfile
	buildctl build $(FRONTEND) --local dockerfile=build/core/dovecot --local \
	 context=build/core/dovecot --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)dovecot:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/dovecot/index.json)), --import-cache type=local$(C)store=cache/dovecot) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/dovecot$(C)mode=max)

nginx: source
	buildctl build $(FRONTEND) --local dockerfile=build/core/nginx --local \
	 context=build/core/nginx --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)nginx:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/nginx/index.json)), --import-cache type=local$(C)store=cache/nginx) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/nginx$(C)mode=max)

none: source
	buildctl build $(FRONTEND) --local dockerfile=build/core/none --local \
	 context=build/core/none --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)none:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/none/index.json)), --import-cache type=local$(C)store=cache/none) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/none$(C)mode=max)

postfix: source
	buildctl build $(FRONTEND) --local dockerfile=build/core/postfix --local \
	 context=build/core/postfix --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)postfix:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/postfix/index.json)), --import-cache type=local$(C)store=cache/postfix) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/postfix$(C)mode=max)


# Optional
clamav: source
	buildctl build $(FRONTEND) --local dockerfile=build/optional/clamav --local \
	 context=build/optional/clamav --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)clamav:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/clamav/index.json)), --import-cache type=local$(C)store=cache/clamav) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/clamav$(C)mode=max)

postgresql: source
	buildctl build $(FRONTEND) --local dockerfile=build/optional/postgresql --local \
	 context=build/optional/postgresql --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)postgresql:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/postgresql/index.json)), --import-cache type=local$(C)store=cache/postgresql) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/postgresql$(C)mode=max)

radicale: source
	buildctl build $(FRONTEND) --local dockerfile=build/optional/radicale --local \
	 context=build/optional/radicale --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)radicale:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/radicale/index.json)), --import-cache type=local$(C)store=cache/radicale) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/radicale$(C)mode=max)

traefik-certdumper: source
	buildctl build $(FRONTEND) --local dockerfile=build/optional/traefik-certdumper --local \
	 context=build/optional/traefik-certdumper --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)traefik-certdumper:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/traefik-certdumper/index.json)), --import-cache type=local$(C)store=cache/traefik-certdumper) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/traefik-certdumper$(C)mode=max)


# Services
fetchmail: source
	buildctl build $(FRONTEND) --local dockerfile=build/services/fetchmail --local \
	 context=build/services/fetchmail --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)fetchmail:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/fetchmail/index.json)), --import-cache type=local$(C)store=cache/fetchmail) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/fetchmail$(C)mode=max)

rspamd: source
	sed "s/alpine:3.8/alpine:edge/g" -i  build/services/rspamd/Dockerfile
	buildctl build $(FRONTEND) --local dockerfile=build/services/rspamd --local \
	 context=build/services/rspamd --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)rspamd:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/rspamd/index.json)), --import-cache type=local$(C)store=cache/rspamd) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/rspamd$(C)mode=max)

unbound: source
	buildctl build $(FRONTEND) --local dockerfile=build/services/unbound --local \
	 context=build/services/unbound --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)unbound:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/unbound/index.json)), --import-cache type=local$(C)store=cache/unbound) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/unbound$(C)mode=max)


# Webmail
rainloop: source
	buildctl build $(FRONTEND) --local dockerfile=build/webmails/rainloop --local \
	 context=build/webmails/rainloop --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)rainloop:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/rainloop/index.json)), --import-cache type=local$(C)store=cache/rainloop) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/rainloop$(C)mode=max)

roundcube: source
	buildctl build $(FRONTEND) --local dockerfile=build/webmails/roundcube --local \
	 context=build/webmails/roundcube --exporter image --exporter-opt \
	 name=$(REPO)/$(PREFIX)roundcube:$(VERSION) \
	 $(if $(and $(CACHE),$(wildcard cache/roundcube/index.json)), --import-cache type=local$(C)store=cache/roundcube) \
	 $(if $(CACHE), --export-cache type=local$(C)store=cache/roundcube$(C)mode=max)
