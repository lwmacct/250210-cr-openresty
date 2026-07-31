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
task container:build:local
```

### Run Container

```shell
docker run --rm -p 8080:80 cr-openresty:latest
```

本地构建任务不会推送镜像。多架构镜像仅在推送 `v*` tag 后由 GitHub Actions 发布到 GHCR。

HTTP configuration files are mounted under `/etc/nginx/conf.d/*.conf`. Main-context configuration, including `stream` blocks, uses `/etc/nginx/conf.d/*.main`.

## Related Links

- [OpenResty](https://openresty.org/)
- [Docker OpenResty](https://github.com/openresty/docker-openresty)
- [Taskfile](https://taskfile.dev/)
- [Pre-commit](https://pre-commit.com/)
