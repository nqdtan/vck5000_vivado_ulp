#!/bin/bash

g++ -Wall -g -std=c++14 host.cpp -o app.exe -I${XILINX_XRT}/include/ -L${XILINX_XRT}/lib/ -lOpenCL -lpthread -lrt -lstdc++ -lxrt_coreutil
