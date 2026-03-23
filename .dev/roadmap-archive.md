# zwasm Roadmap — Completed Stages Archive

Detailed records for completed stages. Moved from roadmap.md to reduce context load.
See roadmap.md for current/planned stages.

## Stage 0: Extraction & Independence (COMPLETE)

**Goal**: Standalone library + CLI, independent of ClojureWasm.

- [x] CW dependency audit and source extraction (10,398 LOC, 11 files)
- [x] Public API design: WasmModule / WasmFn / ImportEntry pattern
- [x] build.zig with library module, tests, benchmark
- [x] 115 tests passing
- [x] MIT license, CW references removed
- [x] CLI tool: `zwasm run`, `zwasm inspect`, `zwasm validate`
- [x] wasmtime comparison benchmark (544ms vs 58ms, 9.4x gap on fib(35))

## Stage 1: Library Quality + CLI Polish (COMPLETE)

**Goal**: Usable standalone Zig library + production CLI comparable to wasmtime basics.

- Ergonomic public API with doc comments
- Structured error types (replace opaque WasmError)
- build.zig.zon metadata
- CLI enhancements: WASI args/env/preopen, inspect --json, exit code propagation

## Stage 2: Spec Conformance (COMPLETE)

**Goal**: WebAssembly spec test suite passing, publishable conformance numbers.

- Wast test runner, MVP spec > 95%, post-MVP proposals
- WASI P1 completion, CI pipeline, conformance dashboard

## Stage 3: JIT + Optimization ARM64 (COMPLETE)

**Goal**: Close the performance gap with wasmtime via JIT compilation.

- 3.1-3.14: Profiling, benchmark suite, register IR (D104), ARM64 codegen (D105),
  tiered execution, call optimization, inline self-call, smart spill
- **Result**: fib(35) = 103ms, wasmtime = 52ms, ratio = 2.0x

## Stage 4: Polish & Robustness (COMPLETE)

- Fix fib_loop TinyGo bug, regalloc u8 overflow, cross-runtime benchmark update

## Stage 5: JIT Coverage Expansion (COMPLETE)

- f64/f32 JIT, memory ops, call_indirect, popcnt, peephole
- **Result**: 20/21 within 2x. 9 faster than wasmtime. st_matrix (3.1x) deferred.

## Stage 5F: E2E Compliance Completion (COMPLETE)

- Fix memory_trap/names spec, transitive import chains
- **Result**: 30,666 spec (99.9%), 180/181 E2E (99.4%)

## Stage 6: Bug Fixes & Stability (COMPLETE)

- Fix JIT prologue caller-saved register corruption. All active bugs resolved.

## Stage 7: Memory64 Table Operations (COMPLETE)

- 64-bit table limit decoding, table.size/grow returns i64
- **Result**: 37 new spec passes

## Stage 8: Exception Handling (COMPLETE)

- Tag section, throw/throw_ref/try_table, exnref, catch clauses
- Exceptions unwind call stack until caught by try_table

## Stage 9: Wide Arithmetic (COMPLETE)

- 4 opcodes: i64.add128, i64.sub128, i64.mul_wide_s, i64.mul_wide_u

## Stage 10: Custom Page Sizes (COMPLETE)

- Non-64KB memory page sizes, power-of-2 validation

## Stage 11: Security Hardening (COMPLETE)

- Deny-by-default WASI, capability flags, import validation
- Resource limits (fuel, memory ceiling), JIT W^X

## Stage 12: WAT Parser (COMPLETE)

- ~3K LOC wat.zig, `zwasm run file.wat`, `-Dwat=false` build flag

## Stage 13: x86_64 JIT Backend (COMPLETE)

- x86.zig code emitter, System V AMD64 ABI, CI on ARM64 + x86_64

## Stage 14: Wasm 3.0 — Trivial Proposals (COMPLETE)

- extended_const, branch_hinting, tail_call (~330 LOC)

## Stage 15: Multi-memory (COMPLETE)

- memidx immediate for all load/store/memory ops, binary format bit 6

## Stage 16: Relaxed SIMD (COMPLETE)

- 20 opcodes, ARM64 NEON direct mapping

## Stage 17: Function References (COMPLETE)

- call_ref, return_call_ref, br_on_null/non_null, generalized ref types

## Stage 18: GC (COMPLETE)

- ~32 opcodes, struct/array types, i31ref, subtyping, mark-and-sweep GC

## Stage 19: Post-GC Improvements (COMPLETE)

- GC spec tests via wasm-tools, table.init fix, GC collector, WASI P1 46/46

## Stage 20: `zwasm features` CLI (COMPLETE)

- `zwasm features`, `--json`, spec level tags

## Stage 21: Threads (COMPLETE)

