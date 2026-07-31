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
entrypoint.sh openresty -g "daemon off;"
```

默认启动链为 `tini -> entrypoint.sh -> /etc/entrypoint.d/*.sh -> OpenResty`。
覆盖容器命令时，由 `tini` 直接执行指定命令，不会隐式运行启动脚本。

## Assets

`assets/` 镜像容器根文件系统。所有需要复制进镜像的文件都放在此目录，例如：

```text
assets/
├── etc/
│   ├── entrypoint.d/
│   │   └── .gitkeep
│   └── profile.d/
│       └── 10-openresty-path.sh
└── usr/local/bin/
    └── entrypoint.sh
```

## Configuration

- HTTP: `/etc/nginx/conf.d/*.conf`
- Main context and Stream: `/etc/nginx/conf.d/*.main`
- Entrypoint hooks: `/etc/entrypoint.d/*.sh`, executed by Bash in lexical order with the target command as arguments

不要挂载整个 `/usr/local/openresty/nginx` 目录。

可以只读挂载整个启动脚本目录。脚本不需要执行权限：

```shell
docker run --rm \
  --volume "$(pwd)/entrypoint.d:/etc/entrypoint.d:ro" \
  IMAGE
```

直接运行命令会跳过启动脚本。需要执行启动脚本时，显式运行 `entrypoint.sh` 并传入要执行的命令：

```shell
docker run --rm IMAGE entrypoint.sh openresty -t
```

可以直接运行 Bash 或 BusyBox 工具：

```shell
docker run --rm IMAGE bash
docker run --rm IMAGE cat /etc/os-release
```

## Build

```shell
task container:build:local
```

默认在当前平台构建 `cr-openresty:latest`，并加载到本地 Docker：

```shell
task container:build:local IMAGE=cr-openresty:dev
```

该任务不会推送镜像。多架构构建和 GHCR 发布仅由 `v*` tag 触发的 GitHub Actions 工作流执行。
