#!/bin/bash
PROJECTID=$(gcloud config list project | awk 'FNR ==2 { print $3 }')

# Clean all images 
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

docker rmi -f grpc-kubernetes/microservice1:1.0
docker rmi -f gcr.io/$PROJECTID/microservice1:1.0

docker rmi -f grpc-kubernetes/microservice1:2.0
docker rmi -f gcr.io/$PROJECTID/microservice1:2.0

docker rmi -f grpc-kubernetes/microservice2:1.0
docker rmi -f gcr.io/$PROJECTID/microservice2:1.0

docker rmi -f grpc-kubernetes/server:1.0
docker rmi -f gcr.io/$PROJECTID/server:1.0