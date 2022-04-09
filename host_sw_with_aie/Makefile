
APP=app.exe

.PHONY: run

$(APP): host.cpp common.cpp common.h
	g++ -Wall -g -std=c++14 common.cpp host.cpp -o $(APP) -I. -I$(XILINX_XRT)/include/ -I$(XAIENGINEV2)/include -L$(XILINX_XRT)/lib/ -L$(XAIENGINEV2)/src -lOpenCL -lpthread -lrt -lstdc++ -lxrt_coreutil -lxaiengine

.PHONY: compile
compile: $(APP)

run: $(APP)
	./$(APP)

.PHONY: clean
clean:
	rm -f *.exe
