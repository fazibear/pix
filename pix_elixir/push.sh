#!/bin/bash -e

export MIX_ENV=prod
export MIX_TARGET=rpi0

cd apps/firmware

mix deps.update --all
mix deps.get
mix hex.outdated || true
mix firmware --verbose

./upload.sh pix.local ../../_build/${MIX_TARGET}/${MIX_TARGET}_${MIX_ENV}/nerves/images/firmware.fw
