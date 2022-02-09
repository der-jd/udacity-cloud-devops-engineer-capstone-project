#!/usr/bin/env bash

kubectl delete -f ../backend/backend-service.yaml
kubectl delete -f ../backend/backend-deployment.yaml
kubectl delete secret database-access
