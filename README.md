# flux-namespace-changer

Change namespace of library to specific project namespace

## Example

```dockerfile
FROM php:8.1-cli-alpine

RUN (mkdir -p /flux-namespace-changer && cd /flux-namespace-changer && wget -O - https://github.com/fluxfw/flux-namespace-changer/releases/download/%tag%/flux-namespace-changer-%tag%-build.tar.gz | tar -xz --strip-components=1)

RUN /flux-namespace-changer/bin/change-namespace.php /path/to/xyz Old\\Namespace New\\Namespace
```
