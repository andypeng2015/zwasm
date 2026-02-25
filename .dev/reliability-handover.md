# Reliability — Session Handover

> Plan: `@./.dev/reliability-plan.md`. Rules: `@./.claude/rules/reliability-work.md`.

## Branch
`strictly-check/reliability-003` (from main at d55a72b)

## Progress

### ✅ Completed
- A-F: Environment, compilation, compat, E2E expansion, benchmarks, analysis, W34 fix
- G.1-G.3: Ubuntu spec 62,158/62,158 (100%). Real-world: all pass without JIT, 6/9 fail with JIT → Phase J
- I.0-I.7: E2E 792/792 (100%). FP precision fix (JIT getOrLoad dirty FP cache),
  funcref validation, import type checking, memory64 bulk ops,
  GC array alloc guard, externref encoding, thread/wait sequential simulation.

### Active / TODO

**Phase J: x86_64 JIT bug fixes**
- [ ] J.1: Investigate x86_64 JIT codegen crash patterns
- [ ] J.2: Fix x86_64 JIT bugs
- [ ] J.3: Verify all real-world pass on Ubuntu with JIT

**Phase K: Performance optimization (target: all ≤1.5x wasmtime)**
- [ ] K.1: JIT call threshold tuning
- [ ] K.2: Library function JIT coverage (try 2-3 approaches)
- [ ] K.3: Register allocation for f64-heavy code
- [ ] K.4: GC allocation optimization
- [ ] K.5: Benchmark re-recording on BOTH platforms

**Phase H: Documentation (LAST — requires Phase H Gate pass, see plan)**
- [ ] H.0: Phase H Gate — all 9 conditions verified (see `@./.dev/reliability-plan.md`)
- [ ] H.1: Audit README claims
- [ ] H.2: Fix discrepancies
- [ ] H.3: Update benchmark table

## Next session: start here

1. **Phase J: x86_64 JIT** — investigate and fix 6 real-world crashes on Ubuntu.
   Apply same getOrLoad fix to x86.zig if applicable.
2. **G.4: Ubuntu benchmarks** — run `bash bench/run_bench.sh --quick` in background.
3. After J: Phase K (performance), then Phase H (documentation).

## x86_64 JIT failures (Phase J input)
All PASS with `--profile` (JIT disabled). Failures with JIT:
- cpp_string_ops: Arithmetic exception (signal 6)
- c_string_processing, cpp_vector_sort: OOB memory access
- go_hello_wasi, go_json_marshal, go_sort_benchmark: OOB memory access

## Benchmark gaps (Phase K input)
rw_c_math: 5.9x, rw_c_string: 4.1x, gc_tree: 3.2x, st_matrix: 2.8x, rw_c_matrix: 2.7x.
Root cause: libm/libc inner functions stay on interpreter.
