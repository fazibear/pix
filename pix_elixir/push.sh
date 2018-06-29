#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi0

cd apps/firmware

mix firmware
#mix firmware.burn
mix firmware.push $1
