[![CircleCI](https://circleci.com/gh/der-jd/udacity-cloud-devops-engineer-capstone-project/tree/main.svg?style=shield)](https://circleci.com/gh/der-jd/udacity-cloud-devops-engineer-capstone-project/tree/main)

# Project 'GetWise' Overview

This is the final capstone project of the Udacity nanodegree `Cloud DevOps Engineer`.
It creates a website showing a "wisdom" or some knowledge from different topics and categories.

This project implies a frontend, backend and SQL database, all running within `AWS`.

The necessary infrastructure gets created and updated via AWS Cloudformation scripts (IaC).

Any changes are continuously built and deployed with the CI/CD environment `CircleCi` (https://circleci.com/).


# Infrastructure

A graph showing the infrastructure in AWS and the used services can be found [here](./AWS_Infrastructure.png).

## Frontend
The frontend consists of a static website and is deployed via a S3 bucket.
The website is accessible via a AWS Cloudfront distribution.

## Backend
The backend consists of a Python flask application connecting to the SQL database containing the wisdoms.
The application itself runs within a Docker container which is deployed via Kubernetes.
The access to the API is managed by a Classic Load Balancer service.
As database a Postgres-Db is used with AWS RDS. Potential images to the wisdoms are saved within a S3 bucket.


# Setup the Environment

* Run `make setup`.
* Activate virtual environment with `source ~/.udacity/bin/activate` (deactivate with `deactivate`).
* When working on an AWS EC2 instance / Cloud9:
    * If the application should run locally, open the ports `80` and `8000` (for backend) and port `8080` (for frontend) in the corresponding security group.
    * Deactivate `AWS managed temporary credentials` under `Preferences`->`AWS Settings`->`Credentials` in the Cloud9 IDE.
    * Attach the necessary IAM role / policies to the instance to be able to create and manage the AWS infrastructure (CloudFormation scripts, etc.).
        * Give the EC2 instance admin rights
        * https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/deploy-an-amazon-eks-cluster-from-aws-cloud9-using-an-ec2-instance-profile.html
        * https://aws.amazon.com/premiumsupport/knowledge-center/amazon-eks-cluster-access/
        * https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
        * https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html
        * https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
    * Consider resizing storage volume: Run `./scripts/resize.sh`.
    * Or run `./scripts/prepare_ec2_env.sh`.
      This resizes the volume and installs all necessary dependencies.
      The following steps can be skipped then, **except** the setting of the necessary environment variables (see below).
    * Restart the EC2 instance to apply the resized volume.
* Run `make install` to install the necessary dependencies.
* Run `sudo make install_hadolint` to install hadolint on Linux.
* Install `Docker` if necessary.
* Install `aws-cli` if necessary.
* Install `kubectl` on Linux (https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).
    * `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`
    * `sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`
    * `rm kubectl`
* Install `minikube` on Linux.
    * `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64`
    * `sudo install minikube-linux-amd64 /usr/local/bin/minikube`
    * `rm minikube-linux-amd64`
* Set the necessary environment variables. This step is **always** necessary and must be done even if running `./scripts/prepare_ec2_env.sh`.
    * Database access
    ```
    echo DATABASE_USERNAME="xxx" | sudo tee -a /etc/environment > /dev/null
    echo DATABASE_PASSWORD="xxx" | sudo tee -a /etc/environment > /dev/null
    echo DATABASE_NAME="xxx" | sudo tee -a /etc/environment > /dev/null
    echo DATABASE_HOST="xxx.xxx.eu-central-1.rds.amazonaws.com" | sudo tee -a /etc/environment > /dev/null
    echo DATABASE_PORT="xxx" | sudo tee -a /etc/environment > /dev/null
    ```
    * KVdb bucket access
    ```
    echo KVDB_BUCKET_ID="xxx" | sudo tee -a /etc/environment > /dev/null
    echo KVDB_WRITE_KEY="xxx" | sudo tee -a /etc/environment > /dev/null
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
    * In this case the environment variables in `/etc/environment` have to be set also in currect shell via `export DATABASE_XXX=xxx`.
    * Run `python backend/src/app.py`.
        * Run `sudo ~/.udacity/bin/python backend/src/app.py` instead when the app is running on port 80.
    * Access API via `curl http://hostname:8000` or via web browser.
    * In this case the frontend cann't connect to the backend by default because the app is running on port 8000 but frontend expects the API on port 80.
      Alternatively the frontend must run in production environment because in that case the expected port for the backend API can be defined in `.env.production`.
2. Run in Docker locally:
    * Run `./scripts/run_docker.sh`.
    * Access API via `curl http://hostname` or via web browser.
3. Run in Kubernetes (minikube) locally:
    * Run `./scripts/run_docker.sh` if not already done to build the image (only necessary if image has changed or not been uploaded yet).
    * Run `./scripts/upload_docker.sh` to upload the image to DockerHub (only necessary if image has changed or not been uploaded yet).
    * Run `./scripts/run_kubernetes_minikube.sh`.
    * Get service endpoint (`http://host-ip:port`) via `minikube service $(minikube service list | grep -o -e "\S*capstone\S*") --url=true`.
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

## Running CI/CD with CircleCi
1. Set AWS credentials as environment variables in CircleCi.
    * `AWS_ACCESS_KEY_ID`
    * `AWS_SECRET_ACCESS_KEY`
    * `AWS_DEFAULT_REGION`
2. Set name of EKS cluster as environment variable in CircleCi.
    * `CLUSTER_NAME`
3. Set the access data for the database as environment variables in CircleCi.
    * `DATABASE_USERNAME`
    * `DATABASE_PASSWORD`
    * `DATABASE_NAME`
    * `DATABASE_HOST`
    * `DATABASE_PORT`
4. Set the password for the DockerHub repository as environment variable in CircleCi.
    * `DOCKERHUB_PASSWORD`
5. Set the keys to access the KVdb bucket as environment variables in CircleCi (https://kvdb.io/docs/api/).
    * `KVDB_BUCKET_ID`
    * `KVDB_SECRET_KEY`
    * `KVDB_WRITE_KEY`
    * `KVDB_READ_KEY`
