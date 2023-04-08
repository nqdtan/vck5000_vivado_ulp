Get *xilinx_vck5000_gen4x8_qdma_2_202220_1_bb_locked.dcp* file and *iprepo* directory from a Vitis project, and copy them here.

To do so, you can run the following Vitis command

```
v++ -l --platform xilinx_vck5000_gen4x8_qdma_2_202220_1
```

This will launch a Vitis run in link mode without a design source. It extracts the hardware platform from the xsa file of the specified target platform *xilinx_vck5000_gen4x8_qdma_2_202220_1*.  Abort the run before the vpl step (**"Run vpl: Step create_project: Started"**). Then you can find the required file and folder at

_x/link/vivado/vpl/.local/hw_platform

*xilinx_vck5000_gen4x8_qdma_2_202220_1_bb_locked.dcp* is the Design Checkpoint of the base platform static design (blp). *iprepo* contains the IP files for some IPs that are used in the user partition design (ulp).
