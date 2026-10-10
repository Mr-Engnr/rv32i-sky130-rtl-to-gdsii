#!/bin/bash
# Compares PC trace + final register file + data memory between result files.
cd "$(dirname "$0")/results"
cmp_pair() { if diff -q "$1.out" "$2.out" >/dev/null; then echo "MATCH     $1 vs $2 (PC trace, 32 regs, 64 dmem words)";
  else echo "DIFFERENT $1 vs $2:"; diff "$1.out" "$2.out" | grep -E '^[<>] (REG|MEM)' | head -20; fi; }
[ -f orig_race_fixed.out ] && [ -f src.out ]    && cmp_pair orig_race_fixed src
[ -f orig_fix.out ]        && [ -f src.out ]    && cmp_pair orig_fix src
[ -f src_x0.out ]          && [ -f src.out ]    && cmp_pair src_x0 src
[ -f src_x0.out ] && [ -f orig_race_fixed.out ] && cmp_pair src_x0 orig_race_fixed
