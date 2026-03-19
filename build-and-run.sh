#!/bin/bash
# build-and-run.sh - Script to build and run the local development container

IMAGE_NAME="terraform-gcloud-local"
CONTAINER_NAME="terraform-dev"

echo "Building Docker image..."
docker build -f Dockerfile.local -t $IMAGE_NAME .

echo "Running container..."
docker run -it --rm \
  --name $CONTAINER_NAME \
  -v $(pwd):/workspace \
  -v ~/.config/gcloud:/root/.config/gcloud \
  -v ~/.ssh:/root/.ssh \
  -e GOOGLE_APPLICATION_CREDENTIALS=/workspace/service-account-key.json \
  $IMAGE_NAME

echo "Container stopped."