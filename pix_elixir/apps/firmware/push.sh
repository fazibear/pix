#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi0

mix firmware
mix firmware.push $1
