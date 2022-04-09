set hls_func [lindex $argv 0]

open_project proj
set_top ${hls_func}

add_files ${hls_func}.cpp

open_solution -reset "solution_${hls_func}"

set_part {xcvc1902-vsvd1760-2MP-e-S}

create_clock -period "500MHz"

#config_compile -pipeline_loops 1

#csim_design
csynth_design
#cosim_design -trace_level none -rtl verilog -tool xsim
#export_design -flow impl
#export_design -format ip_catalog
exit
