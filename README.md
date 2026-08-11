# zuban-wasm-patches

Extends [zuban](https://github.com/zubanls/zuban) with WASM support.

## Layout

```
patches/    3 patches: wasm support, target_family cleanup, panic_hooks revert
scripts/    common.sh (config), setup.sh (clone), build.sh (patch + build)
```

## Build

```bash
ZUBAN_REV=master bash scripts/setup.sh
bash scripts/build.sh
```
