#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
extern void do_timer();
void trap_handler(uint64_t scause, uint64_t sepc) {
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
        printk("[S] Exception: %d\n", cause);
    }
}