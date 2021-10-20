#!/bin/bash

DATE=`date +"%m%d%y"`

sudo docker stop minecraft && sudo docker rm minecraft
sudo docker image tag minecraft:latest minecraft:$DATE
sudo docker build . --no-cache -t minecraft:latest
sudo docker run -d --network=host --restart=unless-stopped --name minecraft -e EULA=TRUE -v /home/bleemus/mcdata/server.properties:/bedrock-server/server.properties -v /home/bleemus/mcdata/worlds/:/bedrock-server/worlds minecraft:latest
