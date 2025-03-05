#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
#include "syscall.h"
extern void do_timer();
extern void do_page_fault(struct pt_regs *regs, uint64_t scause);
extern uint64_t do_fork(struct pt_regs *regs);

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs ) {
    uint64_t flag = scause >> 63;
    uint64_t cause = scause & 0x7FFFFFFFFFFFFFFF;
    if (sepc == 0x102c8) {
        Log("sepc = 0x%lx, stval = 0x%x", sepc, regs->stval);
    }
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
            else if (regs->x17 == SYS_CLONE) {
                uint64_t cpid = do_fork(regs);
                regs->x10 = cpid;
            }
            regs->sepc += 4;
        }
        else if (cause==12 || cause==13 || cause==15) {
            if (cause==13 || cause==15) Log("Exception: scause=0x%x, sepc=0x%x, stval=0x%lx", scause, sepc, regs->stval);
            do_page_fault(regs, scause);
        }
        else Err(RED "[S] Exception: scause=0x%x, sepc=0x%x, stval=0x%x\n", scause, sepc, regs->stval);
    }
}