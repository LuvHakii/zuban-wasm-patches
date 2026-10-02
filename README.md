# zuban-wasm-patches

Builds the [zuban](https://github.com/zubanls/zuban) language server for `wasm32-wasip1`.

## Layout

```
patches/    net diff vs upstream/master: single-threaded zubanls server binary for wasm32-wasip1
scripts/    common.sh (config), setup.sh (clone), build.sh (patch + build)
```

## Run

`zuban.wasm` is a WASI command that runs the zubanls server; arguments are ignored.

- JSON-RPC on stdin/stdout, one compact JSON message per line, no `Content-Length`.
- Files come from the WASI preopens. Set `ZUBAN_TYPESHED=/typeshed`.
- No file watching: send `workspace/didChangeWatchedFiles` after changing files.
- stdin reads block. In a browser, either wrap `fd_read` in `WebAssembly.Suspending` and `_start` in `WebAssembly.promising` (JSPI), or run it in a Worker whose `fd_read` waits on a `SharedArrayBuffer` with `Atomics.wait`.

## Build

```bash
ZUBAN_REV=master bash scripts/setup.sh
bash scripts/build.sh
```
