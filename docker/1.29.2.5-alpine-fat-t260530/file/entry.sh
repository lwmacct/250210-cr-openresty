#!/usr/bin/env bash

__main() {
  if [ -z "$(find /usr/local/openresty/nginx/ -mindepth 1 -print -quit)" ]; then
    echo "copy nginx"
    rsync -a /usr/local/openresty/nginx.bak/ /usr/local/openresty/nginx/

    {
      # 减少体积
      rm -rf /usr/local/openresty/nginx/conf/*.default

      rm -rf /usr/local/openresty/nginx/modules
      ln -sfn /usr/local/openresty/nginx.bak/modules /usr/local/openresty/nginx/modules

      rm -rf /usr/local/openresty/nginx/html
      ln -sfn /usr/local/openresty/nginx.bak/html /usr/local/openresty/nginx/html
    }
  fi
}

__main
