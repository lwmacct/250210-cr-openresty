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

LABEL org.opencontainers.image.source=https://github.com/lwmacct/250210-cr-openresty
LABEL org.opencontainers.image.description="lwmacct"
LABEL org.opencontainers.image.licenses=MIT
