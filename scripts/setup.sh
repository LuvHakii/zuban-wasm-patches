#!/usr/bin/env bash
set -e

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

mkdir -p $ROOT

if [ ! -d $SRC ]; then
  echo "cloning zubanls/zuban @ $ZUBAN_REV"
  git clone --depth 1 --branch $ZUBAN_REV --single-branch \
    https://github.com/zubanls/zuban.git $SRC
fi

echo "SETUP DONE"
