# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 complete. v1.1.0 released. ~38K LOC, 510 unit tests.
- Spec: 62,158/62,158 Mac + Ubuntu (100.0%). E2E: 792/792 (100.0%).
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64. Size: 1.31MB / 3.44MB RSS.
- **main = stable**: ClojureWasm depends on main (v1.1.0 tag).

## Current Task

Reliability improvement (branch: `strictly-check/reliability-003`).
Plan: `@./.dev/reliability-plan.md`. Progress: `@./.dev/reliability-handover.md`.

Phases A-G complete. I.1-I.7 complete (E2E 100%).
**Next**: I.0 (FP precision), Phase J (x86_64 JIT), K (perf), H (docs).

## Previous Task

I.1-I.7: E2E 792/792 (100%). Funcref validation, import type checking,
memory64 bulk ops, GC alloc guard, externref encoding, thread support.

## Known Bugs

- x86_64 JIT: 6 real-world programs crash/OOB on Ubuntu (pass without JIT)
- FP precision: c_math_compute differs from wasmtime (IEEE 754 bug)

## References

- `@./.dev/roadmap.md`, `@./private/roadmap-production.md` (stages)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/reliability-plan.md` (plan), `@./.dev/reliability-handover.md` (progress)
- `@./.dev/jit-debugging.md`, `@./.dev/ubuntu-x86_64.md` (gitignored)
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
