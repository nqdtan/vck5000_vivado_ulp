#!/bin/bash

export XILINX_XRT=/opt/xilinx/xrt
export XAIENGINEV2=/home/nqdtan/embeddedsw/XilinxProcessorIPLib/drivers/aienginev2
export XILINX_VITIS=/home/nqdtan/Xilinx/Vitis/2022.2

export AIETOOLS=${XILINX_VITIS}/aietools
source ${XILINX_VITIS}/settings64.sh
export LD_LIBRARY_PATH=${XILINX_XRT}/lib:${XAIENGINEV2}/src:$LD_LIBRARY_PATH
