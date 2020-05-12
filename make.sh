#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

docker build -t demoncat/edt:"$VERSION_EDT" \
    --build-arg ONEC_USERNAME="$ONEC_USERNAME" \
    --build-arg ONEC_PASSWORD="$ONEC_PASSWORD"  \
    --build-arg ONEC_VERSION="$ONEC_VERSION"  \
    --build-arg VERSION="$VERSION_EDT" .