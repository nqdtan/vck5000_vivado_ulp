add_files -fileset utils_1 -norecurse pre_init.tcl
add_files -fileset utils_1 -norecurse post_init.tcl
add_files -fileset utils_1 -norecurse pre_opt.tcl
add_files -fileset utils_1 -norecurse post_opt.tcl
add_files -fileset utils_1 -norecurse pre_place.tcl
add_files -fileset utils_1 -norecurse post_place.tcl
add_files -fileset utils_1 -norecurse post_route.tcl
add_files -fileset utils_1 -norecurse pre_write_device_image.tcl
add_files -fileset utils_1 -norecurse post_write_device_image.tcl

set_property -name STEPS.INIT_DESIGN.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_init.tcl] -objects [get_runs impl_1]
set_property -name STEPS.INIT_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_init.tcl] -objects [get_runs impl_1]
set_property -name STEPS.OPT_DESIGN.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_opt.tcl] -objects [get_runs impl_1]
set_property -name STEPS.OPT_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_opt.tcl] -objects [get_runs impl_1]
set_property -name STEPS.PLACE_DESIGN.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_place.tcl] -objects [get_runs impl_1]
set_property -name STEPS.PLACE_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_place.tcl] -objects [get_runs impl_1]
set_property -name STEPS.ROUTE_DESIGN.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_route.tcl] -objects [get_runs impl_1]
set_property -name STEPS.WRITE_DEVICE_IMAGE.TCL.PRE -value [get_files -of_object [get_filesets utils_1] pre_write_device_image.tcl] -objects [get_runs impl_1]
set_property -name STEPS.WRITE_DEVICE_IMAGE.TCL.POST -value [get_files -of_object [get_filesets utils_1] post_write_device_image.tcl] -objects [get_runs impl_1]
