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
    .extern clock_set_next_event
_start:
    
    la sp, boot_stack_top 

    
    call setup_vm
    call relocate
    call mm_init

    call setup_vm_final

    call task_init  

    la a0, _traps
    csrrw x0, stvec, a0
    call clock_set_next_event
    
    addi a0, x0, 32
    csrrs x0, sie, a0
    
    call start_kernel

relocate:
    li a1, 0xffffffdf80000000
    add ra, ra, a1
    add sp, sp, a1

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero

    la a0, early_pgtbl
    slli a0, a0, 8
    srli a0, a0, 20
    addi a1, x0, 8
    slli a1, a1, 60
    add a0, a0, a1
    csrw satp, a0
    ret

    .section .bss.stack
    .globl boot_stack
boot_stack:
    .space 4096 # <-- change to your stack size

    .globl boot_stack_top
boot_stack_top: