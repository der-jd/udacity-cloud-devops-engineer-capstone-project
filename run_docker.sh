#!/usr/bin/env bash

# Build image and add a descriptive tag
docker build --tag udacity-project .

# List docker images
docker image ls

# Run flask app
docker run --rm -it -p 80:80 --env-file /etc/environment --name udacity-app udacity-project
