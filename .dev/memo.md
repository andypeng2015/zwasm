# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 + Phase 1, 3, 5, 8, 11, 15, **19** complete. **v1.6.0+** (main dd8003b).
- Spec: 62,263/62,263 Mac+Ubuntu+Windows (100.0%, 0 skip). E2E: 792/792. Real-world: 50/50.
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64 (macOS, Linux, Windows x86_64). Size: 1.22MB stripped.
- **Phase 19**: JIT differential testing + fuel check at back-edges.
  `force_interpreter` flag, 4 differential tests, `jitSuppressed()` fuel条件除去.
- **C API**: c_allocator + ReleaseSafe default (#11 fix). 64-test FFI suite.
- **main = stable**. ClojureWasm updated to v1.5.0.

## Current Task

**W35: ARM64 JIT OOB investigation** (Phase 19.3)

- Reproduce: `rustup run 1.93.1 cargo build` serde_json → run with zwasm ARM64
- Use differential testing (interp vs JIT) to confirm JIT-only failure
- Binary diff wasm (1.92.0 vs 1.93.1) → identify triggering opcode pattern
- Create minimal reproducer → fix JIT codegen → unpin CI Rust

### Remaining workarounds to resolve
- `jitSuppressed()` still blocks JIT for deadline (epoch-based check needed)
- W35 ARM64 JIT OOB (CI Rust pinned to 1.92.0)
- W36 flaky go compat (likely W35-related)

## Handover Notes

### Phase 19 design principles
- **Interpreter = source of truth**. JIT must produce identical results.
- **Differential testing** (force_interpreter) catches JIT-only bugs.
- JIT fuel: back-edge decrement (jit_fuel i64) + shared exit stub.
  ARM64: MOVZ+ADD+LDR+SUBS+STR+B.MI per back-edge.
  x86: push rax/load/SUB [mem],1/JS/pop rax per back-edge.

### Issue #11 root cause (2026-03-22)
- Zig 0.15 GPA crashes in Debug-mode shared libraries on Linux x86_64 (PIC codegen).
- Fix: c_allocator + library builds default to ReleaseSafe.

## References

- `@./.dev/roadmap.md` (future phases), `@./.dev/roadmap-archive.md` (completed stages)
- `@./private/future/03_zwasm_clojurewasm_roadmap_ja.md` (integrated roadmap)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/jit-debugging.md`, `@./.dev/bench-strategy.md`
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
