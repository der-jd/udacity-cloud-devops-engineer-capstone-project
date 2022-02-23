#!/usr/bin/env bash

source /etc/environment

uuid=1aa940fd-79db-4e9a-9954-ca60c5b021c8
defaultVPC=vpc-4bcca221 # for region eu-central-1

scriptPath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $scriptPath

echo "Restore database from snapshot (without DBName)..."
aws cloudformation create-stack \
	--stack-name capstone-db-$uuid \
	--template-body file://database-restore.yaml \
	--parameters ParameterKey=MyDBInstanceIdentifier,ParameterValue=database-wisdoms \
	             ParameterKey=MyDBSnapshotIdentifier,ParameterValue=database-wisdoms-final-snapshot-update \
				 ParameterKey=DBPort,ParameterValue=$DATABASE_PORT \
				 ParameterKey=DBUsername,ParameterValue=$DATABASE_USERNAME \
				 ParameterKey=DBPassword,ParameterValue=$DATABASE_PASSWORD \
				 ParameterKey=MyVpcId,ParameterValue=$defaultVPC

# echo "Create new database (with DBName)..."
# aws cloudformation create-stack \
#	--stack-name capstone-db-$uuid \
#	--template-body file://database.yaml \
#	--parameters ParameterKey=MyDBInstanceIdentifier,ParameterValue=database-wisdoms \
#				 ParameterKey=MyDBName,ParameterValue=$DATABASE_NAME \
#				 ParameterKey=DBPort,ParameterValue=$DATABASE_PORT \
#				 ParameterKey=DBUsername,ParameterValue=$DATABASE_USERNAME \
#				 ParameterKey=DBPassword,ParameterValue=$DATABASE_PASSWORD \
#				 ParameterKey=MyVpcId,ParameterValue=$defaultVPC

echo "Create S3 bucket for static frontend website..."
aws cloudformation create-stack \
	--stack-name capstone-website-$uuid \
	--template-body file://../.circleci/files/frontend-bucket.yaml \
	--parameters file://../.circleci/files/frontend-bucket-params.json

echo "Create Cloudfront distribution for website..."
aws cloudformation create-stack \
	--stack-name capstone-cloudfront-$uuid \
	--template-body file://../.circleci/files/cloudfront.yaml \
	--parameters file://../.circleci/files/cloudfront-params.json

echo "Create S3 bucket for images..."
aws cloudformation create-stack \
	--stack-name capstone-images-$uuid \
	--template-body file://image-bucket.yaml \
	--parameters file://image-bucket-params.json
echo "IMPORTANT: Images have to be uploaded manually to S3 bucket!"

echo "Create EKS cluster for backend..."
aws cloudformation create-stack \
	--stack-name capstone-eks-$uuid \
	--template-body file://backend-eks.yaml \
	--parameters file://backend-eks-params.json

echo "Wait for finished creation of EKS stack. This can take several minutes..."
aws cloudformation wait stack-create-complete --stack-name capstone-eks-$uuid
echo "Add AWS users to EKS cluster..."
aws eks update-kubeconfig --name cluster-$uuid
kubectl apply -f backend-eks-aws-auth.yaml
