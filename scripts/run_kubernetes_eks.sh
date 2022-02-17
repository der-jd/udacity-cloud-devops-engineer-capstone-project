#!/usr/bin/env bash

# This file runs a K8s service and deployment with the containerized application in the EKS cluster.
# Assumes that an image is uploaded to DockerHub via `upload_docker.sh`

uuid=1aa940fd-79db-4e9a-9954-ca60c5b021c8

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

# Update kubectl to point to EKS cluster
aws eks update-kubeconfig --name cluster-$uuid

kubectl create secret generic database-access --from-env-file=/etc/environment

output="$(kubectl apply -f ../backend/backend-deployment.yaml)"
echo $output
kubectl apply -f ../backend/backend-service.yaml

# Wait until pods are available
deploymentName="$(echo $output | grep -o -E "^\S+")"
if timeout 120s kubectl wait $deploymentName --for condition=available; then
    kubectl get deploy
    kubectl get svc
    echo "Deployment available!"
    exit 0
else
    kubectl get deploy
    kubectl get svc
    echo "ERROR: Deployment not available after 120 s!"
    exit 1
fi
