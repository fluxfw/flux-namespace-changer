# flux-namespace-changer

Change namespace of library to specific project namespace

## Docker image build

```dockerfile
FROM docker-registry.fluxpublisher.ch/flux-namespace-changer:latest AS xyz_build
ENV FLUX_NAMESPACE_CHANGER_FROM_NAMESPACE Old\\Namespace
ENV FLUX_NAMESPACE_CHANGER_TO_NAMESPACE New\\Namespace
COPY --from=xyz /path/to/xyz /code
RUN /flux-namespace-changer/bin/change-namespace.php
```

```dockerfile
COPY --from=xyz_build /code /path/to/xyz
```

## Local

### Installation

```shell
./bin/install-to-home-local-bin.sh
```

### Commands

#### namespace-changer

```shell
namespace-changer Old\\Namespace New\\Namespace
```
