#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
#include "syscall.h"
extern void do_timer();

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs ) {
    uint64_t flag = scause >> 63;
    uint64_t cause = scause & 0x7FFFFFFFFFFFFFFF;

    if(flag) {//interrupt
        if(cause == 5) {
            // uint64_t ret = csr_read(sstatus);
            // csr_write(sscratch, ret);
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            
            clock_set_next_event();
            do_timer();
        }
        else {
            printk("[S] Interrupt: %d\n", cause);
        }
    }
    else {
        if (cause == 8) {
            if(regs->x17 == SYS_GETPID) {
                uint64_t ret = sys_getpid();
                regs->x10 = ret;
            } else if (regs->x17 == SYS_WRITE) {
                const char *buf = (char *)regs->x11;
                uint64_t ret = sys_write(regs->x10, buf, regs->x12);
                regs->x10 = ret;
            }
            regs->sepc += 4;
        }
        else Err(RED "[S] Exception: %d\n", cause);
    }
}