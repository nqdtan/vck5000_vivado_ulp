
XILINX_XRT=/opt/xilinx/xrt
XAIE_INC=/home/bwrc/embeddedsw/XilinxProcessorIPLib/drivers/aienginev2/include
XAIE_LIB=/home/bwrc/embeddedsw/XilinxProcessorIPLib/drivers/aienginev2/src

APP=app.exe

.PHONY: run

$(APP): host.cpp common.cpp common.h
	g++ -Wall -g -std=c++14 common.cpp host.cpp -o $(APP) -I. -I$(XILINX_XRT)/include/ -I$(XAIE_INC) -L$(XILINX_XRT)/lib/ -L$(XAIE_LIB) -lOpenCL -lpthread -lrt -lstdc++ -lxrt_coreutil -lxaiengine

.PHONY: compile
compile: $(APP)

run: $(APP)
	./$(APP)

.PHONY: clean
clean:
	rm -f *.exe
