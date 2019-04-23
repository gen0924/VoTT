#!/bin/bash
set -eou pipefail

# NOTE: this script should be ran from the root of the repository; the CWD should reflect this
echo "registry=${REGISTRY}"
echo "versio=${VERSION}"
echo "container=${CONTAINER_NAME}"
echo "azure_sub_name=${AZURE_SUB_NAME}"
echo "azure_sub_id=${AZURE_SUB_ID}"

echo "Setting Azure subscription to: ${AZURE_SUB_NAME}"
az account set --subscription ${AZURE_SUB_ID}

echo "Logging into ACR ${REGISTRY}"
az acr login --name ${REGISTRY}

echo "Building image ${CONTAINER_NAME}:${VERSION}..."
docker build --no-cache -t ${CONTAINER_NAME}:${VERSION} -t ${CONTAINER_NAME}:latest ../.

echo "Tagging image ${CONTAINER_NAME} ${REGISTRY}.azurecr.io/${CONTAINER_NAME}:${VERSION} and latest"
docker tag ${CONTAINER_NAME} ${REGISTRY}.azurecr.io/${CONTAINER_NAME}:${VERSION}
docker tag ${CONTAINER_NAME} ${REGISTRY}.azurecr.io/${CONTAINER_NAME}:latest

echo "Pushing image to: ${REGISTRY}.azurecr.io/${CONTAINER_NAME} and ${CONTAINER_NAME}:latest"
docker push ${REGISTRY}.azurecr.io/${CONTAINER_NAME}:${VERSION}
docker push ${REGISTRY}.azurecr.io/${CONTAINER_NAME}:latest