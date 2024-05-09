#!/bin/bash
docker rm -f projects-fitcrack_server-1 || true
sudo rm -rf data/fitcrack/*

docker run --rm -itd --entrypoint bash --name fitcrack hranicky/fitcrack_server:2.4.0
docker cp fitcrack:/home/boincadm data/fitcrack/boincadm
docker cp fitcrack:/var/lib/mysql data/fitcrack/mysql
docker rm -f fitcrack

chmod -R 777 data/fitcrack
