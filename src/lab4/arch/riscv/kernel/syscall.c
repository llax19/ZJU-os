#include "syscall.h"
#include "stdint.h"
#include "proc.h"

extern struct task_struct *current;
uint64_t sys_getpid() {
    return current->pid;
}

uint64_t sys_write(uint64_t fd, const char* buf, uint64_t count) {
    if (fd != 1) {
        return -1;
    }
    int i=0;
    for (i=0; i<count; i++) {
        printk("%c", buf[i]);
    }
    return i;
}