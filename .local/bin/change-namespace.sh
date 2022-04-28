#!/usr/bin/env sh

set -e

from_namespace="$1"
if [ -z "$from_namespace" ]; then
    echo "Please pass a \"from namespace\""
    exit 1
fi

to_namespace="$2"
if [ -z "$to_namespace" ]; then
    echo "Please pass a \"to namespace\""
    exit 1
fi

if [ -n "$CI_REGISTRY" ] && [ -n "$CI_PROJECT_NAMESPACE" ]; then
    image="$CI_REGISTRY/$CI_PROJECT_NAMESPACE/flux-namespace-changer"
else
    image="docker-registry.fluxpublisher.ch/flux-namespace-changer"
fi

tag="$3"
if [ -z "$tag" ]; then
    tag="latest"
fi

folder="/code/`basename "$PWD"`"

#docker pull "$image:$tag"
docker run --rm -it --network none -u `id -u`:`id -g` -v "$PWD":"$folder" "$image:$tag" "$folder" "$from_namespace" "$to_namespace"
