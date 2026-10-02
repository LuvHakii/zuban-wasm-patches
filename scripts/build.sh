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

export CARGO_PROFILE_RELEASE_DEBUG=false CARGO_PROFILE_RELEASE_STRIP=debuginfo CARGO_PROFILE_RELEASE_OPT_LEVEL=z \
  CARGO_PROFILE_RELEASE_LTO=true CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 CARGO_PROFILE_RELEASE_PANIC=abort \
  RUSTFLAGS="-C link-arg=-zstack-size=2097152"

echo "building wasm"
cargo build --release --target wasm32-wasip1 -p zubanls --bin zubanls
mkdir -p target/wasm
wasm-opt -O --strip-debug target/wasm32-wasip1/release/zubanls.wasm -o target/wasm/zuban.wasm

echo "BUILD DONE"
