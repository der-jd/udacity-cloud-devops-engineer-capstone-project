*// TODO insert correct Circle CI Batch*
[![CircleCI](https://circleci.com/gh/der-jd/udacity-cloud-devops-engineer-microservices-project/tree/main.svg?style=shield)](https://circleci.com/gh/der-jd/udacity-cloud-devops-engineer-microservices-project/tree/main)

# Project 'GetWise' Overview

This is the final capstone project of the Udacity nanodegree `Cloud DevOps Engineer`.
It creates a website showing a "wisdom" or some knowledge from different topics and categories.

This project implies a backend, frontend and SQL database, all running within `AWS`.

The necessary infrastructure gets created and updated via AWS Cloudformation scripts (IaC).

Any changes are continuously built and deployed with the CI/CD environment `CircleCi`.

## Backend
The backend consists of a Python flask app connecting to the SQL database containing the wisdoms. The application itself runs within a Docker container which is deployed via Kubernetes.

As database a Postgres-Db is used with AWS RDS.

## Frontend
The frontend consists of a static website and is deployed via a S3 bucket.
The website is accessible via a AWS Cloudfront distribution.


# Setup the Environment

* Run `make setup`
* Activate virtual environment with `source ~/.udacity/bin/activate` (deactivate with `deactivate`)
* When using an AWS EC2 instance, resize storage volume: Run `resize.sh`
* Install `Docker` if necessary
* Install `kubectl` on Linux (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
    * curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    * sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
* Install `minikube` on Linux
    * curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    * sudo install minikube-linux-amd64 /usr/local/bin/minikube
* Run `make install` to install the necessary dependencies
* Run `sudo make install_hadolint` to install hadolint on Linux


# Using the app

* Open 'localhost' to access the Web-UI showing a random wisdom from the database.
* Clicking the 'refresh' button or reloading the website will show a new random wisdom / knowledge.

## Running `app.py`
1. Standalone:  `sudo ~/.udacity/bin/python app.py` (`sudo` is necessary because the app is running on port 80.)
2. Run in Docker:  `./run_docker.sh`
3. Run in Kubernetes:
    * Run `./run_docker.sh` if not already done to build the image
    * Run `./upload_docker.sh` to upload the image to DockerHub
    * Start minikube cluster via `minikube start`
    * Run `./run_kubernetes.sh`
    * Delete pods after use via `./delete_kubernetes.sh`
    * Delete minikube cluster via `minikube delete`

## Kubernetes Steps
* Setup and Configure Docker locally
* Setup and Configure Kubernetes locally
* Create Flask app in Container
* Run via kubectl


# Files // TODO update

* .circleci/config.yml
    * Config file for CI pipeline of circleci
* model_data/
    * Data for the housing price model
* output_txt_files/
    * Example for the log output of the running application via Docker and K8s after making an API call
* .gitignore
    * Well....ignore it ;-)
* app.py
    *  Python application for predicting housing prices in Boston
* delete_kubernetes.sh
    *  Delete created K8s pod
* Dockerfile
    *  Description of the image for the containerized application
* make_prediction.sh
    * Run to make an API call to the web application
* Makefile
    * Commands to setup the environment, install dependencies and lint files
* README.md
    * recursion...^^
* requirements.txt
    * Python package dependencies
* resize.sh
    * Resize the AWS EC2 storage volume to 20 GB
* run_docker.sh
    * Run the application via Docker container
* run_kubernetes.sh
    * Run the application via a K8s pod
* upload_docker.sh
    * Upload the Docker image to DockerHub repository
