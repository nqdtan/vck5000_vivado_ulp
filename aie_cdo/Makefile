INC_DIRS := -I $(XILINX_VIVADO)/include
INC_DIRS += -I $(AIETOOLS)/include
INC_DIRS += -I $(AIETOOLS)/include/adf
INC_DIRS += -I $(AIETOOLS)/tps/lnx64/gcc/include/c++/6.2.0
INC_DIRS += -I $(AIETOOLS)/tps/lnx64/gcc/include/c++/6.2.0/backward
INC_DIRS += -I $(AIETOOLS)/tps/lnx64/gcc/include/c++/6.2.0/x86_64-pc-linux-gnu
INC_DIRS += -I $(AIETOOLS)/include/common_cpp/common_cpp_v1_0/include
INC_DIRS += -I $(AIETOOLS)/include/drivers/aiengine

LIBS += $(AIETOOLS)/lib/lnx64.o
CXX=$(AIETOOLS)/tps/lnx64/gcc/bin/g++

export LD_LIBRARY_PATH := $(LIBS):$(LD_LIBRARY_PATH)

cdo_generator.o: cdo_generator.cpp
	$(CXX) -fPIC -c -std=c++14 $(INC_DIRS) -Wno-deprecated-declarations -D__AIESIM__ -D__CDO__ -D__PS_INIT_AIE__ -Og -flto  -o cdo_generator.o cdo_generator.cpp

cdo_generator.exe: cdo_generator.o
	$(CXX) -o cdo_generator.exe cdo_generator.o -Wl,--allow-shlib-undefined -L $(LIBS) -lcdo_driver -lxioutils -lxaiengine -ladf_api -Wl,-R$(AIETOOLS)/tps/lnx64/gcc/lib64

compile: cdo_generator.exe
run: cdo_generator.exe
	./cdo_generator.exe

clean:
	rm -f *.bin *.o *.exe
