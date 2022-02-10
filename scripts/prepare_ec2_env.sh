#!/usr/bin/env bash

# Run AFTER activating virtual environment

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

# Set region and output format for aws cli
echo [default] >> ~/.aws/config
echo region = eu-central-1 >> ~/.aws/config
echo output = json >> ~/.aws/config 

# Resize ec2 storage
./resize.sh

cd ..

# Install dependencies
make install
sudo make install_hadolint

cd ..

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
