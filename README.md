# PoC - gRPC

### Description:
Design, build and deploy a collection of microservices developed by gRPC along with Google Cloud Platform and Kubernetes.

### Steps to run:

* Create a GCP Account [Click](https://cloud.google.com/)
* Create a New Project in GCP
* Enable Compute Engine and Container Engine APIs [Click](https://console.developers.google.com/apis/library)
* Enable Google Cloud Shell
* Configure Cloud Shell Environment

```sh
$ gcloud compute zones list
```

```sh
$ gcloud config set compute/zone europe-west1-d
```

* Setting up Kubernetes - Provision a Kubernetes Cluster with GKE using gcloud

```sh
$ gcloud container clusters create k0
```

```sh
$ gcloud container clusters get-credentials k0
```

* Clean all images

```sh
$ PROJECTID=$(gcloud config list project | awk 'FNR ==2 { print $3 }')
```

```sh
$ ./clean.sh
```

* Build Containers