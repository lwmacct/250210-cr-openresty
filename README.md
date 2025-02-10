## 推荐阅读
- 代码仓库: https://github.com/lwmacct/250210-cr-openresty
- 语雀文档: https://www.yuque.com/lwmacct/docker-run/openresty
- 官方仓库: https://github.com/openresty/openresty
- 配置文档: https://openresty.org/cn/

## 运行示例
```bash
#!/usr/bin/env bash

__main() {

  {
    # 镜像准备
    _image1="ghcr.io/lwmacct/250210-cr-openresty:1.25.3.2-alpine-fat-t2502100"
    _image2="$(docker images -q $_image1)"
    if [[ "$_image2" == "" ]]; then
      docker pull $_image1
      _image2="$(docker images -q $_image1)"
    fi
  }

  _apps_name="openresty"
  _apps_data="/data/$_apps_name"
  cat <<EOF | docker compose -p "$_apps_name" -f - up -d --remove-orphans
services:
  main:
    container_name: $_apps_name
    image: "$_image2"
    restart: always
    network_mode: host
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/nginx/conf.d:/etc/nginx/conf.d
      - $_apps_data:/usr/local/openresty/nginx
    environment:
      - TZ=Asia/Shanghai
EOF
}

__help() {
  cat <<EOF

EOF
}

__main

```