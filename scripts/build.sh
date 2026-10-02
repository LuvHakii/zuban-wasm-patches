#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

cd $SRC

if [ ! -f .patched ]; then
  echo "applying patches"
  out=$(git apply -v $REPO/patches/*.patch 2>&1) || { echo "$out"; exit 1; }
  echo "$out"
  if grep -q offset <<<"$out"; then echo "hunk applied at an offset, regenerate that patch"; exit 1; fi
  touch .patched
fi

export CARGO_PROFILE_RELEASE_DEBUG=false CARGO_PROFILE_RELEASE_STRIP=true CARGO_PROFILE_RELEASE_OPT_LEVEL=z \
  CARGO_PROFILE_RELEASE_LTO=true CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 CARGO_PROFILE_RELEASE_PANIC=abort

echo "building wasm"
bash scripts/build-wasm.sh

echo "BUILD DONE"