- Shared memory, 79 atomic operations, wait/notify

## Stage 22: Component Model (COMPLETE)

- WIT parser, component binary decoder, Canonical ABI, WASI P2 adapter
- ~121 CM tests

## Stage 23: JIT Optimization — Smart Spill + Direct Call (COMPLETE)

- Liveness-based spill/reload, direct call, FP cache (D2-D7),
  inline self-call, vm/inst/reg_ptr caching
- **Result**: 13/21 beat wasmtime, fib 331→91ms, nbody 42→9ms

## Stage 25: Lightweight Self-Call (COMPLETE)

- Dual entry point, x29 flag, conditional epilogue, callee-saved liveness (D117)
- **Result**: fib 91→52ms (-43%), matches wasmtime (1.0x)

## Stages 26-47: Spec Conformance, Fuzz, Windows, Production Hardening (COMPLETE)

- Stage 26-31: JIT peephole, platform verification, spec cleanup, GC benchmarks
- Stage 32: 100% spec conformance (62,263/62,263 on macOS + Linux)
- Stage 33: Fuzz testing (differential testing, 10K+ corpus, 0 crashes)
- Stage 34: Windows x86_64 (build, test, JIT, C API, release)
- Stages 35-41: Production hardening (crash safety, CI/CD, docs, distribution)
- Stages 42-43: Community preparation, v1.0.0 release
- Stages 44-47: WAT parser spec parity, SIMD perf analysis, book i18n, WAT roundtrip

## Phase 1: Guard Pages + Module Cache (COMPLETE)

- 1.1 Virtual Memory Guard Pages: mmap/mprotect/signal handler, bounds check elimination
- 1.2 Module Cache (D124): predecoded IR serialization to `~/.cache/zwasm/<hash>.zwcache`
- **Gate**: PASSED. v1.3.0.

## Phase 3: CI Automation + Documentation (COMPLETE)

- CI: spec-bump (weekly), wasm-tools-bump (monthly), spectec-monitor (weekly), nightly (weekly)
- Documentation: ARCHITECTURE.md, data-structures.md, fuzz harness docs
- D125 decision record
- **Gate**: PASSED.

## Phase 5: C API + Conditional Compilation (COMPLETE)

- 5.1 C API (D126): 25 exported `zwasm_*` functions, `include/zwasm.h`, `libzwasm`
- 5.2 Conditional Compilation (D127): `-Djit=false`, `-Dcomponent=false`, `-Dwat=false`
- Minimal build: ~940KB stripped (24% reduction)
- **Gate**: PASSED.

## Phase 8: Real-World Coverage + WAT Parity (COMPLETE)

- 50 real-world programs: TinyGo(4) + C(9) + C++(1) + Go(2) + Rust(4) + existing(30)
- WAT roundtrip: 62,259/62,259 (100%)
- W30: 5 JIT codegen fixes (guard recovery, instrDefinesRd, callee-saved, x86 emitCall)
- **Gate**: PASSED.

## Phase 10: Quality / Stabilization (COMPLETE)

- Full test suite re-verification (Mac + Ubuntu), benchmark check, size guard
- **Gate**: PASSED.

## Phase 11: Allocator Injection + Embedding (COMPLETE, D128)

- CW finalizer, C API config + allocator callback injection
- `zwasm_config_t` with `set_allocator(alloc_fn, free_fn, ctx)`
- Embedding docs (Zig/C/Python/Go guide)
- **Gate**: PASSED. v1.5.0.

## Phase 13: SIMD JIT (COMPLETE, D130)

- ARM64 NEON: 253/256 native (98.8%). x86 SSE: 244/256 native (95.3%).
- v128 split storage (regs[vreg] lo + simd_hi[vreg] hi)
- 13.0-13.6: Foundation, load/store, arithmetic, float, compare, convert, shuffle
- 13.7: 5 real-world C -msimd128 benchmarks, wasmtime comparison
- Results: image_blend 4.7x, matrix_mul 1.6x (beats wasmtime), byte_search 1.2x
- **Gate**: PASSED. Merged 2026-03-23.

## Phase 15: Windows Port (COMPLETE, D129)

- VEH signal handler, VirtualAlloc/VirtualProtect, Win64 ABI
- WASI filesystem Windows branch, CI Windows job + release binaries
- **Gate**: PASSED. 3-OS CI complete.

## Phase 19: JIT Reliability (COMPLETE)

- 19.1: `force_interpreter` flag, `--interp` CLI
- 19.2: JIT fuel check at back-edges (ARM64 + x86)
- 19.3: W35 interpreter OOB fix (emitGlobalSet ABI clobber)
- **Gate**: PASSED. CI Rust unpinned.
