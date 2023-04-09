#!/bin/bash

rm -f ulp.xclbin
xclbinutil --add-section BITSTREAM_PARTIAL_PDI:raw:top_i_ulp_my_rm_partial.pdi --force --target hw --key-value SYS:dfx_enable:true --add-section IP_LAYOUT:JSON:ip_layout_vecadd.json --add-section MEM_TOPOLOGY:JSON:mem_topology.json --add-section PARTITION_METADATA:JSON:partition_metadata.json --add-section CLOCK_FREQ_TOPOLOGY:JSON:clock_freq_topology.json --add-section EMBEDDED_METADATA:RAW:embedded_metadata_vecadd.xml --key-value SYS:PlatformVBNV:xilinx_vck5000_gen4x8_qdma_2_202220_1 --output ulp.xclbin

xclbinutil --quiet --force --info ulp.xclbin.info --input ulp.xclbin
