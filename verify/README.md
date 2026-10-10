# RTL verification: rtl_orig vs src

Compares the original RV32I RTL with the synthesizable copy in `../src` by simulating the
same program (hardcoded in the instruction ROM) with Icarus Verilog 12, taken from the
OpenLane container, so nothing is installed on the host.

## Rerun
    verify/run_sim.sh        # needs docker + ghcr.io/efabless/openlane2:2.3.10
Takes seconds (1 CPU, nice 19). It prepares scratch variants in `verify/work/`, simulates,
writes `verify/results/*.out`, then runs `verify/compare.sh`. `rtl_orig/` and `src/` are
mounted read-only. If `../src_x0/` exists it is simulated too.

## Files
- `tb.sv` – original `tb/Wrapper_tb.sv` stimulus (780 ns), plus: `-DSRC` connects the new
  `pc_out` port by name; prints `PC` every posedge; at the end dumps all 32 registers
  (`REG[i]`) and 64 data-memory words (`MEM[i]`) via hierarchical refs, then `$finish`.
- `prepare.sh` – builds the original-RTL variants (see below).
- `sim_inner.sh` – runs inside the container. `compare.sh` – diffs PC trace + REG/MEM dumps.
- `results/` – simulation outputs and saved diffs.

## Variants
| name | what |
|---|---|
| `orig_as_written` | `rtl_orig` unchanged: does NOT compile in Icarus (`mem_write` declared twice in `Wrapper.sv`); expected "COMPILE FAILED" |
| `orig_fix` | original minus `alu_control.sv`, duplicate `logic mem_write;` (line 72) removed |
| `orig_race_fixed` | `orig_fix` + `control_unit.sv` `always @(inst)` -> `always @*` |
| `src` | the hardened copy used by the OpenLane runs |
| `src_x0` | `src` with x0 hardwired to zero (`../src_x0`, separate directory, not used by any flow run) |

## Results (current)
- `orig_race_fixed` == `src` == `src_x0`: identical PC trace, registers and data memory.
- `orig_fix` != `src`: original `control_unit` reads `opcode` (a continuous assign) from an
  `always @(inst)` block, so it decodes the previous instruction (control lags by one);
  the simulated original ends with mostly-zero state. Expected final state (src):
  x7=0x7b (25+12+48+7+31), x28=x29=5, mem[0,4,8,12,16]=25,12,48,7,31.
