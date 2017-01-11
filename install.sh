#	BEEVA
# 
# Initiative R&D
# 
# PoC - gRPC
#  
# Description:
# Design, build and deploy a collection of microservices developed 
# by gRPC along with Google Cloud Platform and Kubernetes
#
# Steps
# 0. Create a GCP Account
# 1. Create a New Project in GCP
# 2. Enable Compute Engine and Container Engine APIs => https://console.developers.google.com/apis/library
# 3. Enable Google Cloud Shell
# 4. Configure Cloud Shell Environment
# gcloud compute zones list
# gcloud config set compute/zone europe-west1-d

# 5. Setting up Kubernetes
# Provision a Kubernetes Cluster with GKE using gcloud
# gcloud container clusters create k0
# gcloud container clusters get-credentials k0

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

clear


# Build Containers
printf "\n\n Build Containers \n"

printf "\n\n Container microservice1 \n"

docker build -t grpc-kubernetes/microservice1:1.0 ./microservice1/

printf "\n\n Container microservice2 \n"

docker build -t grpc-kubernetes/microservice2:1.0 ./microservice2/

printf "\n\n Container server \n"

docker build -t grpc-kubernetes/server:1.0 ./server/


# Publish Containers

printf "\n\n Publish Containers \n"

printf "\n\n Publish Container microservice1 \n"

docker tag grpc-kubernetes/microservice1:1.0 gcr.io/$PROJECTID/microservice1:1.0
gcloud docker push gcr.io/$PROJECTID/microservice1:1.0

printf "\n\n Publish Container microservice2 \n"

docker tag grpc-kubernetes/microservice2:1.0 gcr.io/$PROJECTID/microservice2:1.0
gcloud docker push gcr.io/$PROJECTID/microservice2:1.0

printf "\n\n Publish Container server \n"

docker tag grpc-kubernetes/server:1.0 gcr.io/$PROJECTID/server:1.0
gcloud docker push gcr.io/$PROJECTID/server:1.0


# Create Controllers

printf "\n\n Create Controllers \n"

printf "\n\n Create Controller microservice1 \n"
kubectl create -f microservice1-controller.yaml

printf "\n\n Create Controller microservice2 \n"

kubectl create -f microservice2-controller.yaml

printf "\n\n Create Controller server \n"

kubectl create -f server-controller.yaml


# Create Services

printf "\n\n Create Services \n"

printf "\n\n Create Service microservice1 \n"

kubectl create -f microservice1-service.yaml

printf "\n\n Create Service microservice2 \n"

kubectl create -f microservice2-service.yaml

printf "\n\n Create Service server \n"

kubectl create -f server-service.yaml


# Next Step: Update microservice1 to microservice1b

# Update Microservice1

# docker build -t grpc-kubernetes/microservice1:2.0 ./microservice1b/

# docker tag grpc-kubernetes/microservice1:2.0 gcr.io/$PROJECTID/microservice1:2.0
# gcloud docker push gcr.io/$PROJECTID/microservice1:2.0

# Modify microservice1-controller.yaml 
# - image: gcr.io/centering-talon-150121/microservice1b:2.0

# kubectl apply -f microservice1-controller.yaml