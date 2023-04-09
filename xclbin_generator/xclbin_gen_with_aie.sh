#!/bin/bash

rm -f boot.bin ulp.xclbin
bootgen -arch versal -image boot_image.bif -w -o boot.bin

xclbinutil --add-section BITSTREAM_PARTIAL_PDI:raw:boot.bin --force --target hw --key-value SYS:dfx_enable:true --add-section IP_LAYOUT:JSON:ip_layout_data_mover_mm2mm.json --add-section MEM_TOPOLOGY:JSON:mem_topology.json --add-section PARTITION_METADATA:JSON:partition_metadata.json --add-section CLOCK_FREQ_TOPOLOGY:JSON:clock_freq_topology.json --add-section EMBEDDED_METADATA:RAW:embedded_metadata_data_mover_mm2mm.xml --key-value SYS:PlatformVBNV:xilinx_vck5000_gen4x8_qdma_2_202220_1 --output ulp.xclbin

xclbinutil --quiet --force --info ulp.xclbin.info --input ulp.xclbin
