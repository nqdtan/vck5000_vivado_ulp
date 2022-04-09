#!/bin/bash

# Ref: https://github.com/Xilinx/mlir-aie/blob/main/tools/chess-clang/xchesscc_wrapper

XILINX_VITIS := /home/bwrc/Xilinx/Vitis/2021.2
AIETOOLS := $(XILINX_VITIS)/aietools

export RDI_DATADIR := $(AIETOOLS)/data
export LD_LIBRARY_PATH := $(AIETOOLS)/lib/lnx64.o:$(LD_LIBRARY_PATH)
# Carefully crafted path so that we can inject other scripts into the chess path, namely chess-clang
export PATH := $(AIETOOLS)/bin/unwrapped/lnx64.o:$(AIETOOLS)/tps/lnx64/target/bin/LNa64bin:$(PATH)

BCF := core.bcf
SRC := core.cc

compile: $(SRC)
	xchesscc +P 4 -p me -C Release_LLVM -P $(AIETOOLS)/data/cervino/lib -d -f $(SRC) +l $(BCF) -o core.out

clean:
	rm -f core.o*

