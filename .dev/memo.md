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

Phases A-K complete. E2E 792/792 (100%), x86_64 JIT fully optimized.
**W34 OSR + JIT fixes**: ARM64 OSR (On-Stack Replacement) implemented for
back-edge JIT of C/C++ functions with init-once guard patterns.
Two critical bugs fixed:
1. FP cache premature-dirty: `fpAllocResult` set dirty before actual D-reg write,
   causing self-clobbering when rd==rs1 in `emitFpMemLoad64`.
2. `emitGlobalGet` x0 clobber: `reloadCallerSaved()` overwrote x0 (return value)
   with vreg 20 when reg_count > 20. Fixed by storing result before reload.
rw_c_matrix (4.5ms), rw_c_math (17.5ms) now pass with JIT.
**Phase H Gate**: conditions 1-5,8 met. Remaining blockers:
Mac: st_matrix 3.14x (regalloc), gc_tree (GC JIT), nbody 1.54x, rw_c_string (hangs in interpreter too).
Next: Phase H Gate remaining blockers, then Phase H (documentation audit).

## Previous Task

W34 OSR + JIT bug fixes:
- ARM64 OSR prologue: callee-saved push, REGS_PTR setup, mem cache, vreg load, branch to target
- FP cache fix: `fpAllocResult` no longer premature-dirty; callers call `fpMarkResultDirty` after write
- GlobalGet fix: store x0 to regs[rd] before `reloadCallerSaved()` to prevent vreg 20 clobber
- x86_64 OSR: infrastructure fields added (guard_branch_pc, osr_target_pc, osr_prologue_offset)

## Known Bugs

- c_hello_wasi: EXIT=71 on Ubuntu (WASI issue, not JIT — same with --profile)
- Go WASI: 3 Go programs produce no output (WASI compatibility, not JIT-related)

## References

- `@./.dev/roadmap.md`, `@./private/roadmap-production.md` (stages)
- `@./.dev/decisions.md`, `@./.dev/checklist.md`, `@./.dev/spec-support.md`
- `@./.dev/reliability-plan.md` (plan), `@./.dev/reliability-handover.md` (progress)
- `@./.dev/jit-debugging.md`, `@./.dev/ubuntu-x86_64.md` (gitignored)
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
