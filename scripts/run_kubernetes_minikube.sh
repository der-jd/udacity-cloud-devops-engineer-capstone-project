#!/usr/bin/env bash

# This file runs a K8s service and deployment with the containerized application in a minikube cluster.
# Assumes that an image is uploaded to DockerHub via `upload_docker.sh`

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

if minikube status | grep "host: Stopped"; then
    minikube start
fi

# Update kubectl to point to minikube cluster
rm ~/.kube/config
minikube update-context

kubectl create secret generic database-access --from-env-file=/etc/environment

kubectl apply -f ../backend/backend-deployment.yaml
kubectl apply -f ../backend/backend-service.yaml

# Wait until pods are running
sleep 10s

kubectl get deploy
kubectl get svc