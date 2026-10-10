#!/bin/bash
# Builds scratch RTL variants under verify/work/ (never touches rtl_orig or src).
#   orig_fix  : rtl_orig minus alu_control.sv (the latch version), with the duplicate
#               'logic mem_write;' (Wrapper.sv line 72) removed so Icarus can compile it.
#   orig_fix2 : orig_fix + control_unit sensitivity list '@(inst)' -> '@*' (fixes the race).
#   src_x0    : copy of src with register x0 hardwired to zero (only if src_x0/ exists).
set -e
cd "$(dirname "$0")/.."
rm -rf verify/work && mkdir -p verify/work
cp -r rtl_orig verify/work/orig_fix && rm verify/work/orig_fix/alu_control.sv
sed -i '72s/.*/\/\/ duplicate mem_write declaration removed for simulation/' verify/work/orig_fix/Wrapper.sv
cp -r verify/work/orig_fix verify/work/orig_fix2
sed -i 's/^always @(inst)$/always @*/' verify/work/orig_fix2/control_unit.sv
