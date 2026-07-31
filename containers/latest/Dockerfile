# syntax=docker/dockerfile:1

ARG OPENRESTY_VERSION="1.31.1.1-2"

FROM openresty/openresty:${OPENRESTY_VERSION}-alpine-fat AS lua-deps

ARG LUA_RESTY_HTTP_VERSION="0.17.1"
ARG LUA_RESTY_MLCACHE_VERSION="2.7.0"

RUN opm get \
      "ledgetech/lua-resty-http=${LUA_RESTY_HTTP_VERSION}" \
      "thibaultcha/lua-resty-mlcache=${LUA_RESTY_MLCACHE_VERSION}" \
    && resty -e 'require "resty.http"; require "resty.mlcache"'

FROM openresty/openresty:${OPENRESTY_VERSION}-alpine

LABEL maintainer="https://github.com/lwmacct"
LABEL org.opencontainers.image.source="https://github.com/lwmacct/250210-cr-openresty"
LABEL org.opencontainers.image.description="OpenResty runtime with pinned Lua extensions"
LABEL org.opencontainers.image.licenses="MIT"

ENV TZ="Asia/Shanghai"

RUN apk add --no-cache bash tini

COPY --from=lua-deps /usr/local/openresty/site/ /usr/local/openresty/site/
COPY containers/latest/assets/ /

RUN set -eux; \
    bash -n /usr/local/bin/entrypoint.sh; \
    bash -lc 'command -v openresty'; \
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
ENTRYPOINT ["tini", "-g", "--"]
CMD ["entrypoint.sh", "openresty", "-g", "daemon off;"]
