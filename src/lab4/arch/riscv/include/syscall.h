#ifndef __SYSCALL_H__
#define __SYSCALL_H__

#include "stdint.h"

#define SYS_WRITE   64
#define SYS_GETPID  172

struct pt_regs{
    uint64_t x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10;
    uint64_t x11,x12,x13,x14,x15,x16,x17,x18,x19,x20;
    uint64_t x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
    uint64_t sepc;
};

uint64_t sys_getpid();
uint64_t sys_write(uint64_t fd, const char* buf, uint64_t count);

#endif