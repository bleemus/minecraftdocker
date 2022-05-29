#!/bin/bash

DATE=`date +"%m%d%y"`

sudo docker compose down
#sudo docker rm minecraft
sudo docker image tag minecraft:latest minecraft:$DATE
sudo docker compose build . --no-cache
sudo docker compose up -d
