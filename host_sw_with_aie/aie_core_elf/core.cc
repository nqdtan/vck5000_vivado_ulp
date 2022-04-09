
#include <stdio.h>

#define ACQUIRE_LOCK_FOR_WRITE 0
#define RELEASE_LOCK_FOR_READ  1
#define ACQUIRE_LOCK_FOR_READ  1
#define RELEASE_LOCK_FOR_WRITE 0

#define LOCK_S_OFFSET 0
#define LOCK_S(x) (LOCK_S_OFFSET + x)

#define LOCK_W_OFFSET 16
#define LOCK_W(x) (LOCK_W_OFFSET + x)

#define LOCK_N_OFFSET 32
#define LOCK_N(x) (LOCK_N_OFFSET + x)

#define LOCK_E_OFFSET 48
#define LOCK_E(x) (LOCK_E_OFFSET + x)

extern int32_t buffer[16];

int main() {
  acquire(LOCK_E(2), ACQUIRE_LOCK_FOR_READ);
  acquire(LOCK_E(1), ACQUIRE_LOCK_FOR_WRITE);
  for (int i = 0; i < 16; i++)
    buffer[i] += 1; // add one
  release(LOCK_E(1), RELEASE_LOCK_FOR_READ);
  release(LOCK_E(2), RELEASE_LOCK_FOR_WRITE);

  // spin here (otherwise it seems that the core is auto restarting)
  for (;;);
  return 0;
}
