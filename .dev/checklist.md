# Deferred Work Checklist

Open items only. Resolved items in git history.
Prefix: W## (to distinguish from CW's F## items).

## Invariants (always enforce)

- [ ] D100: No CW-specific types in public API (Value, GC, Env)
- [ ] D102: All types take allocator parameter, no global allocator

## Open Items

- [ ] W38: SIMD JIT — compiler-generated code performance
  C compiler (`wasm32-wasi-clang -O2 -msimd128`) patterns are much slower than
  hand-written WAT. Gap vs wasmtime: microbench 1.2-3.8x, C-generated 13-131x.

  **Root cause analysis** (investigate in this order):
  1. WASI C runtime overhead — large C-compiled wasm includes libc startup.
     Compare bare function execution time vs full program to isolate.
  2. replace_lane fusion — `wasm_i16x8_make(a,b,c,...)` generates 8x
     `i16x8.replace_lane`. Fuse consecutive replace_lane into single v128.const
     or DUP/INS sequence. Implement in predecode.zig or regalloc.zig peephole.
  3. Interpreter fallback frequency — C code has large mixed functions (scalar+SIMD).
     If regalloc bails on any unsupported opcode, entire function falls back.
     Check bail rate on the 5 C benchmark modules.

  **Key data**: `bench/simd_comparison.yaml` (3 layers: baseline → post-opt → JIT)
  **Benchmark sources**: `bench/simd/src/` (grayscale.c, box_blur.c, sum_reduce.c,
  byte_freq.c, nbody_simd.c). Build: `bash bench/simd/build_simd_bench.sh`
  **Microbench WAT**: `bench/simd/` (dot_product.wat, matrix_mul.wat, etc.)
  **Run**: `bash bench/run_simd_bench.sh [--quick]`
  **W37 impact**: v128 load/store is now 1 instruction (was 3-5). Re-measure
  dot_product (was 0.75x vs scalar, should improve) before deeper optimization.

## Resolved (summary)

W37: Contiguous v128 storage. W39: Multi-value return JIT (guard removed).
W40: Epoch-based JIT timeout (D131).

W2-W36: See git history. All resolved through Stages 0-47 and Phases 1-19.
