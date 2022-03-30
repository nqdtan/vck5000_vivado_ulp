
XILINX_XRT=/opt/xilinx/xrt

APP=app.exe

.PHONY: run

$(APP): host.cpp fpga.xclbin
	g++ -Wall -g -std=c++14 host.cpp -o $(APP) -I$(XILINX_XRT)/include/ -L$(XILINX_XRT)/lib/ -lOpenCL -lpthread -lrt -lstdc++ -lxrt_coreutil

.PHONY: compile
compile: $(APP)

run: $(APP)
	./$(APP)

.PHONY: clean
clean:
	rm -f *.exe
