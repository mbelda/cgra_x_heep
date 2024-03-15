#ifndef _CGRA_BITSTREAM_H_
#define _CGRA_BITSTREAM_H_

#include <stdint.h>

#include "cgra.h"

// Kernel 0 => NULL
#define TRANSFORMER 1

static uint32_t cgra_kmem_bitstream[CGRA_KMEM_SIZE] = { 0x0, 0xf01f, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,  };
const uint32_t  cgra_imem_bitstream[CGRA_IMEM_SIZE] = { 0xa90000, 0xab0000, 0xa0d0004, 0xf0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8980001c, 0x6b80000, 0x0, 0x0, 0x0, 0x6a080004, 0x0, 0x0, 0x0, 0x0, 0x1a080004, 0x0, 0x0, 0x0, 0x0, 0x0, 0x60080000, 0x30090000, 0x9a0f0001, 0xf0000, 0x67090000, 0x0, 0xc80000, 0xa90000, 0xab0000, 0xad0000, 0xf0000, 0x0, 0x0, 0x0, 0x0, 0x8980001f, 0x0, 0x6b80000, 0x0, 0x0, 0x0, 0x6a080004, 0x0, 0x0, 0x0, 0x0, 0x1a080004, 0x0, 0x0, 0x0, 0x0, 0x0, 0x60080000, 0x30090000, 0x800009, 0x0, 0x67090000, 0x9a0f0001, 0x0, 0xa90000, 0xab0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x6b80000, 0x0, 0x0, 0x0, 0x6a080004, 0x0, 0x0, 0x0, 0x0, 0x1a080004, 0x0, 0x0, 0x0, 0x0, 0x0, 0x60080000, 0x30090000, 0x0, 0x0, 0x67090000, 0x800008, 0x0, 0xa90000, 0xab0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x6b80000, 0x0, 0x0, 0x0, 0x6a080004, 0x0, 0x0, 0x0, 0x0, 0x1a080004, 0x0, 0x0, 0x0, 0x0, 0x0, 0x60080000, 0x30090000, 0x0, 0x0, 0x67090000, 0x0, 0x0, 0xa80000, 0x1b90000, 0xa80000, 0x1bb0000, 0xa80000, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x0, 0x16180000, 0x10f0000, 0x4b80000, 0x0, 0x0, 0x17180000, 0x910f0000, 0x4b80000, 0x0, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xa80000, 0x1b90000, 0xa80000, 0x1bb0000, 0xa80000, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x0, 0x16180000, 0x10f0000, 0x4b80000, 0x0, 0x0, 0x17180000, 0x910f0000, 0x4b80000, 0x0, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xa80000, 0x1b90000, 0xa80000, 0x1bb0000, 0xa80000, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x0, 0x16180000, 0x10f0000, 0x4b80000, 0x0, 0x0, 0x17180000, 0x910f0000, 0x4b80000, 0x0, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xa80000, 0x1b90000, 0xa80000, 0x1bb0000, 0xa80000, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x0, 0x16180000, 0x10f0000, 0x4b80000, 0x0, 0x0, 0x17180000, 0x910f0000, 0x4b80000, 0x0, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x16180000, 0x10f0000, 0x0, 0x4080000, 0x0, 0x17180000, 0x910f0000, 0x0, 0x4080000, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x16180000, 0x10f0000, 0x0, 0x4080000, 0x0, 0x17180000, 0x910f0000, 0x0, 0x4080000, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x16180000, 0x10f0000, 0x0, 0x4080000, 0x0, 0x17180000, 0x910f0000, 0x0, 0x4080000, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4080000, 0x16180000, 0x10f0000, 0x0, 0x4080000, 0x0, 0x17180000, 0x910f0000, 0x0, 0x4080000, 0x0, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x5080000, 0x0, 0x16180000, 0x10f0000, 0x0, 0x0, 0x4080000, 0x17180000, 0x910f0000, 0x0, 0x0, 0x4080000, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x5080000, 0x0, 0x16180000, 0x10f0000, 0x0, 0x0, 0x4080000, 0x17180000, 0x910f0000, 0x0, 0x0, 0x4080000, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x5080000, 0x0, 0x16180000, 0x10f0000, 0x0, 0x0, 0x4080000, 0x17180000, 0x910f0000, 0x0, 0x0, 0x4080000, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4a080010, 0x1b90000, 0x4a080010, 0x1bb0000, 0x4a080010, 0x1bd0000, 0x0, 0x0, 0x0, 0x5080000, 0x0, 0x16180000, 0x10f0000, 0x0, 0x0, 0x4080000, 0x17180000, 0x910f0000, 0x0, 0x0, 0x4080000, 0x18180000, 0x910f0000, 0x90b00000, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,  };

#endif // _CGRA_BITSTREAM_H_
