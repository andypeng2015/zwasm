# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 + Phase 1 complete. v1.3.0 candidate (pending release).
- Spec: 62,263/62,263 Mac+Ubuntu (100.0%, 0 skip). E2E: 792/792 (100.0%, 0 leak).
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64. Size: 1.3MB stripped.
- Module cache: `zwasm run --cache`, `zwasm compile` (D124).
- **main = stable**: Phase 1 merged. ClojureWasm depends on main.

## Current Task

Phase 1 merged to main. Next: v1.3.0 release, then Phase 3.

Merge Gate passed (Mac + Ubuntu): spec 62,263, E2E 792/792, real-world 30/30.

**Next steps**:
1. Tag v1.3.0 + update CW dependency (use `/release` skill)
2. Phase 3: CI Automation + Documentation (see `roadmap.md`)

Previous: Phase 1 (guard pages + module cache) merged to main.

## Known Bugs

None.

## References

- `@./.dev/roadmap.md` (future phases), `@./.dev/roadmap-archive.md` (completed stages)
- `@./private/future/03_zwasm_clojurewasm_roadmap_ja.md` (integrated roadmap)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/jit-debugging.md`, `@./.dev/bench-strategy.md`
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
