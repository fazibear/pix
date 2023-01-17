#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi0
export HOST_OS=darwin
export HOST_ARCH=arm

mix $@
