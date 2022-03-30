Get *hw_bb_locked.dcp* and **iprepo/** from a Vitis project, and copy them here.

One way to achieve that is creating a Vitis application project (e.g., vecadd) with **xilinx_vck5000_gen3x16_xdma_1_202120_1** as the target platform, then set the build target to *Hardware*, and start the build process. The build can be aborted when reaching the step **Run vpl: Step create_bd**. The specified file and folder can be found at

<app_name>_hw_link/Hardware/binary_container_1.build/link/vivado/vpl/.local/hw_platform
