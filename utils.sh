#!/usr/bin/env bash

BUILD_DIR=${BUILD_DIR:-"repo"}
ROOT_DIR=$(pwd)

MERGE_PR=${REPO:-"1052"}

REPO=${REPO:-"dani09"}
SUFFIX=${SUFFIX:-"mailu-multiarch-"}
VERSION=${VERSION:-"master"}
PLATFORMS=${PLATFORMS:-"linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6"}

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
    git clone https://github.com/Mailu/Mailu.git $BUILD_DIR
  else
    echo "Git repo already exists"
  fi
  cd "$BUILD_DIR" && git fetch --all && \
    git checkout "$VERSION" --force && git reset origin/$VERSION --hard && git merge origin/$VERSION

  for pr in $MERGE_PR; do
    echo "Merging pr $pr"
    git fetch origin pull/$pr/head:$pr
    git merge $pr
  done

  cd "$ROOT_DIR"
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

function login {
    img login -u dani09 -p "$DOCKER_PASSWORD"
}

function push {
    IMG_NAME=$(basename $DIR)
    img push "docker.io/${REPO}/${SUFFIX}${IMG_NAME}:${VERSION}"
}

function travis_wait {
  while true; do
    sleep 120
    echo -e "\a"
  done
}

travis_wait &