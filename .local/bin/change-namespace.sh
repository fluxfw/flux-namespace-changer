#!/usr/bin/env sh

set -e

if [ -z `command -v run-in-docker` ]; then
    echo "Please install flux-docker-utils"
    exit 1
fi

from_namespace="$1"
if [ -z "$from_namespace" ]; then
    echo "Please pass a \"from namespace\""
    exit 1
fi
export FLUX_NAMESPACE_CHANGER_FROM_NAMESPACE="$from_namespace"

to_namespace="$2"
if [ -z "$to_namespace" ]; then
    echo "Please pass a \"to namespace\""
    exit 1
fi
export FLUX_NAMESPACE_CHANGER_TO_NAMESPACE="$to_namespace"

if [ -n "$CI_REGISTRY" ] && [ -n "$CI_PROJECT_NAMESPACE" ]; then
    image="$CI_REGISTRY/$CI_PROJECT_NAMESPACE/flux-namespace-changer"
else
    image="docker-registry.fluxpublisher.ch/flux-namespace-changer"
fi

tag="$1"
if [ -z "$tag" ]; then
    tag="latest"
fi

run-in-docker "$image:$tag" change-namespace
