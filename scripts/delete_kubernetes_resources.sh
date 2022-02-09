#!/usr/bin/env bash

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

kubectl delete -f ../backend/backend-service.yaml
kubectl delete -f ../backend/backend-deployment.yaml
kubectl delete secret database-access
