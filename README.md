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

* Run `make setup`.
* Activate virtual environment with `source ~/.udacity/bin/activate` (deactivate with `deactivate`).
* When working on an AWS EC2 instance:
    * If the application should run locally, open the ports `80` and `8000` (for backend) and port `8080` (for frontend) in the corresponding security group.
    * Attach the necessary IAM role / policies to the instance to be able to create and manage the AWS infrastructure (CloudFormation scripts, etc.).
        * Give the EC2 instance admin rights
        * https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/deploy-an-amazon-eks-cluster-from-aws-cloud9-using-an-ec2-instance-profile.html
        * https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
        * https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
    * Consider resizing storage volume: Run `./scripts/resize.sh`.
    * Or run `./scripts/prepare_ec2_env.sh`.
      This resizes the volume and installs all necessary dependencies.
      The following steps can be skipped then, **except** the setting of the necessary environment variables for the database access (see below).
* Run `make install` to install the necessary dependencies.
* Run `sudo make install_hadolint` to install hadolint on Linux.
* Install `Docker` if necessary.
* Install `aws-cli` if necessary.
* Install `kubectl` on Linux (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).
    * `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`
    * `sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`
* Install `minikube` on Linux.
    * `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
    * `sudo install minikube-linux-amd64 /usr/local/bin/minikube`
* Set the necessary environment variables for the database access. This step is **always** necessary and must be done even if running `./scripts/prepare_ec2_env.sh`.
    ```
    echo DATABASE_USERNAME="xxx" | sudo tee -a /etc/environment
    echo DATABASE_PASSWORD="xxx" | sudo tee -a /etc/environment
    echo DATABASE_NAME="xxx" | sudo tee -a /etc/environment
    echo DATABASE_HOST="xxx.xxx.eu-central-1.rds.amazonaws.com" | sudo tee -a /etc/environment
    echo DATABASE_PORT="xxx" | sudo tee -a /etc/environment
    ```

# Using the app

* Clicking the `Reload` button or reloading the website will show a new random wisdom / knowledge.

## Creating the AWS infrastructure
* Run `./scripts/create_initial_infrastructure.sh`.
    * If no database snapshot is available, update script to create a new database. See section `Create Database` for more information.
    * Manually upload any images to the S3 bucket for image storage.
* Delete the infrastructure with `./scripts/delete_initial_infrastructure.sh`.

## Create Database // TODO

## Running Backend
1. Standalone locally:
    * Run `sudo ~/.udacity/bin/python backend/src/app.py` (when the app is running on port 80).
    * Run `python backend/src/app.py` (otherwise).
    * Access API via `curl http://hostname:8000` or via web browser.
2. Run in Docker locally:
    * Run `./scripts/run_docker.sh`.
    * Access API via `curl http://hostname` or via web browser.
3. Run in Kubernetes (minikube) locally:
    * Run `./scripts/run_docker.sh` if not already done to build the image (only necessary if image has changed or not been uploaded yet).
    * Run `./scripts/upload_docker.sh` to upload the image to DockerHub (only necessary if image has changed or not been uploaded yet).
    * Run `./scripts/run_kubernetes_minikube.sh`.
    * Get service endpoint (`http://host-ip:port`) via `minikube service $(minikube service list | grep -o -e ".[^ ]*capstone.[^ ]*") --url=true`.
    * Access API via `curl http://host-ip:port` or via web browser.
    * Delete K8s resources after use via `./scripts/delete_kubernetes_resources.sh`.
    * Delete minikube cluster via `minikube delete`.
4. Run in Kubernetes (EKS):
    * Run `./scripts/run_docker.sh` if not already done to build the image (only necessary if image has changed or not been uploaded yet).
    * Run `./scripts/upload_docker.sh` to upload the image to DockerHub (only necessary if image has changed or not been uploaded yet).
    * Run `./scripts/run_kubernetes_eks.sh`.
    * Get hostname of the AWS load balancer via `kubectl get $(kubectl get svc -o name | grep -o -e ".*capstone.*") --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'`.
    * Access API via `curl http://hostname:8000` or via web browser.
    * Delete K8s resources after use via `./scripts/delete_kubernetes_resources.sh`.

## Running Frontend
1. Standalone locally (development environment):
    * See the corresponding [README](./frontend/README.md).
    * Access frontend via `curl http://hostname:8080` or via web browser.
2. Via S3 bucket (production environment):
    * Set the hostname of the backend API endpoint in `./frontend/.env.production` (see section `Running Backend` for possible endpoints, e.g. `http://hostname-aws-loadBalancer:8000`).
    * Build the frontend for production (see the corresponding [README](./frontend/README.md)).
    * After creating the `./frontend/build` folder, upload its content to the S3 bucket for the static website.
    * Get hostname directly from the S3 bucket website endpoint or from the CloudFront domain name.
    * Access frontend via `curl http://hostname` or via web browser.
