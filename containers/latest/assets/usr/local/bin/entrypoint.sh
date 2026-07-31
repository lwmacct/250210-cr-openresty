#!/bin/ash
# shellcheck shell=dash
set -eu

__run_entrypoint_scripts() {
  local _script_file

  for _script_file in /entrypoint.d/*.sh; do
    [ -f "$_script_file" ] || continue
    [ -x "$_script_file" ] || continue

    printf 'entrypoint: running %s\n' "$_script_file"
    "$_script_file"
  done
}

__main() {
  case "${1:-}" in
    openresty | nginx)
      __run_entrypoint_scripts
      ;;
  esac

  exec "$@"
}

__main "$@"
