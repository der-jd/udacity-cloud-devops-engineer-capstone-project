#!/usr/bin/env bash

# This file runs a K8s service and deployment with the containerized application in the EKS cluster.
# Assumes that an image is uploaded to DockerHub via `upload_docker.sh`

source /etc/environment

uuid=1aa940fd-79db-4e9a-9954-ca60c5b021c8

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

# Update kubectl to point to EKS cluster
aws eks update-kubeconfig --name cluster-$uuid

if kubectl get secret -o name | grep "secret/database-access"; then
    echo "Secret already exists!"
else
    kubectl create secret generic database-access --from-env-file=/etc/environment
fi

output="$(kubectl apply -f ../backend/backend-deployment.yaml)"
echo $output
kubectl apply -f ../backend/backend-service.yaml

echo "Write initial id to KVdb bucket..."
curl https://kvdb.io/$KVDB_BUCKET_ID/old_id -d "$uuid" -u $KVDB_WRITE_KEY:$KVDB_WRITE_KEY

echo "Wait until pods are available..."
deploymentName="$(echo $output | grep -o -E "^\S+")"
if kubectl wait --for condition=available --timeout=180s $deploymentName; then
    kubectl get deploy
    kubectl get svc
    echo "Deployment available!"
    exit 0
else
    kubectl get deploy
    kubectl get svc
    echo "ERROR: Deployment not available after 180 s!"
    exit 1
fi
