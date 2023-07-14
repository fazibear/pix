#!/bin/bash -e

# ./mix_env.sh deps.clean --all
./mix_env.sh deps.update --all
./mix_env.sh deps.get
./mix_env.sh hex.outdated || true
./mix_env.sh deps.compile --force
./mix_env.sh compile
./mix_env.sh firmware --verbose
# ./mix_env.sh upload
