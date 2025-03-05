    .extern start_kernel
    .section .text.init
    .globl _start
    .extern task_init
    .extern mm_init
    .extern sbi_set_timer
_start:
    
    # set sp with the top of boot_stack
    la sp, boot_stack_top 

     #memory init
    call mm_init
    # task init
    call task_init
    

    # set stvec
    la a0, _traps
    csrrw x0, stvec, a0

    # set sie[stie]=1
    addi a0, x0, 32
    csrrs x0, sie, a0

    

    # set the first timer interrupt
    rdtime a0
    call sbi_set_timer

   

    # set sstatus[SIE]=1
    csrrsi x0, sstatus, 2
    
    

    call start_kernel

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 # <-- change to your stack size

    .globl boot_stack_top
boot_stack_top: