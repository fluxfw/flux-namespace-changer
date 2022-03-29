ARG ALPINE_IMAGE=alpine:latest
ARG FLUX_AUTOLOAD_API_IMAGE=docker-registry.fluxpublisher.ch/flux-autoload/api:latest
ARG FLUX_NAMESPACE_CHANGER_IMAGE=docker-registry.fluxpublisher.ch/flux-namespace-changer:latest
ARG PHP_CLI_IMAGE=php:cli-alpine

FROM $FLUX_AUTOLOAD_API_IMAGE AS flux_autoload_api
FROM $FLUX_NAMESPACE_CHANGER_IMAGE AS flux_autoload_api_build
ENV FLUX_NAMESPACE_CHANGER_FROM_NAMESPACE FluxAutoloadApi
ENV FLUX_NAMESPACE_CHANGER_TO_NAMESPACE FluxNamespaceChanger\\Libs\\FluxAutoloadApi
COPY --from=flux_autoload_api /flux-autoload-api /code
RUN $FLUX_NAMESPACE_CHANGER_BIN

FROM $ALPINE_IMAGE AS build

COPY --from=flux_autoload_api_build /code /flux-namespace-changer/libs/flux-autoload-api
COPY . /flux-namespace-changer

FROM $PHP_CLI_IMAGE

LABEL org.opencontainers.image.source="https://github.com/flux-eco/flux-namespace-changer"
LABEL maintainer="fluxlabs <support@fluxlabs.ch> (https://fluxlabs.ch)"

ENV FLUX_NAMESPACE_CHANGER_BIN=/flux-namespace-changer/bin/docker-entrypoint.php
ENTRYPOINT $FLUX_NAMESPACE_CHANGER_BIN

COPY --from=build /flux-namespace-changer /flux-namespace-changer
