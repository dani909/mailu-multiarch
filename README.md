# mailu-multiarch

[![Build Status](https://travis-ci.com/daniel0611/mailu-multiarch.svg?branch=master)](https://travis-ci.com/daniel0611/mailu-multiarch)

This repository contains scripts for building [Mailu](https://github.com/Mailu/Mailu) multiarch images with amd64,arm64,armv7 and armv6 support.
The images are published at `dani09/multiarch-mailu-*` and are built weekly by travis. Note that currently only builds for the master branch are published.

You can use them the following way: `DOCKER_ORG=dani09 DOCKER_PREFIX=multiarch-mailu- docker-compose up -d`
with the config files of the setup generator hosted at [setup.mailu.io](https://setup.mailu.io)

