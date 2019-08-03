#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi0

cd apps/firmware

mix deps.get
mix deps.update --all
mix firmware --verbose
./upload.sh pix.local ../../_build/rpi0/rpi0_prod/nerves/images/firmware.fw
