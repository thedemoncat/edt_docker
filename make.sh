#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

docker build -t demoncat/edt:latest \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg VERSION="$VERSION_EDT" .