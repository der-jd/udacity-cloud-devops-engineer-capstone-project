#!/usr/bin/env bash

# This file runs a K8s pod with the containerized application
# Assumes that an image is uploaded to DockerHub via `upload_docker.sh`

# This is your Docker ID/path
dockerpath=judt/udacity-cloud-devops-engineer-capstone-project

# Create and run the container from the Docker Hub image with kubernetes
kubectl run udacity-app --image=$dockerpath --port=8000 \
    --env="DATABASE_USERNAME=$DATABASE_USERNAME" \
    --env="DATABASE_PASSWORD=$DATABASE_PASSWORD" \
    --env="DATABASE_NAME=$DATABASE_NAME" \
    --env="DATABASE_HOST=$DATABASE_HOST" \
    --env="DATABASE_PORT=$DATABASE_PORT"

# Wait until the pod is running so that the port can be forwarded
sleep 5s

# List kubernetes pods
kubectl get pods

# Forward the container port to a host
kubectl port-forward udacity-app 8000:8000
