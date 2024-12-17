#!/bin/bash

log() {
  echo "==> $1";
}

##################################################################################################
#                                           Constants                                            #
##################################################################################################

TARGET_DIR="target"
CHARTS_NAME="jaeger-tests-helm-charts"
DOCKER_FILE="Dockerfile"

mkdir -p ${TARGET_DIR}

###################################################################################################
#                                              Build                                              #
###################################################################################################

log "Build docker image"
for docker_image_name in ${DOCKER_NAMES}; do
  log "Docker image name: $docker_image_name"

  docker build \
    --file=${DOCKER_FILE} \
    --pull \
    -t ${docker_image_name} \
    .
done

log "Archive artifacts"
zip -r ${TARGET_DIR}/${CHARTS_NAME}.zip robot/tests
