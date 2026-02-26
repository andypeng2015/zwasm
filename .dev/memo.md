# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 complete. v1.1.0 released. ~38K LOC, 510 unit tests.
- Spec: 62,158/62,158 Mac + Ubuntu (100.0%). E2E: 792/792 (100.0%).
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64. Size: 1.31MB / 3.44MB RSS.
- **main = stable**: ClojureWasm depends on main (v1.1.0 tag).

## Current Task

Reliability improvement (branch: `strictly-check/reliability-005`).
Plan: `@./.dev/reliability-plan.md`. Progress: `@./.dev/reliability-handover.md`.

**reliability-005: Real-world DIFF fix + test expansion + Phase H**
- [x] R0: CI + gate update (E2E/compat in gates, memory check, WASI SDK in CI)
- [ ] R1: E2E segfault fix (Mac aarch64 e2e_runner poison crash)
- [ ] R2: Go WASI fix (3 programs no output)
- [ ] R3: cpp_string_ops Ubuntu fix (25000 vs 24995)
- [ ] R4: c_hello_wasi Ubuntu fix (EXIT=71)
- [ ] R5: Add 18 new real-world test programs (12 → 30, all PASS)
- [ ] R6: Phase H Gate pass (all 9 conditions)
- [ ] R7: Merge to main, push, CI green
- [ ] R8: Phase H — 41-file documentation audit

## Previous Task

reliability-004 (P1-P5): rw_c_string hang fix, nbody FP cache, rw_c_math/st_matrix
regalloc limits, GC JIT. All merged to main at f654cc9.

## Known Bugs

- E2E segfault on Mac (0xaaaaaaaaaaaaaab2 — use-after-free poison in e2e_runner)
- Go WASI: 3 Go programs produce no output (Mac + Ubuntu)
- cpp_string_ops: 25000 vs 24995 on Ubuntu x86_64 only
- c_hello_wasi: EXIT=71 on Ubuntu (WASI issue)

## References

- `@./.dev/roadmap.md`, `@./private/roadmap-production.md` (stages)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/reliability-plan.md` (plan), `@./.dev/reliability-handover.md` (progress)
- `@./.dev/jit-debugging.md`, `@./.dev/ubuntu-x86_64.md` (gitignored)
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
