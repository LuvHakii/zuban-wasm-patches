# zuban-wasm-patches

Builds the [zuban](https://github.com/zubanls/zuban) language server for `wasm32-wasip1`.

## Layout

```
zuban/      upstream, pinned submodule
patches/    net diff vs the pinned commit: single-threaded zubanls server binary for wasm32-wasip1
scripts/    build.sh (patch + build), smoke.ts
```

## Run

`zuban.wasm` is a WASI command that runs the zubanls server; arguments are ignored.

- JSON-RPC on stdin/stdout, one compact JSON message per line, no `Content-Length`.
- Files come from the WASI preopens. Set `ZUBAN_TYPESHED=/typeshed`.
- No file watching: send `workspace/didChangeWatchedFiles` after changing files.
- stdin reads block. In a browser, either wrap `fd_read` in `WebAssembly.Suspending` and `_start` in `WebAssembly.promising` (JSPI), or run it in a Worker whose `fd_read` waits on a `SharedArrayBuffer` with `Atomics.wait`.

## Build

```bash
bash scripts/build.sh   # inits the submodule, applies patches, builds zuban/target/wasm/zuban.wasm
```
