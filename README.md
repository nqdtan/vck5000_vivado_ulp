# vck5000_vivado_custom_ulp_design
An alternative Vivado custom design example (to fully Vitis) for the User Logic Partition targeting VCK5000

## Description

This repository shows two example designs, one is PL-only (vecadd) and the other involves AIE (add-one) plus PL (BRAM controller) targeting VCK5000 Versal card. For these PCIe-based cards, a Xilinx base platform (blp) is provided as a static design to handle system management (e.g., clock scaling, data transfer between host and device), and users launch Vitis to design a (Partial) Reconfigurable user partition logic (ulp) that conforms with the interface present in base platform. The final output is a bitstream file which configures the ulp of the target device.

To facilitate some customizability, the examples shown here can be built using Vivado only (along with some utility scripts from Vitis to emit necessary metadata and bitstream files to ensure the card operates correctly). The toolchain scripts and constraint files are extracted from the Vitis flow, by and large. Note that this is not a fully-automated flow that would work out-of-the-box for any kernels (though doable with more scripting effort), and one might be able to achieve the same customizability in Vitis if using the TCL hooks effectively. This is intended for someone who would like to mainly work with Vivado hardware development flow.

## Development Environment

**Base platform**: xilinx_vck5000_gen3x16_xdma_1_202120_1

**Vitis**: 2021.2

**XRT**: 2.12.447 (2021.2)

**Linux kernel**: 5.4.0-42-generic

## [PL-only example]

### Build steps

First, please follow the instruction in [utils/README.md](https://github.com/nqdtan/vck5000_vivado_custom_ulp_design/tree/main/utils) to get the files needed to build the project. Then, please do

```
  cd src/hls
  # Generate HLS RTL for vecadd kernel
  vitis_hls run_hls vecadd
  cd ../../
  # Pack vecadd RTL as IP so that it can be imported to a Vivado Block Design
  make kernel_pack top=vecadd
  
  # Build Vivado Block Design with vecadd HLS IP + some necessary logic
  # for ulp (adhere to the interface provided by the blp)
  make ulp_bd top=vecadd
  
  # Build Vivado Reconfigurable Module Project (PR flow). This flow will synthesize,
  # P&R the ulp and link it with the static blp (hw_bb_locked.dcp)
  make rm_project top=vecadd
```

After the Vivado project build completes, a platform device image will be generated (PDI). We can then generate an xclbin file to program the card

```
  cd xclbin_generator
  cp ../<project_rm_vecadd_*>/<project_rm_vecadd_*>.runs/impl_1/level0_i_ulp_my_rm_partial.pdi .
  
  # The script will embed the metadata, such as kernel name, operating kernel clock,
  # AXI4-Lite MM register offsets, etc. along with the PDI to emit ulp.xclbin.
  # The metadata is required and queried by the XRT drivers (xclmgmt, xocl) running on the host.
  ./xclbin_gen.sh
```

### Host Execution

```
cd host_sw
cp ../xcl_bin/ulp.xclbin .
make compile
make run
```

## [PL + AIE example]

### Build steps

First, please follow the instruction in [utils/README.md](https://github.com/nqdtan/vck5000_vivado_custom_ulp_design/tree/main/utils) to get the files needed to build the project. Then, please do

```
  cd src/hls
  # Generate HLS RTL for data_mover_mm2mm kernel
  vitis_hls run_hls data_mover_mm2mm
  cd ../../
  # Pack data_mover_mm2mm RTL as IP so that it can be imported to a Vivado Block Design
  make kernel_pack top=data_mover_mm2mm
  
  # Build Vivado Block Design with vecadd HLS IP + some necessary logic
  # for ulp (adhere to the interface provided by the blp)
  make ulp_bd top=data_mover_mm2mm aie=1
  
  # Build Vivado Reconfigurable Module Project (PR flow). This flow will synthesize,
  # P&R the ulp and link it with the static blp (hw_bb_locked.dcp)
  make rm_project top=data_mover_mm2mm
```

After the Vivado project build completes, a platform device image will be generated (PDI). We can then generate an xclbin file to program the card, but before that, we will need to generate some CDO (configuration data object) binary files for the AIE. The CDO files will also be packaged in the final xclbin file so that the firmware controller can properly initialize the AIE array.

(Please make sure to change the paths to the software tools in these make files according to your environment setup.)

```
  cd aie_cdo
  make run
  
  cd ../xclbin_generator
  cp ../<project_rm_vecadd_*>/<project_rm_vecadd_*>.runs/impl_1/level0_i_ulp_my_rm_partial.pdi .
  
  # The script will embed the metadata, such as kernel name, operating kernel clock,
  # AXI4-Lite MM register offsets, etc. along with the PDI and aie_cdo bin files to emit ulp.xclbin.
  # The metadata is required and queried by the XRT drivers (xclmgmt, xocl) running on the host.
  # Take a look at boot_image.bif to see which aie_cdo bin files are included.
  ./xclbin_gen_with_aie.sh
```


### Host Execution

```
cd host_sw_with_aie
cp ../xcl_bin/ulp.xclbin .
make compile
make run
```
