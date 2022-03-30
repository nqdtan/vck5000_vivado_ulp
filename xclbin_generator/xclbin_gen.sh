#!/bin/bash

xclbinutil --add-section BITSTREAM_PARTIAL_PDI:raw:level0_i_ulp_my_rm_partial.pdi --force --target hw --key-value SYS:dfx_enable:true --add-section :JSON:kernel.json --append-section :JSON:appendSection.json --add-section CLOCK_FREQ_TOPOLOGY:JSON:clock_freq_topology.json --add-section EMBEDDED_METADATA:RAW:embedded_metadata.xml --key-value SYS:PlatformVBNV:xilinx_vck5000_gen3x16_xdma_1_202120_1 --output fpga.xclbin

xclbinutil --quiet --force --info fpga.xclbin.info --input fpga.xclbin
