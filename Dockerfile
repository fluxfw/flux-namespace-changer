FROM php:8.1-cli-alpine AS build

RUN (mkdir -p /flux-namespace-changer && cd /flux-namespace-changer && wget -O - https://github.com/fluxfw/flux-namespace-changer/releases/download/v2022-07-12-1/flux-namespace-changer-v2022-07-12-1-build.tar.gz | tar -xz --strip-components=1)

RUN (mkdir -p /build/flux-namespace-changer/libs/flux-autoload-api && cd /build/flux-namespace-changer/libs/flux-autoload-api && wget -O - https://github.com/fluxfw/flux-autoload-api/releases/download/v2022-07-12-1/flux-autoload-api-v2022-07-12-1-build.tar.gz | tar -xz --strip-components=1 && /flux-namespace-changer/bin/change-namespace.php . FluxAutoloadApi FluxNamespaceChanger\\Libs\\FluxAutoloadApi)

COPY . /build/flux-namespace-changer

FROM scratch

COPY --from=build /build /
