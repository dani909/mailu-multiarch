#!/usr/bin/env bash

BUILD_DIR="build"
ROOT_DIR=$(pwd)

REPO="dani09"
SUFFIX="mailu-multiarch-"
VERSION="master"
PLATFORMS="linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6"

function img {
  docker run --rm -it \
    --name img \
    --volume $(pwd):/home/user/src:ro \
    --workdir /home/user/src \
    --volume "${HOME}/.docker:/root/.docker:ro" \
    --volume "${HOME}/.local/share/img:/home/user/.local/share/img" \
    --security-opt seccomp=unconfined --security-opt apparmor=unconfined \
    r.j3ss.co/img "$@"
}

function source {
  if [ ! -d "$BUILD_DIR/.git" ]; then
    git clone https://github.com/Mailu/Mailu.git build
  else
    echo "Git repo already exists"
  fi
  cd "$BUILD_DIR" && git fetch --all && \
    git checkout "$VERSION" && git merge origin/"$VERSION" && cd "$ROOT_DIR"
}

function build {
    DIR="${BUILD_DIR}/$1"
    IMG_NAME=$(basename $DIR)

    ARGS="--platform $PLATFORMS -t docker.io/${REPO}/${SUFFIX}${IMG_NAME}:${VERSION}"

    if [ "$TRAVIS" != "" ];then
      ARGS="${ARGS} --no-console"
    fi

    img build $ARGS "$DIR"
}
