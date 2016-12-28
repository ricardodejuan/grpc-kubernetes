PROJECTID=$(gcloud config list project | awk 'FNR ==2 { print $3 }')


docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

docker rmi -f grpc-kubernetes/microservice1:1.0
docker rmi -f gcr.io/$PROJECTID/microservice1:1.0
docker rmi -f grpc-kubernetes/microservice2:1.0
docker rmi -f gcr.io/$PROJECTID/microservice2:1.0
docker rmi -f grpc-kubernetes/server:1.0
docker rmi -f gcr.io/$PROJECTID/server:1.0

clear

docker build -t grpc-kubernetes/microservice1:1.0 ./microservice1/
docker build -t grpc-kubernetes/microservice2:1.0 ./microservice2/
docker build -t grpc-kubernetes/server:1.0 ./server/


docker tag grpc-kubernetes/microservice1:1.0 gcr.io/$PROJECTID/microservice1:1.0
gcloud docker push gcr.io/$PROJECTID/microservice1:1.0

docker tag grpc-kubernetes/microservice2:1.0 gcr.io/$PROJECTID/microservice2:1.0
gcloud docker push gcr.io/$PROJECTID/microservice2:1.0

docker tag grpc-kubernetes/server:1.0 gcr.io/$PROJECTID/server:1.0
gcloud docker push gcr.io/$PROJECTID/server:1.0


kubectl create -f microservice1-controller.yaml
kubectl create -f microservice2-controller.yaml
kubectl create -f server-controller.yaml


kubectl create -f microservice1-service.yaml
kubectl create -f microservice2-service.yaml
kubectl create -f server-service.yaml
