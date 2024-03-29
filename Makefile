
ts=$(shell date +"%Y-%m-%d_%H-%M-%S")
project_name=project_rm_$(top)_$(ts)

SRC_DIR := src/hls/proj/solution_$(top)/syn/verilog
SRC := $(SRC_DIR)/*.v

KERNEL_XML := kernel_pack_$(top)/component.xml
ULP_BD := myproj_$(top)/project_1.srcs/sources_1/bd/ulp_inst_0/ulp_inst_0.bd
XPR := $(project_name)/$(project_name).xpr

jobs := 1
aie := 0
ifeq ($(aie),1)
  BD_TCL := ulp_bd_with_aie_16.tcl
else
  BD_TCL := ulp_bd.tcl
endif

$(XPR): $(ULP_BD)
	vivado -mode batch -source build_rm_project.tcl -tclargs $(project_name) $(top) $(jobs) > log_rm_$(top)_$(ts)

$(ULP_BD): $(KERNEL_XML)
	vivado -mode batch -source $(BD_TCL) -tclargs $(top)

$(KERNEL_XML): $(SRC)
	vivado -mode batch -source package_kernel_$(top).tcl -tclargs $(top) $(SRC_DIR)

kernel_pack: $(KERNEL_XML)
ulp_bd: $(ULP_BD)
rm_project: $(XPR)

clean:
	rm -f log_rm_* *.log *.jou

cleanall:
	rm -rf log_rm_* *.log *.jou kernel_pack* myproj* project_rm*
