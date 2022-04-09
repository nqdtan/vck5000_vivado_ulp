
#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <string>
#include <sys/time.h>
#include "experimental/xrt_kernel.h"
#include "experimental/xrt_ip.h"
#include "experimental/xrt_uuid.h"

#define DEVICE_ID 0
#define VEC_LEN 1024

typedef int64_t DATATYPE;

unsigned long diff(const struct timeval *newTime, const struct timeval *oldTime) {
  return (newTime->tv_sec - oldTime->tv_sec) * 1000000 + (newTime->tv_usec - oldTime->tv_usec);
}

int main(int argc, char *argv[]) {
  struct timeval tstart, tend;
  int exec_time;

  DATATYPE *host_a= new DATATYPE [VEC_LEN];
  DATATYPE *host_b= new DATATYPE [VEC_LEN];
  DATATYPE *host_c= new DATATYPE [VEC_LEN];

  for (int i = 0; i < VEC_LEN; i++) {
    host_a[i] = 2 * i;
    host_b[i] = 2 * i + 1;
  }

  std::string xclbin_file;
  std::cout << "Program running in hardware mode" << std::endl;
  xclbin_file = "ulp.xclbin";

  // Load xclbin
  std::cout << "Load " << xclbin_file << std::endl;
  xrt::device device = xrt::device(DEVICE_ID);
  xrt::uuid xclbin_uuid = device.load_xclbin(xclbin_file);

  // create kernel objects
  std::cout << "Create kernel ip" << std::endl;
  xrt::ip ip = xrt::ip(device, xclbin_uuid, "vecadd");

  xrt::bo dev_a = xrt::bo(device, VEC_LEN * sizeof(DATATYPE), xrt::bo::flags::normal, 0);
  xrt::bo dev_b = xrt::bo(device, VEC_LEN * sizeof(DATATYPE), xrt::bo::flags::normal, 0);
  xrt::bo dev_c = xrt::bo(device, VEC_LEN * sizeof(DATATYPE), xrt::bo::flags::normal, 0);

  // a offset
  ip.write_register(0x10, dev_a.address());       // lower 32b
  ip.write_register(0x14, dev_a.address() >> 32); // upper 32b
  // b offset
  ip.write_register(0x1c, dev_b.address());       // lower 32b
  ip.write_register(0x20, dev_b.address() >> 32); // upper 32b
  // c offset
  ip.write_register(0x28, dev_c.address());       // lower 32b
  ip.write_register(0x2c, dev_c.address() >> 32); // upper 32b
  // len
  ip.write_register(0x34, VEC_LEN);


  gettimeofday(&tstart, 0);
  dev_a.write(host_a);
  dev_a.sync(XCL_BO_SYNC_BO_TO_DEVICE);
  gettimeofday(&tend, 0);
  exec_time = diff(&tend, &tstart);
  std::cout << "Done transferring host_a->dev_a" << std::endl;
  std::cout << "Transfer time: " << exec_time << " us" << std::endl;

  gettimeofday(&tstart, 0);
  dev_b.write(host_b);
  dev_b.sync(XCL_BO_SYNC_BO_TO_DEVICE);
  gettimeofday(&tend, 0);
  exec_time = diff(&tend, &tstart);
  std::cout << "Done transferring host_b->dev_b" << std::endl;
  std::cout << "Transfer time: " << exec_time << " us" << std::endl;

  std::cout << "Run FPGA kernel...\n" ;
  gettimeofday(&tstart, 0);
  ip.write_register(0x0, 1); // assert 'start'
  while ((ip.read_register(0x0) & 0x2) == 0); // check 'done'
  gettimeofday(&tend, 0);
  exec_time = diff(&tend, &tstart);
  std::cout << "Kernel Execution time: " << exec_time << " us" << std::endl;

  gettimeofday(&tstart, 0);
  dev_c.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
  dev_c.read(host_c);
  gettimeofday(&tend, 0);
  exec_time = diff(&tend, &tstart);
  std::cout << "Done transferring dev_c->host_c" << std::endl;
  std::cout << "Transfer time: " << exec_time << " us" << std::endl;

  for (int i = 0; i < 10; i++) {
    std::cout << "c[" << i << "] = " << host_c[i] << " ";
    std::cout << "\ta[" << i << "] = " << host_a[i] << " ";
    std::cout << "\tb[" << i << "] = " << host_b[i] << '\n';
  }

  int num_mismatches = 0;
  for (int i = 0; i < VEC_LEN; i++) {
    if (host_c[i] != host_a[i] + host_b[i]) {
      num_mismatches += 1;
    }
  }

  if (num_mismatches == 0)
    std::cout << "Test Passed!" << std::endl;
  else
    std::cout << "Test Failed! Num. mismatches: " << num_mismatches << std::endl;

  free(host_a);
  free(host_b);
  free(host_c);
}
