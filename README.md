# cr-openresty

## Quick Start

### Init Development Environment

```shell
pre-commit install
```

### List All Available Tasks

```shell
task -a
```

### Build Container

```shell
containers/latest/build.sh ghcr.io/lwmacct/250210-cr-openresty:latest
```

### Run Container

```shell
docker run --rm -p 8080:80 ghcr.io/lwmacct/250210-cr-openresty:latest
```

HTTP configuration files are mounted under `/etc/nginx/conf.d/*.conf`. Main-context configuration, including `stream` blocks, uses `/etc/nginx/conf.d/*.main`.

## Related Links

- [OpenResty](https://openresty.org/)
- [Docker OpenResty](https://github.com/openresty/docker-openresty)
- [Taskfile](https://taskfile.dev/)
- [Pre-commit](https://pre-commit.com/)
