
#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <sys/stat.h>
#include <string>
#include <sys/time.h>
#include "common.h"

#define ACQUIRE_LOCK_FOR_WRITE 0
#define RELEASE_LOCK_FOR_READ  1
#define ACQUIRE_LOCK_FOR_READ  1
#define RELEASE_LOCK_FOR_WRITE 0
#define BD(x) (x)

#define DEVICE_ID 0

using namespace std;

unsigned long diff(const struct timeval *newTime, const struct timeval *oldTime) {
  return (newTime->tv_sec - oldTime->tv_sec) * 1000000 + (newTime->tv_usec - oldTime->tv_usec);
}

void aie_clear_config(int col, int row) {

}

int main(int argc, char *argv[]) {
  struct timeval tstart, tend;
  int exec_time;

  std::string xclbin_file;
  xclbin_file = "ulp.xclbin";

  // Load xclbin
  std::cout << "Load " << xclbin_file << std::endl;
  xrt::device device = xrt::device(DEVICE_ID);
  xrt::uuid xclbin_uuid = device.load_xclbin(xclbin_file);

  // create kernel objects
  std::cout << "Create kernel ip" << std::endl;
  xrt::ip data_mover = xrt::ip(device, xclbin_uuid, "data_mover_mm2mm");

  init_ptrs(device, data_mover);

  int len = 16; // number of 32b items
  // host buffers (x86)
  u32 *host_mm0 = new u32 [len];
  u32 *host_mm1 = new u32 [len];
  u32 *host_mm2 = new u32 [len];
  // device buffers (device DDR)
  xrt::bo dev_mm0 = xrt::bo(device, len * sizeof(u32), xrt::bo::flags::normal, 0);
  xrt::bo dev_mm1 = xrt::bo(device, len * sizeof(u32), xrt::bo::flags::normal, 0);

  for (int i = 0; i < len; i++) {
    host_mm0[i] = i * 2 + 1;
    host_mm1[i] = 0;
    host_mm2[i] = 0;
  }
  std::cout << "Transfer host_mm0 buffer to PL BRAM\n";
  // Sync host buffer with dev DDR, and then copy it to PL BRAM
  data_mover_mm_write(dev_mm0, host_mm0, PL_BRAM_BASE_ADDR, len);

  std::cout << "Configuring AIE...\n";
  XAie_SetupConfig(ConfigPtr, XAIE_DEV_GEN_AIE, XAIE_BASE_ADDR,
    XAIE_COL_SHIFT, XAIE_ROW_SHIFT,
    XAIE_NUM_COLS, XAIE_NUM_ROWS, XAIE_SHIM_ROW,
    XAIE_RES_TILE_ROW_START, XAIE_RES_TILE_NUM_ROWS,
    XAIE_AIE_TILE_ROW_START, XAIE_AIE_TILE_NUM_ROWS);

  XAie_InstDeclare(DevInst, &ConfigPtr);

  AieRC RC = XAIE_OK;
  RC = XAie_CfgInitialize(&DevInst, &ConfigPtr);
  if (RC != XAIE_OK) {
    std::cout << "Driver initialization failed.\n";
    return -1;
  }

  // These XAie configs should be embedded in CDO binary files that are stored within
  // an xclbin file. They should not be called in a host program since they involve
  // setting NPI registers whose address space is not visible to the x86 host or the PL.
  // XAie_ResetPartition(&DevInst);
  // XAie_ErrorHandlingInit(&DevInst);
  // XAie_TurnEccOn(&DevInst);

  // Clock gating
  XAie_LocType locs[2] = {XAie_TileLoc(18, 1), XAie_TileLoc(18, 0)};
  XAie_PmRequestTiles(&DevInst, locs, 2);

  // Clear array memory (only applicable for the requested tiles)
  XAie_ClearPartitionMems(&DevInst);

  // Load ELF (add-one kernel)
  if (XAie_LoadElf(&DevInst, XAie_TileLoc(18, 1), "aie_core_elf/core.out", XAIE_ENABLE) != XAIE_OK) {
    std::cout << "Failed to load elf!\n";
  }

  // Init Config
  XAie_CoreReset(&DevInst, XAie_TileLoc(18, 1));
  XAie_CoreUnreset(&DevInst, XAie_TileLoc(18, 1));
  XAie_CoreConfigureDone(&DevInst, XAie_TileLoc(18, 1));

  // SHIM -> AIE =============
  XAie_StrmConnCctEnable(&DevInst, XAie_TileLoc(18, 1), SOUTH, 2, DMA, 0);
  XAie_StrmConnCctEnable(&DevInst, XAie_TileLoc(18, 0), SOUTH, 3, NORTH, 2);

  // NOC -> (18, 0) via MM2S (ShimDMA)
  {
    XAie_DmaDesc DmaInst;
    XAie_DmaDescInit(&DevInst, &DmaInst, XAie_TileLoc(18, 0));
    XAie_DmaSetAddrLen(&DmaInst, PL_BRAM_BASE_ADDR, len * sizeof(u32));
    //XAie_DmaSetLock(&DmaInst, XAie_LockInit(1, 0), XAie_LockInit(1, 1));
    XAie_DmaSetNextBd(&DmaInst, BD(1), XAIE_DISABLE);
    XAie_DmaEnableBd(&DmaInst);
    XAie_DmaWriteBd(&DevInst, &DmaInst, XAie_TileLoc(18, 0), BD(1));
  }
  XAie_DmaChannelPushBdToQueue(&DevInst, XAie_TileLoc(18, 0), 0, DMA_MM2S, BD(1));
  XAie_DmaChannelEnable(&DevInst, XAie_TileLoc(18, 0), 0, DMA_MM2S);

  // (18, 0) -> (18, 1) via S2MM (TileDMA)
  {
    XAie_DmaDesc DmaInst;
    XAie_DmaDescInit(&DevInst, &DmaInst, XAie_TileLoc(18, 1));
    XAie_DmaSetAddrLen(&DmaInst, 0x0, len * sizeof(u32));
    XAie_DmaSetLock(&DmaInst, XAie_LockInit(2, ACQUIRE_LOCK_FOR_WRITE), XAie_LockInit(2, RELEASE_LOCK_FOR_READ));
    XAie_DmaSetNextBd(&DmaInst, BD(1), XAIE_DISABLE);
    XAie_DmaEnableBd(&DmaInst);
    XAie_DmaWriteBd(&DevInst, &DmaInst, XAie_TileLoc(18, 1), BD(1));
  }
  XAie_DmaChannelPushBdToQueue(&DevInst, XAie_TileLoc(18, 1), 0, DMA_S2MM, BD(1));
  XAie_DmaChannelEnable(&DevInst, XAie_TileLoc(18, 1), 0, DMA_S2MM);

  XAie_EnableShimDmaToAieStrmPort(&DevInst, XAie_TileLoc(18, 0), 3);

  // AIE -> SHIM =============
  XAie_StrmConnCctEnable(&DevInst, XAie_TileLoc(18, 1), DMA, 0, SOUTH, 3);
  XAie_StrmConnCctEnable(&DevInst, XAie_TileLoc(18, 0), NORTH, 3, SOUTH, 2);

  // (18, 1) -> (18, 0) via MM2S (TileDMA)
  {
    XAie_DmaDesc DmaInst;
    XAie_DmaDescInit(&DevInst, &DmaInst, XAie_TileLoc(18, 1));
    XAie_DmaSetAddrLen(&DmaInst, 0x0, len * sizeof(u32));
    XAie_DmaSetLock(&DmaInst, XAie_LockInit(1, ACQUIRE_LOCK_FOR_READ), XAie_LockInit(1, RELEASE_LOCK_FOR_WRITE));
    XAie_DmaSetNextBd(&DmaInst, BD(0), XAIE_DISABLE);
    XAie_DmaEnableBd(&DmaInst);
    XAie_DmaWriteBd(&DevInst, &DmaInst, XAie_TileLoc(18, 1), BD(0));
  }
  XAie_DmaChannelPushBdToQueue(&DevInst, XAie_TileLoc(18, 1), 0, DMA_MM2S, BD(0));
  XAie_DmaChannelEnable(&DevInst, XAie_TileLoc(18, 1), 0, DMA_MM2S);
  // (18, 0) -> NOC via S2MM (ShimDMA)
  {
    XAie_DmaDesc DmaInst;
    XAie_DmaDescInit(&DevInst, &DmaInst, XAie_TileLoc(18, 0));
    XAie_DmaSetAddrLen(&DmaInst, PL_BRAM_BASE_ADDR, len * sizeof(u32));
    //XAie_DmaSetLock(&DmaInst, XAie_LockInit(1, 0), XAie_LockInit(1, 1));
    XAie_DmaSetNextBd(&DmaInst, BD(0), XAIE_DISABLE);
    XAie_DmaEnableBd(&DmaInst);
    XAie_DmaWriteBd(&DevInst, &DmaInst, XAie_TileLoc(18, 0), BD(0));
  }
  XAie_DmaChannelPushBdToQueue(&DevInst, XAie_TileLoc(18, 0), 0, DMA_S2MM, BD(0));
  XAie_DmaChannelEnable(&DevInst, XAie_TileLoc(18, 0), 0, DMA_S2MM);

  XAie_EnableAieToShimDmaStrmPort(&DevInst, XAie_TileLoc(18, 0), 2);

  // Enable core
  XAie_CoreEnable(&DevInst, XAie_TileLoc(18, 1));

  gettimeofday(&tstart, 0);
  // Wait for ShimDma to copy data from AIE to PL BRAM
  while (XAie_DmaWaitForDone(&DevInst, XAie_TileLoc(18, 0), 0, DMA_S2MM, BD(0)) != XAIE_OK) {};
  gettimeofday(&tend, 0);
  exec_time = diff(&tend, &tstart);
  std::cout << "ShimDMA(18, 0) S2MM Ch0 BD0 transfer done in " << exec_time << " us\n";

  bool print_result = true;
  std::cout << "Check results from AIE_Tile(18, 1) Data Memory\n";
  // Read AIE_Tile(18, 1) Data Memory and copy it to DDR
  data_mover_mm_read(dev_mm1, host_mm2, XAIE_BASE_ADDR + _XAie_GetTileAddr(&DevInst, 1, 18), len, print_result);

  std::cout << "Check results from BRAM\n";
  // Read BRAM content and copy it to DDR
  data_mover_mm_read(dev_mm0, host_mm1, PL_BRAM_BASE_ADDR, len, print_result);

  int num_errs = 0;
  for (int i = 0; i < len; i++) {
    if (host_mm1[i] != host_mm0[i] + 1)
      num_errs++;
  }
  if (num_errs == 0)
    std::cout << "Test Passed!\n";
  else
    std::cout << "Test Failed! Num. errors: " << num_errs << '\n';

  free(host_mm0);
  free(host_mm1);
  free(host_mm2);
}
