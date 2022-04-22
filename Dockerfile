ARG FLUX_AUTOLOAD_API_IMAGE=docker-registry.fluxpublisher.ch/flux-autoload/api
ARG FLUX_NAMESPACE_CHANGER_IMAGE=docker-registry.fluxpublisher.ch/flux-namespace-changer

FROM $FLUX_AUTOLOAD_API_IMAGE:latest AS flux_autoload_api
FROM $FLUX_NAMESPACE_CHANGER_IMAGE:latest AS flux_autoload_api_build
ENV FLUX_NAMESPACE_CHANGER_FROM_NAMESPACE FluxAutoloadApi
ENV FLUX_NAMESPACE_CHANGER_TO_NAMESPACE FluxNamespaceChanger\\Libs\\FluxAutoloadApi
COPY --from=flux_autoload_api /flux-autoload-api /code
RUN /flux-namespace-changer/bin/docker-entrypoint.php

FROM alpine:latest AS build

COPY --from=flux_autoload_api_build /code /flux-namespace-changer/libs/flux-autoload-api
COPY . /flux-namespace-changer

FROM php:8.1-cli-alpine

LABEL org.opencontainers.image.source="https://github.com/flux-caps/flux-namespace-changer"
LABEL maintainer="fluxlabs <support@fluxlabs.ch> (https://fluxlabs.ch)"

ENTRYPOINT /flux-namespace-changer/bin/docker-entrypoint.php

COPY --from=build /flux-namespace-changer /flux-namespace-changer

ARG COMMIT_SHA
LABEL org.opencontainers.image.revision="$COMMIT_SHA"
