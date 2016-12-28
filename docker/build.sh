#!/bin/bash

pushd $(dirname $0) > /dev/null
DOCKER_DIR=$(pwd)
popd > /dev/null
SOURCE_DIR=$DOCKER_DIR/..

. settings.sh

PACKAGE_NAME="connect-mongo-${PACKAGE_VERSION}.tgz"

set -ex

echo "Building kafka-connect-mongo"
cd $SOURCE_DIR
./gradlew clean distTar
cd $DOCKER_DIR

echo "Extracting distributions"
rm -rf targets && mkdir -p targets
tar -xvf $SOURCE_DIR/build/distributions/$PACKAGE_NAME -C targets --strip 1

echo "Build and tag docker images"

DOCKER_FILE=${DOCKER_DIR}/Dockerfile

docker build $DOCKER_BUILD_OPTS -t "${IMAGE_NAME}:${PACKAGE_VERSION}" ./
docker tag $DOCKER_TAG_OPTS "${IMAGE_NAME}:${PACKAGE_VERSION}" "${IMAGE_NAME}:latest"
docker tag $DOCKER_TAG_OPTS "${IMAGE_NAME}:${PACKAGE_VERSION}" "quay.io/${IMAGE_NAME}:latest"
docker tag $DOCKER_TAG_OPTS "${IMAGE_NAME}:${PACKAGE_VERSION}" "quay.io/${IMAGE_NAME}:${PACKAGE_VERSION}"
