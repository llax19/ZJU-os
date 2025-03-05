    .extern trap_handler
    .extern dummy
    .globl __dummy
    .section .text.entry
    .align 2
    .globl _traps
    .equ regbytes, 8
    .globl __switch_to

__switch_to:
    # save state to prev process
    addi a0, a0, 32 #a0 = prev->thread
    sd ra, 0*regbytes(a0)
    sd sp, 1*regbytes(a0)
    sd s0, 2*regbytes(a0)
    sd s1, 3*regbytes(a0)
    sd s2, 4*regbytes(a0)
    sd s3, 5*regbytes(a0)
    sd s4, 6*regbytes(a0)
    sd s5, 7*regbytes(a0)
    sd s6, 8*regbytes(a0)
    sd s7, 9*regbytes(a0)
    sd s8, 10*regbytes(a0)
    sd s9, 11*regbytes(a0)
    sd s10, 12*regbytes(a0)
    sd s11, 13*regbytes(a0)



    # restore state from next process
    
    addi a1, a1, 32  #a1 = next->thread
    ld ra, 0*regbytes(a1)
    ld sp, 1*regbytes(a1)
    ld s0, 2*regbytes(a1)
    ld s1, 3*regbytes(a1)
    ld s2, 4*regbytes(a1)
    ld s3, 5*regbytes(a1)
    ld s4, 6*regbytes(a1)
    ld s5, 7*regbytes(a1)
    ld s6, 8*regbytes(a1)
    ld s7, 9*regbytes(a1)
    ld s8, 10*regbytes(a1)
    ld s9, 11*regbytes(a1)
    ld s10, 12*regbytes(a1)
    ld s11, 13*regbytes(a1)
    ret


__dummy:
    la a0, dummy
    csrrw x0, sepc, a0
    sret
    

_traps:
    # save 32 registers and sepc to stack
    # csrrw x0, sscratch, sp
    addi sp, sp, -33 * regbytes
    sd x0, 0*regbytes(sp)
    sd x1, 1*regbytes(sp)
    sd x3, 3*regbytes(sp)
    sd x4, 4*regbytes(sp)
    sd x5, 5*regbytes(sp)
    sd x6, 6*regbytes(sp)
    sd x7, 7*regbytes(sp)
    sd x8, 8*regbytes(sp)
    sd x9, 9*regbytes(sp)
    sd x10, 10*regbytes(sp)
    sd x11, 11*regbytes(sp)
    sd x12, 12*regbytes(sp)
    sd x13, 13*regbytes(sp)
    sd x14, 14*regbytes(sp)
    sd x15, 15*regbytes(sp)
    sd x16, 16*regbytes(sp)
    sd x17, 17*regbytes(sp)
    sd x18, 18*regbytes(sp)
    sd x19, 19*regbytes(sp)
    sd x20, 20*regbytes(sp)
    sd x21, 21*regbytes(sp)
    sd x22, 22*regbytes(sp)
    sd x23, 23*regbytes(sp)
    sd x24, 24*regbytes(sp)
    sd x25, 25*regbytes(sp)
    sd x26, 26*regbytes(sp)
    sd x27, 27*regbytes(sp)
    sd x28, 28*regbytes(sp)
    sd x29, 29*regbytes(sp)
    sd x30, 30*regbytes(sp)
    sd x31, 31*regbytes(sp)
    csrrs a0, sepc, x0
    sd a0, 32*regbytes(sp)
    sd sp, 2*regbytes(sp)

    # call trap_handler
    csrrw a0, scause, x0
    csrrw a1, sepc, x0
    call trap_handler
    
    # restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a0, 32*regbytes(sp)
    csrrw x0, sepc, a0
    ld x1, 1*regbytes(sp)
    ld x3, 3*regbytes(sp)
    ld x4, 4*regbytes(sp)
    ld x5, 5*regbytes(sp)
    ld x6, 6*regbytes(sp)
    ld x7, 7*regbytes(sp)
    ld x8, 8*regbytes(sp)
    ld x9, 9*regbytes(sp)
    ld x10, 10*regbytes(sp)
    ld x11, 11*regbytes(sp)
    ld x12, 12*regbytes(sp)
    ld x13, 13*regbytes(sp)
    ld x14, 14*regbytes(sp)
    ld x15, 15*regbytes(sp)
    ld x16, 16*regbytes(sp)
    ld x17, 17*regbytes(sp)
    ld x18, 18*regbytes(sp)
    ld x19, 19*regbytes(sp)
    ld x20, 20*regbytes(sp)
    ld x21, 21*regbytes(sp)
    ld x22, 22*regbytes(sp)
    ld x23, 23*regbytes(sp)
    ld x24, 24*regbytes(sp)
    ld x25, 25*regbytes(sp)
    ld x26, 26*regbytes(sp)
    ld x27, 27*regbytes(sp)
    ld x28, 28*regbytes(sp)
    ld x29, 29*regbytes(sp)
    ld x30, 30*regbytes(sp)
    ld x31, 31*regbytes(sp)
    ld x2, 2*regbytes(sp)
    addi sp, sp, 33 * regbytes
    # return from trap
    sret


    # 1. save 32 registers and sepc to stack
    # 2. call trap_handler
    # 3. restore sepc and 32 registers (x2(sp) should be restore last) from stack
    # regbytes. return from trap