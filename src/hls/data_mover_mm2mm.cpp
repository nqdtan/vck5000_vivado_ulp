#include <ap_int.h>

void data_mover_mm2mm(ap_int<128> *data_int, ap_int<128> *data_ext,
                      int *aie_cfg_value,
                      int aie_cfg_mask,
                      int aie_cfg_word_offset,
                      int len, int mode) {
#pragma HLS INTERFACE m_axi port=data_int offset=slave bundle=data_int
#pragma HLS INTERFACE m_axi port=data_ext offset=slave bundle=data_ext

#pragma HLS INTERFACE s_axilite port=return              bundle=control
#pragma HLS INTERFACE s_axilite port=aie_cfg_value       bundle=control
#pragma HLS INTERFACE s_axilite port=aie_cfg_mask        bundle=control
#pragma HLS INTERFACE s_axilite port=aie_cfg_word_offset bundle=control
#pragma HLS INTERFACE s_axilite port=len                 bundle=control
#pragma HLS INTERFACE s_axilite port=mode                bundle=control
#pragma HLS INTERFACE s_axilite port=data_int            bundle=control
#pragma HLS INTERFACE s_axilite port=data_ext            bundle=control

  // ext -> int
  if (mode == 0) {
    for (int i = 0; i < len; i++) {
      #pragma HLS PIPELINE
      data_int[i] = data_ext[i];
    }
  }

  // int -> ext
  if (mode == 1) {
    for (int i = 0; i < len; i++) {
      #pragma HLS PIPELINE
      data_ext[i] = data_int[i];
    }
  }

  // aie write
  if (mode == 2) {
    if (aie_cfg_word_offset == 0)
      data_int[0](31, 0)   = *aie_cfg_value;
    else if (aie_cfg_word_offset == 1)
      data_int[0](63, 32)  = *aie_cfg_value;
    else if (aie_cfg_word_offset == 2)
      data_int[0](95, 64)  = *aie_cfg_value;
    else if (aie_cfg_word_offset == 3)
      data_int[0](127, 96) = *aie_cfg_value;
  }

  // aie mask write
  if (mode == 3) {
    if (aie_cfg_word_offset == 0)
      data_int[0](31, 0)   = (data_int[0](31, 0)   & ~aie_cfg_mask) | *aie_cfg_value;
    else if (aie_cfg_word_offset == 1)
      data_int[0](63, 32)  = (data_int[0](63, 32)  & ~aie_cfg_mask) | *aie_cfg_value;
    else if (aie_cfg_word_offset == 2)
      data_int[0](95, 64)  = (data_int[0](95, 64)  & ~aie_cfg_mask) | *aie_cfg_value;
    else if (aie_cfg_word_offset == 3)
      data_int[0](127, 96) = (data_int[0](127, 96) & ~aie_cfg_mask) | *aie_cfg_value;
  }

  // aie block set
  if (mode == 4) {
    for (int i = 0; i < len; i++) {
      #pragma HLS PIPELINE
      data_int[i](31, 0)   = *aie_cfg_value;
      data_int[i](63, 32)  = *aie_cfg_value;
      data_int[i](95, 64)  = *aie_cfg_value;
      data_int[i](127, 96) = *aie_cfg_value;
    }
  }

  // aie read
  if (mode == 5) {
    if (aie_cfg_word_offset == 0)
      *aie_cfg_value = data_int[0](31, 0);
    else if (aie_cfg_word_offset == 1)
      *aie_cfg_value = data_int[0](63, 32);
    else if (aie_cfg_word_offset == 2)
      *aie_cfg_value = data_int[0](95, 64);
    else if (aie_cfg_word_offset == 3)
      *aie_cfg_value = data_int[0](127, 96);
  }
}
