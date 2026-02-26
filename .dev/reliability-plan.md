# zwasm Reliability Improvement — Plan

> Updated: 2026-02-26
> Principles & branch strategy: `@./.claude/rules/reliability-work.md`
> Progress: `@./.dev/reliability-handover.md`

## Goal

Make zwasm **undeniably correct and fast** on Mac (aarch64) and Ubuntu (x86_64).
zwasm の理念: **仕様100%準拠、wasmtimeで動くものは全部動く、軽量なのにwasmtimeに匹敵する速さ。**

## Priority Order

| Priority | 意味 | 基準 |
|----------|------|------|
| **A** | 正確性 | spec/test/real-world が arm64+amd64 で完全動作 |
| **B** | 機能充足 | 未実装機能を実装（GC JIT等） |
| **C** | 性能 | wasmtime 1x目標、1.5x許容、例外的に2-3x許容（single-pass限界） |

## Completed Phases

| Phase | 内容 | Status |
|-------|------|--------|
| A-F | 環境/コンパイル/compat/E2E/ベンチ/解析 | ✅ |
| G | Ubuntu cross-platform | ✅ spec 62,158 (100%) |
| I | E2E 100% + FP correctness | ✅ 792/792 |
| J | x86_64 JIT bug fixes | ✅ |
| K.old | JIT opcode coverage, self-call, div-const | ✅ |

## Active: Plan A — 段階的リグレッション修正 + 機能実装

### Phase 1: rw_c_string hang 修正 (Priority A — 正確性)

**症状**: zwasm で rw_c_string がタイムアウト（60s）。wasmtime は 9.3ms。
**原因**: ee5f585 (OSR) で発生。22859e2 時点では 21ms で正常動作。
**方針**: OSR の back-edge 検出 or guard 関数判定の誤爆を調査。

検証:
- `./zig-out/bin/zwasm run test/realworld/wasm/c_string_processing.wasm` が正常完了すること
- `zig build test` pass, spec pass, 他ベンチにリグレッションなし
- **record**: `bash bench/record.sh --id=P1 --reason="Fix rw_c_string hang"`

### Phase 2: nbody FP キャッシュ修正 (Priority C — リグレッション)

**症状**: nbody 43.8ms (1.99x wasmtime)。be466a0 以前は 8-12ms (0.5x)。
**原因**: be466a0 "Fix JIT FP precision: getOrLoad must check dirty FP cache first"
  → 正確性修正は正しいが、実装が過剰にFPキャッシュを evict している。
**方針**: `rd==rs1` のときだけ退避する限定的修正に書き換え。正確性維持。
**目標**: 10-15ms (≤0.7x wasmtime) に戻す。

検証:
- nbody ≤ 15ms、spec pass、他ベンチにリグレッションなし
- **record**: `bash bench/record.sh --id=P2 --reason="Fix nbody FP cache regression"`

### Phase 3: rw_c_math 再計測 (Priority C)

**症状**: 16.4ms (1.86x wasmtime 8.8ms)。FP heavy。
**方針**: Phase 2 の nbody FP修正が波及して改善する可能性あり。まず再計測。
  改善不十分なら追加の FP キャッシュ最適化を検討。

検証:
- **record**: `bash bench/record.sh --id=P3 --reason="Re-measure after FP cache fix"`

### Phase 4: GC JIT 基本実装 (Priority B — 機能実装)

**症状**: gc_alloc 1.79x, gc_tree 4.40x。GC opcodes がインタプリタ fallback。
**方針**: struct.new, struct.get, struct.set, array.new, array.get, array.set を JIT 化。
  GC 方式（回収ロジック）は JIT codegen に影響しない——struct/array のメモリレイアウトに
  対する load/store を生成するだけ。
**目標**: gc_alloc ≤1.5x, gc_tree ≤2x。

検証:
- GC spec tests pass, unit tests pass
- **record**: `bash bench/record.sh --id=P4 --reason="GC JIT basic opcodes"`

### Phase 5: st_matrix — 許容判断 (Priority C — single-pass 限界)

**症状**: 296ms (3.23x wasmtime 92ms)。35 vreg、single-pass regalloc の本質的限界。
  cranelift は graph-coloring regalloc で最適 spill 位置を決定できる。
**判断**: 3.5x 以内を許容。改善余地があれば LRU eviction 等を試すが、
  1.5x 達成は現実的でない。
**公式例外**: Phase H Gate 条件 6 で st_matrix を例外扱い。

---

## Phase H Gate — Entry Criteria

**Phase H may NOT begin until ALL of the following are satisfied.**

| # | Condition | Verification |
|---|-----------|-------------|
| 1 | E2E: **778/778 (100%)** | Mac: e2e runner 0 failures |
| 2 | Real-world Mac: **all PASS** | `bash test/realworld/run_compat.sh` exits 0 |
| 3 | Real-world Ubuntu: **all PASS with JIT** | SSH same |
| 4 | Spec Mac: **62,158/62,158** | `python3 test/spec/run_spec.py --build --summary` |
| 5 | Spec Ubuntu: **62,158/62,158** | SSH same |
| 6 | Benchmarks Mac: **≤1.5x wasmtime** | `bash bench/compare_runtimes.sh` |
|   | 例外: st_matrix ≤3.5x (single-pass regalloc 限界) | |
| 7 | Benchmarks Ubuntu: **≤1.5x wasmtime** (同例外) | SSH same |
| 8 | Unit tests: **Mac + Ubuntu PASS** | `zig build test` |
| 9 | Benchmark regression: **none vs history.yaml** | `bash bench/run_bench.sh` |

---

## Phase H: Documentation Accuracy (LAST)

Phase H Gate 通過後。README claims audit, benchmark table update.
