# vck5000_vivado_custom_ulp_design
An alternative Vivado custom design example (to fully Vitis) for the User Logic Partition targeting VCK5000

## Description

This repository shows two example designs, one is PL-only (vecadd) and the other involves AIE (add-one) plus PL (BRAM controller) targeting VCK5000 Versal card. For these PCIe-based cards, a Xilinx base platform is provided that handles system management, and users are expected to use Vitis to design a user partition logic that conforms with the provided base platform.

To facilitate some customizability, the examples shown here can be built using Vivado only (along with other utility scripts from Vitis to generate necessary metadata and bitstream files to ensure the card operates correctly). The toolchain scripts and constraint files are extracted from the Vitis flow. Note that this is not a fully-automated flow that would work out-of-the-box for any kernels (though doable with more scripting effort), and one might be able to achieve the same customizability in Vitis if using the TCL hooks effectively. This is meant for someone who is more familiar with Vivado hardware development flow.

## Development Environment

**Base platform**: xilinx_vck5000_gen3x16_xdma_1_202120_1

**Vitis**: 2021.2

**XRT**: 2.12.447 (2012.2)

**Linux kernel**: 5.4.0-42-generic

## [PL-only example] Build steps

```
  cd src/hls
  vitis_hls run_hls vecadd
  cd ../../
  make kernel_pack top=vecadd
  make ulp_bd top=vecadd
  make rm_project top=vecadd
```

After the Vivado project finish and a platform device image is generated (PDI), we can generate a xclbin file that can be downloaded to the card
```
  cd xclbin_generator
  cp ../<project_dir>/<project_dir>.runs/*.pdi .
  ./xclbin_gen.sh
```

## [PL + AIE example] Build steps

```
  cd src/hls
  vitis_hls run_hls data_mover_mm2mm
  cd ../../
  make kernel_pack top=data_mover_mm2mm
  make ulp_bd top=data_mover_mm2mm aie=1
  make rm_project top=data_mover_mm2mm
```

After the Vivado project finish and a platform device image is generated (PDI), we can generate a xclbin file that can be downloaded to the card
```
  cd xclbin_generator
  cp ../<project_dir>/<project_dir>.runs/*.pdi .
  ./xclbin_gen_with_aie.sh
```

