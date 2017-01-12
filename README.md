# PoC - gRPC

### Description:
Design, build and deploy a collection of microservices developed by gRPC along with Google Cloud Platform and Kubernetes.

### Steps to Run:

1. Create a GCP Account [Click](https://cloud.google.com/)
2. Create a New Project in GCP
3. Enable Compute Engine and Container Engine APIs [Click](https://console.developers.google.com/apis/library)
4. Enable Google Cloud Shell
5. Configure Cloud Shell Environment

	```sh
	$ gcloud compute zones list

	$ gcloud config set compute/zone europe-west1-d
	```

6. Setting up Kubernetes - Provision a Kubernetes Cluster with GKE using gcloud

	```sh
	$ gcloud container clusters create k0

	$ gcloud container clusters get-credentials k0	
	```

7. Clone this repository 

8. Clean all images

	```sh
	$ PROJECTID=$(gcloud config list project | awk 'FNR ==2 { print $3 }')

	$ ./clean.sh
	```

9. Get a new API KEY for Microservice 2 [Click](http://imdb.wemakesites.net/#anhcor-authentication)

	Set the API KEY obtained to `microservice2/catalogMicroservice.js file


10. Build Containers

	```sh
	# Container microservice1
	$ docker build -t grpc-kubernetes/microservice1:1.0 ./microservice1/

	# Container microservice2
	$ docker build -t grpc-kubernetes/microservice2:1.0 ./microservice2/

	# Container server
	$ docker build -t grpc-kubernetes/server:1.0 ./server/
	```

11. Publish Containers

	```sh
	# Container microservice1
	$ docker tag grpc-kubernetes/microservice1:1.0 gcr.io/$PROJECTID/microservice1:1.0
	$ gcloud docker push gcr.io/$PROJECTID/microservice1:1.0

	# Container microservice2
	$ docker tag grpc-kubernetes/microservice2:1.0 gcr.io/$PROJECTID/microservice2:1.0
	$ gcloud docker push gcr.io/$PROJECTID/microservice2:1.0

	# Container server
	$ docker tag grpc-kubernetes/server:1.0 gcr.io/$PROJECTID/server:1.0
	$ gcloud docker push gcr.io/$PROJECTID/server:1.0
	```

12. Create Controllers

	First, change the $PROJECTID variable for each *-controller.yaml file

	```sh
	# Controller microservice1
	$ kubectl create -f microservice1-controller.yaml

	# Controller microservice2
	$ kubectl create -f microservice2-controller.yaml

	# Controller server
	$ kubectl create -f server-controller.yaml
	```

13. Create Services

	```sh
	# Service microservice1
	$ kubectl create -f microservice1-service.yaml

	# Service microservice2
	$ kubectl create -f microservice2-service.yaml

	# Service server
	$ kubectl create -f server-service.yaml
	```


### Test

Get EXTERNAL-IP from "server" service

```sh
$ kubectl get svc
```

- Microservice 1

	```sh
	$ http://EXTERNAL-IP/localCatalogByGenre?genre=Drama-History-Comedy
	```

- Microservice 2

	```sh
	$ http://EXTERNAL-IP/imdbCatalogByKeyword?keyword=Quentin%20Tarantino
	```

### Update Microservice 1 to version 2.0

```sh	
# Build Container
$ docker build -t grpc-kubernetes/microservice1:2.0 ./microservice1b/

# Publish Container
$ docker tag grpc-kubernetes/microservice1:2.0 gcr.io/$PROJECTID/microservice1:2.0
$ gcloud docker push gcr.io/$PROJECTID/microservice1:2.0

# Update Controller
Modify line 13 to version 2.0 in microservice1-controller.yaml file:
	- image: gcr.io/$PROJECTID/microservice1b:2.0

# Apply changes
$ kubectl apply -f microservice1-controller.yaml
```

### Test Microservice 1 version 2.0

```sh
$ http://EXTERNAL-IP/localCatalogByGenre?genre=Drama-History-Comedy
``

