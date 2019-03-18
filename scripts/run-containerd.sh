#!/usr/bin/env bash
# installs containerd into /usr/bin and runs it
set -e

sudo apt update
sudo apt install libseccomp-dev btrfs-tools

WORKDIR=$(pwd)
TEMPDIR=$(mktemp -d)
cd $TEMPDIR

wget https://github.com/containerd/containerd/releases/download/v1.2.5/containerd-1.2.5.linux-amd64.tar.gz
tar xvf containerd-1.2.5.linux-amd64.tar.gz
sudo chmod 755 bin/*
sudo mv bin/* /usr/bin
wget https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64 -o runc
sudo chmod 755 runc
sudo mv runc /usr/bin

cd $WORKDIR

sudo containerd > containerd.log 2>&1 &
sleep 5
cat containerd.log
