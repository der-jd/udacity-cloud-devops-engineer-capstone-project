#!/usr/bin/env bash

# This file tags and uploads an image to Docker Hub
# Assumes that an image is built via `run_docker.sh`

# Create dockerpath
dockerpath=judt/udacity-cloud-devops-engineer-capstone-project

# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
echo "Login to DockerHub..."
docker login --username judt
docker tag udacity-project $dockerpath

# Push image to a docker repository
docker push $dockerpath
