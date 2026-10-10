# Load the routed Wrapper design in OpenROAD, report timing and power (nom_tt_025C_1v80).
# Usage (inside the openlane2 container, which has openroad):
#   RUN=runs/<tag> PDK_ROOT=<volare sky130 version dir> openroad -exit report_routed.tcl
# Parasitics: routed SPEF from the flow (final/spef/nom) when present, else a placement estimate.
set run  $::env(RUN)
set pdk  $::env(PDK_ROOT)/sky130A

read_liberty $pdk/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_db      $run/final/odb/Wrapper.odb
read_sdc     $run/final/sdc/Wrapper.sdc

set spef $run/final/spef/nom/Wrapper.nom.spef
if {[file exists $spef]} {
    read_spef $spef
    puts "parasitics: routed SPEF $spef"
} else {
    set_wire_rc -signal -layer met2
    set_wire_rc -clock  -layer met5
    estimate_parasitics -placement
    puts "parasitics: placement estimate (no SPEF found)"
}

puts "===== report_checks (setup) ====="
report_checks -path_delay max -fields {slew cap fanout} -digits 3
puts "===== report_checks (hold) ====="
report_checks -path_delay min -digits 3
puts "===== report_power ====="
report_power
