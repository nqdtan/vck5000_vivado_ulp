#!/bin/bash

rm -f ulp.xclbin
xclbinutil --add-section BITSTREAM_PARTIAL_PDI:raw:level0_i_ulp_my_rm_partial.pdi --force --target hw --key-value SYS:dfx_enable:true --add-section :JSON:kernel_vecadd.json --append-section :JSON:appendSection.json --add-section CLOCK_FREQ_TOPOLOGY:JSON:clock_freq_topology.json --add-section EMBEDDED_METADATA:RAW:embedded_metadata_vecadd.xml --key-value SYS:PlatformVBNV:xilinx_vck5000_gen3x16_xdma_1_202120_1 --output ulp.xclbin

xclbinutil --quiet --force --info ulp.xclbin.info --input ulp.xclbin
