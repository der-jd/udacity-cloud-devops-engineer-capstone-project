#!/usr/bin/env bash

# This file runs a K8s service and deployment with the containerized application in the EKS cluster.
# Assumes that an image is uploaded to DockerHub via `upload_docker.sh`

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

# TODO: config kubectl to access EKS

kubectl create secret generic database-access --from-env-file=/etc/environment

kubectl apply -f ../backend/backend-deployment.yaml
kubectl apply -f ../backend/backend-service.yaml

# Wait until pods are running
sleep 10s

kubectl get deploy
kubectl get svc