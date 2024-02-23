#!/bin/bash

# builds the Dockerfile and pushes it to AWS ECR
# WARNING: bump tag, otherwise you might pull an old image
# WARNING: WSL chmod requires /etc/wsl.conf
# [automount]
# options = "metadata"
LAMBDA_NAME=fit_rating
REGION=us-west-2
ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)
REPO=ratingcurve-lambda
TAG=0.0.17
URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$REPO


aws ecr get-login-password \
       	--region $REGION | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com

aws ecr create-repository \
       	--repository-name $REPO \
	--region $REGION \
	--image-scanning-configuration scanOnPush=true \
	--image-tag-mutability MUTABLE

docker build \
	--platform linux/amd64 \
       	-t $REPO:$TAG .

docker tag $REPO:$TAG $URI:$TAG #:latest

docker push $URI:$TAG #:latest

# update lambda
aws lambda update-function-code \
        --region $REGION \
        --function-name $LAMBDA_NAME \
        --image-uri $URI:$TAG \
	--no-cli-pager
