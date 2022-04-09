#ifndef __COMMON_H__
#define __COMMON_H__
#include <stdio.h>
#include <xaiengine.h>

#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <map>
#include <cassert>

#include "experimental/xrt_kernel.h"
#include "experimental/xrt_ip.h"
#include "experimental/xrt_uuid.h"

/* AIE Device parameters */
#define XAIE_BASE_ADDR          0x20000000000
#define XAIE_NUM_ROWS           9
#define XAIE_NUM_COLS           50
#define XAIE_COL_SHIFT          23
#define XAIE_ROW_SHIFT          18
#define XAIE_SHIM_ROW           0
#define XAIE_RES_TILE_ROW_START 0
#define XAIE_RES_TILE_NUM_ROWS  0
#define XAIE_AIE_TILE_ROW_START 1
#define XAIE_AIE_TILE_NUM_ROWS  8

#define PL_BRAM_BASE_ADDR 0x20100000000

#define DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO       0x10
#define DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI       0x14
#define DATA_MOVER_CTRL_ADDR_EXT_OFFSET_LO       0x1c
#define DATA_MOVER_CTRL_ADDR_EXT_OFFSET_HI       0x20
#define DATA_MOVER_CTRL_ADDR_AIE_CFG_VALUE_W     0x28
#define DATA_MOVER_CTRL_ADDR_AIE_CFG_VALUE_R     0x30
#define DATA_MOVER_CTRL_ADDR_AIE_CFG_MASK        0x38
#define DATA_MOVER_CTRL_ADDR_AIE_CFG_WORD_OFFSET 0x40
#define DATA_MOVER_CTRL_ADDR_LEN                 0x48
#define DATA_MOVER_CTRL_ADDR_MODE                0x50

#define DATA_MOVER_MODE_EXT2INT       0
#define DATA_MOVER_MODE_INT2EXT       1
#define DATA_MOVER_MODE_AIE_WRITE     2
#define DATA_MOVER_MODE_AIE_MASKWRITE 3
#define DATA_MOVER_MODE_AIE_BLOCKSET  4
#define DATA_MOVER_MODE_AIE_READ      5

//static xrt::device device;
//static xrt::ip data_mover;

void init_ptrs(xrt::device&, xrt::ip&);
extern "C" AieRC PL_Write32(u64 Addr, u32 Value);
extern "C" AieRC PL_MaskWrite32(u64 Addr, u32 Mask, u32 Value);
extern "C" AieRC PL_BlockWrite32(u64 Addr, u32 *Data, u32 Size);
extern "C" AieRC PL_BlockSet32(u64 Addr, u32 Data, u32 Size);
extern "C" AieRC PL_Read32(u64 Addr, u32 *Data);
extern "C" AieRC PL_MaskPoll(u64 Addr, u32 Mask, u32 Value, u32 TimeOutUs);
extern "C" AieRC PL_NpiWrite32(u32 Addr, u32 Value);
extern "C" AieRC PL_NpiMaskPoll(u32 Addr, u32 Mask, u32 Value, u32 TimeOutUs);
void data_mover_mm_read(xrt::bo &dev_buf, u32 *host_buf, u64 int_addr, u32 len, bool print_result);
void data_mover_mm_write(xrt::bo &dev_buf, u32 *host_buf, u64 int_addr, u32 len);
#endif
