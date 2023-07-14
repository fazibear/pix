#!/bin/bash -e

cd apps/firmware

./build.sh
#./upload.sh pix.local ../../_build/${MIX_TARGET}/${MIX_TARGET}_${MIX_ENV}/nerves/images/firmware.fw
mix nerves.burn
cd ..
