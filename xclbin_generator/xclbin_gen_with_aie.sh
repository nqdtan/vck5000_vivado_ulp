#!/bin/bash

rm -f boot.bin
bootgen -arch versal -image boot_image.bif -w -o boot.bin

xclbinutil --add-section BITSTREAM_PARTIAL_PDI:raw:boot.bin --force --target hw --key-value SYS:dfx_enable:true --add-section :JSON:kernel_data_mover_mm2mm.json --append-section :JSON:appendSection.json --add-section CLOCK_FREQ_TOPOLOGY:JSON:clock_freq_topology.json --add-section EMBEDDED_METADATA:RAW:embedded_metadata_data_mover_mm2mm.xml --key-value SYS:PlatformVBNV:xilinx_vck5000_gen3x16_xdma_1_202120_1 --output ulp.xclbin

xclbinutil --quiet --force --info ulp.xclbin.info --input ulp.xclbin
