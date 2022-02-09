#!/usr/bin/env bash

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

# Build image and add a descriptive tag
docker build --tag udacity-project ../backend

# List docker images
docker image ls

# Run flask app
docker run --rm -it -p 80:8000 --env-file /etc/environment --name udacity-app udacity-project
