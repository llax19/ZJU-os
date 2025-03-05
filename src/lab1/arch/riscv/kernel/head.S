    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    # set sp with the top of boot_stack
    la sp, boot_stack_top 

    # set stvec
    la a0, _traps
    csrrw x0, stvec, a0

    # set sie[stie]=1
    addi a0, x0, 32
    csrrs x0, sie, a0

    # set the first timer interrupt
    rdtime a1
    li a7, 0x54494d45
    mv a6, x0
    mv a0, a1
    mv a1, x0
    mv a2, x0
    mv a3, x0
    mv a4, x0
    mv a5, x0
    ecall

    # set sstatus[SIE]=1
    csrrsi x0, sstatus, 2
    

    call start_kernel

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 # <-- change to your stack size

    .globl boot_stack_top
boot_stack_top: