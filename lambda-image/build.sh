#!/bin/bash

# builds the Dockerfile and pushes it to AWS ECR
REGION=us-west-2
ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)
REPO=ratingcurve-lambda
TAG=1.0.0
URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$REPO


aws ecr get-login-password \
       	--region $REGION | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com

aws ecr create-repository \
       	--repository-name $REPO \
	--region $REGION \
	--image-scanning-configuration scanOnPush=true \
	--image-tag-mutability MUTABLE

docker build --platform linux/amd64 -t $REPO:$TAG .

docker tag $REPO:$TAG $URI:latest

docker push $URI:latest
