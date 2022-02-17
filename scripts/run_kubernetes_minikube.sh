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

output="$(kubectl apply -f ../backend/backend-deployment.yaml)"
echo $output
kubectl apply -f ../backend/backend-service.yaml

# Wait until pods are available
deploymentName="$(echo $output | grep -o -E "^\S+")"
if timeout 300s kubectl wait $deploymentName --for condition=available; then
    kubectl get deploy
    kubectl get svc
    echo "Deployment available!"
    exit 0
else
    kubectl get deploy
    kubectl get svc
    echo "ERROR: Deployment not available after 300 s!"
    exit 1
fi
