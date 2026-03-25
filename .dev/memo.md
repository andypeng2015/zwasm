# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 + Phase 1, 3, 5, 8, 10, 11, 13, 15, 19, **20** complete.
- Spec: 62,263/62,263 Mac+Ubuntu (100.0%, 0 skip).
- E2E: 797/797 (Mac+Ubuntu). Fixed JIT memory64 bounds + custom-page-sizes 2026-03-25.
- Real-world: Mac 50/50, Ubuntu 50/50. go_math_big fixed 2026-03-25.
- JIT: Register IR + ARM64/x86_64 + SIMD (NEON 253/256, SSE 244/256).
- HOT_THRESHOLD=3 (lowered from 10 in W38).
- Binary: 1.29MB stripped. Memory: ~3.5MB RSS.
- Platforms: macOS ARM64, Linux x86_64/ARM64, Windows x86_64.
- **main = stable**. ClojureWasm updated to v1.5.0.

## Current Task

**W45: SIMD Loop Persistence — DONE (2026-03-26)**

Q-reg/XMM cache now persists across loop iterations. Three techniques:

1. **Loop pre-header**: pre-loads v128 input vregs into Q/XMM before pc_map entry.
   Back-edges skip pre-loads (jump to pc_map). First iteration pays LDR cost once.

2. **Flush-not-evict at back-edges**: `simdQregFlushAll()` writes dirty Q-regs
   to memory but keeps cache entries. Ensures deopt safety while preserving cache.

3. **Out-of-line flush stubs**: forward conditional branches (loop exits) use
   stubs at function end. Fall-through (hot loop path) has zero flush overhead.

### Results (2026-03-26)

| Benchmark            | Before | After   | Improvement |
|----------------------|--------|---------|-------------|
| simd_mandel (simd)   | 18.7s  | 17.23s  | 8%          |
| simd_matmul (simd)   | 2.7s   | 2.53s   | 6%          |
| simd_chain           | 390ms  | 397ms   | ~same       |
| simd_nbody (simd)    | 520ms  | 352ms   | 32%         |
| scalar benchmarks    |        |         | no regress  |

### Remaining SIMD gap

| Benchmark            | zwasm  | wasmtime | ratio  |
|----------------------|--------|----------|--------|
| simd_mandel          | 17.2s  | 240ms    | 72x    |
| simd_matmul          | 2.5s   | 20ms     | 125x   |
| simd_chain           | 397ms  | 10ms     | 40x    |
| simd_nbody           | 352ms  | 10ms     | 35x    |

### Next optimization opportunities

1. **v128.load/store guard page path** → reduce bounds check overhead
2. **FMLA instruction fusion** → ARM64 fused multiply-add
3. **Non-native SIMD ops to native** → reduce trampoline calls in loops

### Key code locations

- `jit.zig:2604`: branch target eviction (ARM64)
- `x86.zig:3872`: branch target eviction (x86)
- `jit.zig:simdQregEvictAll`: Q-cache eviction function
- `jit.zig:emitSimdBinaryNeon`: direct Q-reg binary ops (already optimal within basic block)
- `jit.zig:scanBranchTargets`: identifies branch targets (needs loop detection)

### SIMD benchmarks

Build: `bash bench/simd/build_simd_bench.sh`
Compare: `bash bench/compare_runtimes.sh --rt=zwasm,wasmtime`
Sources: `bench/simd/src/` (C: mandelbrot, matmul, simd_chain, nbody, etc.)
         `bench/simd/rust-blake2/` (Rust: blake2b_simd)

### Open Work Items

| Item       | Description                                       | Status           |
|------------|---------------------------------------------------|------------------|
| W45        | SIMD loop persistence (Q-reg across loops)        | DONE (2026-3-26) |
| W44        | SIMD register class (D132 Phase B)                | DONE (2026-3-26) |
| Phase 18   | Lazy Compilation + CLI Extensions                 | Future           |
| Zig 0.16   | API breaking changes                              | When released    |

## Completed Phases (summary)

| Phase    | Name                                  | Date       |
|----------|---------------------------------------|------------|
| 1        | Guard Pages + Module Cache            | 2026-03    |
| 3        | CI Automation + Documentation         | 2026-03    |
| 5        | C API + Conditional Compilation       | 2026-03    |
| 8        | Real-World Coverage + WAT Parity      | 2026-03    |
| 10       | Quality / Stabilization               | 2026-03    |
| 11       | Allocator Injection + Embedding       | 2026-03    |
| 13       | SIMD JIT (NEON + SSE)                 | 2026-03-23 |
| 15       | Windows Port                          | 2026-03    |
| 19       | JIT Reliability                       | 2026-03    |
| 20       | JIT Correctness Sweep                 | 2026-03-25 |

## Next Session Reference Chain

1. **Orient**: `git log --oneline -5 && git status && git branch`
2. **This memo**: current task (W44 design + implementation plan)
3. **D132 Phase B**: `@./.dev/decisions.md` → search `## D132` → "Phase B"
4. **regalloc.zig**: `RegInstr` struct, SIMD opcode handling (search `SIMD_BASE`)
5. **jit.zig**: `emitSimdBinaryOp`, `emitLoadV128`, `emitStoreV128`, `SIMD_SCRATCH0/1`
6. **x86.zig**: same patterns as jit.zig
7. **Reference impl**: wasmtime cranelift (`~/Documents/OSS/wasmtime/`) — SIMD register allocation
8. **SIMD benchmarks**: `bench/run_simd_bench.sh` — A/B comparison
9. **Ubuntu testing**: `@./.dev/references/ubuntu-testing-guide.md`
10. **Merge gate**: CLAUDE.md → "Merge Gate Checklist" section

## References

- `@./.dev/roadmap.md` — Phase roadmap
- `@./.dev/checklist.md` — resolved work items
- `@./.dev/decisions.md` — D130 (SIMD arch), D132 (SIMD perf plan)
- `@./.dev/jit-debugging.md` — JIT debug techniques
- `@./.dev/references/w38-osr-research.md` — OSR research
- `bench/simd_comparison.yaml` — SIMD performance data
- `bench/history.yaml` — benchmark history (latest: phase20-rem-fix)
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
