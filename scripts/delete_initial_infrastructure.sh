#!/usr/bin/env bash

uuid=1aa940fd-79db-4e9a-9954-ca60c5b021c8

echo "Delete database stack..."
aws cloudformation delete-stack --stack-name capstone-db-$uuid

echo "Empty S3 bucket for static frontend website..."
aws s3 rm "s3://website-$uuid" --recursive
echo "Delete S3 bucket for static frontend website..."
aws cloudformation delete-stack --stack-name capstone-website-$uuid

echo "Empty S3 bucket for images..."
aws s3 rm "s3://images-$uuid" --recursive
echo "Delete S3 bucket for images..."
aws cloudformation delete-stack --stack-name capstone-images-$uuid

echo "Delete CloudFront stack..."
aws cloudformation delete-stack --stack-name capstone-cloudfront-$uuid

echo "Delete EKS cluster..."
aws cloudformation delete-stack --stack-name capstone-eks-$uuid
