#!/usr/bin/env bash

__main() {

  {
    _proxy="ghcr.nju.edu.cn/"
    _proxy="1181.s.kuaicdn.cn:11818/"
    _image1="${_proxy}ghcr.io/lwmacct/250210-cr-openresty:1.29.2.5-alpine-fat-t260530"
    _image2="$(docker images -q $_image1)"
    if [[ "$_image2" == "" ]]; then docker pull $_image1 && _image2="$(docker images -q $_image1)"; fi
  }

  _app_name="250210-cr-openresty"
  _app_data="/data/project/$_app_name"
  cat <<EOF | docker compose -p "$_app_name" -f - up -d --remove-orphans
services:
  main:
    container_name: $_app_name
    image: "$_image2"
    restart: always
    network_mode: host
    volumes:
      - /data/deploy:/data/deploy
      - /etc/localtime:/etc/localtime:ro
      - /etc/nginx/conf.d:/etc/nginx/conf.d
      - $_app_data:/usr/local/openresty/nginx
    environment:
      - TZ=Asia/Shanghai
EOF
}

__help() {
  cat <<EOF

EOF
}

__main
