#include <cstdint>

void vecadd(int64_t *a, int64_t *b, int64_t *c, int len) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=a
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=b
#pragma HLS INTERFACE m_axi port=c offset=slave bundle=c

#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE s_axilite port=len bundle=control
#pragma HLS INTERFACE s_axilite port=a bundle=control
#pragma HLS INTERFACE s_axilite port=b bundle=control
#pragma HLS INTERFACE s_axilite port=c bundle=control

  for (int i = 0; i < len; i++) {
    c[i] = a[i] + b[i];
  }
}
