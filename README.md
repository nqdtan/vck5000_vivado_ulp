# vck5000_vivado_custom_ulp_design
An alternative Vivado custom design example (to fully Vitis) for the User Logic Partition targeting VCK5000

## Description

This repository shows two example designs, one is PL-only (vecadd) and the other involves AIE (add-one) plus PL (data mover and BRAM controller) targeting VCK5000 Versal card. For these PCIe-based cards, a Xilinx base platform (blp) is typically provided as a static design to handle system management (e.g., clock scaling, data transfer between host and device over PCIe), and users launch Vitis to design a (Partial) Reconfigurable user partition logic (ulp) that conforms with the interface present in the base platform.

To facilitate some customizability, the examples shown here can be built with Vivado only (along with some utility scripts from Vitis to emit necessary metadata and bitstream files to ensure the card operates correctly). Most of the toolchain scripts and constraint files in this repo are extracted from the Vitis flow with some modification. Note that this is not a fully-automated flow that would work out-of-the-box for any kernels (though doable with more scripting effort), and one might be able to achieve the same customizability in Vitis if using the TCL hooks effectively. This is intended for someone who would like to mainly work with Vivado hardware development flow. Similar to Vitis, the final output is an xclbin file combining a partial FPGA bitstream for configuring the ulp of the target device, and some metadata required by XRT drivers such as operating user kernel clock or AXI4-Lite MMIO register adddresses.

## Development Environment

**Base platform**: xilinx_vck5000_gen4x8_qdma_2_202220_1

**Vitis**: 2022.2

**XRT**: 2.14.384 (2022.2)

**Linux kernel**: 5.4.0-42-generic

## General setup
1. Build the following custom libxaiengine (required if you would like to build and run the PL + AIE example). It should be built on a machine that hosts a VCK5000 card.

```
git clone -b aiev2_custom https://github.com/nqdtan/embeddedsw.git
cd embeddedsw/XilinxProcessorIPLib/drivers/aienginev2/src
make -f Makefile.Linux
```

2. Please make sure to change the paths to the software tools in *settings.sh* according to your environment setup. Then do

```
source settings.sh
```

3. Follow the instruction in [utils/README.md](https://github.com/nqdtan/vck5000_vivado_custom_ulp_design/tree/main/utils) to get the extra files needed to build the designs.

## [PL-only example]

### About

This simple example demonstrates how to configure a PL kernel (vecadd) to perform computation on host-allocated buffers.

### Build steps

```
  cd src/hls
  # Generate HLS RTL for vecadd kernel
  vitis_hls run_hls vecadd
  cd ../../
  # Pack vecadd RTL as IP so that it can be imported to a Vivado Block Design
  make kernel_pack top=vecadd
  
  # Build Vivado Block Design with vecadd HLS IP + some necessary logic
  # for ulp (adhere to the interface provided by the blp)
  # Upon completion, you can open the project (myproject_vecadd) to inspect
  # the Block design
  make ulp_bd top=vecadd
  
  # Build Vivado Reconfigurable Module Project (PR flow). This flow will synthesize,
  # P&R the ulp and link it with the static blp (xilinx_vck5000_gen4x8_qdma_2_202220_1_bb_locked.dcp)
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
cp xcl_generator/ulp.xclbin host_sw/
cd host_sw
make compile
make run
```

## [PL + AIE example]

### About

Please make sure libxaie is built before compiling and running the host code. We use the XAie API from libxaie (v2) to configure the AIE array. Unlike the ARM-based platform (e.g., VCK190), the AIE address space is not visible to the x86 host. Therefore, we use a PL module (data_mover_mm2mm) as a master to configure the AIE over the NoC. The XAie exposes the configuration data (such as tile address and value) to the host via the [(custom) IO DEBUG backend](https://github.com/nqdtan/embeddedsw/blob/aiev2_custom/XilinxProcessorIPLib/drivers/aienginev2/src/io_backend/ext/xaie_debug.c); the host then programs the PL data mover to send the configuration data to AIE using AXI Memory-mapped transactions.

In this example, an array is initialized in the host program and transferred to the PL BRAM. The data is then copied to the Data Memory of AIE Tile (18, 1) using ShimDMA of the AIE NOC interface Tile (18, 0). The core updates the values of the array (adds one) before sending it back to the PL BRAM and eventually to host. In this design, the AIE uses the Shim NOC to communicate with the PL through AXIMM, no PLIO resource is used and you could test with different [AIE NOC interface tiles](https://docs.xilinx.com/r/en-US/am009-versal-ai-engine/AI-Engine-Array-Interface-Architecture) as well.

This simple example demonstrates how to configure the AIE (Tile core, Tile DMA, Shim DMA, Stream switches, etc.) in user space to move data between AIE, PL, and x86 host.

### Build steps

```
  cd src/hls
  # Generate HLS RTL for data_mover_mm2mm kernel
  vitis_hls run_hls data_mover_mm2mm
  cd ../../
  # Pack data_mover_mm2mm RTL as IP so that it can be imported to a Vivado Block Design
  make kernel_pack top=data_mover_mm2mm
  
  # Build Vivado Block Design with data_mover_mm2mm HLS IP + some necessary logic
  # for ulp (adhere to the interface provided by the blp)
  # Upon completion, you can open the project (myproject_data_mover_mm2mm) to inspect
  # the Block design
  make ulp_bd top=data_mover_mm2mm aie=1
  
  # Build Vivado Reconfigurable Module Project (PR flow). This flow will synthesize,
  # P&R the ulp and link it with the static blp (xilinx_vck5000_gen4x8_qdma_2_202220_1_bb_locked.dcp)
  make rm_project top=data_mover_mm2mm
```

After the Vivado project build completes, a platform device image will be generated (PDI). We can then generate an xclbin file to program the card, but before that, we need some CDO (configuration data object) binary files for configuring the AIE. The CDO files will also be packaged in the final xclbin file so that the firmware controller can properly initialize the AIE array.

```
  cd aie_cdo
  make run
  
  cd ../xclbin_generator
  cp ../<project_rm_data_mover_mm2mm_*>/<project_rm_data_mover_mm2mm_*>.runs/impl_1/level0_i_ulp_my_rm_partial.pdi .
  
  # The script will embed the metadata, such as kernel name, operating kernel clock,
  # AXI4-Lite MM register offsets, etc. along with the PDI and aie_cdo bin files to emit ulp.xclbin.
  # The metadata is required and queried by the XRT drivers (xclmgmt, xocl) running on the host.
  # Take a look at boot_image.bif to see which aie_cdo bin files are included.
  ./xclbin_gen_with_aie.sh
```

### Host Execution

```
cp xcl_generator/ulp.xclbin host_sw_with_aie/
cd host_sw_with_aie
make compile
make run
```
