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

run-in-docker docker-registry.fluxpublisher.ch/flux-namespace-changer:latest /flux-namespace-changer/bin/docker-entrypoint.php
