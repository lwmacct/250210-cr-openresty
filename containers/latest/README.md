# latest container

这个目录维护 `latest` OpenResty 镜像的构建定义。

## Runtime

- OpenResty `1.31.1.1-2`
- Alpine runtime image
- `lua-resty-http` `0.17.1`
- `lua-resty-mlcache` `2.7.0`
- Native `linux/amd64` and `linux/arm64` images

默认命令为：

```shell
openresty -g "daemon off;"
```

启动链为 `tini -> entrypoint.sh -> /entrypoint.d/*.sh -> OpenResty`。只有启动 OpenResty 时才执行入口脚本；执行 `sh` 等其他命令时会直接跳过。

## Assets

`assets/` 镜像容器根文件系统。所有需要复制进镜像的文件都放在此目录，例如：

```text
assets/
├── entrypoint.d/
│   └── 10-test-config.sh
└── usr/local/bin/
    └── entrypoint.sh
```

## Configuration

- HTTP: `/etc/nginx/conf.d/*.conf`
- Main context and Stream: `/etc/nginx/conf.d/*.main`
- Entrypoint hooks: executable `/entrypoint.d/*.sh`, executed in lexical order

不要挂载整个 `/usr/local/openresty/nginx` 目录。

镜像预置的 `10-test-config.sh` 会在默认启动前执行 `openresty -t`。覆盖命令为 `sh` 等非 OpenResty 命令时，入口 hooks 会跳过。

## Build

```shell
containers/latest/build.sh ghcr.io/lwmacct/250210-cr-openresty:latest
```

默认构建并推送：

```shell
PLATFORMS=linux/amd64,linux/arm64 containers/latest/build.sh
```
