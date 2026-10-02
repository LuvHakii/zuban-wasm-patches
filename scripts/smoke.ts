import {mkdirSync, mkdtempSync, openSync, readFileSync, writeFileSync} from "node:fs";
import {tmpdir} from "node:os";
import {WASI} from "node:wasi";

const [wasm, typeshed] = process.argv.slice(2);
const dir = mkdtempSync(`${tmpdir()}/zuban-smoke-`);
mkdirSync(`${dir}/src`);
writeFileSync(`${dir}/src/a.py`, "y: str = 1\n");
const uri = "file:///src/a.py";
const msgs = [
	{id: 1, method: "initialize", params: {processId: null, rootUri: "file:///src", capabilities: {}}},
	{method: "initialized", params: {}},
	{method: "textDocument/didOpen", params: {textDocument: {uri, languageId: "python", version: 1, text: "y: str = 1\n"}}},
	{id: 2, method: "textDocument/diagnostic", params: {textDocument: {uri}}},
	{id: 3, method: "shutdown", params: null},
	{method: "exit", params: null},
];
writeFileSync(`${dir}/in`, msgs.map(m => JSON.stringify({jsonrpc: "2.0", ...m}) + "\n").join(""));
const wasi = new WASI({
	version: "preview1",
	args: ["zuban", "server"],
	env: {ZUBAN_TYPESHED: "/typeshed"},
	preopens: {"/": dir, "/typeshed": typeshed},
	stdin: openSync(`${dir}/in`, "r"),
	stdout: openSync(`${dir}/out`, "w"),
	returnOnExit: true,
});
const {instance} = await WebAssembly.instantiate(readFileSync(wasm), wasi.getImportObject());
const code = wasi.start(instance);
const out = readFileSync(`${dir}/out`, "utf8").trim().split("\n").map(l => JSON.parse(l));
const diags = out.find(m => m.id === 2)?.result?.items?.map(d => d.message) ?? [];
const shut = out.some(m => m.id === 3 && "result" in m);
console.log({code, diags, shut});
if (code !== 0 || diags.length !== 1 || !/Incompatible types/.test(diags[0]) || !shut) process.exit(1);
