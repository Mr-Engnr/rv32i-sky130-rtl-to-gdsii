#!/bin/sh
# Runs INSIDE the openlane2 container (has iverilog/vvp, no sed). Mounted at /v.
cd /v
run() { # name, extra-flags, files...
  n=$1; f=$2; shift 2
  nice -n 19 iverilog -g2012 $f -o work/$n.vvp tb.sv "$@" 2>work/$n.cerr || { echo "$n: COMPILE FAILED"; return; }
  nice -n 19 vvp work/$n.vvp > results/$n.out
}
run orig_as_written "" $(ls /rtl_orig/*.sv | grep -v '/alu_control.sv$')   # expected to fail: duplicate decl
run orig_fix        "" work/orig_fix/*.sv
run orig_race_fixed "" work/orig_fix2/*.sv
run src             "-DSRC" /src/*.sv
[ -d /src_x0 ] && run src_x0 "-DSRC" /src_x0/*.sv
exit 0
