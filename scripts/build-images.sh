#!/bin/bash
set -e

DOCKERHUB_ORGANIZATION=balenaplayground
IMAGE_NAME=ide

function build_and_push_image () {
  local BALENA_MACHINE_NAME=$1
  local DOCKER_ARCH=$2
  echo "Building for $BALENA_MACHINE_NAME..."
  sed "s/%%BALENA_MACHINE_NAME%%/$BALENA_MACHINE_NAME/g" Dockerfile.template > Dockerfile.$BALENA_MACHINE_NAME
  docker buildx build -t $DOCKERHUB_ORGANIZATION/$IMAGE_NAME:$BALENA_MACHINE_NAME --platform $DOCKER_ARCH --file Dockerfile.$BALENA_MACHINE_NAME .
  
  echo "Publishing..."
  docker push $DOCKERHUB_ORGANIZATION/$IMAGE_NAME:$BALENA_MACHINE_NAME

  echo "Cleaning up..."
  rm Dockerfile.$BALENA_MACHINE_NAME
}

function build_and_push_rpi () {
  local BALENA_MACHINE_NAME=$1
  local DOCKER_ARCH=$2
  echo "Building for $BALENA_MACHINE_NAME..."
  docker buildx build -t $DOCKERHUB_ORGANIZATION/$IMAGE_NAME:$BALENA_MACHINE_NAME --platform $DOCKER_ARCH --file Dockerfile.$BALENA_MACHINE_NAME .
  
  echo "Publishing..."
  docker push $DOCKERHUB_ORGANIZATION/$IMAGE_NAME:$BALENA_MACHINE_NAME
}

DIRNAME=$(dirname $0)
if [[ $DIRNAME != './scripts' ]]; then
  echo "Please run from project's root directory"
fi

build_and_push_image "intel-nuc" "linux/amd64"
# build_and_push_rpi "raspberrypi3" "linux/arm/v7"
# build_and_push_rpi "raspberrypi4-64" "linux/arm64"