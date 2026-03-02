# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 + Phase 1 complete. **v1.3.0 released** (tagged 7570170).
- Spec: 62,263/62,263 Mac+Ubuntu (100.0%, 0 skip). E2E: 792/792 (100.0%, 0 leak).
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64. Size: 1.20MB stripped. RSS: 4.48MB.
- Module cache: `zwasm run --cache`, `zwasm compile` (D124).
- **main = stable**: v1.3.0 tagged. ClojureWasm updated to v1.3.0.

## Current Task

**Phase 5: C API + Conditional Compilation** — branch `phase5/c-api`

### 5.1 C API (wasm-c-api)
- D126 decision record
- `src/c_api.zig`: export engine/store/module/instance/func/memory/val via C ABI
- WASI config C API
- `include/zwasm.h` header
- `libzwasm.so` / `libzwasm.dylib` shared library build
- C test + Python ctypes example

### 5.2 Conditional Compilation
- `-Djit=false`, `-Dsimd=false`, `-Dgc=false`, `-Dthreads=false`, `-Dcomponent=false`
- Minimal build (MVP+WASI, no JIT) target < 500KB
- CI size matrix

### Design Notes
- Reference: wasm-c-api spec (https://github.com/WebAssembly/wasm-c-api)
- Reference: wasmtime C API (`~/Documents/OSS/wasmtime/crates/c-api/`)
- Zig C ABI export: `export fn` + `callconv(.c)`

## Known Bugs

None.

## References

- `@./.dev/roadmap.md` (future phases), `@./.dev/roadmap-archive.md` (completed stages)
- `@./private/future/03_zwasm_clojurewasm_roadmap_ja.md` (integrated roadmap)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/jit-debugging.md`, `@./.dev/bench-strategy.md`
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
