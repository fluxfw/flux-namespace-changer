# flux-namespace-changer

Change namespace of library to specific project namespace

## Example

```dockerfile
FROM docker-registry.fluxpublisher.ch/flux-namespace-changer:latest AS build_namespaces
COPY --from=xyz /path/to/xyz /code/xyz
RUN change-namespace /code/xyz Old\\Namespace New\\Namespace
```

```dockerfile
COPY --from=build_namespaces /code/xyz /path/to/xyz
```
