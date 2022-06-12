#!/bin/sh

echo "What is your user id?"
read USER_ID
echo "What is your project name?"
read PROJECT_NAME
eval "aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${USER_ID}.dkr.ecr.ap-northeast-1.amazonaws.com"
eval "docker build -t ${PROJECT_NAME} ."
eval "docker tag nuxt-aws-starter:latest ${USER_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/${PROJECT_NAME}:latest"
eval "docker push ${USER_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/${PROJECT_NAME}:latest"
