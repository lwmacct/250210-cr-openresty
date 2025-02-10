#!/usr/bin/env bash

__main() {
    if [ -z "$(find /usr/local/openresty/nginx/ -mindepth 1 -print -quit)" ]; then
        echo "copy nginx"
        rsync -a /usr/local/openresty/nginx.bak/ /usr/local/openresty/nginx/
    fi
}

__main
