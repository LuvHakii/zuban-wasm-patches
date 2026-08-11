#!/usr/bin/env bash

ZUBAN_REV=${ZUBAN_REV:-master}

ROOT=${ROOT:-$HOME/zuban-build}
REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

SRC=$ROOT/zuban
