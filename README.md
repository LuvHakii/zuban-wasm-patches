# zuban-wasm-patches

Extends [zuban](https://github.com/zubanls/zuban) with WASM support.

## Layout

```
patches/    net diff vs upstream/master: wasm support for zubanls
scripts/    common.sh (config), setup.sh (clone), build.sh (patch + build)
```

## Build

```bash
ZUBAN_REV=master bash scripts/setup.sh
bash scripts/build.sh
```
