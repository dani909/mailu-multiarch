#!/usr/bin/env bash
# Runs buildkit
set -e

ID=$(docker create moby/buildkit:v0.4.0)
sudo docker cp $ID:/usr/bin/buildctl /usr/bin/
sudo docker cp $ID:/usr/bin/buildkitd /usr/bin/
docker rm $ID
sudo buildkitd --oci-worker=false --containerd-worker=true --addr tcp://0.0.0.0:1234 > buildkitd.log 2>&1 &
sleep 5
cat buildkitd.log
