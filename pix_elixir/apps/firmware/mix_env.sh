#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi0
export HOST_OS=darwin
#export HOST_ARCH=x86_64

echo Running: mix $@
mix $@
