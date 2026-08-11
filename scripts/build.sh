#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

cd $SRC

if [ ! -f .patched ]; then
  echo "applying patches"
  git apply $REPO/patches/*.patch
  touch .patched
fi

echo "building wasm"
bash scripts/build-wasm.sh

echo "BUILD DONE"
