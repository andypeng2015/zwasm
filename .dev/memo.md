# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 complete. v1.2.0 released. ~50K LOC, 521 unit tests.
- Spec: 62,263/62,263 Mac+Ubuntu (100.0%, 0 skip). E2E: 792/792 (100.0%, 0 leak).
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64. Size: 1.19MB / 1.52MB RSS.
- **main = stable**: ClojureWasm depends on main (v1.2.0 tag).

## Current Task

v1.2.0 released (tagged, pushed, CW updated).

## Previous Task (gate-hardening)

All merged to main. Zero-skip/zero-leak + gate enforcement:
- T1-T6 complete. Spec 62,263/0/0, E2E 792/0/0, Compat 30/0/0.

## Previous Task

reliability-005 (R0-R8): E2E segfault fix, Go/C++/C WASI back-edge JIT fixes,
18 new real-world tests, OSR for back-edge JIT, x86 OSR fixes, Phase H doc audit.
All merged to main at 48b3202.

## Known Bugs

None — all previously known bugs fixed (R1: E2E segfault, R2-R4: back-edge JIT restart).

## References

- `@./.dev/roadmap.md`, `@./private/roadmap-production.md` (stages)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/reliability-plan.md` (plan), `@./.dev/reliability-handover.md` (progress)
- `@./.dev/jit-debugging.md`, `@./.dev/ubuntu-x86_64.md` (gitignored)
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
