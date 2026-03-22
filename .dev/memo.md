# zwasm Development Memo

Session handover document. Read at session start.

## Current State

- Stages 0-46 + Phase 1, 3, 5, 8, 11, 15, **19** complete. **v1.6.0+** (main 2be62cd).
- Spec: 62,263/62,263 Mac+Ubuntu+Windows (100.0%, 0 skip). E2E: 792/792. Real-world: 50/50.
- Wasm 3.0: all 9 proposals. WASI: 46/46 (100%). WAT parser complete.
- JIT: Register IR + ARM64/x86_64. Fuel check at back-edges (Phase 19.2).
- **C API**: c_allocator + ReleaseSafe default (#11 fix). 64-test FFI suite.
- **CLI**: `--interp` flag for interpreter-only execution (Phase 19 debug tool).
- **main = stable**. ClojureWasm updated to v1.5.0.

## Current Task

**Phase 13: SIMD JIT** — Branch `phase13/simd-jit`. Decision D130.

### Status

- **13.0 DONE**: simdStackEffect table, simd_arm64/x86.zig stubs
- **13.1 DONE**: All 252 SIMD opcodes flow through RegIR via stack adapter
  - v128 storage: lo in regs[rd], hi in simd_hi[rd] (stack-local [512]u64)
  - OP_MOV/CONST now copy/clear simd_hi (bug: upper 64-bit loss, fixed)
  - Spec: 62,263/62,263. SIMD conformance: 3/3. Real-world samples: 6/6 correct.
- **5 real-world SIMD C samples** in test/realworld/c_simd/ (wasi-sdk -msimd128)
- **Next**: Step 13.2+ (JIT codegen for SIMD opcodes — ARM64 NEON + x86 SSE)
- SIMD bench baseline recorded (adapter is 20-53x slower than scalar — expected,
  adapter marshals via op_stack; JIT will eliminate this overhead)
- See `@./.dev/roadmap.md` Phase 13 for step breakdown (13.0-13.8)

### Key Design (D130)

- Float register class (GP + Float, industry standard)
- ARM64 + x86 per opcode group (no big-bang porting)
- SSE4.1 minimum, tbl/pshufb shuffle fallback
- Full opcode coverage needed for real-world benefit (SIMD in large mixed functions)
- `-Dsimd=false` excludes codegen via comptime

### Remaining Workarounds

| Workaround              | Status | Plan                       |
|--------------------------|--------|----------------------------|
| jitSuppressed(deadline) | Active | Epoch-based check (future) |

## Handover Notes

### W35/W36 (resolved, 2026-03-22)
- W35: ARM64 JIT `emitGlobalSet` ABI clobber + `--interp` + `i32.store16`. Commit 1429f81.
- W36: Was W35 side-effect. 3 consecutive 50/50 PASS after W35 merge.

## References

- `@./.dev/roadmap.md` — Phase 13 SIMD JIT plan (13.0-13.8)
- `@./.dev/references/simd-jit-research.md` — SIMD JIT research
- `@./.dev/decisions.md` — D130 SIMD JIT architecture
- `@./.claude/rules/simd-jit.md` — auto-loaded rules for SIMD work
- `@./.dev/checklist.md` — open items
- `@./.dev/jit-debugging.md` — JIT debug techniques
- External: wasmtime (`~/Documents/OSS/wasmtime/`), zware (`~/Documents/OSS/zware/`)
