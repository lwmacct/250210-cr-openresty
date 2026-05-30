#!/usr/bin/env bash

{
  mkdir -p data/{certs,config,stream,script}
  touch data/{certs,config,stream,script}/.gitkeep
  touch data/{config,stream}/default.conf
}
