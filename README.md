# mailu-multiarch

[![Build Status](https://travis-ci.com/daniel0611/mailu-multiarch.svg?branch=master)](https://travis-ci.com/daniel0611/mailu-multiarch)

## Description
This repository contains scripts for building [Mailu](https://github.com/Mailu/Mailu) multiarch images with amd64, arm64 and armv7 support using [img](https://github.com/genuinetools/img).
These images are published at `dani09/mailu-multiarch-*` currently for the master branch and the 1.6 release.

## Usage
You can use them the following way: `DOCKER_ORG=dani09 DOCKER_PREFIX=mailu-multiarch- docker-compose up -d`
with the config files of the setup generator hosted at [setup.mailu.io](https://setup.mailu.io).
