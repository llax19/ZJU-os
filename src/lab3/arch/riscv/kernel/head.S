    .extern start_kernel
    .section .text.init
    .globl _start
    .extern task_init
    .extern mm_init
    .extern sbi_set_timer
    .extern setup_vm
    .extern early_pgtbl
    .extern setup_vm_final
    .extern _stext
    .extern _srodata
_start:
    
    # set sp with the top of boot_stack
    la sp, boot_stack_top 


    # set sstatus[SIE]=1
    csrrsi x0, sstatus, 2
    
    call setup_vm
    call relocate
     #memory init
    call mm_init

    call setup_vm_final

    # task init
    call task_init  
    
    # set stvec for trap
    la a0, _traps
    csrrw x0, stvec, a0

    # set the first timer interrupt
    rdtime a0
    call sbi_set_timer
    
    # set sie[stie]=1
    addi a0, x0, 32
    csrrs x0, sie, a0
    
    # j _srodata
    call start_kernel

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
    li a1, 0xffffffdf80000000
    add ra, ra, a1
    add sp, sp, a1

    # set stvec for vm_set
    la a0, SRET
    add a0, a0, a1
    csrw stvec, a0

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero

    # set satp with early_pgtbl
    # 要把early_pgtbl的地址右移12位, 高四位设置成0x8，存到satp里, 
    # early_pgtbl是物理地址
    la a0, early_pgtbl
    slli a0, a0, 8
    srli a0, a0, 20
    addi a1, x0, 8
    slli a1, a1, 60
    add a0, a0, a1
    csrw satp, a0
    ret
SRET:
    csrr a0, sepc
    li a1, 0xffffffdf80000000
    add a0, a0, a1
    csrw sepc, a0
    sret

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 # <-- change to your stack size

    .globl boot_stack_top
boot_stack_top: