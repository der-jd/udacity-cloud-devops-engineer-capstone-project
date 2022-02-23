#!/usr/bin/env bash

# This file tags and uploads an image to Docker Hub
# Assumes that an image is built via `run_docker.sh`
# Param: Tag for the Repository

if [ -z "$1" ]; then
    tag=1aa940fd-79db-4e9a-9954-ca60c5b021c8
else
    tag=$1
fi

dockerpath=judt/udacity-cloud-devops-engineer-capstone-project
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"

echo "Login to DockerHub..."
if [ -z "$DOCKERHUB_PASSWORD" ]; then
    docker login --username judt
else
    echo $DOCKERHUB_PASSWORD | docker login --username judt --password-stdin
fi

docker tag udacity-project $dockerpath:latest
docker tag udacity-project $dockerpath:$tag

# Push image to repository
docker push $dockerpath:latest
docker push $dockerpath:$tag
