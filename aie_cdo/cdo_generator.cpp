// Generated from aie_compile flow with some modification.

/***************************** Includes *********************************/
#include <fstream>
extern "C"
{
  #include <xaiengine.h>
}

#include <iostream> 
#include <cstring>
extern "C" {
#include "cdo_driver.h"
}
#include <vector>
#include <string>
#include <getopt.h>
#include <unistd.h>

/************************** Constants/Macros *****************************/
#define HW_GEN                   XAIE_DEV_GEN_AIE
#define XAIE_NUM_ROWS            9
#define XAIE_NUM_COLS            50
#define XAIE_BASE_ADDR           0x20000000000
#define XAIE_COL_SHIFT           23
#define XAIE_ROW_SHIFT           18
#define XAIE_SHIM_ROW            0
#define XAIE_MEM_TILE_ROW_START  0
#define XAIE_MEM_TILE_NUM_ROWS   0
#define XAIE_AIE_TILE_ROW_START  1
#define XAIE_AIE_TILE_NUM_ROWS   8
#define FOR_WRITE                0
#define FOR_READ                 1


XAie_InstDeclare(DevInst, &ConfigPtr);   // Declare global device instance

void initializeCDOGenerator(bool endianness){
  std::cout << "init CDO...\n";
  setEndianness(endianness);
  XAie_SetIOBackend(&DevInst, XAIE_IO_BACKEND_CDO); // Set C-RTS Library to run for CDO Mode 
  std::cout << "set io backend done\n";
}

void addInitConfigToCDO() {
  // We will init configs in host code during runtime instead

//  XAie_StrmConnCctEnable(&DevInst, XAie_TileLoc(18, 1), DMA, 0, SOUTH, 3);
//  XAie_StrmConnCctEnable(&DevInst, XAie_TileLoc(18, 0), NORTH, 3, SOUTH, 2);
//  XAie_EnableAieToShimDmaStrmPort(&DevInst, XAie_TileLoc(18, 0), 2);
}

void addCoreEnableToCDO() {
  // We will enable core in host code during runtime instead

//  XAie_CoreEnable(&DevInst, XAie_TileLoc(18, 1));
}

void addDbgHaltToCDO() {
  XAie_CoreDebugHalt(&DevInst, XAie_TileLoc(18, 1));
}

void addResetConfigToCDO() {
  XAie_ResetPartition(&DevInst);
}

void addErrorHandlingToCDO() {
  XAie_TurnEccOn(&DevInst);
  XAie_ErrorHandlingInit(&DevInst);
}

void addClockGatingToCDO() {
  // We will request tiles in host code during runtime instead

  XAie_LocType locs[2] = {XAie_TileLoc(18, 1), XAie_TileLoc(18, 0)};
  XAie_PmRequestTiles(&DevInst, locs, 2);
}

void addMemClearingConfigToCDO() {
  // We will clear mems in host code during runtime instead

//  XAie_ClearPartitionMems(&DevInst);
}

void addAieElfsToCDO() {
  // We will load elf files in host code during runtime instead

//  if (XAie_LoadElf(&DevInst, XAie_TileLoc(18, 1), "../host_sw_with_aie/aie_core_elf/core.out", XAIE_ENABLE) != XAIE_OK) {
//    std::cout << "Failed to load elf!\n";
//    exit(EXIT_FAILURE);
//  }
}

void generateCDOBinariesSeparately() {

  const std::string initCfgCDOFilePath       = "aie_cdo_init.bin";
  const std::string coreEnableCDOFilePath    = "aie_cdo_enable.bin";
  const std::string dbgHaltCDOFilePath       = "aie_cdo_debug.bin";
  const std::string resetCDOFilePath         = "aie_cdo_reset.bin";
  const std::string errorHandlingCDOFilePath = "aie_cdo_error_handling.bin";
  const std::string clockGatingCDOFilePath   = "aie_cdo_clock_gating.bin";
  const std::string memClearingCDOFilePath   = "aie_cdo_mem_clear.bin";
  const std::string elfsCDOFilePath          = "aie_cdo_elfs.bin";
	
  // ******************************* Reset CDO ******************************* //
  startCDOFileStream(resetCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add reset configuration to: aie_cdo_reset.bin
  addResetConfigToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* Error Handling CDO ******************************* //
  startCDOFileStream(errorHandlingCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add error handling configuration to: aie_cdo_error_handling.bin
  addErrorHandlingToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* Clock Gating CDO ******************************* //
  startCDOFileStream(clockGatingCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add clock gating configuration to: aie_cdo_clock_gating.bin
  addClockGatingToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* Partition Memory Clearing CDO ******************************* //
  startCDOFileStream(memClearingCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add memory clearing configuration to: aie_cdo_mem_clear.bin
  addMemClearingConfigToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* Convert AIE Elfs To CDO ******************************* //
  startCDOFileStream(elfsCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add AIE ELFs configuration to: aie_cdo_elfs.bin
  addAieElfsToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* Initial configuration CDO ******************************* //
  startCDOFileStream(initCfgCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add init configuration to: aie_cdo_init.bin
  addInitConfigToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* AIE core enable CDO ******************************* //
  startCDOFileStream(coreEnableCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add AIE core enable configuration to: aie_cdo_enable.bin
  addCoreEnableToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();

  // ******************************* AIE Core debug Halt CDO ******************************* //
  startCDOFileStream(dbgHaltCDOFilePath.c_str());
  FileHeader();// Add CDO-v2 file header 
  // Add AIE core debug-halt configuration to: aie_cdo_debug.bin
  addDbgHaltToCDO();
  configureHeader(); // Update CDO header for length and check-sum
  endCurrentCDOFileStream();
}

int main(int argc, char** argv) {
  bool endianness;
  endianness = byte_ordering::Little_Endian;
  //endianness = byte_ordering::Big_Endian;
  std::cout << "Initializing AIE driver...\n";
  XAie_SetupConfig(ConfigPtr, HW_GEN, XAIE_BASE_ADDR, XAIE_COL_SHIFT,
    XAIE_ROW_SHIFT, XAIE_NUM_COLS, XAIE_NUM_ROWS,
    XAIE_SHIM_ROW, XAIE_MEM_TILE_ROW_START,
    XAIE_MEM_TILE_NUM_ROWS, XAIE_AIE_TILE_ROW_START,
    XAIE_AIE_TILE_NUM_ROWS);

  XAie_CfgInitialize(&(DevInst), &ConfigPtr);

  initializeCDOGenerator(endianness);
  generateCDOBinariesSeparately();
  return EXIT_SUCCESS;
}
