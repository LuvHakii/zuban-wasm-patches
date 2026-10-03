#!/usr/bin/env bash
set -e

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SRC=$REPO/zuban

want="$(git -C $REPO rev-parse :zuban) $(cat $REPO/patches/*.yml $REPO/scripts/apply-rules.sh $(find $REPO/overlay -type f | sort) | git hash-object --stdin)"
if [ "$(cat $SRC/.patched 2>/dev/null)" != "$want" ]; then
  if [ -e $SRC/.git ]; then git -C $SRC reset -q --hard && git -C $SRC clean -fdq; fi
  git -C $REPO submodule update --init --depth 1 zuban
  $REPO/scripts/apply-rules.sh $SRC $REPO/patches/*.yml
  cp -r $REPO/overlay/. $SRC/
  echo "$want" > $SRC/.patched
fi

cd $SRC

export CARGO_PROFILE_RELEASE_DEBUG=false CARGO_PROFILE_RELEASE_STRIP=debuginfo CARGO_PROFILE_RELEASE_OPT_LEVEL=z \
  CARGO_PROFILE_RELEASE_LTO=true CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1 CARGO_PROFILE_RELEASE_PANIC=abort \
  RUSTFLAGS="-C link-arg=-zstack-size=2097152"

echo "building wasm"
cargo build --release --target wasm32-wasip1 -p zubanls --bin zubanls
mkdir -p target/wasm
wasm-opt -O --strip-debug target/wasm32-wasip1/release/zubanls.wasm -o target/wasm/zuban.wasm

echo "BUILD DONE"
