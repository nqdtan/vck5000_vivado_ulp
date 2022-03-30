set xocc_optimize_level 0
set_property SEVERITY {Warning} [get_drc_checks HDPR-5]
set_param logicopt.enableBUFGinsertHFN 0

#Check if PMCPLIRQ still connect to GND (flat platform) and connect to gpio
set pmcplirq_pin [get_pins {level0_i/blp/cips/inst/PS9_inst/PMCPLIRQ[4]}]
if {[string first "GND" [get_nets -of $pmcplirq_pin]] != -1} {
  disconnect_net -objects $pmcplirq_pin
  connect_net -hierarchical -net [get_nets -of [get_pins level0_i/blp/force_reset_and_0/Res]] -objects $pmcplirq_pin
}
