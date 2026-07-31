#!/bin/bash
set -euo pipefail

__run_entrypoint_scripts() {
  local _script_file

  for _script_file in /etc/entrypoint.d/*.sh; do
    [ -f "$_script_file" ] || continue

    printf 'entrypoint: running %s\n' "$_script_file"
    bash "$_script_file" "$@"
  done
}

__main() {
  __run_entrypoint_scripts "$@"
  exec "$@"
}

__main "$@"
