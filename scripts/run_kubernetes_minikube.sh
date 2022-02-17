#!/usr/bin/env bash

# This file runs a K8s service and deployment with the containerized application in a minikube cluster.
# Assumes that an image is uploaded to DockerHub via `upload_docker.sh`

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

if minikube status | grep -e "\"minikube\" not found" -e "host: Stopped"; then
    minikube start
fi

# Update kubectl to point to minikube cluster
minikube update-context

kubectl create secret generic database-access --from-env-file=/etc/environment

kubectl apply -f ../backend/backend-deployment.yaml
kubectl apply -f ../backend/backend-service.yaml

# Wait until pods are running
DEPLOYMENT_NAME="$(kubectl get deploy -o name | grep -o -e ".*capstone.*")"
if timeout 60s kubectl wait $DEPLOYMENT_NAME --for condition=available; then
    kubectl get deploy
    kubectl get svc
    echo "Deployment available!"
    exit 0
else
    kubectl get deploy
    kubectl get svc
    echo "ERROR: Deployment not available after 60 s!"
    exit 1
fi
