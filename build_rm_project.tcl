set project_name [lindex $argv 0]
set kernel [lindex $argv 1]

create_project -force $project_name $project_name -part xcvc1902-vsvd1760-2MP-e-S
set_property board_part xilinx.com:vck5000:part0:1.0 [current_project]

set_property design_mode GateLvl [current_fileset]
set_property PR_FLOW 1 [current_project]
import_files -norecurse utils/hw_bb_locked.dcp
create_partition_def -name my_pd -module ulp
create_reconfig_module -name my_rm -partition_def [get_partition_defs my_pd ] -top ulp

set_property use_blackbox_stub false [get_filesets my_rm -of_objects [get_reconfig_modules my_rm]]
set_property USE_BLACKBOX_STUB 0 [get_partition_defs my_pd]
create_pr_configuration -name config_1 -partitions [list level0_i/ulp:my_rm]

set_property board_part xilinx.com:vck5000:part0:1.0 [current_project]

source setup_ip_repos.tcl

import_files -norecurse myproj_${kernel}/project_1.srcs/sources_1/bd/ulp/ulp.bd -of_objects my_rm

open_bd_design $project_name/$project_name.srcs/my_rm/bd/ulp/ulp.bd

add_files -fileset constrs_1 -norecurse constrs/impl.xdc
import_files -fileset constrs_1 constrs/impl.xdc
set_property used_in_synthesis false [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/impl.xdc]
set_property used_in_implementation false [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/impl.xdc]
set_property used_in_implementation true [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/impl.xdc]
validate_bd_design -force


generate_target all [get_files ulp.bd]

add_files -fileset constrs_1 -norecurse constrs/ulp_ooc_copy.xdc
import_files -fileset constrs_1 constrs/ulp_ooc_copy.xdc
set_property PROCESSING_ORDER EARLY [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/ulp_ooc_copy.xdc]
set_property USED_IN {synthesis implementation out_of_context} [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/ulp_ooc_copy.xdc]
move_files [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/ulp_ooc_copy.xdc] -of_objects [get_reconfig_modules my_rm] -quiet

set_property processing_order late [get_files $project_name/$project_name.srcs/constrs_1/imports/constrs/ulp_ooc_copy.xdc]

read_xdc constrs/dont_partition.xdc

set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-directive sdx_optimization_effort_high} -objects [get_runs my_rm_synth_1]

add_files -fileset utils_1 -norecurse tcl_hooks/pre_init.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/post_init.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/pre_opt.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/post_opt.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/pre_place.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/post_place.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/post_route.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/pre_write_device_image.tcl
add_files -fileset utils_1 -norecurse tcl_hooks/post_write_device_image.tcl

set_property -name STEPS.INIT_DESIGN.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_init.tcl] -objects [get_runs impl_1]
set_property -name STEPS.INIT_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_init.tcl] -objects [get_runs impl_1]
set_property -name STEPS.OPT_DESIGN.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_opt.tcl] -objects [get_runs impl_1]
set_property -name STEPS.OPT_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_opt.tcl] -objects [get_runs impl_1]
set_property -name STEPS.PLACE_DESIGN.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_place.tcl] -objects [get_runs impl_1]
set_property -name STEPS.PLACE_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_place.tcl] -objects [get_runs impl_1]
set_property -name STEPS.ROUTE_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_route.tcl] -objects [get_runs impl_1]
set_property -name STEPS.WRITE_DEVICE_IMAGE.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_write_device_image.tcl] -objects [get_runs impl_1]
set_property -name STEPS.WRITE_DEVICE_IMAGE.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_write_device_image.tcl] -objects [get_runs impl_1]

set_property GEN_FULL_BITSTREAM 0 [get_runs impl_1]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]

launch_runs my_rm_synth_1 -jobs 1
wait_on_run my_rm_synth_1 -verbose

link_design

read_xdc constrs/_user_impl_clk.xdc

launch_runs impl_1 -to_step write_bitstream -jobs 1
wait_on_run impl_1 -verbose