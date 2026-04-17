#!/bin/bash

set -e

CWD=$(cd $(dirname $0); pwd)
IMAGE="claude:${RELEASE:-latest}"

if [ "$1" == "--build" ]; then
    echo "building ${IMAGE} image..."
    docker build \
        --rm=true \
        -f "${CWD}/Dockerfile" \
        -t "${IMAGE}" \
        "${CWD}"
    shift # i.e. $2 == $1
fi

echo "starting ${1:?Project name is required.} project"
docker run --rm -it \
  --name claudIA \
  -v "${CWD}/.claude":/home/ubuntu/.claude \
  -v "${CWD}/.claude.json":/home/ubuntu/.claude.json \
  -v "${CWD}/projects":/home/ubuntu/projects \
  "${IMAGE}" \
  bash
