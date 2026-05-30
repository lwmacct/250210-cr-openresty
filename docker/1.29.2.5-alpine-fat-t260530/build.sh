#!/usr/bin/env bash
# shellcheck disable=SC2317
# document https://www.yuque.com/lwmacct/docker/buildx

__main() {
  {
    _sh_path=$(realpath "$(ps -p $$ -o args= 2>/dev/null | awk '{print $2}')")    # 当前脚本路径
    _dir_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-1)}')                  # 当前目录名
    _pro_name=$(git remote get-url origin | head -n1 | xargs -r basename -s .git) # 当前仓库名
    _image="${_pro_name}:$_dir_name"
  }

  _dockerfile=$(
    cat <<"EOF"
# https://hub.docker.com/r/openresty/openresty/tags
FROM openresty/openresty:1.29.2.5-alpine-fat

LABEL maintainer="https://yuque.com/lwmacct"
LABEL document="https://yuque.com/lwmacct/docker/buildx"
ARG DEBIAN_FRONTEND=noninteractive
USER root

RUN set -eux; \
    echo "配置源"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories;

RUN set -eux; \
    echo "安装常用软件"; \
    apk add --no-cache \
        busybox-extras tini bash jq bc curl wget vim sudo tzdata socat iproute2 tmux apache2-utils wrk rsync;

RUN set -eux; \
    echo "安装常用 OpenResty 模块"; \
    opm get \
        openresty/lua-resty-redis \
        openresty/lua-resty-mysql \
        openresty/lua-resty-lrucache \
        openresty/lua-resty-lock \
				openresty/lua-resty-websocket \
        openresty/lua-resty-string \
				ledgetech/lua-resty-http \
				thibaultcha/lua-resty-mlcache;


RUN set -eux; \
    echo "创建 Nginx 软链接"; \
    mv /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/; \
    ln -sf /usr/local/bin/nginx /usr/local/openresty/nginx/sbin/nginx; \
    cp -a /usr/local/openresty/nginx/ /usr/local/openresty/nginx.bak;

COPY file/entry.sh /usr/local/bin/entry.sh

ENV TZ=Asia/Shanghai

ENTRYPOINT ["tini", "--"]
CMD ["bash", "-c", "/usr/local/bin/entry.sh && /usr/local/openresty/bin/openresty -g 'daemon off;'"]

LABEL org.opencontainers.image.source=$_ghcr_source
LABEL org.opencontainers.image.description="lwmacct"
LABEL org.opencontainers.image.licenses=MIT
EOF
  )
  {
    cd "$(dirname "$_sh_path")" || exit 1
    echo "$_dockerfile" >Dockerfile

    _ghcr_source=$(git remote get-url origin | head -n1 | sed 's|git@github.com:|https://github.com/|' | sed 's|.git$||')
    sed -i "s|\$_ghcr_source|$_ghcr_source|g" Dockerfile
  }
  {
    if command -v sponge >/dev/null 2>&1; then
      jq 'del(.credsStore)' ~/.docker/config.json | sponge ~/.docker/config.json
    else
      jq 'del(.credsStore)' ~/.docker/config.json >~/.docker/config.json.tmp && mv ~/.docker/config.json.tmp ~/.docker/config.json
    fi
  }
  {
    _registry="ghcr.io/lwmacct" # 托管平台, 如果是 docker.io 则可以只填写用户名
    _repository="$_registry/$_image"
    _buildcache="$_registry/$_pro_name:cache"
    echo "image: $_repository"
    echo "cache: $_buildcache"
    echo "-----------------------------------"
    # docker buildx build --builder default --platform linux/amd64 -t "$_repository" --network host --progress plain --load --cache-to "type=registry,ref=$_buildcache,mode=max" --cache-from "type=registry,ref=$_buildcache" . && {
    docker buildx build --builder default --platform linux/amd64 -t "$_repository" --network host --progress plain --load . && {
      # true/false
      if false; then
        docker rm -f sss >/dev/null 2>&1 || true
        docker run -itd --name=sss \
          --restart=unless-stopped \
          --network=host \
          --privileged=false \
          "$_repository"
        docker exec -it sss bash
      fi
    }
    docker push "$_repository"

  }
}

__main

__help() {
  cat >/dev/null <<"EOF"
这里可以写一些备注

ghcr.io/lwmacct/250812-cr-vscode:latest-arm64

EOF
}
