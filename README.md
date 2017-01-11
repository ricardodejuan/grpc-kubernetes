# PoC - gRPC

### Description:
Design, build and deploy a collection of microservices developed by gRPC along with Google Cloud Platform and Kubernetes.

### Steps:

+ Create a GCP Account [Click](https://cloud.google.com/)
+ Create a New Project in GCP
+ Enable Compute Engine and Container Engine APIs [Click](https://console.developers.google.com/apis/library)
+ Enable Google Cloud Shell
+ Configure Cloud Shell Environment

`$ gcloud compute zones list`

`$ gcloud config set compute/zone europe-west1-d`

+ Setting up Kubernetes - Provision a Kubernetes Cluster with GKE using gcloud

`$ gcloud container clusters create k0`

`$ gcloud container clusters get-credentials k0`