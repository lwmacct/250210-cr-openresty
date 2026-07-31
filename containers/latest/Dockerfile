# syntax=docker/dockerfile:1

ARG OPENRESTY_BUILD_IMAGE="openresty/openresty:1.31.1.1-2-alpine-fat@sha256:427d94fea0c24b099e7891e8d1b7976f6d008e2d427e56bab725c8b8b293795b"
ARG OPENRESTY_RUNTIME_IMAGE="openresty/openresty:1.31.1.1-2-alpine@sha256:5f621903212ed7194a6bd31de7a76c1cfbe92e7b7a6fdb0f2b38626e97bd38c4"

FROM ${OPENRESTY_BUILD_IMAGE} AS lua-deps

ARG LUA_RESTY_HTTP_VERSION="0.17.1"
ARG LUA_RESTY_MLCACHE_VERSION="2.7.0"

RUN opm get \
      "ledgetech/lua-resty-http=${LUA_RESTY_HTTP_VERSION}" \
      "thibaultcha/lua-resty-mlcache=${LUA_RESTY_MLCACHE_VERSION}" \
    && resty -e 'require "resty.http"; require "resty.mlcache"'

FROM ${OPENRESTY_RUNTIME_IMAGE}

LABEL maintainer="https://github.com/lwmacct"
LABEL org.opencontainers.image.source="https://github.com/lwmacct/250210-cr-openresty"
LABEL org.opencontainers.image.description="OpenResty runtime with pinned Lua extensions"
LABEL org.opencontainers.image.licenses="MIT"

ENV TZ="Asia/Shanghai"

RUN apk add --no-cache tini

COPY --from=lua-deps /usr/local/openresty/site/ /usr/local/openresty/site/
COPY containers/latest/assets/ /

RUN set -eux; \
    ash -n /usr/local/bin/entrypoint.sh; \
    ash -n /entrypoint.d/10-test-config.sh; \
    _config_file="$(mktemp)"; \
    printf '%s\n' \
      'error_log stderr notice;' \
      'pid /tmp/nginx.pid;' \
      'events {}' \
      'stream {}' \
      'http { init_by_lua_block { require "resty.http"; require "resty.mlcache"; require "resty.redis"; require "resty.mysql" } }' \
      >"$_config_file"; \
    openresty -t -c "$_config_file"; \
    timeout 1 openresty -c "$_config_file" -g 'daemon off;'; \
    rm -f "$_config_file"

EXPOSE 80
STOPSIGNAL SIGQUIT
ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["openresty", "-g", "daemon off;"]
