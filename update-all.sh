#!/bin/sh
docker ps --format '{{.Image}}' | xargs -L1 docker pull
./run.sh all
