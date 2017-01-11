# PoC - gRPC

### Description:
Design, build and deploy a collection of microservices developed by gRPC along with Google Cloud Platform and Kubernetes.

### Steps:

1. Create a GCP Account [Click](https://cloud.google.com/)
2. Create a New Project in GCP
3. Enable Compute Engine and Container Engine APIs [Click](https://console.developers.google.com/apis/library)
4. Enable Google Cloud Shell
5. Configure Cloud Shell Environment

`$ gcloud compute zones list`
`$ gcloud config set compute/zone europe-west1-d`

6. Setting up Kubernetes - Provision a Kubernetes Cluster with GKE using gcloud

`$ gcloud container clusters create k0`
`$ gcloud container clusters get-credentials k0`