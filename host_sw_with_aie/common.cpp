#include "common.h"

xrt::device *device;
xrt::ip *data_mover;

void init_ptrs(xrt::device &dev, xrt::ip &ip) {
  device = &dev;
  data_mover = &ip;
}

extern "C" AieRC PL_Write32(u64 Addr, u32 Value) {
  assert(data_mover != nullptr && "data_mover uninitialized!"); 

  //std::cout << "PL_Write32 " << std::hex << Addr << " " << Value << std::dec << '\n';
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, Addr);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, Addr >> 32);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_VALUE_W, Value);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_WORD_OFFSET, (Addr >> 2) & 0x3);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_AIE_WRITE);
  data_mover->write_register(0x0, 1); // assert 'start'
  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'

  return XAIE_OK;
}

extern "C" AieRC PL_MaskWrite32(u64 Addr, u32 Mask, u32 Value) {
  assert(data_mover != nullptr && "data_mover uninitialized!"); 

  //std::cout << "PL_MaskWrite32 " << std::hex << Addr << " " << Mask << " " << Value << std::dec << '\n';
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, Addr);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, Addr >> 32);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_MASK, Mask);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_VALUE_W, Value);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_WORD_OFFSET, (Addr >> 2) & 0x3);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_AIE_MASKWRITE);
  data_mover->write_register(0x0, 1); // assert 'start'
  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'

  return XAIE_OK;
}

extern "C" AieRC PL_BlockWrite32(u64 Addr, u32 *Data, u32 Size) {
  // We can use ext2int functionality to write block of config data more efficiently,
  // but need to handle Size that is not divisible by 4 (config block not 128b-aligned)
  // in the HLS core

  assert(false && "Not supported!");

  assert(data_mover != nullptr && "data_mover uninitialized!"); 
  assert(device != nullptr && "device uninitialized!"); 

  //std::cout << "PL_BlockWrite32 " << std::hex << Addr << " " << Size << std::dec << '\n';
//  // Copy host data to device DDR
//  xrt::bo Data_dev = xrt::bo(*device, Size * sizeof(u32), xrt::bo::flags::normal, 0);
//  Data_dev.write(Data);
//  Data_dev.sync(XCL_BO_SYNC_BO_TO_DEVICE);
//
//
//  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, Addr);
//  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, Addr >> 32);
//  data_mover->write_register(DATA_MOVER_CTRL_ADDR_EXT_OFFSET_LO, Data_dev.address());
//  data_mover->write_register(DATA_MOVER_CTRL_ADDR_EXT_OFFSET_HI, Data_dev.address() >> 32);
//
//  data_mover->write_register(DATA_MOVER_CTRL_ADDR_LEN, Size / 4);
//  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_EXT2INT);
//  data_mover->write_register(0x0, 1); // assert 'start'
//  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'

  return XAIE_OK;
}

extern "C" AieRC PL_BlockSet32(u64 Addr, u32 Data, u32 Size) {
  assert(data_mover != nullptr && "data_mover uninitialized!"); 

  //std::cout << "PL_BlockSet32 " << std::hex << Addr << " " << Data << " " << Size << std::dec << '\n';
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, Addr);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, Addr >> 32);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_VALUE_W, Data);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_LEN, Size / 4);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_AIE_BLOCKSET);
  data_mover->write_register(0x0, 1); // assert 'start'
  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'

  return XAIE_OK;
}

extern "C" AieRC PL_Read32(u64 Addr, u32 *Data) {
  assert(data_mover != nullptr && "data_mover uninitialized!"); 

  //std::cout << "PL_Read32 " << std::hex << Addr << std::dec << '\n';
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, Addr);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, Addr >> 32);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_WORD_OFFSET, (Addr >> 2) & 0x3);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_AIE_READ);
  data_mover->write_register(0x0, 1); // assert 'start'
  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'

  Data[0] = data_mover->read_register(DATA_MOVER_CTRL_ADDR_AIE_CFG_VALUE_R);

  return XAIE_OK;
}

extern "C" AieRC PL_MaskPoll(u64 Addr, u32 Mask, u32 Value, u32 TimeOutUs) {
  // Ref: embeddedsw/XilinxProcessorIPLib/drivers/aienginev2/src/io_backend/ext/xaie_sim.c
  //std::cout << "PL_MaskPoll " << std::hex << Addr << " " << Mask << " " << Value << std::dec << " " << TimeOutUs << '\n';
  AieRC Ret = XAIE_ERR;
  u32 RegVal;

  /* Increment TimeOut value to 1 if user passed value is 1 */
  if (TimeOutUs == 0)
    TimeOutUs++;

  while (TimeOutUs > 0) {
    PL_Read32(Addr, &RegVal);
    if ((RegVal & Mask) == Value) {
      Ret = XAIE_OK;
      break;
    }
    usleep(1);
    TimeOutUs--;
  }

  return Ret;
}

extern "C" AieRC PL_NpiWrite32(u32 Addr, u32 Value) {
  assert(false && "Not supported!");
}

extern "C" AieRC PL_NpiMaskPoll(u32 Addr, u32 Mask, u32 Value, u32 TimeOutUs) {
  assert(false && "Not supported!");
}

void data_mover_mm_read(xrt::bo &dev_buf, u32 *host_buf, u64 int_addr, u32 len, bool print_result) {
  assert(data_mover != nullptr && "data_mover uninitialized!"); 

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, int_addr);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, int_addr >> 32);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_EXT_OFFSET_LO, dev_buf.address());
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_EXT_OFFSET_HI, dev_buf.address() >> 32);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_LEN, len / 4);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_INT2EXT);
  data_mover->write_register(0x0, 1); // assert 'start'
  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'

  // Copy data from device DDR to host
  dev_buf.sync(XCL_BO_SYNC_BO_FROM_DEVICE);
  dev_buf.read(host_buf);

  if (print_result) {
    // 128b alignment
    for (u32 i = 0; i < len; i++) {
      std::cout << std::hex <<
        "[" << ((int_addr & 0xFFFFFFFFFFFFFFF0) + (i << 2)) << "]: "
            << host_buf[i] << '\n';
    }
    std::cout << std::dec;
  }
}

void data_mover_mm_write(xrt::bo &dev_buf, u32 *host_buf, u64 int_addr, u32 len) {
  assert(data_mover != nullptr && "data_mover uninitialized!"); 

  // Copy data from host to device DDR
  dev_buf.write(host_buf);
  dev_buf.sync(XCL_BO_SYNC_BO_TO_DEVICE);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_LO, int_addr);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_INT_OFFSET_HI, int_addr >> 32);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_EXT_OFFSET_LO, dev_buf.address());
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_EXT_OFFSET_HI, dev_buf.address() >> 32);
  data_mover->write_register(DATA_MOVER_CTRL_ADDR_LEN, len / 4);

  data_mover->write_register(DATA_MOVER_CTRL_ADDR_MODE, DATA_MOVER_MODE_EXT2INT);
  data_mover->write_register(0x0, 1); // assert 'start'
  while ((data_mover->read_register(0x0) & 0x2) == 0); // check 'done'
}
