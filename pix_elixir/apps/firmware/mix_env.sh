#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi2
export HOST_OS=darwin
export HOST_ARCH=arm

mix $@
