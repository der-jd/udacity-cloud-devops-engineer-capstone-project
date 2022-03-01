#!/usr/bin/env bash

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

kubectl cluster-info

kubectl delete -f ../backend/backend-service.yaml
kubectl delete --all deploy -n default
kubectl delete secret database-access
