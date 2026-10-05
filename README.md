# zuban-wasm-patches

Builds the [zuban](https://github.com/zubanls/zuban) language server for `wasm32-wasip1`.

## Layout

```
zuban/      upstream, pinned submodule
patches/    ast-grep rules (each with an expected match count): single-threaded zubanls server for wasm32-wasip1
overlay/    new files copied over the source (the server-only bin)
scripts/    build.sh (rules + overlay + build), apply-rules.sh, smoke.ts
```

## Run

`zuban.wasm` is a WASI command that runs the zubanls server; arguments are ignored.

- JSON-RPC on stdin/stdout, one compact JSON message per line, no `Content-Length`.
- Files come from the WASI preopens. Set `ZUBAN_TYPESHED=/typeshed`.
- No file watching: send `workspace/didChangeWatchedFiles` after changing files.
- stdin reads block. In a browser, either wrap `fd_read` in `WebAssembly.Suspending` and `_start` in `WebAssembly.promising` (JSPI), or run it in a Worker whose `fd_read` waits on a `SharedArrayBuffer` with `Atomics.wait`.

## Build

```bash
bash scripts/build.sh   # inits the submodule, applies rules + overlay, builds zuban/target/wasm/zuban.wasm
```

## License

The patches, overlay and the built `zuban.wasm` are modifications of zuban and are licensed under the GNU Affero General Public License v3.0 only (see `LICENSE`). Zuban is also available under a commercial license from its authors. Each release is built from this repository at its tag with `zuban/` pinned to the commit named in the release notes, which is the Corresponding Source for that binary.
