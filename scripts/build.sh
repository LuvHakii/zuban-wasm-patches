#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

cd $SRC

if [ ! -f .patched ]; then
  echo "applying patches"
  git apply $REPO/patches/*.patch
  touch .patched
fi

export CARGO_PROFILE_RELEASE_DEBUG=false CARGO_PROFILE_RELEASE_STRIP=true CARGO_PROFILE_RELEASE_OPT_LEVEL=z \
  CARGO_PROFILE_RELEASE_LTO=true CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 CARGO_PROFILE_RELEASE_PANIC=abort

echo "building wasm"
bash scripts/build-wasm.sh

echo "BUILD DONE"
