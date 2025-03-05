
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern _stext
    .extern _srodata
_start:
    
    # set sp with the top of boot_stack
    la sp, boot_stack_top 
ffffffe000200000:	00006117          	auipc	sp,0x6
ffffffe000200004:	00010113          	mv	sp,sp


    # set sstatus[SIE]=1
    csrrsi x0, sstatus, 2
ffffffe000200008:	10016073          	csrsi	sstatus,2
    
    call setup_vm
ffffffe00020000c:	601000ef          	jal	ffffffe000200e0c <setup_vm>
    call relocate
ffffffe000200010:	030000ef          	jal	ffffffe000200040 <relocate>
     #memory init
    call mm_init
ffffffe000200014:	404000ef          	jal	ffffffe000200418 <mm_init>

    call setup_vm_final
ffffffe000200018:	685000ef          	jal	ffffffe000200e9c <setup_vm_final>

    # task init
    call task_init  
ffffffe00020001c:	440000ef          	jal	ffffffe00020045c <task_init>
    
    # set stvec for trap
    la a0, _traps
ffffffe000200020:	00000517          	auipc	a0,0x0
ffffffe000200024:	10c50513          	addi	a0,a0,268 # ffffffe00020012c <_traps>
    csrrw x0, stvec, a0
ffffffe000200028:	10551073          	csrw	stvec,a0

    # set the first timer interrupt
    rdtime a0
ffffffe00020002c:	c0102573          	rdtime	a0
    call sbi_set_timer
ffffffe000200030:	4c1000ef          	jal	ffffffe000200cf0 <sbi_set_timer>
    
    # set sie[stie]=1
    addi a0, x0, 32
ffffffe000200034:	02000513          	li	a0,32
    csrrs x0, sie, a0
ffffffe000200038:	10452073          	csrs	sie,a0
    
    # j _srodata
    call start_kernel
ffffffe00020003c:	288010ef          	jal	ffffffe0002012c4 <start_kernel>

ffffffe000200040 <relocate>:

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
    li a1, 0xffffffdf80000000
ffffffe000200040:	fbf0059b          	addiw	a1,zero,-65
ffffffe000200044:	01f59593          	slli	a1,a1,0x1f
    add ra, ra, a1
ffffffe000200048:	00b080b3          	add	ra,ra,a1
    add sp, sp, a1
ffffffe00020004c:	00b10133          	add	sp,sp,a1

    # set stvec for vm_set
    la a0, SRET
ffffffe000200050:	00000517          	auipc	a0,0x0
ffffffe000200054:	03850513          	addi	a0,a0,56 # ffffffe000200088 <SRET>
    add a0, a0, a1
ffffffe000200058:	00b50533          	add	a0,a0,a1
    csrw stvec, a0
ffffffe00020005c:	10551073          	csrw	stvec,a0

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero
ffffffe000200060:	12000073          	sfence.vma

    # set satp with early_pgtbl
    # 要把early_pgtbl的地址右移12位, 高四位设置成0x8，存到satp里, 
    # early_pgtbl是物理地址
    la a0, early_pgtbl
ffffffe000200064:	00007517          	auipc	a0,0x7
ffffffe000200068:	f9c50513          	addi	a0,a0,-100 # ffffffe000207000 <early_pgtbl>
    slli a0, a0, 8
ffffffe00020006c:	00851513          	slli	a0,a0,0x8
    srli a0, a0, 20
ffffffe000200070:	01455513          	srli	a0,a0,0x14
    addi a1, x0, 8
ffffffe000200074:	00800593          	li	a1,8
    slli a1, a1, 60
ffffffe000200078:	03c59593          	slli	a1,a1,0x3c
    add a0, a0, a1
ffffffe00020007c:	00b50533          	add	a0,a0,a1
    csrw satp, a0
ffffffe000200080:	18051073          	csrw	satp,a0
    ret
ffffffe000200084:	00008067          	ret

ffffffe000200088 <SRET>:
SRET:
    csrr a0, sepc
ffffffe000200088:	14102573          	csrr	a0,sepc
    li a1, 0xffffffdf80000000
ffffffe00020008c:	fbf0059b          	addiw	a1,zero,-65
ffffffe000200090:	01f59593          	slli	a1,a1,0x1f
    add a0, a0, a1
ffffffe000200094:	00b50533          	add	a0,a0,a1
    csrw sepc, a0
ffffffe000200098:	14151073          	csrw	sepc,a0
    sret
ffffffe00020009c:	10200073          	sret

ffffffe0002000a0 <__switch_to>:
    .equ regbytes, 8
    .globl __switch_to

__switch_to:
    # save state to prev process
    addi a0, a0, 32 #a0 = prev->thread
ffffffe0002000a0:	02050513          	addi	a0,a0,32
    sd ra, 0*regbytes(a0)
ffffffe0002000a4:	00153023          	sd	ra,0(a0)
    sd sp, 1*regbytes(a0)
ffffffe0002000a8:	00253423          	sd	sp,8(a0)
    sd s0, 2*regbytes(a0)
ffffffe0002000ac:	00853823          	sd	s0,16(a0)
    sd s1, 3*regbytes(a0)
ffffffe0002000b0:	00953c23          	sd	s1,24(a0)
    sd s2, 4*regbytes(a0)
ffffffe0002000b4:	03253023          	sd	s2,32(a0)
    sd s3, 5*regbytes(a0)
ffffffe0002000b8:	03353423          	sd	s3,40(a0)
    sd s4, 6*regbytes(a0)
ffffffe0002000bc:	03453823          	sd	s4,48(a0)
    sd s5, 7*regbytes(a0)
ffffffe0002000c0:	03553c23          	sd	s5,56(a0)
    sd s6, 8*regbytes(a0)
ffffffe0002000c4:	05653023          	sd	s6,64(a0)
    sd s7, 9*regbytes(a0)
ffffffe0002000c8:	05753423          	sd	s7,72(a0)
    sd s8, 10*regbytes(a0)
ffffffe0002000cc:	05853823          	sd	s8,80(a0)
    sd s9, 11*regbytes(a0)
ffffffe0002000d0:	05953c23          	sd	s9,88(a0)
    sd s10, 12*regbytes(a0)
ffffffe0002000d4:	07a53023          	sd	s10,96(a0)
    sd s11, 13*regbytes(a0)
ffffffe0002000d8:	07b53423          	sd	s11,104(a0)



    # restore state from next process
    
    addi a1, a1, 32  #a1 = next->thread
ffffffe0002000dc:	02058593          	addi	a1,a1,32
    ld ra, 0*regbytes(a1)
ffffffe0002000e0:	0005b083          	ld	ra,0(a1)
    ld sp, 1*regbytes(a1)
ffffffe0002000e4:	0085b103          	ld	sp,8(a1)
    ld s0, 2*regbytes(a1)
ffffffe0002000e8:	0105b403          	ld	s0,16(a1)
    ld s1, 3*regbytes(a1)
ffffffe0002000ec:	0185b483          	ld	s1,24(a1)
    ld s2, 4*regbytes(a1)
ffffffe0002000f0:	0205b903          	ld	s2,32(a1)
    ld s3, 5*regbytes(a1)
ffffffe0002000f4:	0285b983          	ld	s3,40(a1)
    ld s4, 6*regbytes(a1)
ffffffe0002000f8:	0305ba03          	ld	s4,48(a1)
    ld s5, 7*regbytes(a1)
ffffffe0002000fc:	0385ba83          	ld	s5,56(a1)
    ld s6, 8*regbytes(a1)
ffffffe000200100:	0405bb03          	ld	s6,64(a1)
    ld s7, 9*regbytes(a1)
ffffffe000200104:	0485bb83          	ld	s7,72(a1)
    ld s8, 10*regbytes(a1)
ffffffe000200108:	0505bc03          	ld	s8,80(a1)
    ld s9, 11*regbytes(a1)
ffffffe00020010c:	0585bc83          	ld	s9,88(a1)
    ld s10, 12*regbytes(a1)
ffffffe000200110:	0605bd03          	ld	s10,96(a1)
    ld s11, 13*regbytes(a1)
ffffffe000200114:	0685bd83          	ld	s11,104(a1)
    ret
ffffffe000200118:	00008067          	ret

ffffffe00020011c <__dummy>:


__dummy:
    la a0, dummy
ffffffe00020011c:	00000517          	auipc	a0,0x0
ffffffe000200120:	53050513          	addi	a0,a0,1328 # ffffffe00020064c <dummy>
    csrrw x0, sepc, a0
ffffffe000200124:	14151073          	csrw	sepc,a0
    sret
ffffffe000200128:	10200073          	sret

ffffffe00020012c <_traps>:
    

_traps:
    # save 32 registers and sepc to stack
    # csrrw x0, sscratch, sp
    addi sp, sp, -33 * regbytes
ffffffe00020012c:	ef810113          	addi	sp,sp,-264 # ffffffe000205ef8 <_sbss+0xef8>
    sd x0, 0*regbytes(sp)
ffffffe000200130:	00013023          	sd	zero,0(sp)
    sd x1, 1*regbytes(sp)
ffffffe000200134:	00113423          	sd	ra,8(sp)
    sd x3, 3*regbytes(sp)
ffffffe000200138:	00313c23          	sd	gp,24(sp)
    sd x4, 4*regbytes(sp)
ffffffe00020013c:	02413023          	sd	tp,32(sp)
    sd x5, 5*regbytes(sp)
ffffffe000200140:	02513423          	sd	t0,40(sp)
    sd x6, 6*regbytes(sp)
ffffffe000200144:	02613823          	sd	t1,48(sp)
    sd x7, 7*regbytes(sp)
ffffffe000200148:	02713c23          	sd	t2,56(sp)
    sd x8, 8*regbytes(sp)
ffffffe00020014c:	04813023          	sd	s0,64(sp)
    sd x9, 9*regbytes(sp)
ffffffe000200150:	04913423          	sd	s1,72(sp)
    sd x10, 10*regbytes(sp)
ffffffe000200154:	04a13823          	sd	a0,80(sp)
    sd x11, 11*regbytes(sp)
ffffffe000200158:	04b13c23          	sd	a1,88(sp)
    sd x12, 12*regbytes(sp)
ffffffe00020015c:	06c13023          	sd	a2,96(sp)
    sd x13, 13*regbytes(sp)
ffffffe000200160:	06d13423          	sd	a3,104(sp)
    sd x14, 14*regbytes(sp)
ffffffe000200164:	06e13823          	sd	a4,112(sp)
    sd x15, 15*regbytes(sp)
ffffffe000200168:	06f13c23          	sd	a5,120(sp)
    sd x16, 16*regbytes(sp)
ffffffe00020016c:	09013023          	sd	a6,128(sp)
    sd x17, 17*regbytes(sp)
ffffffe000200170:	09113423          	sd	a7,136(sp)
    sd x18, 18*regbytes(sp)
ffffffe000200174:	09213823          	sd	s2,144(sp)
    sd x19, 19*regbytes(sp)
ffffffe000200178:	09313c23          	sd	s3,152(sp)
    sd x20, 20*regbytes(sp)
ffffffe00020017c:	0b413023          	sd	s4,160(sp)
    sd x21, 21*regbytes(sp)
ffffffe000200180:	0b513423          	sd	s5,168(sp)
    sd x22, 22*regbytes(sp)
ffffffe000200184:	0b613823          	sd	s6,176(sp)
    sd x23, 23*regbytes(sp)
ffffffe000200188:	0b713c23          	sd	s7,184(sp)
    sd x24, 24*regbytes(sp)
ffffffe00020018c:	0d813023          	sd	s8,192(sp)
    sd x25, 25*regbytes(sp)
ffffffe000200190:	0d913423          	sd	s9,200(sp)
    sd x26, 26*regbytes(sp)
ffffffe000200194:	0da13823          	sd	s10,208(sp)
    sd x27, 27*regbytes(sp)
ffffffe000200198:	0db13c23          	sd	s11,216(sp)
    sd x28, 28*regbytes(sp)
ffffffe00020019c:	0fc13023          	sd	t3,224(sp)
    sd x29, 29*regbytes(sp)
ffffffe0002001a0:	0fd13423          	sd	t4,232(sp)
    sd x30, 30*regbytes(sp)
ffffffe0002001a4:	0fe13823          	sd	t5,240(sp)
    sd x31, 31*regbytes(sp)
ffffffe0002001a8:	0ff13c23          	sd	t6,248(sp)
    csrrs a0, sepc, x0
ffffffe0002001ac:	14102573          	csrr	a0,sepc
    sd a0, 32*regbytes(sp)
ffffffe0002001b0:	10a13023          	sd	a0,256(sp)
    sd sp, 2*regbytes(sp)
ffffffe0002001b4:	00213823          	sd	sp,16(sp)

    # call trap_handler
    csrrw a0, scause, x0
ffffffe0002001b8:	14201573          	csrrw	a0,scause,zero
    csrrw a1, sepc, x0
ffffffe0002001bc:	141015f3          	csrrw	a1,sepc,zero
    call trap_handler
ffffffe0002001c0:	3bd000ef          	jal	ffffffe000200d7c <trap_handler>
    
    # restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a0, 32*regbytes(sp)
ffffffe0002001c4:	10013503          	ld	a0,256(sp)
    csrrw x0, sepc, a0
ffffffe0002001c8:	14151073          	csrw	sepc,a0
    ld x1, 1*regbytes(sp)
ffffffe0002001cc:	00813083          	ld	ra,8(sp)
    ld x3, 3*regbytes(sp)
ffffffe0002001d0:	01813183          	ld	gp,24(sp)
    ld x4, 4*regbytes(sp)
ffffffe0002001d4:	02013203          	ld	tp,32(sp)
    ld x5, 5*regbytes(sp)
ffffffe0002001d8:	02813283          	ld	t0,40(sp)
    ld x6, 6*regbytes(sp)
ffffffe0002001dc:	03013303          	ld	t1,48(sp)
    ld x7, 7*regbytes(sp)
ffffffe0002001e0:	03813383          	ld	t2,56(sp)
    ld x8, 8*regbytes(sp)
ffffffe0002001e4:	04013403          	ld	s0,64(sp)
    ld x9, 9*regbytes(sp)
ffffffe0002001e8:	04813483          	ld	s1,72(sp)
    ld x10, 10*regbytes(sp)
ffffffe0002001ec:	05013503          	ld	a0,80(sp)
    ld x11, 11*regbytes(sp)
ffffffe0002001f0:	05813583          	ld	a1,88(sp)
    ld x12, 12*regbytes(sp)
ffffffe0002001f4:	06013603          	ld	a2,96(sp)
    ld x13, 13*regbytes(sp)
ffffffe0002001f8:	06813683          	ld	a3,104(sp)
    ld x14, 14*regbytes(sp)
ffffffe0002001fc:	07013703          	ld	a4,112(sp)
    ld x15, 15*regbytes(sp)
ffffffe000200200:	07813783          	ld	a5,120(sp)
    ld x16, 16*regbytes(sp)
ffffffe000200204:	08013803          	ld	a6,128(sp)
    ld x17, 17*regbytes(sp)
ffffffe000200208:	08813883          	ld	a7,136(sp)
    ld x18, 18*regbytes(sp)
ffffffe00020020c:	09013903          	ld	s2,144(sp)
    ld x19, 19*regbytes(sp)
ffffffe000200210:	09813983          	ld	s3,152(sp)
    ld x20, 20*regbytes(sp)
ffffffe000200214:	0a013a03          	ld	s4,160(sp)
    ld x21, 21*regbytes(sp)
ffffffe000200218:	0a813a83          	ld	s5,168(sp)
    ld x22, 22*regbytes(sp)
ffffffe00020021c:	0b013b03          	ld	s6,176(sp)
    ld x23, 23*regbytes(sp)
ffffffe000200220:	0b813b83          	ld	s7,184(sp)
    ld x24, 24*regbytes(sp)
ffffffe000200224:	0c013c03          	ld	s8,192(sp)
    ld x25, 25*regbytes(sp)
ffffffe000200228:	0c813c83          	ld	s9,200(sp)
    ld x26, 26*regbytes(sp)
ffffffe00020022c:	0d013d03          	ld	s10,208(sp)
    ld x27, 27*regbytes(sp)
ffffffe000200230:	0d813d83          	ld	s11,216(sp)
    ld x28, 28*regbytes(sp)
ffffffe000200234:	0e013e03          	ld	t3,224(sp)
    ld x29, 29*regbytes(sp)
ffffffe000200238:	0e813e83          	ld	t4,232(sp)
    ld x30, 30*regbytes(sp)
ffffffe00020023c:	0f013f03          	ld	t5,240(sp)
    ld x31, 31*regbytes(sp)
ffffffe000200240:	0f813f83          	ld	t6,248(sp)
    ld x2, 2*regbytes(sp)
ffffffe000200244:	01013103          	ld	sp,16(sp)
    addi sp, sp, 33 * regbytes
ffffffe000200248:	10810113          	addi	sp,sp,264
    # return from trap
    sret
ffffffe00020024c:	10200073          	sret

ffffffe000200250 <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe000200250:	fe010113          	addi	sp,sp,-32
ffffffe000200254:	00813c23          	sd	s0,24(sp)
ffffffe000200258:	02010413          	addi	s0,sp,32
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe00020025c:	c01027f3          	rdtime	a5
ffffffe000200260:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe000200264:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200268:	00078513          	mv	a0,a5
ffffffe00020026c:	01813403          	ld	s0,24(sp)
ffffffe000200270:	02010113          	addi	sp,sp,32
ffffffe000200274:	00008067          	ret

ffffffe000200278 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe000200278:	fe010113          	addi	sp,sp,-32
ffffffe00020027c:	00113c23          	sd	ra,24(sp)
ffffffe000200280:	00813823          	sd	s0,16(sp)
ffffffe000200284:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe000200288:	fc9ff0ef          	jal	ffffffe000200250 <get_cycles>
ffffffe00020028c:	00050713          	mv	a4,a0
ffffffe000200290:	00004797          	auipc	a5,0x4
ffffffe000200294:	d7078793          	addi	a5,a5,-656 # ffffffe000204000 <TIMECLOCK>
ffffffe000200298:	0007b783          	ld	a5,0(a5)
ffffffe00020029c:	00f707b3          	add	a5,a4,a5
ffffffe0002002a0:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe0002002a4:	fe843503          	ld	a0,-24(s0)
ffffffe0002002a8:	249000ef          	jal	ffffffe000200cf0 <sbi_set_timer>
ffffffe0002002ac:	00000013          	nop
ffffffe0002002b0:	01813083          	ld	ra,24(sp)
ffffffe0002002b4:	01013403          	ld	s0,16(sp)
ffffffe0002002b8:	02010113          	addi	sp,sp,32
ffffffe0002002bc:	00008067          	ret

ffffffe0002002c0 <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
ffffffe0002002c0:	fe010113          	addi	sp,sp,-32
ffffffe0002002c4:	00113c23          	sd	ra,24(sp)
ffffffe0002002c8:	00813823          	sd	s0,16(sp)
ffffffe0002002cc:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
ffffffe0002002d0:	00006797          	auipc	a5,0x6
ffffffe0002002d4:	d3078793          	addi	a5,a5,-720 # ffffffe000206000 <kmem>
ffffffe0002002d8:	0007b783          	ld	a5,0(a5)
ffffffe0002002dc:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
ffffffe0002002e0:	fe843783          	ld	a5,-24(s0)
ffffffe0002002e4:	0007b703          	ld	a4,0(a5)
ffffffe0002002e8:	00006797          	auipc	a5,0x6
ffffffe0002002ec:	d1878793          	addi	a5,a5,-744 # ffffffe000206000 <kmem>
ffffffe0002002f0:	00e7b023          	sd	a4,0(a5)
    
    memset((void *)r, 0x0, PGSIZE);
ffffffe0002002f4:	00001637          	lui	a2,0x1
ffffffe0002002f8:	00000593          	li	a1,0
ffffffe0002002fc:	fe843503          	ld	a0,-24(s0)
ffffffe000200300:	00c020ef          	jal	ffffffe00020230c <memset>
    return (void *)r;
ffffffe000200304:	fe843783          	ld	a5,-24(s0)
}
ffffffe000200308:	00078513          	mv	a0,a5
ffffffe00020030c:	01813083          	ld	ra,24(sp)
ffffffe000200310:	01013403          	ld	s0,16(sp)
ffffffe000200314:	02010113          	addi	sp,sp,32
ffffffe000200318:	00008067          	ret

ffffffe00020031c <kfree>:

void kfree(void *addr) {
ffffffe00020031c:	fd010113          	addi	sp,sp,-48
ffffffe000200320:	02113423          	sd	ra,40(sp)
ffffffe000200324:	02813023          	sd	s0,32(sp)
ffffffe000200328:	03010413          	addi	s0,sp,48
ffffffe00020032c:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
ffffffe000200330:	fd843783          	ld	a5,-40(s0)
ffffffe000200334:	00078693          	mv	a3,a5
ffffffe000200338:	fd840793          	addi	a5,s0,-40
ffffffe00020033c:	fffff737          	lui	a4,0xfffff
ffffffe000200340:	00e6f733          	and	a4,a3,a4
ffffffe000200344:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
ffffffe000200348:	fd843783          	ld	a5,-40(s0)
ffffffe00020034c:	00001637          	lui	a2,0x1
ffffffe000200350:	00000593          	li	a1,0
ffffffe000200354:	00078513          	mv	a0,a5
ffffffe000200358:	7b5010ef          	jal	ffffffe00020230c <memset>

    r = (struct run *)addr;
ffffffe00020035c:	fd843783          	ld	a5,-40(s0)
ffffffe000200360:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
ffffffe000200364:	00006797          	auipc	a5,0x6
ffffffe000200368:	c9c78793          	addi	a5,a5,-868 # ffffffe000206000 <kmem>
ffffffe00020036c:	0007b703          	ld	a4,0(a5)
ffffffe000200370:	fe843783          	ld	a5,-24(s0)
ffffffe000200374:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
ffffffe000200378:	00006797          	auipc	a5,0x6
ffffffe00020037c:	c8878793          	addi	a5,a5,-888 # ffffffe000206000 <kmem>
ffffffe000200380:	fe843703          	ld	a4,-24(s0)
ffffffe000200384:	00e7b023          	sd	a4,0(a5)

    return;
ffffffe000200388:	00000013          	nop
}
ffffffe00020038c:	02813083          	ld	ra,40(sp)
ffffffe000200390:	02013403          	ld	s0,32(sp)
ffffffe000200394:	03010113          	addi	sp,sp,48
ffffffe000200398:	00008067          	ret

ffffffe00020039c <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe00020039c:	fd010113          	addi	sp,sp,-48
ffffffe0002003a0:	02113423          	sd	ra,40(sp)
ffffffe0002003a4:	02813023          	sd	s0,32(sp)
ffffffe0002003a8:	03010413          	addi	s0,sp,48
ffffffe0002003ac:	fca43c23          	sd	a0,-40(s0)
ffffffe0002003b0:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe0002003b4:	fd843703          	ld	a4,-40(s0)
ffffffe0002003b8:	000017b7          	lui	a5,0x1
ffffffe0002003bc:	fff78793          	addi	a5,a5,-1 # fff <regbytes+0xff7>
ffffffe0002003c0:	00f70733          	add	a4,a4,a5
ffffffe0002003c4:	fffff7b7          	lui	a5,0xfffff
ffffffe0002003c8:	00f777b3          	and	a5,a4,a5
ffffffe0002003cc:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe0002003d0:	01c0006f          	j	ffffffe0002003ec <kfreerange+0x50>
        kfree((void *)addr);
ffffffe0002003d4:	fe843503          	ld	a0,-24(s0)
ffffffe0002003d8:	f45ff0ef          	jal	ffffffe00020031c <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe0002003dc:	fe843703          	ld	a4,-24(s0)
ffffffe0002003e0:	000017b7          	lui	a5,0x1
ffffffe0002003e4:	00f707b3          	add	a5,a4,a5
ffffffe0002003e8:	fef43423          	sd	a5,-24(s0)
ffffffe0002003ec:	fe843703          	ld	a4,-24(s0)
ffffffe0002003f0:	000017b7          	lui	a5,0x1
ffffffe0002003f4:	00f70733          	add	a4,a4,a5
ffffffe0002003f8:	fd043783          	ld	a5,-48(s0)
ffffffe0002003fc:	fce7fce3          	bgeu	a5,a4,ffffffe0002003d4 <kfreerange+0x38>
    }
}
ffffffe000200400:	00000013          	nop
ffffffe000200404:	00000013          	nop
ffffffe000200408:	02813083          	ld	ra,40(sp)
ffffffe00020040c:	02013403          	ld	s0,32(sp)
ffffffe000200410:	03010113          	addi	sp,sp,48
ffffffe000200414:	00008067          	ret

ffffffe000200418 <mm_init>:

void mm_init(void) {
ffffffe000200418:	ff010113          	addi	sp,sp,-16
ffffffe00020041c:	00113423          	sd	ra,8(sp)
ffffffe000200420:	00813023          	sd	s0,0(sp)
ffffffe000200424:	01010413          	addi	s0,sp,16
    kfreerange(_ekernel, (char *)(PHY_END + PA2VA_OFFSET));
ffffffe000200428:	c0100793          	li	a5,-1023
ffffffe00020042c:	01b79593          	slli	a1,a5,0x1b
ffffffe000200430:	00009517          	auipc	a0,0x9
ffffffe000200434:	bd050513          	addi	a0,a0,-1072 # ffffffe000209000 <_ebss>
ffffffe000200438:	f65ff0ef          	jal	ffffffe00020039c <kfreerange>
    printk("...mm_init done!\n");
ffffffe00020043c:	00003517          	auipc	a0,0x3
ffffffe000200440:	bc450513          	addi	a0,a0,-1084 # ffffffe000203000 <_srodata>
ffffffe000200444:	5a9010ef          	jal	ffffffe0002021ec <printk>
}
ffffffe000200448:	00000013          	nop
ffffffe00020044c:	00813083          	ld	ra,8(sp)
ffffffe000200450:	00013403          	ld	s0,0(sp)
ffffffe000200454:	01010113          	addi	sp,sp,16
ffffffe000200458:	00008067          	ret

ffffffe00020045c <task_init>:

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
ffffffe00020045c:	fd010113          	addi	sp,sp,-48
ffffffe000200460:	02113423          	sd	ra,40(sp)
ffffffe000200464:	02813023          	sd	s0,32(sp)
ffffffe000200468:	03010413          	addi	s0,sp,48
    srand(2024);
ffffffe00020046c:	7e800513          	li	a0,2024
ffffffe000200470:	5fd010ef          	jal	ffffffe00020226c <srand>
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    char * PageLow = (char *)kalloc();
ffffffe000200474:	e4dff0ef          	jal	ffffffe0002002c0 <kalloc>
ffffffe000200478:	fea43023          	sd	a0,-32(s0)
    idle = (struct task_struct *)PageLow;
ffffffe00020047c:	00006797          	auipc	a5,0x6
ffffffe000200480:	b8c78793          	addi	a5,a5,-1140 # ffffffe000206008 <idle>
ffffffe000200484:	fe043703          	ld	a4,-32(s0)
ffffffe000200488:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe00020048c:	00006797          	auipc	a5,0x6
ffffffe000200490:	b7c78793          	addi	a5,a5,-1156 # ffffffe000206008 <idle>
ffffffe000200494:	0007b783          	ld	a5,0(a5)
ffffffe000200498:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe00020049c:	00006797          	auipc	a5,0x6
ffffffe0002004a0:	b6c78793          	addi	a5,a5,-1172 # ffffffe000206008 <idle>
ffffffe0002004a4:	0007b783          	ld	a5,0(a5)
ffffffe0002004a8:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe0002004ac:	00006797          	auipc	a5,0x6
ffffffe0002004b0:	b5c78793          	addi	a5,a5,-1188 # ffffffe000206008 <idle>
ffffffe0002004b4:	0007b783          	ld	a5,0(a5)
ffffffe0002004b8:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe0002004bc:	00006797          	auipc	a5,0x6
ffffffe0002004c0:	b4c78793          	addi	a5,a5,-1204 # ffffffe000206008 <idle>
ffffffe0002004c4:	0007b783          	ld	a5,0(a5)
ffffffe0002004c8:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe0002004cc:	00006797          	auipc	a5,0x6
ffffffe0002004d0:	b3c78793          	addi	a5,a5,-1220 # ffffffe000206008 <idle>
ffffffe0002004d4:	0007b703          	ld	a4,0(a5)
ffffffe0002004d8:	00006797          	auipc	a5,0x6
ffffffe0002004dc:	b3878793          	addi	a5,a5,-1224 # ffffffe000206010 <current>
ffffffe0002004e0:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe0002004e4:	00006797          	auipc	a5,0x6
ffffffe0002004e8:	b2478793          	addi	a5,a5,-1244 # ffffffe000206008 <idle>
ffffffe0002004ec:	0007b703          	ld	a4,0(a5)
ffffffe0002004f0:	00006797          	auipc	a5,0x6
ffffffe0002004f4:	b3078793          	addi	a5,a5,-1232 # ffffffe000206020 <task>
ffffffe0002004f8:	00e7b023          	sd	a4,0(a5)
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (int i=1 ;i<NR_TASKS; i++){
ffffffe0002004fc:	00100793          	li	a5,1
ffffffe000200500:	fef42623          	sw	a5,-20(s0)
ffffffe000200504:	1180006f          	j	ffffffe00020061c <task_init+0x1c0>
        char * PageLow = (char *)kalloc();
ffffffe000200508:	db9ff0ef          	jal	ffffffe0002002c0 <kalloc>
ffffffe00020050c:	fca43c23          	sd	a0,-40(s0)
        task[i] = (struct task_struct *)PageLow;
ffffffe000200510:	00006717          	auipc	a4,0x6
ffffffe000200514:	b1070713          	addi	a4,a4,-1264 # ffffffe000206020 <task>
ffffffe000200518:	fec42783          	lw	a5,-20(s0)
ffffffe00020051c:	00379793          	slli	a5,a5,0x3
ffffffe000200520:	00f707b3          	add	a5,a4,a5
ffffffe000200524:	fd843703          	ld	a4,-40(s0)
ffffffe000200528:	00e7b023          	sd	a4,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe00020052c:	00006717          	auipc	a4,0x6
ffffffe000200530:	af470713          	addi	a4,a4,-1292 # ffffffe000206020 <task>
ffffffe000200534:	fec42783          	lw	a5,-20(s0)
ffffffe000200538:	00379793          	slli	a5,a5,0x3
ffffffe00020053c:	00f707b3          	add	a5,a4,a5
ffffffe000200540:	0007b783          	ld	a5,0(a5)
ffffffe000200544:	0007b023          	sd	zero,0(a5)
        task[i]->counter = 0;
ffffffe000200548:	00006717          	auipc	a4,0x6
ffffffe00020054c:	ad870713          	addi	a4,a4,-1320 # ffffffe000206020 <task>
ffffffe000200550:	fec42783          	lw	a5,-20(s0)
ffffffe000200554:	00379793          	slli	a5,a5,0x3
ffffffe000200558:	00f707b3          	add	a5,a4,a5
ffffffe00020055c:	0007b783          	ld	a5,0(a5)
ffffffe000200560:	0007b423          	sd	zero,8(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200564:	54d010ef          	jal	ffffffe0002022b0 <rand>
ffffffe000200568:	00050793          	mv	a5,a0
ffffffe00020056c:	00078713          	mv	a4,a5
ffffffe000200570:	00a00793          	li	a5,10
ffffffe000200574:	02f767bb          	remw	a5,a4,a5
ffffffe000200578:	0007879b          	sext.w	a5,a5
ffffffe00020057c:	0017879b          	addiw	a5,a5,1
ffffffe000200580:	0007869b          	sext.w	a3,a5
ffffffe000200584:	00006717          	auipc	a4,0x6
ffffffe000200588:	a9c70713          	addi	a4,a4,-1380 # ffffffe000206020 <task>
ffffffe00020058c:	fec42783          	lw	a5,-20(s0)
ffffffe000200590:	00379793          	slli	a5,a5,0x3
ffffffe000200594:	00f707b3          	add	a5,a4,a5
ffffffe000200598:	0007b783          	ld	a5,0(a5)
ffffffe00020059c:	00068713          	mv	a4,a3
ffffffe0002005a0:	00e7b823          	sd	a4,16(a5)
        task[i]->pid = i;
ffffffe0002005a4:	00006717          	auipc	a4,0x6
ffffffe0002005a8:	a7c70713          	addi	a4,a4,-1412 # ffffffe000206020 <task>
ffffffe0002005ac:	fec42783          	lw	a5,-20(s0)
ffffffe0002005b0:	00379793          	slli	a5,a5,0x3
ffffffe0002005b4:	00f707b3          	add	a5,a4,a5
ffffffe0002005b8:	0007b783          	ld	a5,0(a5)
ffffffe0002005bc:	fec42703          	lw	a4,-20(s0)
ffffffe0002005c0:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe0002005c4:	00006717          	auipc	a4,0x6
ffffffe0002005c8:	a5c70713          	addi	a4,a4,-1444 # ffffffe000206020 <task>
ffffffe0002005cc:	fec42783          	lw	a5,-20(s0)
ffffffe0002005d0:	00379793          	slli	a5,a5,0x3
ffffffe0002005d4:	00f707b3          	add	a5,a4,a5
ffffffe0002005d8:	0007b783          	ld	a5,0(a5)
ffffffe0002005dc:	00000717          	auipc	a4,0x0
ffffffe0002005e0:	b4070713          	addi	a4,a4,-1216 # ffffffe00020011c <__dummy>
ffffffe0002005e4:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)PageLow + PGSIZE;
ffffffe0002005e8:	fd843683          	ld	a3,-40(s0)
ffffffe0002005ec:	00006717          	auipc	a4,0x6
ffffffe0002005f0:	a3470713          	addi	a4,a4,-1484 # ffffffe000206020 <task>
ffffffe0002005f4:	fec42783          	lw	a5,-20(s0)
ffffffe0002005f8:	00379793          	slli	a5,a5,0x3
ffffffe0002005fc:	00f707b3          	add	a5,a4,a5
ffffffe000200600:	0007b783          	ld	a5,0(a5)
ffffffe000200604:	00001737          	lui	a4,0x1
ffffffe000200608:	00e68733          	add	a4,a3,a4
ffffffe00020060c:	02e7b423          	sd	a4,40(a5)
    for (int i=1 ;i<NR_TASKS; i++){
ffffffe000200610:	fec42783          	lw	a5,-20(s0)
ffffffe000200614:	0017879b          	addiw	a5,a5,1
ffffffe000200618:	fef42623          	sw	a5,-20(s0)
ffffffe00020061c:	fec42783          	lw	a5,-20(s0)
ffffffe000200620:	0007871b          	sext.w	a4,a5
ffffffe000200624:	01f00793          	li	a5,31
ffffffe000200628:	eee7d0e3          	bge	a5,a4,ffffffe000200508 <task_init+0xac>
    }

    printk("...task_init done!\n");
ffffffe00020062c:	00003517          	auipc	a0,0x3
ffffffe000200630:	9ec50513          	addi	a0,a0,-1556 # ffffffe000203018 <_srodata+0x18>
ffffffe000200634:	3b9010ef          	jal	ffffffe0002021ec <printk>
}
ffffffe000200638:	00000013          	nop
ffffffe00020063c:	02813083          	ld	ra,40(sp)
ffffffe000200640:	02013403          	ld	s0,32(sp)
ffffffe000200644:	03010113          	addi	sp,sp,48
ffffffe000200648:	00008067          	ret

ffffffe00020064c <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
ffffffe00020064c:	fd010113          	addi	sp,sp,-48
ffffffe000200650:	02113423          	sd	ra,40(sp)
ffffffe000200654:	02813023          	sd	s0,32(sp)
ffffffe000200658:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe00020065c:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000200660:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000200664:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000200668:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe00020066c:	fff00793          	li	a5,-1
ffffffe000200670:	fef42223          	sw	a5,-28(s0)
    printk("First in dummy: current counter = %d\n", current->counter);
ffffffe000200674:	00006797          	auipc	a5,0x6
ffffffe000200678:	99c78793          	addi	a5,a5,-1636 # ffffffe000206010 <current>
ffffffe00020067c:	0007b783          	ld	a5,0(a5)
ffffffe000200680:	0087b783          	ld	a5,8(a5)
ffffffe000200684:	00078593          	mv	a1,a5
ffffffe000200688:	00003517          	auipc	a0,0x3
ffffffe00020068c:	9a850513          	addi	a0,a0,-1624 # ffffffe000203030 <_srodata+0x30>
ffffffe000200690:	35d010ef          	jal	ffffffe0002021ec <printk>
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200694:	fe442783          	lw	a5,-28(s0)
ffffffe000200698:	0007871b          	sext.w	a4,a5
ffffffe00020069c:	fff00793          	li	a5,-1
ffffffe0002006a0:	00f70e63          	beq	a4,a5,ffffffe0002006bc <dummy+0x70>
ffffffe0002006a4:	00006797          	auipc	a5,0x6
ffffffe0002006a8:	96c78793          	addi	a5,a5,-1684 # ffffffe000206010 <current>
ffffffe0002006ac:	0007b783          	ld	a5,0(a5)
ffffffe0002006b0:	0087b703          	ld	a4,8(a5)
ffffffe0002006b4:	fe442783          	lw	a5,-28(s0)
ffffffe0002006b8:	fcf70ee3          	beq	a4,a5,ffffffe000200694 <dummy+0x48>
ffffffe0002006bc:	00006797          	auipc	a5,0x6
ffffffe0002006c0:	95478793          	addi	a5,a5,-1708 # ffffffe000206010 <current>
ffffffe0002006c4:	0007b783          	ld	a5,0(a5)
ffffffe0002006c8:	0087b783          	ld	a5,8(a5)
ffffffe0002006cc:	fc0784e3          	beqz	a5,ffffffe000200694 <dummy+0x48>
            if (current->counter == 1) {
ffffffe0002006d0:	00006797          	auipc	a5,0x6
ffffffe0002006d4:	94078793          	addi	a5,a5,-1728 # ffffffe000206010 <current>
ffffffe0002006d8:	0007b783          	ld	a5,0(a5)
ffffffe0002006dc:	0087b703          	ld	a4,8(a5)
ffffffe0002006e0:	00100793          	li	a5,1
ffffffe0002006e4:	00f71e63          	bne	a4,a5,ffffffe000200700 <dummy+0xb4>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe0002006e8:	00006797          	auipc	a5,0x6
ffffffe0002006ec:	92878793          	addi	a5,a5,-1752 # ffffffe000206010 <current>
ffffffe0002006f0:	0007b783          	ld	a5,0(a5)
ffffffe0002006f4:	0087b703          	ld	a4,8(a5)
ffffffe0002006f8:	fff70713          	addi	a4,a4,-1 # fff <regbytes+0xff7>
ffffffe0002006fc:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe000200700:	00006797          	auipc	a5,0x6
ffffffe000200704:	91078793          	addi	a5,a5,-1776 # ffffffe000206010 <current>
ffffffe000200708:	0007b783          	ld	a5,0(a5)
ffffffe00020070c:	0087b783          	ld	a5,8(a5)
ffffffe000200710:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000200714:	fe843783          	ld	a5,-24(s0)
ffffffe000200718:	00178713          	addi	a4,a5,1
ffffffe00020071c:	fd843783          	ld	a5,-40(s0)
ffffffe000200720:	02f777b3          	remu	a5,a4,a5
ffffffe000200724:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d, current counter = %d\n", current->pid, auto_inc_local_var, current->counter);
ffffffe000200728:	00006797          	auipc	a5,0x6
ffffffe00020072c:	8e878793          	addi	a5,a5,-1816 # ffffffe000206010 <current>
ffffffe000200730:	0007b783          	ld	a5,0(a5)
ffffffe000200734:	0187b703          	ld	a4,24(a5)
ffffffe000200738:	00006797          	auipc	a5,0x6
ffffffe00020073c:	8d878793          	addi	a5,a5,-1832 # ffffffe000206010 <current>
ffffffe000200740:	0007b783          	ld	a5,0(a5)
ffffffe000200744:	0087b783          	ld	a5,8(a5)
ffffffe000200748:	00078693          	mv	a3,a5
ffffffe00020074c:	fe843603          	ld	a2,-24(s0)
ffffffe000200750:	00070593          	mv	a1,a4
ffffffe000200754:	00003517          	auipc	a0,0x3
ffffffe000200758:	90450513          	addi	a0,a0,-1788 # ffffffe000203058 <_srodata+0x58>
ffffffe00020075c:	291010ef          	jal	ffffffe0002021ec <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200760:	f35ff06f          	j	ffffffe000200694 <dummy+0x48>

ffffffe000200764 <switch_to>:
    }
}

extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void switch_to(struct task_struct *next) {
ffffffe000200764:	fd010113          	addi	sp,sp,-48
ffffffe000200768:	02113423          	sd	ra,40(sp)
ffffffe00020076c:	02813023          	sd	s0,32(sp)
ffffffe000200770:	03010413          	addi	s0,sp,48
ffffffe000200774:	fca43c23          	sd	a0,-40(s0)
    if (current != next) {
ffffffe000200778:	00006797          	auipc	a5,0x6
ffffffe00020077c:	89878793          	addi	a5,a5,-1896 # ffffffe000206010 <current>
ffffffe000200780:	0007b783          	ld	a5,0(a5)
ffffffe000200784:	fd843703          	ld	a4,-40(s0)
ffffffe000200788:	08f70063          	beq	a4,a5,ffffffe000200808 <switch_to+0xa4>
        struct task_struct *prev = current;
ffffffe00020078c:	00006797          	auipc	a5,0x6
ffffffe000200790:	88478793          	addi	a5,a5,-1916 # ffffffe000206010 <current>
ffffffe000200794:	0007b783          	ld	a5,0(a5)
ffffffe000200798:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe00020079c:	00006797          	auipc	a5,0x6
ffffffe0002007a0:	87478793          	addi	a5,a5,-1932 # ffffffe000206010 <current>
ffffffe0002007a4:	fd843703          	ld	a4,-40(s0)
ffffffe0002007a8:	00e7b023          	sd	a4,0(a5)
        printk("Switch to PID=%d counter=%d priority=%d\n", current->pid, current->counter, current->priority);
ffffffe0002007ac:	00006797          	auipc	a5,0x6
ffffffe0002007b0:	86478793          	addi	a5,a5,-1948 # ffffffe000206010 <current>
ffffffe0002007b4:	0007b783          	ld	a5,0(a5)
ffffffe0002007b8:	0187b703          	ld	a4,24(a5)
ffffffe0002007bc:	00006797          	auipc	a5,0x6
ffffffe0002007c0:	85478793          	addi	a5,a5,-1964 # ffffffe000206010 <current>
ffffffe0002007c4:	0007b783          	ld	a5,0(a5)
ffffffe0002007c8:	0087b603          	ld	a2,8(a5)
ffffffe0002007cc:	00006797          	auipc	a5,0x6
ffffffe0002007d0:	84478793          	addi	a5,a5,-1980 # ffffffe000206010 <current>
ffffffe0002007d4:	0007b783          	ld	a5,0(a5)
ffffffe0002007d8:	0107b783          	ld	a5,16(a5)
ffffffe0002007dc:	00078693          	mv	a3,a5
ffffffe0002007e0:	00070593          	mv	a1,a4
ffffffe0002007e4:	00003517          	auipc	a0,0x3
ffffffe0002007e8:	8bc50513          	addi	a0,a0,-1860 # ffffffe0002030a0 <_srodata+0xa0>
ffffffe0002007ec:	201010ef          	jal	ffffffe0002021ec <printk>
        __switch_to(prev, current);
ffffffe0002007f0:	00006797          	auipc	a5,0x6
ffffffe0002007f4:	82078793          	addi	a5,a5,-2016 # ffffffe000206010 <current>
ffffffe0002007f8:	0007b783          	ld	a5,0(a5)
ffffffe0002007fc:	00078593          	mv	a1,a5
ffffffe000200800:	fe843503          	ld	a0,-24(s0)
ffffffe000200804:	89dff0ef          	jal	ffffffe0002000a0 <__switch_to>
        
    }
}
ffffffe000200808:	00000013          	nop
ffffffe00020080c:	02813083          	ld	ra,40(sp)
ffffffe000200810:	02013403          	ld	s0,32(sp)
ffffffe000200814:	03010113          	addi	sp,sp,48
ffffffe000200818:	00008067          	ret

ffffffe00020081c <do_timer>:

void do_timer() {
ffffffe00020081c:	ff010113          	addi	sp,sp,-16
ffffffe000200820:	00113423          	sd	ra,8(sp)
ffffffe000200824:	00813023          	sd	s0,0(sp)
ffffffe000200828:	01010413          	addi	s0,sp,16
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
    if (current == idle || current->counter == 0) {
ffffffe00020082c:	00005797          	auipc	a5,0x5
ffffffe000200830:	7e478793          	addi	a5,a5,2020 # ffffffe000206010 <current>
ffffffe000200834:	0007b703          	ld	a4,0(a5)
ffffffe000200838:	00005797          	auipc	a5,0x5
ffffffe00020083c:	7d078793          	addi	a5,a5,2000 # ffffffe000206008 <idle>
ffffffe000200840:	0007b783          	ld	a5,0(a5)
ffffffe000200844:	00f70c63          	beq	a4,a5,ffffffe00020085c <do_timer+0x40>
ffffffe000200848:	00005797          	auipc	a5,0x5
ffffffe00020084c:	7c878793          	addi	a5,a5,1992 # ffffffe000206010 <current>
ffffffe000200850:	0007b783          	ld	a5,0(a5)
ffffffe000200854:	0087b783          	ld	a5,8(a5)
ffffffe000200858:	00079663          	bnez	a5,ffffffe000200864 <do_timer+0x48>
        schedule();
ffffffe00020085c:	044000ef          	jal	ffffffe0002008a0 <schedule>
ffffffe000200860:	0300006f          	j	ffffffe000200890 <do_timer+0x74>
    } else {
        if (--current->counter) {
ffffffe000200864:	00005797          	auipc	a5,0x5
ffffffe000200868:	7ac78793          	addi	a5,a5,1964 # ffffffe000206010 <current>
ffffffe00020086c:	0007b783          	ld	a5,0(a5)
ffffffe000200870:	0087b703          	ld	a4,8(a5)
ffffffe000200874:	fff70713          	addi	a4,a4,-1
ffffffe000200878:	00e7b423          	sd	a4,8(a5)
ffffffe00020087c:	0087b783          	ld	a5,8(a5)
ffffffe000200880:	00079663          	bnez	a5,ffffffe00020088c <do_timer+0x70>
            return;
        } else {
            schedule();
ffffffe000200884:	01c000ef          	jal	ffffffe0002008a0 <schedule>
ffffffe000200888:	0080006f          	j	ffffffe000200890 <do_timer+0x74>
            return;
ffffffe00020088c:	00000013          	nop
        }
    }
}
ffffffe000200890:	00813083          	ld	ra,8(sp)
ffffffe000200894:	00013403          	ld	s0,0(sp)
ffffffe000200898:	01010113          	addi	sp,sp,16
ffffffe00020089c:	00008067          	ret

ffffffe0002008a0 <schedule>:

void schedule() {
ffffffe0002008a0:	fd010113          	addi	sp,sp,-48
ffffffe0002008a4:	02113423          	sd	ra,40(sp)
ffffffe0002008a8:	02813023          	sd	s0,32(sp)
ffffffe0002008ac:	03010413          	addi	s0,sp,48
    uint64_t max_counter = 0;
ffffffe0002008b0:	fe043423          	sd	zero,-24(s0)
    struct task_struct *next = NULL;
ffffffe0002008b4:	fe043023          	sd	zero,-32(s0)
    for (int i=0; i<NR_TASKS; i++){
ffffffe0002008b8:	fc042e23          	sw	zero,-36(s0)
ffffffe0002008bc:	0900006f          	j	ffffffe00020094c <schedule+0xac>
        if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
ffffffe0002008c0:	00005717          	auipc	a4,0x5
ffffffe0002008c4:	76070713          	addi	a4,a4,1888 # ffffffe000206020 <task>
ffffffe0002008c8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008cc:	00379793          	slli	a5,a5,0x3
ffffffe0002008d0:	00f707b3          	add	a5,a4,a5
ffffffe0002008d4:	0007b783          	ld	a5,0(a5)
ffffffe0002008d8:	0007b783          	ld	a5,0(a5)
ffffffe0002008dc:	06079263          	bnez	a5,ffffffe000200940 <schedule+0xa0>
ffffffe0002008e0:	00005717          	auipc	a4,0x5
ffffffe0002008e4:	74070713          	addi	a4,a4,1856 # ffffffe000206020 <task>
ffffffe0002008e8:	fdc42783          	lw	a5,-36(s0)
ffffffe0002008ec:	00379793          	slli	a5,a5,0x3
ffffffe0002008f0:	00f707b3          	add	a5,a4,a5
ffffffe0002008f4:	0007b783          	ld	a5,0(a5)
ffffffe0002008f8:	0087b783          	ld	a5,8(a5)
ffffffe0002008fc:	fe843703          	ld	a4,-24(s0)
ffffffe000200900:	04f77063          	bgeu	a4,a5,ffffffe000200940 <schedule+0xa0>
            max_counter = task[i]->counter;
ffffffe000200904:	00005717          	auipc	a4,0x5
ffffffe000200908:	71c70713          	addi	a4,a4,1820 # ffffffe000206020 <task>
ffffffe00020090c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200910:	00379793          	slli	a5,a5,0x3
ffffffe000200914:	00f707b3          	add	a5,a4,a5
ffffffe000200918:	0007b783          	ld	a5,0(a5)
ffffffe00020091c:	0087b783          	ld	a5,8(a5)
ffffffe000200920:	fef43423          	sd	a5,-24(s0)
            next = task[i];
ffffffe000200924:	00005717          	auipc	a4,0x5
ffffffe000200928:	6fc70713          	addi	a4,a4,1788 # ffffffe000206020 <task>
ffffffe00020092c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200930:	00379793          	slli	a5,a5,0x3
ffffffe000200934:	00f707b3          	add	a5,a4,a5
ffffffe000200938:	0007b783          	ld	a5,0(a5)
ffffffe00020093c:	fef43023          	sd	a5,-32(s0)
    for (int i=0; i<NR_TASKS; i++){
ffffffe000200940:	fdc42783          	lw	a5,-36(s0)
ffffffe000200944:	0017879b          	addiw	a5,a5,1
ffffffe000200948:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020094c:	fdc42783          	lw	a5,-36(s0)
ffffffe000200950:	0007871b          	sext.w	a4,a5
ffffffe000200954:	01f00793          	li	a5,31
ffffffe000200958:	f6e7d4e3          	bge	a5,a4,ffffffe0002008c0 <schedule+0x20>
        }
    }
    if (max_counter == 0) {
ffffffe00020095c:	fe843783          	ld	a5,-24(s0)
ffffffe000200960:	16079463          	bnez	a5,ffffffe000200ac8 <schedule+0x228>
        for (int i=0; i<NR_TASKS; i++) {
ffffffe000200964:	fc042c23          	sw	zero,-40(s0)
ffffffe000200968:	0ac0006f          	j	ffffffe000200a14 <schedule+0x174>
            task[i]->counter = task[i]->priority;
ffffffe00020096c:	00005717          	auipc	a4,0x5
ffffffe000200970:	6b470713          	addi	a4,a4,1716 # ffffffe000206020 <task>
ffffffe000200974:	fd842783          	lw	a5,-40(s0)
ffffffe000200978:	00379793          	slli	a5,a5,0x3
ffffffe00020097c:	00f707b3          	add	a5,a4,a5
ffffffe000200980:	0007b703          	ld	a4,0(a5)
ffffffe000200984:	00005697          	auipc	a3,0x5
ffffffe000200988:	69c68693          	addi	a3,a3,1692 # ffffffe000206020 <task>
ffffffe00020098c:	fd842783          	lw	a5,-40(s0)
ffffffe000200990:	00379793          	slli	a5,a5,0x3
ffffffe000200994:	00f687b3          	add	a5,a3,a5
ffffffe000200998:	0007b783          	ld	a5,0(a5)
ffffffe00020099c:	01073703          	ld	a4,16(a4)
ffffffe0002009a0:	00e7b423          	sd	a4,8(a5)
            printk("SET [PID = %d counter = %d priority = %d]\n", task[i]->pid, task[i]->counter, task[i]->priority);
ffffffe0002009a4:	00005717          	auipc	a4,0x5
ffffffe0002009a8:	67c70713          	addi	a4,a4,1660 # ffffffe000206020 <task>
ffffffe0002009ac:	fd842783          	lw	a5,-40(s0)
ffffffe0002009b0:	00379793          	slli	a5,a5,0x3
ffffffe0002009b4:	00f707b3          	add	a5,a4,a5
ffffffe0002009b8:	0007b783          	ld	a5,0(a5)
ffffffe0002009bc:	0187b583          	ld	a1,24(a5)
ffffffe0002009c0:	00005717          	auipc	a4,0x5
ffffffe0002009c4:	66070713          	addi	a4,a4,1632 # ffffffe000206020 <task>
ffffffe0002009c8:	fd842783          	lw	a5,-40(s0)
ffffffe0002009cc:	00379793          	slli	a5,a5,0x3
ffffffe0002009d0:	00f707b3          	add	a5,a4,a5
ffffffe0002009d4:	0007b783          	ld	a5,0(a5)
ffffffe0002009d8:	0087b603          	ld	a2,8(a5)
ffffffe0002009dc:	00005717          	auipc	a4,0x5
ffffffe0002009e0:	64470713          	addi	a4,a4,1604 # ffffffe000206020 <task>
ffffffe0002009e4:	fd842783          	lw	a5,-40(s0)
ffffffe0002009e8:	00379793          	slli	a5,a5,0x3
ffffffe0002009ec:	00f707b3          	add	a5,a4,a5
ffffffe0002009f0:	0007b783          	ld	a5,0(a5)
ffffffe0002009f4:	0107b783          	ld	a5,16(a5)
ffffffe0002009f8:	00078693          	mv	a3,a5
ffffffe0002009fc:	00002517          	auipc	a0,0x2
ffffffe000200a00:	6d450513          	addi	a0,a0,1748 # ffffffe0002030d0 <_srodata+0xd0>
ffffffe000200a04:	7e8010ef          	jal	ffffffe0002021ec <printk>
        for (int i=0; i<NR_TASKS; i++) {
ffffffe000200a08:	fd842783          	lw	a5,-40(s0)
ffffffe000200a0c:	0017879b          	addiw	a5,a5,1
ffffffe000200a10:	fcf42c23          	sw	a5,-40(s0)
ffffffe000200a14:	fd842783          	lw	a5,-40(s0)
ffffffe000200a18:	0007871b          	sext.w	a4,a5
ffffffe000200a1c:	01f00793          	li	a5,31
ffffffe000200a20:	f4e7d6e3          	bge	a5,a4,ffffffe00020096c <schedule+0xcc>
        }
        for (int i=0; i<NR_TASKS; i++){
ffffffe000200a24:	fc042a23          	sw	zero,-44(s0)
ffffffe000200a28:	0900006f          	j	ffffffe000200ab8 <schedule+0x218>
            if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
ffffffe000200a2c:	00005717          	auipc	a4,0x5
ffffffe000200a30:	5f470713          	addi	a4,a4,1524 # ffffffe000206020 <task>
ffffffe000200a34:	fd442783          	lw	a5,-44(s0)
ffffffe000200a38:	00379793          	slli	a5,a5,0x3
ffffffe000200a3c:	00f707b3          	add	a5,a4,a5
ffffffe000200a40:	0007b783          	ld	a5,0(a5)
ffffffe000200a44:	0007b783          	ld	a5,0(a5)
ffffffe000200a48:	06079263          	bnez	a5,ffffffe000200aac <schedule+0x20c>
ffffffe000200a4c:	00005717          	auipc	a4,0x5
ffffffe000200a50:	5d470713          	addi	a4,a4,1492 # ffffffe000206020 <task>
ffffffe000200a54:	fd442783          	lw	a5,-44(s0)
ffffffe000200a58:	00379793          	slli	a5,a5,0x3
ffffffe000200a5c:	00f707b3          	add	a5,a4,a5
ffffffe000200a60:	0007b783          	ld	a5,0(a5)
ffffffe000200a64:	0087b783          	ld	a5,8(a5)
ffffffe000200a68:	fe843703          	ld	a4,-24(s0)
ffffffe000200a6c:	04f77063          	bgeu	a4,a5,ffffffe000200aac <schedule+0x20c>
                max_counter = task[i]->counter;
ffffffe000200a70:	00005717          	auipc	a4,0x5
ffffffe000200a74:	5b070713          	addi	a4,a4,1456 # ffffffe000206020 <task>
ffffffe000200a78:	fd442783          	lw	a5,-44(s0)
ffffffe000200a7c:	00379793          	slli	a5,a5,0x3
ffffffe000200a80:	00f707b3          	add	a5,a4,a5
ffffffe000200a84:	0007b783          	ld	a5,0(a5)
ffffffe000200a88:	0087b783          	ld	a5,8(a5)
ffffffe000200a8c:	fef43423          	sd	a5,-24(s0)
                next = task[i];
ffffffe000200a90:	00005717          	auipc	a4,0x5
ffffffe000200a94:	59070713          	addi	a4,a4,1424 # ffffffe000206020 <task>
ffffffe000200a98:	fd442783          	lw	a5,-44(s0)
ffffffe000200a9c:	00379793          	slli	a5,a5,0x3
ffffffe000200aa0:	00f707b3          	add	a5,a4,a5
ffffffe000200aa4:	0007b783          	ld	a5,0(a5)
ffffffe000200aa8:	fef43023          	sd	a5,-32(s0)
        for (int i=0; i<NR_TASKS; i++){
ffffffe000200aac:	fd442783          	lw	a5,-44(s0)
ffffffe000200ab0:	0017879b          	addiw	a5,a5,1
ffffffe000200ab4:	fcf42a23          	sw	a5,-44(s0)
ffffffe000200ab8:	fd442783          	lw	a5,-44(s0)
ffffffe000200abc:	0007871b          	sext.w	a4,a5
ffffffe000200ac0:	01f00793          	li	a5,31
ffffffe000200ac4:	f6e7d4e3          	bge	a5,a4,ffffffe000200a2c <schedule+0x18c>
            }
        }
    }
    if (next == NULL) {
ffffffe000200ac8:	fe043783          	ld	a5,-32(s0)
ffffffe000200acc:	02079063          	bnez	a5,ffffffe000200aec <schedule+0x24c>
        printk("Error: no available thread to run!\n");
ffffffe000200ad0:	00002517          	auipc	a0,0x2
ffffffe000200ad4:	63050513          	addi	a0,a0,1584 # ffffffe000203100 <_srodata+0x100>
ffffffe000200ad8:	714010ef          	jal	ffffffe0002021ec <printk>
        next = idle;
ffffffe000200adc:	00005797          	auipc	a5,0x5
ffffffe000200ae0:	52c78793          	addi	a5,a5,1324 # ffffffe000206008 <idle>
ffffffe000200ae4:	0007b783          	ld	a5,0(a5)
ffffffe000200ae8:	fef43023          	sd	a5,-32(s0)
    }
    switch_to(next);
ffffffe000200aec:	fe043503          	ld	a0,-32(s0)
ffffffe000200af0:	c75ff0ef          	jal	ffffffe000200764 <switch_to>
}
ffffffe000200af4:	00000013          	nop
ffffffe000200af8:	02813083          	ld	ra,40(sp)
ffffffe000200afc:	02013403          	ld	s0,32(sp)
ffffffe000200b00:	03010113          	addi	sp,sp,48
ffffffe000200b04:	00008067          	ret

ffffffe000200b08 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000200b08:	f9010113          	addi	sp,sp,-112
ffffffe000200b0c:	06813423          	sd	s0,104(sp)
ffffffe000200b10:	07010413          	addi	s0,sp,112
ffffffe000200b14:	fca43423          	sd	a0,-56(s0)
ffffffe000200b18:	fcb43023          	sd	a1,-64(s0)
ffffffe000200b1c:	fac43c23          	sd	a2,-72(s0)
ffffffe000200b20:	fad43823          	sd	a3,-80(s0)
ffffffe000200b24:	fae43423          	sd	a4,-88(s0)
ffffffe000200b28:	faf43023          	sd	a5,-96(s0)
ffffffe000200b2c:	f9043c23          	sd	a6,-104(s0)
ffffffe000200b30:	f9143823          	sd	a7,-112(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000200b34:	fc843783          	ld	a5,-56(s0)
ffffffe000200b38:	fc043703          	ld	a4,-64(s0)
ffffffe000200b3c:	fb843683          	ld	a3,-72(s0)
ffffffe000200b40:	fb043603          	ld	a2,-80(s0)
ffffffe000200b44:	fa843583          	ld	a1,-88(s0)
ffffffe000200b48:	fa043503          	ld	a0,-96(s0)
ffffffe000200b4c:	f9843803          	ld	a6,-104(s0)
ffffffe000200b50:	f9043883          	ld	a7,-112(s0)
ffffffe000200b54:	00078893          	mv	a7,a5
ffffffe000200b58:	00070813          	mv	a6,a4
ffffffe000200b5c:	00068513          	mv	a0,a3
ffffffe000200b60:	00060593          	mv	a1,a2
ffffffe000200b64:	00058613          	mv	a2,a1
ffffffe000200b68:	00050693          	mv	a3,a0
ffffffe000200b6c:	00080713          	mv	a4,a6
ffffffe000200b70:	00088793          	mv	a5,a7
ffffffe000200b74:	00000073          	ecall
ffffffe000200b78:	00050713          	mv	a4,a0
ffffffe000200b7c:	00058793          	mv	a5,a1
ffffffe000200b80:	fce43823          	sd	a4,-48(s0)
ffffffe000200b84:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1"
        : [error] "=r" (ret.error), [value] "=r" (ret.value)
        : [eid]"r"(eid), [fid]"r"(fid), [arg0]"r"(arg0), [arg1]"r"(arg1), [arg2]"r"(arg2), [arg3]"r"(arg3), [arg4]"r"(arg4), [arg5]"r"(arg5)
        : "memory"
    );
    return ret;
ffffffe000200b88:	fd043783          	ld	a5,-48(s0)
ffffffe000200b8c:	fef43023          	sd	a5,-32(s0)
ffffffe000200b90:	fd843783          	ld	a5,-40(s0)
ffffffe000200b94:	fef43423          	sd	a5,-24(s0)
ffffffe000200b98:	fe043703          	ld	a4,-32(s0)
ffffffe000200b9c:	fe843783          	ld	a5,-24(s0)
ffffffe000200ba0:	00070313          	mv	t1,a4
ffffffe000200ba4:	00078393          	mv	t2,a5
ffffffe000200ba8:	00030713          	mv	a4,t1
ffffffe000200bac:	00038793          	mv	a5,t2
}
ffffffe000200bb0:	00070513          	mv	a0,a4
ffffffe000200bb4:	00078593          	mv	a1,a5
ffffffe000200bb8:	06813403          	ld	s0,104(sp)
ffffffe000200bbc:	07010113          	addi	sp,sp,112
ffffffe000200bc0:	00008067          	ret

ffffffe000200bc4 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000200bc4:	fc010113          	addi	sp,sp,-64
ffffffe000200bc8:	02113c23          	sd	ra,56(sp)
ffffffe000200bcc:	02813823          	sd	s0,48(sp)
ffffffe000200bd0:	03213423          	sd	s2,40(sp)
ffffffe000200bd4:	03313023          	sd	s3,32(sp)
ffffffe000200bd8:	04010413          	addi	s0,sp,64
ffffffe000200bdc:	00050793          	mv	a5,a0
ffffffe000200be0:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);;
ffffffe000200be4:	fcf44603          	lbu	a2,-49(s0)
ffffffe000200be8:	00000893          	li	a7,0
ffffffe000200bec:	00000813          	li	a6,0
ffffffe000200bf0:	00000793          	li	a5,0
ffffffe000200bf4:	00000713          	li	a4,0
ffffffe000200bf8:	00000693          	li	a3,0
ffffffe000200bfc:	00200593          	li	a1,2
ffffffe000200c00:	44424537          	lui	a0,0x44424
ffffffe000200c04:	34e50513          	addi	a0,a0,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe000200c08:	f01ff0ef          	jal	ffffffe000200b08 <sbi_ecall>
ffffffe000200c0c:	00050713          	mv	a4,a0
ffffffe000200c10:	00058793          	mv	a5,a1
ffffffe000200c14:	fce43823          	sd	a4,-48(s0)
ffffffe000200c18:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200c1c:	fd043703          	ld	a4,-48(s0)
ffffffe000200c20:	fd843783          	ld	a5,-40(s0)
ffffffe000200c24:	00070913          	mv	s2,a4
ffffffe000200c28:	00078993          	mv	s3,a5
ffffffe000200c2c:	00090713          	mv	a4,s2
ffffffe000200c30:	00098793          	mv	a5,s3
}
ffffffe000200c34:	00070513          	mv	a0,a4
ffffffe000200c38:	00078593          	mv	a1,a5
ffffffe000200c3c:	03813083          	ld	ra,56(sp)
ffffffe000200c40:	03013403          	ld	s0,48(sp)
ffffffe000200c44:	02813903          	ld	s2,40(sp)
ffffffe000200c48:	02013983          	ld	s3,32(sp)
ffffffe000200c4c:	04010113          	addi	sp,sp,64
ffffffe000200c50:	00008067          	ret

ffffffe000200c54 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe000200c54:	fc010113          	addi	sp,sp,-64
ffffffe000200c58:	02113c23          	sd	ra,56(sp)
ffffffe000200c5c:	02813823          	sd	s0,48(sp)
ffffffe000200c60:	03213423          	sd	s2,40(sp)
ffffffe000200c64:	03313023          	sd	s3,32(sp)
ffffffe000200c68:	04010413          	addi	s0,sp,64
ffffffe000200c6c:	00050793          	mv	a5,a0
ffffffe000200c70:	00058713          	mv	a4,a1
ffffffe000200c74:	fcf42623          	sw	a5,-52(s0)
ffffffe000200c78:	00070793          	mv	a5,a4
ffffffe000200c7c:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0x0, reset_type, reset_reason, 0, 0, 0, 0);;
ffffffe000200c80:	fcc46603          	lwu	a2,-52(s0)
ffffffe000200c84:	fc846683          	lwu	a3,-56(s0)
ffffffe000200c88:	00000893          	li	a7,0
ffffffe000200c8c:	00000813          	li	a6,0
ffffffe000200c90:	00000793          	li	a5,0
ffffffe000200c94:	00000713          	li	a4,0
ffffffe000200c98:	00000593          	li	a1,0
ffffffe000200c9c:	53525537          	lui	a0,0x53525
ffffffe000200ca0:	35450513          	addi	a0,a0,852 # 53525354 <PHY_SIZE+0x4b525354>
ffffffe000200ca4:	e65ff0ef          	jal	ffffffe000200b08 <sbi_ecall>
ffffffe000200ca8:	00050713          	mv	a4,a0
ffffffe000200cac:	00058793          	mv	a5,a1
ffffffe000200cb0:	fce43823          	sd	a4,-48(s0)
ffffffe000200cb4:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200cb8:	fd043703          	ld	a4,-48(s0)
ffffffe000200cbc:	fd843783          	ld	a5,-40(s0)
ffffffe000200cc0:	00070913          	mv	s2,a4
ffffffe000200cc4:	00078993          	mv	s3,a5
ffffffe000200cc8:	00090713          	mv	a4,s2
ffffffe000200ccc:	00098793          	mv	a5,s3
}
ffffffe000200cd0:	00070513          	mv	a0,a4
ffffffe000200cd4:	00078593          	mv	a1,a5
ffffffe000200cd8:	03813083          	ld	ra,56(sp)
ffffffe000200cdc:	03013403          	ld	s0,48(sp)
ffffffe000200ce0:	02813903          	ld	s2,40(sp)
ffffffe000200ce4:	02013983          	ld	s3,32(sp)
ffffffe000200ce8:	04010113          	addi	sp,sp,64
ffffffe000200cec:	00008067          	ret

ffffffe000200cf0 <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
ffffffe000200cf0:	fc010113          	addi	sp,sp,-64
ffffffe000200cf4:	02113c23          	sd	ra,56(sp)
ffffffe000200cf8:	02813823          	sd	s0,48(sp)
ffffffe000200cfc:	03213423          	sd	s2,40(sp)
ffffffe000200d00:	03313023          	sd	s3,32(sp)
ffffffe000200d04:	04010413          	addi	s0,sp,64
ffffffe000200d08:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0x0, stime_value, 0, 0, 0, 0, 0);
ffffffe000200d0c:	00000893          	li	a7,0
ffffffe000200d10:	00000813          	li	a6,0
ffffffe000200d14:	00000793          	li	a5,0
ffffffe000200d18:	00000713          	li	a4,0
ffffffe000200d1c:	00000693          	li	a3,0
ffffffe000200d20:	fc843603          	ld	a2,-56(s0)
ffffffe000200d24:	00000593          	li	a1,0
ffffffe000200d28:	54495537          	lui	a0,0x54495
ffffffe000200d2c:	d4550513          	addi	a0,a0,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
ffffffe000200d30:	dd9ff0ef          	jal	ffffffe000200b08 <sbi_ecall>
ffffffe000200d34:	00050713          	mv	a4,a0
ffffffe000200d38:	00058793          	mv	a5,a1
ffffffe000200d3c:	fce43823          	sd	a4,-48(s0)
ffffffe000200d40:	fcf43c23          	sd	a5,-40(s0)
ffffffe000200d44:	fd043703          	ld	a4,-48(s0)
ffffffe000200d48:	fd843783          	ld	a5,-40(s0)
ffffffe000200d4c:	00070913          	mv	s2,a4
ffffffe000200d50:	00078993          	mv	s3,a5
ffffffe000200d54:	00090713          	mv	a4,s2
ffffffe000200d58:	00098793          	mv	a5,s3
ffffffe000200d5c:	00070513          	mv	a0,a4
ffffffe000200d60:	00078593          	mv	a1,a5
ffffffe000200d64:	03813083          	ld	ra,56(sp)
ffffffe000200d68:	03013403          	ld	s0,48(sp)
ffffffe000200d6c:	02813903          	ld	s2,40(sp)
ffffffe000200d70:	02013983          	ld	s3,32(sp)
ffffffe000200d74:	04010113          	addi	sp,sp,64
ffffffe000200d78:	00008067          	ret

ffffffe000200d7c <trap_handler>:
#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
extern void do_timer();
void trap_handler(uint64_t scause, uint64_t sepc) {
ffffffe000200d7c:	fd010113          	addi	sp,sp,-48
ffffffe000200d80:	02113423          	sd	ra,40(sp)
ffffffe000200d84:	02813023          	sd	s0,32(sp)
ffffffe000200d88:	03010413          	addi	s0,sp,48
ffffffe000200d8c:	fca43c23          	sd	a0,-40(s0)
ffffffe000200d90:	fcb43823          	sd	a1,-48(s0)
    uint64_t flag = scause >> 63;
ffffffe000200d94:	fd843783          	ld	a5,-40(s0)
ffffffe000200d98:	03f7d793          	srli	a5,a5,0x3f
ffffffe000200d9c:	fef43423          	sd	a5,-24(s0)
    uint64_t cause = scause & 0x7FFFFFFFFFFFFFFF;
ffffffe000200da0:	fd843703          	ld	a4,-40(s0)
ffffffe000200da4:	fff00793          	li	a5,-1
ffffffe000200da8:	0017d793          	srli	a5,a5,0x1
ffffffe000200dac:	00f777b3          	and	a5,a4,a5
ffffffe000200db0:	fef43023          	sd	a5,-32(s0)

    if(flag) {//interrupt
ffffffe000200db4:	fe843783          	ld	a5,-24(s0)
ffffffe000200db8:	02078863          	beqz	a5,ffffffe000200de8 <trap_handler+0x6c>
        if(cause == 5) {
ffffffe000200dbc:	fe043703          	ld	a4,-32(s0)
ffffffe000200dc0:	00500793          	li	a5,5
ffffffe000200dc4:	00f71863          	bne	a4,a5,ffffffe000200dd4 <trap_handler+0x58>
            // uint64_t ret = csr_read(sstatus);
            // csr_write(sscratch, ret);
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            
            clock_set_next_event();
ffffffe000200dc8:	cb0ff0ef          	jal	ffffffe000200278 <clock_set_next_event>
            do_timer();
ffffffe000200dcc:	a51ff0ef          	jal	ffffffe00020081c <do_timer>
        }
    }
    else {
        printk("[S] Exception: %d\n", cause);
    }
ffffffe000200dd0:	0280006f          	j	ffffffe000200df8 <trap_handler+0x7c>
            printk("[S] Interrupt: %d\n", cause);
ffffffe000200dd4:	fe043583          	ld	a1,-32(s0)
ffffffe000200dd8:	00002517          	auipc	a0,0x2
ffffffe000200ddc:	35050513          	addi	a0,a0,848 # ffffffe000203128 <_srodata+0x128>
ffffffe000200de0:	40c010ef          	jal	ffffffe0002021ec <printk>
ffffffe000200de4:	0140006f          	j	ffffffe000200df8 <trap_handler+0x7c>
        printk("[S] Exception: %d\n", cause);
ffffffe000200de8:	fe043583          	ld	a1,-32(s0)
ffffffe000200dec:	00002517          	auipc	a0,0x2
ffffffe000200df0:	35450513          	addi	a0,a0,852 # ffffffe000203140 <_srodata+0x140>
ffffffe000200df4:	3f8010ef          	jal	ffffffe0002021ec <printk>
ffffffe000200df8:	00000013          	nop
ffffffe000200dfc:	02813083          	ld	ra,40(sp)
ffffffe000200e00:	02013403          	ld	s0,32(sp)
ffffffe000200e04:	03010113          	addi	sp,sp,48
ffffffe000200e08:	00008067          	ret

ffffffe000200e0c <setup_vm>:
extern char _erodata[];
extern char _sdata[];
/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe000200e0c:	fe010113          	addi	sp,sp,-32
ffffffe000200e10:	00813c23          	sd	s0,24(sp)
ffffffe000200e14:	02010413          	addi	s0,sp,32
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/
    for (int i = 0; i < 512; i++) {
ffffffe000200e18:	fe042623          	sw	zero,-20(s0)
ffffffe000200e1c:	05c0006f          	j	ffffffe000200e78 <setup_vm+0x6c>
        //if(i==2) early_pgtbl[i] = (uint64_t)0x2000000F;
        if (i==384) early_pgtbl[i] = (uint64_t)0x2000000F;
ffffffe000200e20:	fec42783          	lw	a5,-20(s0)
ffffffe000200e24:	0007871b          	sext.w	a4,a5
ffffffe000200e28:	18000793          	li	a5,384
ffffffe000200e2c:	02f71463          	bne	a4,a5,ffffffe000200e54 <setup_vm+0x48>
ffffffe000200e30:	00006717          	auipc	a4,0x6
ffffffe000200e34:	1d070713          	addi	a4,a4,464 # ffffffe000207000 <early_pgtbl>
ffffffe000200e38:	fec42783          	lw	a5,-20(s0)
ffffffe000200e3c:	00379793          	slli	a5,a5,0x3
ffffffe000200e40:	00f707b3          	add	a5,a4,a5
ffffffe000200e44:	20000737          	lui	a4,0x20000
ffffffe000200e48:	00f70713          	addi	a4,a4,15 # 2000000f <PHY_SIZE+0x1800000f>
ffffffe000200e4c:	00e7b023          	sd	a4,0(a5)
ffffffe000200e50:	01c0006f          	j	ffffffe000200e6c <setup_vm+0x60>
        else early_pgtbl[i] = (uint64_t)0x0;
ffffffe000200e54:	00006717          	auipc	a4,0x6
ffffffe000200e58:	1ac70713          	addi	a4,a4,428 # ffffffe000207000 <early_pgtbl>
ffffffe000200e5c:	fec42783          	lw	a5,-20(s0)
ffffffe000200e60:	00379793          	slli	a5,a5,0x3
ffffffe000200e64:	00f707b3          	add	a5,a4,a5
ffffffe000200e68:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
ffffffe000200e6c:	fec42783          	lw	a5,-20(s0)
ffffffe000200e70:	0017879b          	addiw	a5,a5,1
ffffffe000200e74:	fef42623          	sw	a5,-20(s0)
ffffffe000200e78:	fec42783          	lw	a5,-20(s0)
ffffffe000200e7c:	0007871b          	sext.w	a4,a5
ffffffe000200e80:	1ff00793          	li	a5,511
ffffffe000200e84:	f8e7dee3          	bge	a5,a4,ffffffe000200e20 <setup_vm+0x14>
    }
}
ffffffe000200e88:	00000013          	nop
ffffffe000200e8c:	00000013          	nop
ffffffe000200e90:	01813403          	ld	s0,24(sp)
ffffffe000200e94:	02010113          	addi	sp,sp,32
ffffffe000200e98:	00008067          	ret

ffffffe000200e9c <setup_vm_final>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final() {
ffffffe000200e9c:	fd010113          	addi	sp,sp,-48
ffffffe000200ea0:	02113423          	sd	ra,40(sp)
ffffffe000200ea4:	02813023          	sd	s0,32(sp)
ffffffe000200ea8:	03010413          	addi	s0,sp,48
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe000200eac:	00001637          	lui	a2,0x1
ffffffe000200eb0:	00000593          	li	a1,0
ffffffe000200eb4:	00007517          	auipc	a0,0x7
ffffffe000200eb8:	14c50513          	addi	a0,a0,332 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200ebc:	450010ef          	jal	ffffffe00020230c <memset>

    // No OpenSBI mapping required
    for (int i = 0; i < 512; i++) {
ffffffe000200ec0:	fe042623          	sw	zero,-20(s0)
ffffffe000200ec4:	0280006f          	j	ffffffe000200eec <setup_vm_final+0x50>
        swapper_pg_dir[i] = (uint64_t)0x0;
ffffffe000200ec8:	00007717          	auipc	a4,0x7
ffffffe000200ecc:	13870713          	addi	a4,a4,312 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200ed0:	fec42783          	lw	a5,-20(s0)
ffffffe000200ed4:	00379793          	slli	a5,a5,0x3
ffffffe000200ed8:	00f707b3          	add	a5,a4,a5
ffffffe000200edc:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
ffffffe000200ee0:	fec42783          	lw	a5,-20(s0)
ffffffe000200ee4:	0017879b          	addiw	a5,a5,1
ffffffe000200ee8:	fef42623          	sw	a5,-20(s0)
ffffffe000200eec:	fec42783          	lw	a5,-20(s0)
ffffffe000200ef0:	0007871b          	sext.w	a4,a5
ffffffe000200ef4:	1ff00793          	li	a5,511
ffffffe000200ef8:	fce7d8e3          	bge	a5,a4,ffffffe000200ec8 <setup_vm_final+0x2c>
    }
    // mapping kernel text X|-|R|V
    create_mapping(
ffffffe000200efc:	fffff597          	auipc	a1,0xfffff
ffffffe000200f00:	10458593          	addi	a1,a1,260 # ffffffe000200000 <_skernel>
        swapper_pg_dir, 
        (uint64_t)_stext, 
        (uint64_t)((uint64_t)_stext-PA2VA_OFFSET), 
ffffffe000200f04:	fffff717          	auipc	a4,0xfffff
ffffffe000200f08:	0fc70713          	addi	a4,a4,252 # ffffffe000200000 <_skernel>
    create_mapping(
ffffffe000200f0c:	04100793          	li	a5,65
ffffffe000200f10:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f14:	00f70633          	add	a2,a4,a5
        (uint64_t)((uint64_t)_etext-(uint64_t)_stext), 
ffffffe000200f18:	00001717          	auipc	a4,0x1
ffffffe000200f1c:	46470713          	addi	a4,a4,1124 # ffffffe00020237c <_etext>
ffffffe000200f20:	fffff797          	auipc	a5,0xfffff
ffffffe000200f24:	0e078793          	addi	a5,a5,224 # ffffffe000200000 <_skernel>
    create_mapping(
ffffffe000200f28:	40f707b3          	sub	a5,a4,a5
ffffffe000200f2c:	00b00713          	li	a4,11
ffffffe000200f30:	00078693          	mv	a3,a5
ffffffe000200f34:	00007517          	auipc	a0,0x7
ffffffe000200f38:	0cc50513          	addi	a0,a0,204 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200f3c:	0fc000ef          	jal	ffffffe000201038 <create_mapping>
        (uint64_t)0x0B
    );

    // mapping kernel rodata -|-|R|V
    create_mapping(
ffffffe000200f40:	00002597          	auipc	a1,0x2
ffffffe000200f44:	0c058593          	addi	a1,a1,192 # ffffffe000203000 <_srodata>
        swapper_pg_dir, 
        (uint64_t)_srodata, 
        (uint64_t)((uint64_t)_srodata-PA2VA_OFFSET), 
ffffffe000200f48:	00002717          	auipc	a4,0x2
ffffffe000200f4c:	0b870713          	addi	a4,a4,184 # ffffffe000203000 <_srodata>
    create_mapping(
ffffffe000200f50:	04100793          	li	a5,65
ffffffe000200f54:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f58:	00f70633          	add	a2,a4,a5
        (uint64_t)((uint64_t)_erodata-(uint64_t)_srodata), 
ffffffe000200f5c:	00002717          	auipc	a4,0x2
ffffffe000200f60:	29c70713          	addi	a4,a4,668 # ffffffe0002031f8 <_erodata>
ffffffe000200f64:	00002797          	auipc	a5,0x2
ffffffe000200f68:	09c78793          	addi	a5,a5,156 # ffffffe000203000 <_srodata>
    create_mapping(
ffffffe000200f6c:	40f707b3          	sub	a5,a4,a5
ffffffe000200f70:	00300713          	li	a4,3
ffffffe000200f74:	00078693          	mv	a3,a5
ffffffe000200f78:	00007517          	auipc	a0,0x7
ffffffe000200f7c:	08850513          	addi	a0,a0,136 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200f80:	0b8000ef          	jal	ffffffe000201038 <create_mapping>
        (uint64_t)0x03
    );

    // mapping other memory -|W|R|V
    create_mapping(
ffffffe000200f84:	00003597          	auipc	a1,0x3
ffffffe000200f88:	07c58593          	addi	a1,a1,124 # ffffffe000204000 <TIMECLOCK>
        swapper_pg_dir, 
        (uint64_t)_sdata, 
        (uint64_t)((uint64_t) _sdata-PA2VA_OFFSET), 
ffffffe000200f8c:	00003717          	auipc	a4,0x3
ffffffe000200f90:	07470713          	addi	a4,a4,116 # ffffffe000204000 <TIMECLOCK>
    create_mapping(
ffffffe000200f94:	04100793          	li	a5,65
ffffffe000200f98:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f9c:	00f70633          	add	a2,a4,a5
        (uint64_t)(PHY_END+PA2VA_OFFSET-(uint64_t)_sdata), 
ffffffe000200fa0:	00003797          	auipc	a5,0x3
ffffffe000200fa4:	06078793          	addi	a5,a5,96 # ffffffe000204000 <TIMECLOCK>
    create_mapping(
ffffffe000200fa8:	c0100713          	li	a4,-1023
ffffffe000200fac:	01b71713          	slli	a4,a4,0x1b
ffffffe000200fb0:	40f707b3          	sub	a5,a4,a5
ffffffe000200fb4:	00700713          	li	a4,7
ffffffe000200fb8:	00078693          	mv	a3,a5
ffffffe000200fbc:	00007517          	auipc	a0,0x7
ffffffe000200fc0:	04450513          	addi	a0,a0,68 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200fc4:	074000ef          	jal	ffffffe000201038 <create_mapping>
        (uint64_t)0x07
    );

    // set satp with swapper_pg_dir
    // printk("PH_swapper_pg_dir = %lx\n", (uint64_t) (swapper_pg_dir-PA2VA_OFFSET));
    uint64_t virtual = (uint64_t)swapper_pg_dir-PA2VA_OFFSET;
ffffffe000200fc8:	00007717          	auipc	a4,0x7
ffffffe000200fcc:	03870713          	addi	a4,a4,56 # ffffffe000208000 <swapper_pg_dir>
ffffffe000200fd0:	04100793          	li	a5,65
ffffffe000200fd4:	01f79793          	slli	a5,a5,0x1f
ffffffe000200fd8:	00f707b3          	add	a5,a4,a5
ffffffe000200fdc:	fef43023          	sd	a5,-32(s0)
    printk("virtual = %lx\n", virtual);
ffffffe000200fe0:	fe043583          	ld	a1,-32(s0)
ffffffe000200fe4:	00002517          	auipc	a0,0x2
ffffffe000200fe8:	17450513          	addi	a0,a0,372 # ffffffe000203158 <_srodata+0x158>
ffffffe000200fec:	200010ef          	jal	ffffffe0002021ec <printk>
    uint64_t value = (uint64_t)(virtual>>12);
ffffffe000200ff0:	fe043783          	ld	a5,-32(s0)
ffffffe000200ff4:	00c7d793          	srli	a5,a5,0xc
ffffffe000200ff8:	fcf43c23          	sd	a5,-40(s0)
    value += 0x8000000000000000;
ffffffe000200ffc:	fd843703          	ld	a4,-40(s0)
ffffffe000201000:	fff00793          	li	a5,-1
ffffffe000201004:	03f79793          	slli	a5,a5,0x3f
ffffffe000201008:	00f707b3          	add	a5,a4,a5
ffffffe00020100c:	fcf43c23          	sd	a5,-40(s0)
    csr_write(satp, value);
ffffffe000201010:	fd843783          	ld	a5,-40(s0)
ffffffe000201014:	fcf43823          	sd	a5,-48(s0)
ffffffe000201018:	fd043783          	ld	a5,-48(s0)
ffffffe00020101c:	18079073          	csrw	satp,a5
    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201020:	12000073          	sfence.vma
    return;
ffffffe000201024:	00000013          	nop
}
ffffffe000201028:	02813083          	ld	ra,40(sp)
ffffffe00020102c:	02013403          	ld	s0,32(sp)
ffffffe000201030:	03010113          	addi	sp,sp,48
ffffffe000201034:	00008067          	ret

ffffffe000201038 <create_mapping>:


/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201038:	f5010113          	addi	sp,sp,-176
ffffffe00020103c:	0a113423          	sd	ra,168(sp)
ffffffe000201040:	0a813023          	sd	s0,160(sp)
ffffffe000201044:	0b010413          	addi	s0,sp,176
ffffffe000201048:	f6a43c23          	sd	a0,-136(s0)
ffffffe00020104c:	f6b43823          	sd	a1,-144(s0)
ffffffe000201050:	f6c43423          	sd	a2,-152(s0)
ffffffe000201054:	f6d43023          	sd	a3,-160(s0)
ffffffe000201058:	f4e43c23          	sd	a4,-168(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
    uint64_t vpn0 = ((uint64_t)va<<43)>>55;
ffffffe00020105c:	f7043783          	ld	a5,-144(s0)
ffffffe000201060:	02b79793          	slli	a5,a5,0x2b
ffffffe000201064:	0377d793          	srli	a5,a5,0x37
ffffffe000201068:	fef43423          	sd	a5,-24(s0)
    uint64_t vpn1 = ((uint64_t)va<<34)>>55;
ffffffe00020106c:	f7043783          	ld	a5,-144(s0)
ffffffe000201070:	02279793          	slli	a5,a5,0x22
ffffffe000201074:	0377d793          	srli	a5,a5,0x37
ffffffe000201078:	fef43023          	sd	a5,-32(s0)
    uint64_t vpn2 = ((uint64_t)va<<25)>>55;
ffffffe00020107c:	f7043783          	ld	a5,-144(s0)
ffffffe000201080:	01979793          	slli	a5,a5,0x19
ffffffe000201084:	0377d793          	srli	a5,a5,0x37
ffffffe000201088:	fcf43023          	sd	a5,-64(s0)
    uint64_t *pgtbl_entry = &pgtbl[vpn2];
ffffffe00020108c:	fc043783          	ld	a5,-64(s0)
ffffffe000201090:	00379793          	slli	a5,a5,0x3
ffffffe000201094:	f7843703          	ld	a4,-136(s0)
ffffffe000201098:	00f707b3          	add	a5,a4,a5
ffffffe00020109c:	faf43c23          	sd	a5,-72(s0)
    uint64_t *second_pgtbl;
    //创建二级页表
    if(!(*pgtbl_entry & 0x1)) {
ffffffe0002010a0:	fb843783          	ld	a5,-72(s0)
ffffffe0002010a4:	0007b783          	ld	a5,0(a5)
ffffffe0002010a8:	0017f793          	andi	a5,a5,1
ffffffe0002010ac:	04079c63          	bnez	a5,ffffffe000201104 <create_mapping+0xcc>
        //这里新的kalloc出来的是虚拟地址
        uint64_t *new_pgtbl = (uint64_t *)kalloc();
ffffffe0002010b0:	a10ff0ef          	jal	ffffffe0002002c0 <kalloc>
ffffffe0002010b4:	00050793          	mv	a5,a0
ffffffe0002010b8:	faf43823          	sd	a5,-80(s0)
        // printk("new_pgtbl = %lx\n", new_pgtbl);
        //这里存进页表项的是物理地址
        uint64_t phy_pgt = (uint64_t)((uint64_t)new_pgtbl - PA2VA_OFFSET)>>12;
ffffffe0002010bc:	fb043703          	ld	a4,-80(s0)
ffffffe0002010c0:	04100793          	li	a5,65
ffffffe0002010c4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002010c8:	00f707b3          	add	a5,a4,a5
ffffffe0002010cc:	00c7d793          	srli	a5,a5,0xc
ffffffe0002010d0:	faf43423          	sd	a5,-88(s0)
        // printk("phy_pgt = %lx\n", phy_pgt);
        *pgtbl_entry = phy_pgt;
ffffffe0002010d4:	fb843783          	ld	a5,-72(s0)
ffffffe0002010d8:	fa843703          	ld	a4,-88(s0)
ffffffe0002010dc:	00e7b023          	sd	a4,0(a5)
        *pgtbl_entry = (uint64_t)((*pgtbl_entry << 10)+0x1);   
ffffffe0002010e0:	fb843783          	ld	a5,-72(s0)
ffffffe0002010e4:	0007b783          	ld	a5,0(a5)
ffffffe0002010e8:	00a79793          	slli	a5,a5,0xa
ffffffe0002010ec:	00178713          	addi	a4,a5,1
ffffffe0002010f0:	fb843783          	ld	a5,-72(s0)
ffffffe0002010f4:	00e7b023          	sd	a4,0(a5)
        second_pgtbl = new_pgtbl; 
ffffffe0002010f8:	fb043783          	ld	a5,-80(s0)
ffffffe0002010fc:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201100:	1a00006f          	j	ffffffe0002012a0 <create_mapping+0x268>
    }
    //找到二级页表的物理地址，然后转化成虚拟地址去访问
    else {
        second_pgtbl = (uint64_t*)((uint64_t)(*pgtbl_entry<<10)>>20<<12);
ffffffe000201104:	fb843783          	ld	a5,-72(s0)
ffffffe000201108:	0007b783          	ld	a5,0(a5)
ffffffe00020110c:	00a79793          	slli	a5,a5,0xa
ffffffe000201110:	0147d793          	srli	a5,a5,0x14
ffffffe000201114:	00c79793          	slli	a5,a5,0xc
ffffffe000201118:	fcf43c23          	sd	a5,-40(s0)
        second_pgtbl = (uint64_t *)((uint64_t)second_pgtbl + PA2VA_OFFSET);
ffffffe00020111c:	fd843703          	ld	a4,-40(s0)
ffffffe000201120:	fbf00793          	li	a5,-65
ffffffe000201124:	01f79793          	slli	a5,a5,0x1f
ffffffe000201128:	00f707b3          	add	a5,a4,a5
ffffffe00020112c:	fcf43c23          	sd	a5,-40(s0)
    }
    while ((signed)sz > 0) {
ffffffe000201130:	1700006f          	j	ffffffe0002012a0 <create_mapping+0x268>
        uint64_t huge_pgsize = 0x200000;//2MiB
ffffffe000201134:	002007b7          	lui	a5,0x200
ffffffe000201138:	faf43023          	sd	a5,-96(s0)
        uint64_t *second_pgtbl_entry = &second_pgtbl[vpn1];
ffffffe00020113c:	fe043783          	ld	a5,-32(s0)
ffffffe000201140:	00379793          	slli	a5,a5,0x3
ffffffe000201144:	fd843703          	ld	a4,-40(s0)
ffffffe000201148:	00f707b3          	add	a5,a4,a5
ffffffe00020114c:	f8f43c23          	sd	a5,-104(s0)
        uint64_t *third_pgtbl;
        if (!(*second_pgtbl_entry & 0x1)) {
ffffffe000201150:	f9843783          	ld	a5,-104(s0)
ffffffe000201154:	0007b783          	ld	a5,0(a5) # 200000 <OPENSBI_SIZE>
ffffffe000201158:	0017f793          	andi	a5,a5,1
ffffffe00020115c:	04079c63          	bnez	a5,ffffffe0002011b4 <create_mapping+0x17c>
            uint64_t *new_pgtbl = (uint64_t *)kalloc();
ffffffe000201160:	960ff0ef          	jal	ffffffe0002002c0 <kalloc>
ffffffe000201164:	00050793          	mv	a5,a0
ffffffe000201168:	f8f43823          	sd	a5,-112(s0)
            third_pgtbl = (uint64_t)((uint64_t) new_pgtbl - PA2VA_OFFSET)>>12;
ffffffe00020116c:	f9043703          	ld	a4,-112(s0)
ffffffe000201170:	04100793          	li	a5,65
ffffffe000201174:	01f79793          	slli	a5,a5,0x1f
ffffffe000201178:	00f707b3          	add	a5,a4,a5
ffffffe00020117c:	00c7d793          	srli	a5,a5,0xc
ffffffe000201180:	fcf43823          	sd	a5,-48(s0)
            *second_pgtbl_entry = third_pgtbl;
ffffffe000201184:	fd043703          	ld	a4,-48(s0)
ffffffe000201188:	f9843783          	ld	a5,-104(s0)
ffffffe00020118c:	00e7b023          	sd	a4,0(a5)
            *second_pgtbl_entry = (uint64_t)((*second_pgtbl_entry << 10)+0x1);
ffffffe000201190:	f9843783          	ld	a5,-104(s0)
ffffffe000201194:	0007b783          	ld	a5,0(a5)
ffffffe000201198:	00a79793          	slli	a5,a5,0xa
ffffffe00020119c:	00178713          	addi	a4,a5,1
ffffffe0002011a0:	f9843783          	ld	a5,-104(s0)
ffffffe0002011a4:	00e7b023          	sd	a4,0(a5)
            third_pgtbl = new_pgtbl;
ffffffe0002011a8:	f9043783          	ld	a5,-112(s0)
ffffffe0002011ac:	fcf43823          	sd	a5,-48(s0)
ffffffe0002011b0:	0300006f          	j	ffffffe0002011e0 <create_mapping+0x1a8>
        }
        else {
            third_pgtbl = (uint64_t*)((uint64_t)(*second_pgtbl_entry<<10)>>20<<12);
ffffffe0002011b4:	f9843783          	ld	a5,-104(s0)
ffffffe0002011b8:	0007b783          	ld	a5,0(a5)
ffffffe0002011bc:	00a79793          	slli	a5,a5,0xa
ffffffe0002011c0:	0147d793          	srli	a5,a5,0x14
ffffffe0002011c4:	00c79793          	slli	a5,a5,0xc
ffffffe0002011c8:	fcf43823          	sd	a5,-48(s0)
            third_pgtbl = (uint64_t *)((uint64_t)third_pgtbl + PA2VA_OFFSET);
ffffffe0002011cc:	fd043703          	ld	a4,-48(s0)
ffffffe0002011d0:	fbf00793          	li	a5,-65
ffffffe0002011d4:	01f79793          	slli	a5,a5,0x1f
ffffffe0002011d8:	00f707b3          	add	a5,a4,a5
ffffffe0002011dc:	fcf43823          	sd	a5,-48(s0)
        }
        uint64_t entries = huge_pgsize/PGSIZE;//2MiB/4KiB=512
ffffffe0002011e0:	fa043783          	ld	a5,-96(s0)
ffffffe0002011e4:	00c7d793          	srli	a5,a5,0xc
ffffffe0002011e8:	f8f43423          	sd	a5,-120(s0)
        uint64_t count = 0;
ffffffe0002011ec:	fc043423          	sd	zero,-56(s0)
        while((signed)sz > 0 && vpn0 < entries) {
ffffffe0002011f0:	0880006f          	j	ffffffe000201278 <create_mapping+0x240>
            uint64_t *third_pgtbl_entry = &third_pgtbl[vpn0];
ffffffe0002011f4:	fe843783          	ld	a5,-24(s0)
ffffffe0002011f8:	00379793          	slli	a5,a5,0x3
ffffffe0002011fc:	fd043703          	ld	a4,-48(s0)
ffffffe000201200:	00f707b3          	add	a5,a4,a5
ffffffe000201204:	f8f43023          	sd	a5,-128(s0)
            if (!(*third_pgtbl_entry & 0x1)) {
ffffffe000201208:	f8043783          	ld	a5,-128(s0)
ffffffe00020120c:	0007b783          	ld	a5,0(a5)
ffffffe000201210:	0017f793          	andi	a5,a5,1
ffffffe000201214:	02079e63          	bnez	a5,ffffffe000201250 <create_mapping+0x218>
                *third_pgtbl_entry = (uint64_t)(pa + count*PGSIZE)>>12;
ffffffe000201218:	fc843783          	ld	a5,-56(s0)
ffffffe00020121c:	00c79713          	slli	a4,a5,0xc
ffffffe000201220:	f6843783          	ld	a5,-152(s0)
ffffffe000201224:	00f707b3          	add	a5,a4,a5
ffffffe000201228:	00c7d713          	srli	a4,a5,0xc
ffffffe00020122c:	f8043783          	ld	a5,-128(s0)
ffffffe000201230:	00e7b023          	sd	a4,0(a5)
                *third_pgtbl_entry = (uint64_t)((*third_pgtbl_entry << 10)+perm);
ffffffe000201234:	f8043783          	ld	a5,-128(s0)
ffffffe000201238:	0007b783          	ld	a5,0(a5)
ffffffe00020123c:	00a79713          	slli	a4,a5,0xa
ffffffe000201240:	f5843783          	ld	a5,-168(s0)
ffffffe000201244:	00f70733          	add	a4,a4,a5
ffffffe000201248:	f8043783          	ld	a5,-128(s0)
ffffffe00020124c:	00e7b023          	sd	a4,0(a5)
                // third_pgtbl[vpn0] = *third_pgtbl_entry;
            }
            sz -= PGSIZE;
ffffffe000201250:	f6043703          	ld	a4,-160(s0)
ffffffe000201254:	fffff7b7          	lui	a5,0xfffff
ffffffe000201258:	00f707b3          	add	a5,a4,a5
ffffffe00020125c:	f6f43023          	sd	a5,-160(s0)
            count++;
ffffffe000201260:	fc843783          	ld	a5,-56(s0)
ffffffe000201264:	00178793          	addi	a5,a5,1 # fffffffffffff001 <VM_END+0xfffff001>
ffffffe000201268:	fcf43423          	sd	a5,-56(s0)
            vpn0++;
ffffffe00020126c:	fe843783          	ld	a5,-24(s0)
ffffffe000201270:	00178793          	addi	a5,a5,1
ffffffe000201274:	fef43423          	sd	a5,-24(s0)
        while((signed)sz > 0 && vpn0 < entries) {
ffffffe000201278:	f6043783          	ld	a5,-160(s0)
ffffffe00020127c:	0007879b          	sext.w	a5,a5
ffffffe000201280:	00f05863          	blez	a5,ffffffe000201290 <create_mapping+0x258>
ffffffe000201284:	fe843703          	ld	a4,-24(s0)
ffffffe000201288:	f8843783          	ld	a5,-120(s0)
ffffffe00020128c:	f6f764e3          	bltu	a4,a5,ffffffe0002011f4 <create_mapping+0x1bc>
        }
        vpn1++;
ffffffe000201290:	fe043783          	ld	a5,-32(s0)
ffffffe000201294:	00178793          	addi	a5,a5,1
ffffffe000201298:	fef43023          	sd	a5,-32(s0)
        vpn0 = 0;
ffffffe00020129c:	fe043423          	sd	zero,-24(s0)
    while ((signed)sz > 0) {
ffffffe0002012a0:	f6043783          	ld	a5,-160(s0)
ffffffe0002012a4:	0007879b          	sext.w	a5,a5
ffffffe0002012a8:	e8f046e3          	bgtz	a5,ffffffe000201134 <create_mapping+0xfc>
    }
    

}
ffffffe0002012ac:	00000013          	nop
ffffffe0002012b0:	00000013          	nop
ffffffe0002012b4:	0a813083          	ld	ra,168(sp)
ffffffe0002012b8:	0a013403          	ld	s0,160(sp)
ffffffe0002012bc:	0b010113          	addi	sp,sp,176
ffffffe0002012c0:	00008067          	ret

ffffffe0002012c4 <start_kernel>:

extern void test();
extern char _stext[];
extern char _srodata[];

int start_kernel() {
ffffffe0002012c4:	ff010113          	addi	sp,sp,-16
ffffffe0002012c8:	00113423          	sd	ra,8(sp)
ffffffe0002012cc:	00813023          	sd	s0,0(sp)
ffffffe0002012d0:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe0002012d4:	00002517          	auipc	a0,0x2
ffffffe0002012d8:	e9450513          	addi	a0,a0,-364 # ffffffe000203168 <_srodata+0x168>
ffffffe0002012dc:	711000ef          	jal	ffffffe0002021ec <printk>
    printk(" ZJU Operating System\n");
ffffffe0002012e0:	00002517          	auipc	a0,0x2
ffffffe0002012e4:	e9050513          	addi	a0,a0,-368 # ffffffe000203170 <_srodata+0x170>
ffffffe0002012e8:	705000ef          	jal	ffffffe0002021ec <printk>
    // _stext[1] = 'X';
    // _srodata[1] = 'X';
    // printk("text after modify= %c\n", _stext[1]);
    // printk("rodata after modify= %c\n", _srodata[1]);

    test();
ffffffe0002012ec:	01c000ef          	jal	ffffffe000201308 <test>
    return 0;
ffffffe0002012f0:	00000793          	li	a5,0
}
ffffffe0002012f4:	00078513          	mv	a0,a5
ffffffe0002012f8:	00813083          	ld	ra,8(sp)
ffffffe0002012fc:	00013403          	ld	s0,0(sp)
ffffffe000201300:	01010113          	addi	sp,sp,16
ffffffe000201304:	00008067          	ret

ffffffe000201308 <test>:
#include "printk.h"

void test() {
ffffffe000201308:	fe010113          	addi	sp,sp,-32
ffffffe00020130c:	00113c23          	sd	ra,24(sp)
ffffffe000201310:	00813823          	sd	s0,16(sp)
ffffffe000201314:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000201318:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
ffffffe00020131c:	fec42783          	lw	a5,-20(s0)
ffffffe000201320:	0017879b          	addiw	a5,a5,1
ffffffe000201324:	fef42623          	sw	a5,-20(s0)
ffffffe000201328:	fec42783          	lw	a5,-20(s0)
ffffffe00020132c:	00078713          	mv	a4,a5
ffffffe000201330:	05f5e7b7          	lui	a5,0x5f5e
ffffffe000201334:	1007879b          	addiw	a5,a5,256 # 5f5e100 <OPENSBI_SIZE+0x5d5e100>
ffffffe000201338:	02f767bb          	remw	a5,a4,a5
ffffffe00020133c:	0007879b          	sext.w	a5,a5
ffffffe000201340:	fc079ee3          	bnez	a5,ffffffe00020131c <test+0x14>
            printk("kernel is running!\n");
ffffffe000201344:	00002517          	auipc	a0,0x2
ffffffe000201348:	e4450513          	addi	a0,a0,-444 # ffffffe000203188 <_srodata+0x188>
ffffffe00020134c:	6a1000ef          	jal	ffffffe0002021ec <printk>
            i = 0;
ffffffe000201350:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
ffffffe000201354:	fc9ff06f          	j	ffffffe00020131c <test+0x14>

ffffffe000201358 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000201358:	fe010113          	addi	sp,sp,-32
ffffffe00020135c:	00113c23          	sd	ra,24(sp)
ffffffe000201360:	00813823          	sd	s0,16(sp)
ffffffe000201364:	02010413          	addi	s0,sp,32
ffffffe000201368:	00050793          	mv	a5,a0
ffffffe00020136c:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe000201370:	fec42783          	lw	a5,-20(s0)
ffffffe000201374:	0ff7f793          	zext.b	a5,a5
ffffffe000201378:	00078513          	mv	a0,a5
ffffffe00020137c:	849ff0ef          	jal	ffffffe000200bc4 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000201380:	fec42783          	lw	a5,-20(s0)
ffffffe000201384:	0ff7f793          	zext.b	a5,a5
ffffffe000201388:	0007879b          	sext.w	a5,a5
}
ffffffe00020138c:	00078513          	mv	a0,a5
ffffffe000201390:	01813083          	ld	ra,24(sp)
ffffffe000201394:	01013403          	ld	s0,16(sp)
ffffffe000201398:	02010113          	addi	sp,sp,32
ffffffe00020139c:	00008067          	ret

ffffffe0002013a0 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe0002013a0:	fe010113          	addi	sp,sp,-32
ffffffe0002013a4:	00813c23          	sd	s0,24(sp)
ffffffe0002013a8:	02010413          	addi	s0,sp,32
ffffffe0002013ac:	00050793          	mv	a5,a0
ffffffe0002013b0:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe0002013b4:	fec42783          	lw	a5,-20(s0)
ffffffe0002013b8:	0007871b          	sext.w	a4,a5
ffffffe0002013bc:	02000793          	li	a5,32
ffffffe0002013c0:	02f70263          	beq	a4,a5,ffffffe0002013e4 <isspace+0x44>
ffffffe0002013c4:	fec42783          	lw	a5,-20(s0)
ffffffe0002013c8:	0007871b          	sext.w	a4,a5
ffffffe0002013cc:	00800793          	li	a5,8
ffffffe0002013d0:	00e7de63          	bge	a5,a4,ffffffe0002013ec <isspace+0x4c>
ffffffe0002013d4:	fec42783          	lw	a5,-20(s0)
ffffffe0002013d8:	0007871b          	sext.w	a4,a5
ffffffe0002013dc:	00d00793          	li	a5,13
ffffffe0002013e0:	00e7c663          	blt	a5,a4,ffffffe0002013ec <isspace+0x4c>
ffffffe0002013e4:	00100793          	li	a5,1
ffffffe0002013e8:	0080006f          	j	ffffffe0002013f0 <isspace+0x50>
ffffffe0002013ec:	00000793          	li	a5,0
}
ffffffe0002013f0:	00078513          	mv	a0,a5
ffffffe0002013f4:	01813403          	ld	s0,24(sp)
ffffffe0002013f8:	02010113          	addi	sp,sp,32
ffffffe0002013fc:	00008067          	ret

ffffffe000201400 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000201400:	fb010113          	addi	sp,sp,-80
ffffffe000201404:	04113423          	sd	ra,72(sp)
ffffffe000201408:	04813023          	sd	s0,64(sp)
ffffffe00020140c:	05010413          	addi	s0,sp,80
ffffffe000201410:	fca43423          	sd	a0,-56(s0)
ffffffe000201414:	fcb43023          	sd	a1,-64(s0)
ffffffe000201418:	00060793          	mv	a5,a2
ffffffe00020141c:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000201420:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000201424:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000201428:	fc843783          	ld	a5,-56(s0)
ffffffe00020142c:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000201430:	0100006f          	j	ffffffe000201440 <strtol+0x40>
        p++;
ffffffe000201434:	fd843783          	ld	a5,-40(s0)
ffffffe000201438:	00178793          	addi	a5,a5,1
ffffffe00020143c:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000201440:	fd843783          	ld	a5,-40(s0)
ffffffe000201444:	0007c783          	lbu	a5,0(a5)
ffffffe000201448:	0007879b          	sext.w	a5,a5
ffffffe00020144c:	00078513          	mv	a0,a5
ffffffe000201450:	f51ff0ef          	jal	ffffffe0002013a0 <isspace>
ffffffe000201454:	00050793          	mv	a5,a0
ffffffe000201458:	fc079ee3          	bnez	a5,ffffffe000201434 <strtol+0x34>
    }

    if (*p == '-') {
ffffffe00020145c:	fd843783          	ld	a5,-40(s0)
ffffffe000201460:	0007c783          	lbu	a5,0(a5)
ffffffe000201464:	00078713          	mv	a4,a5
ffffffe000201468:	02d00793          	li	a5,45
ffffffe00020146c:	00f71e63          	bne	a4,a5,ffffffe000201488 <strtol+0x88>
        neg = true;
ffffffe000201470:	00100793          	li	a5,1
ffffffe000201474:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe000201478:	fd843783          	ld	a5,-40(s0)
ffffffe00020147c:	00178793          	addi	a5,a5,1
ffffffe000201480:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201484:	0240006f          	j	ffffffe0002014a8 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe000201488:	fd843783          	ld	a5,-40(s0)
ffffffe00020148c:	0007c783          	lbu	a5,0(a5)
ffffffe000201490:	00078713          	mv	a4,a5
ffffffe000201494:	02b00793          	li	a5,43
ffffffe000201498:	00f71863          	bne	a4,a5,ffffffe0002014a8 <strtol+0xa8>
        p++;
ffffffe00020149c:	fd843783          	ld	a5,-40(s0)
ffffffe0002014a0:	00178793          	addi	a5,a5,1
ffffffe0002014a4:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe0002014a8:	fbc42783          	lw	a5,-68(s0)
ffffffe0002014ac:	0007879b          	sext.w	a5,a5
ffffffe0002014b0:	06079c63          	bnez	a5,ffffffe000201528 <strtol+0x128>
        if (*p == '0') {
ffffffe0002014b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002014b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002014bc:	00078713          	mv	a4,a5
ffffffe0002014c0:	03000793          	li	a5,48
ffffffe0002014c4:	04f71e63          	bne	a4,a5,ffffffe000201520 <strtol+0x120>
            p++;
ffffffe0002014c8:	fd843783          	ld	a5,-40(s0)
ffffffe0002014cc:	00178793          	addi	a5,a5,1
ffffffe0002014d0:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe0002014d4:	fd843783          	ld	a5,-40(s0)
ffffffe0002014d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002014dc:	00078713          	mv	a4,a5
ffffffe0002014e0:	07800793          	li	a5,120
ffffffe0002014e4:	00f70c63          	beq	a4,a5,ffffffe0002014fc <strtol+0xfc>
ffffffe0002014e8:	fd843783          	ld	a5,-40(s0)
ffffffe0002014ec:	0007c783          	lbu	a5,0(a5)
ffffffe0002014f0:	00078713          	mv	a4,a5
ffffffe0002014f4:	05800793          	li	a5,88
ffffffe0002014f8:	00f71e63          	bne	a4,a5,ffffffe000201514 <strtol+0x114>
                base = 16;
ffffffe0002014fc:	01000793          	li	a5,16
ffffffe000201500:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe000201504:	fd843783          	ld	a5,-40(s0)
ffffffe000201508:	00178793          	addi	a5,a5,1
ffffffe00020150c:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201510:	0180006f          	j	ffffffe000201528 <strtol+0x128>
            } else {
                base = 8;
ffffffe000201514:	00800793          	li	a5,8
ffffffe000201518:	faf42e23          	sw	a5,-68(s0)
ffffffe00020151c:	00c0006f          	j	ffffffe000201528 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000201520:	00a00793          	li	a5,10
ffffffe000201524:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000201528:	fd843783          	ld	a5,-40(s0)
ffffffe00020152c:	0007c783          	lbu	a5,0(a5)
ffffffe000201530:	00078713          	mv	a4,a5
ffffffe000201534:	02f00793          	li	a5,47
ffffffe000201538:	02e7f863          	bgeu	a5,a4,ffffffe000201568 <strtol+0x168>
ffffffe00020153c:	fd843783          	ld	a5,-40(s0)
ffffffe000201540:	0007c783          	lbu	a5,0(a5)
ffffffe000201544:	00078713          	mv	a4,a5
ffffffe000201548:	03900793          	li	a5,57
ffffffe00020154c:	00e7ee63          	bltu	a5,a4,ffffffe000201568 <strtol+0x168>
            digit = *p - '0';
ffffffe000201550:	fd843783          	ld	a5,-40(s0)
ffffffe000201554:	0007c783          	lbu	a5,0(a5)
ffffffe000201558:	0007879b          	sext.w	a5,a5
ffffffe00020155c:	fd07879b          	addiw	a5,a5,-48
ffffffe000201560:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201564:	0800006f          	j	ffffffe0002015e4 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000201568:	fd843783          	ld	a5,-40(s0)
ffffffe00020156c:	0007c783          	lbu	a5,0(a5)
ffffffe000201570:	00078713          	mv	a4,a5
ffffffe000201574:	06000793          	li	a5,96
ffffffe000201578:	02e7f863          	bgeu	a5,a4,ffffffe0002015a8 <strtol+0x1a8>
ffffffe00020157c:	fd843783          	ld	a5,-40(s0)
ffffffe000201580:	0007c783          	lbu	a5,0(a5)
ffffffe000201584:	00078713          	mv	a4,a5
ffffffe000201588:	07a00793          	li	a5,122
ffffffe00020158c:	00e7ee63          	bltu	a5,a4,ffffffe0002015a8 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe000201590:	fd843783          	ld	a5,-40(s0)
ffffffe000201594:	0007c783          	lbu	a5,0(a5)
ffffffe000201598:	0007879b          	sext.w	a5,a5
ffffffe00020159c:	fa97879b          	addiw	a5,a5,-87
ffffffe0002015a0:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002015a4:	0400006f          	j	ffffffe0002015e4 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002015a8:	fd843783          	ld	a5,-40(s0)
ffffffe0002015ac:	0007c783          	lbu	a5,0(a5)
ffffffe0002015b0:	00078713          	mv	a4,a5
ffffffe0002015b4:	04000793          	li	a5,64
ffffffe0002015b8:	06e7f863          	bgeu	a5,a4,ffffffe000201628 <strtol+0x228>
ffffffe0002015bc:	fd843783          	ld	a5,-40(s0)
ffffffe0002015c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002015c4:	00078713          	mv	a4,a5
ffffffe0002015c8:	05a00793          	li	a5,90
ffffffe0002015cc:	04e7ee63          	bltu	a5,a4,ffffffe000201628 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe0002015d0:	fd843783          	ld	a5,-40(s0)
ffffffe0002015d4:	0007c783          	lbu	a5,0(a5)
ffffffe0002015d8:	0007879b          	sext.w	a5,a5
ffffffe0002015dc:	fc97879b          	addiw	a5,a5,-55
ffffffe0002015e0:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe0002015e4:	fd442783          	lw	a5,-44(s0)
ffffffe0002015e8:	00078713          	mv	a4,a5
ffffffe0002015ec:	fbc42783          	lw	a5,-68(s0)
ffffffe0002015f0:	0007071b          	sext.w	a4,a4
ffffffe0002015f4:	0007879b          	sext.w	a5,a5
ffffffe0002015f8:	02f75663          	bge	a4,a5,ffffffe000201624 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe0002015fc:	fbc42703          	lw	a4,-68(s0)
ffffffe000201600:	fe843783          	ld	a5,-24(s0)
ffffffe000201604:	02f70733          	mul	a4,a4,a5
ffffffe000201608:	fd442783          	lw	a5,-44(s0)
ffffffe00020160c:	00f707b3          	add	a5,a4,a5
ffffffe000201610:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe000201614:	fd843783          	ld	a5,-40(s0)
ffffffe000201618:	00178793          	addi	a5,a5,1
ffffffe00020161c:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000201620:	f09ff06f          	j	ffffffe000201528 <strtol+0x128>
            break;
ffffffe000201624:	00000013          	nop
    }

    if (endptr) {
ffffffe000201628:	fc043783          	ld	a5,-64(s0)
ffffffe00020162c:	00078863          	beqz	a5,ffffffe00020163c <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000201630:	fc043783          	ld	a5,-64(s0)
ffffffe000201634:	fd843703          	ld	a4,-40(s0)
ffffffe000201638:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe00020163c:	fe744783          	lbu	a5,-25(s0)
ffffffe000201640:	0ff7f793          	zext.b	a5,a5
ffffffe000201644:	00078863          	beqz	a5,ffffffe000201654 <strtol+0x254>
ffffffe000201648:	fe843783          	ld	a5,-24(s0)
ffffffe00020164c:	40f007b3          	neg	a5,a5
ffffffe000201650:	0080006f          	j	ffffffe000201658 <strtol+0x258>
ffffffe000201654:	fe843783          	ld	a5,-24(s0)
}
ffffffe000201658:	00078513          	mv	a0,a5
ffffffe00020165c:	04813083          	ld	ra,72(sp)
ffffffe000201660:	04013403          	ld	s0,64(sp)
ffffffe000201664:	05010113          	addi	sp,sp,80
ffffffe000201668:	00008067          	ret

ffffffe00020166c <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe00020166c:	fd010113          	addi	sp,sp,-48
ffffffe000201670:	02113423          	sd	ra,40(sp)
ffffffe000201674:	02813023          	sd	s0,32(sp)
ffffffe000201678:	03010413          	addi	s0,sp,48
ffffffe00020167c:	fca43c23          	sd	a0,-40(s0)
ffffffe000201680:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe000201684:	fd043783          	ld	a5,-48(s0)
ffffffe000201688:	00079863          	bnez	a5,ffffffe000201698 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe00020168c:	00002797          	auipc	a5,0x2
ffffffe000201690:	b1478793          	addi	a5,a5,-1260 # ffffffe0002031a0 <_srodata+0x1a0>
ffffffe000201694:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe000201698:	fd043783          	ld	a5,-48(s0)
ffffffe00020169c:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002016a0:	0240006f          	j	ffffffe0002016c4 <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002016a4:	fe843783          	ld	a5,-24(s0)
ffffffe0002016a8:	00178713          	addi	a4,a5,1
ffffffe0002016ac:	fee43423          	sd	a4,-24(s0)
ffffffe0002016b0:	0007c783          	lbu	a5,0(a5)
ffffffe0002016b4:	0007871b          	sext.w	a4,a5
ffffffe0002016b8:	fd843783          	ld	a5,-40(s0)
ffffffe0002016bc:	00070513          	mv	a0,a4
ffffffe0002016c0:	000780e7          	jalr	a5
    while (*p) {
ffffffe0002016c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002016c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002016cc:	fc079ce3          	bnez	a5,ffffffe0002016a4 <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe0002016d0:	fe843703          	ld	a4,-24(s0)
ffffffe0002016d4:	fd043783          	ld	a5,-48(s0)
ffffffe0002016d8:	40f707b3          	sub	a5,a4,a5
ffffffe0002016dc:	0007879b          	sext.w	a5,a5
}
ffffffe0002016e0:	00078513          	mv	a0,a5
ffffffe0002016e4:	02813083          	ld	ra,40(sp)
ffffffe0002016e8:	02013403          	ld	s0,32(sp)
ffffffe0002016ec:	03010113          	addi	sp,sp,48
ffffffe0002016f0:	00008067          	ret

ffffffe0002016f4 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe0002016f4:	f9010113          	addi	sp,sp,-112
ffffffe0002016f8:	06113423          	sd	ra,104(sp)
ffffffe0002016fc:	06813023          	sd	s0,96(sp)
ffffffe000201700:	07010413          	addi	s0,sp,112
ffffffe000201704:	faa43423          	sd	a0,-88(s0)
ffffffe000201708:	fab43023          	sd	a1,-96(s0)
ffffffe00020170c:	00060793          	mv	a5,a2
ffffffe000201710:	f8d43823          	sd	a3,-112(s0)
ffffffe000201714:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000201718:	f9f44783          	lbu	a5,-97(s0)
ffffffe00020171c:	0ff7f793          	zext.b	a5,a5
ffffffe000201720:	02078663          	beqz	a5,ffffffe00020174c <print_dec_int+0x58>
ffffffe000201724:	fa043703          	ld	a4,-96(s0)
ffffffe000201728:	fff00793          	li	a5,-1
ffffffe00020172c:	03f79793          	slli	a5,a5,0x3f
ffffffe000201730:	00f71e63          	bne	a4,a5,ffffffe00020174c <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe000201734:	00002597          	auipc	a1,0x2
ffffffe000201738:	a7458593          	addi	a1,a1,-1420 # ffffffe0002031a8 <_srodata+0x1a8>
ffffffe00020173c:	fa843503          	ld	a0,-88(s0)
ffffffe000201740:	f2dff0ef          	jal	ffffffe00020166c <puts_wo_nl>
ffffffe000201744:	00050793          	mv	a5,a0
ffffffe000201748:	2a00006f          	j	ffffffe0002019e8 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe00020174c:	f9043783          	ld	a5,-112(s0)
ffffffe000201750:	00c7a783          	lw	a5,12(a5)
ffffffe000201754:	00079a63          	bnez	a5,ffffffe000201768 <print_dec_int+0x74>
ffffffe000201758:	fa043783          	ld	a5,-96(s0)
ffffffe00020175c:	00079663          	bnez	a5,ffffffe000201768 <print_dec_int+0x74>
        return 0;
ffffffe000201760:	00000793          	li	a5,0
ffffffe000201764:	2840006f          	j	ffffffe0002019e8 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe000201768:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe00020176c:	f9f44783          	lbu	a5,-97(s0)
ffffffe000201770:	0ff7f793          	zext.b	a5,a5
ffffffe000201774:	02078063          	beqz	a5,ffffffe000201794 <print_dec_int+0xa0>
ffffffe000201778:	fa043783          	ld	a5,-96(s0)
ffffffe00020177c:	0007dc63          	bgez	a5,ffffffe000201794 <print_dec_int+0xa0>
        neg = true;
ffffffe000201780:	00100793          	li	a5,1
ffffffe000201784:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000201788:	fa043783          	ld	a5,-96(s0)
ffffffe00020178c:	40f007b3          	neg	a5,a5
ffffffe000201790:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe000201794:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe000201798:	f9f44783          	lbu	a5,-97(s0)
ffffffe00020179c:	0ff7f793          	zext.b	a5,a5
ffffffe0002017a0:	02078863          	beqz	a5,ffffffe0002017d0 <print_dec_int+0xdc>
ffffffe0002017a4:	fef44783          	lbu	a5,-17(s0)
ffffffe0002017a8:	0ff7f793          	zext.b	a5,a5
ffffffe0002017ac:	00079e63          	bnez	a5,ffffffe0002017c8 <print_dec_int+0xd4>
ffffffe0002017b0:	f9043783          	ld	a5,-112(s0)
ffffffe0002017b4:	0057c783          	lbu	a5,5(a5)
ffffffe0002017b8:	00079863          	bnez	a5,ffffffe0002017c8 <print_dec_int+0xd4>
ffffffe0002017bc:	f9043783          	ld	a5,-112(s0)
ffffffe0002017c0:	0047c783          	lbu	a5,4(a5)
ffffffe0002017c4:	00078663          	beqz	a5,ffffffe0002017d0 <print_dec_int+0xdc>
ffffffe0002017c8:	00100793          	li	a5,1
ffffffe0002017cc:	0080006f          	j	ffffffe0002017d4 <print_dec_int+0xe0>
ffffffe0002017d0:	00000793          	li	a5,0
ffffffe0002017d4:	fcf40ba3          	sb	a5,-41(s0)
ffffffe0002017d8:	fd744783          	lbu	a5,-41(s0)
ffffffe0002017dc:	0017f793          	andi	a5,a5,1
ffffffe0002017e0:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe0002017e4:	fa043703          	ld	a4,-96(s0)
ffffffe0002017e8:	00a00793          	li	a5,10
ffffffe0002017ec:	02f777b3          	remu	a5,a4,a5
ffffffe0002017f0:	0ff7f713          	zext.b	a4,a5
ffffffe0002017f4:	fe842783          	lw	a5,-24(s0)
ffffffe0002017f8:	0017869b          	addiw	a3,a5,1
ffffffe0002017fc:	fed42423          	sw	a3,-24(s0)
ffffffe000201800:	0307071b          	addiw	a4,a4,48
ffffffe000201804:	0ff77713          	zext.b	a4,a4
ffffffe000201808:	ff078793          	addi	a5,a5,-16
ffffffe00020180c:	008787b3          	add	a5,a5,s0
ffffffe000201810:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe000201814:	fa043703          	ld	a4,-96(s0)
ffffffe000201818:	00a00793          	li	a5,10
ffffffe00020181c:	02f757b3          	divu	a5,a4,a5
ffffffe000201820:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe000201824:	fa043783          	ld	a5,-96(s0)
ffffffe000201828:	fa079ee3          	bnez	a5,ffffffe0002017e4 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe00020182c:	f9043783          	ld	a5,-112(s0)
ffffffe000201830:	00c7a783          	lw	a5,12(a5)
ffffffe000201834:	00078713          	mv	a4,a5
ffffffe000201838:	fff00793          	li	a5,-1
ffffffe00020183c:	02f71063          	bne	a4,a5,ffffffe00020185c <print_dec_int+0x168>
ffffffe000201840:	f9043783          	ld	a5,-112(s0)
ffffffe000201844:	0037c783          	lbu	a5,3(a5)
ffffffe000201848:	00078a63          	beqz	a5,ffffffe00020185c <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe00020184c:	f9043783          	ld	a5,-112(s0)
ffffffe000201850:	0087a703          	lw	a4,8(a5)
ffffffe000201854:	f9043783          	ld	a5,-112(s0)
ffffffe000201858:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe00020185c:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000201860:	f9043783          	ld	a5,-112(s0)
ffffffe000201864:	0087a703          	lw	a4,8(a5)
ffffffe000201868:	fe842783          	lw	a5,-24(s0)
ffffffe00020186c:	fcf42823          	sw	a5,-48(s0)
ffffffe000201870:	f9043783          	ld	a5,-112(s0)
ffffffe000201874:	00c7a783          	lw	a5,12(a5)
ffffffe000201878:	fcf42623          	sw	a5,-52(s0)
ffffffe00020187c:	fd042783          	lw	a5,-48(s0)
ffffffe000201880:	00078593          	mv	a1,a5
ffffffe000201884:	fcc42783          	lw	a5,-52(s0)
ffffffe000201888:	00078613          	mv	a2,a5
ffffffe00020188c:	0006069b          	sext.w	a3,a2
ffffffe000201890:	0005879b          	sext.w	a5,a1
ffffffe000201894:	00f6d463          	bge	a3,a5,ffffffe00020189c <print_dec_int+0x1a8>
ffffffe000201898:	00058613          	mv	a2,a1
ffffffe00020189c:	0006079b          	sext.w	a5,a2
ffffffe0002018a0:	40f707bb          	subw	a5,a4,a5
ffffffe0002018a4:	0007871b          	sext.w	a4,a5
ffffffe0002018a8:	fd744783          	lbu	a5,-41(s0)
ffffffe0002018ac:	0007879b          	sext.w	a5,a5
ffffffe0002018b0:	40f707bb          	subw	a5,a4,a5
ffffffe0002018b4:	fef42023          	sw	a5,-32(s0)
ffffffe0002018b8:	0280006f          	j	ffffffe0002018e0 <print_dec_int+0x1ec>
        putch(' ');
ffffffe0002018bc:	fa843783          	ld	a5,-88(s0)
ffffffe0002018c0:	02000513          	li	a0,32
ffffffe0002018c4:	000780e7          	jalr	a5
        ++written;
ffffffe0002018c8:	fe442783          	lw	a5,-28(s0)
ffffffe0002018cc:	0017879b          	addiw	a5,a5,1
ffffffe0002018d0:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002018d4:	fe042783          	lw	a5,-32(s0)
ffffffe0002018d8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002018dc:	fef42023          	sw	a5,-32(s0)
ffffffe0002018e0:	fe042783          	lw	a5,-32(s0)
ffffffe0002018e4:	0007879b          	sext.w	a5,a5
ffffffe0002018e8:	fcf04ae3          	bgtz	a5,ffffffe0002018bc <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe0002018ec:	fd744783          	lbu	a5,-41(s0)
ffffffe0002018f0:	0ff7f793          	zext.b	a5,a5
ffffffe0002018f4:	04078463          	beqz	a5,ffffffe00020193c <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe0002018f8:	fef44783          	lbu	a5,-17(s0)
ffffffe0002018fc:	0ff7f793          	zext.b	a5,a5
ffffffe000201900:	00078663          	beqz	a5,ffffffe00020190c <print_dec_int+0x218>
ffffffe000201904:	02d00793          	li	a5,45
ffffffe000201908:	01c0006f          	j	ffffffe000201924 <print_dec_int+0x230>
ffffffe00020190c:	f9043783          	ld	a5,-112(s0)
ffffffe000201910:	0057c783          	lbu	a5,5(a5)
ffffffe000201914:	00078663          	beqz	a5,ffffffe000201920 <print_dec_int+0x22c>
ffffffe000201918:	02b00793          	li	a5,43
ffffffe00020191c:	0080006f          	j	ffffffe000201924 <print_dec_int+0x230>
ffffffe000201920:	02000793          	li	a5,32
ffffffe000201924:	fa843703          	ld	a4,-88(s0)
ffffffe000201928:	00078513          	mv	a0,a5
ffffffe00020192c:	000700e7          	jalr	a4
        ++written;
ffffffe000201930:	fe442783          	lw	a5,-28(s0)
ffffffe000201934:	0017879b          	addiw	a5,a5,1
ffffffe000201938:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe00020193c:	fe842783          	lw	a5,-24(s0)
ffffffe000201940:	fcf42e23          	sw	a5,-36(s0)
ffffffe000201944:	0280006f          	j	ffffffe00020196c <print_dec_int+0x278>
        putch('0');
ffffffe000201948:	fa843783          	ld	a5,-88(s0)
ffffffe00020194c:	03000513          	li	a0,48
ffffffe000201950:	000780e7          	jalr	a5
        ++written;
ffffffe000201954:	fe442783          	lw	a5,-28(s0)
ffffffe000201958:	0017879b          	addiw	a5,a5,1
ffffffe00020195c:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000201960:	fdc42783          	lw	a5,-36(s0)
ffffffe000201964:	0017879b          	addiw	a5,a5,1
ffffffe000201968:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020196c:	f9043783          	ld	a5,-112(s0)
ffffffe000201970:	00c7a703          	lw	a4,12(a5)
ffffffe000201974:	fd744783          	lbu	a5,-41(s0)
ffffffe000201978:	0007879b          	sext.w	a5,a5
ffffffe00020197c:	40f707bb          	subw	a5,a4,a5
ffffffe000201980:	0007871b          	sext.w	a4,a5
ffffffe000201984:	fdc42783          	lw	a5,-36(s0)
ffffffe000201988:	0007879b          	sext.w	a5,a5
ffffffe00020198c:	fae7cee3          	blt	a5,a4,ffffffe000201948 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000201990:	fe842783          	lw	a5,-24(s0)
ffffffe000201994:	fff7879b          	addiw	a5,a5,-1
ffffffe000201998:	fcf42c23          	sw	a5,-40(s0)
ffffffe00020199c:	03c0006f          	j	ffffffe0002019d8 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe0002019a0:	fd842783          	lw	a5,-40(s0)
ffffffe0002019a4:	ff078793          	addi	a5,a5,-16
ffffffe0002019a8:	008787b3          	add	a5,a5,s0
ffffffe0002019ac:	fc87c783          	lbu	a5,-56(a5)
ffffffe0002019b0:	0007871b          	sext.w	a4,a5
ffffffe0002019b4:	fa843783          	ld	a5,-88(s0)
ffffffe0002019b8:	00070513          	mv	a0,a4
ffffffe0002019bc:	000780e7          	jalr	a5
        ++written;
ffffffe0002019c0:	fe442783          	lw	a5,-28(s0)
ffffffe0002019c4:	0017879b          	addiw	a5,a5,1
ffffffe0002019c8:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002019cc:	fd842783          	lw	a5,-40(s0)
ffffffe0002019d0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002019d4:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002019d8:	fd842783          	lw	a5,-40(s0)
ffffffe0002019dc:	0007879b          	sext.w	a5,a5
ffffffe0002019e0:	fc07d0e3          	bgez	a5,ffffffe0002019a0 <print_dec_int+0x2ac>
    }

    return written;
ffffffe0002019e4:	fe442783          	lw	a5,-28(s0)
}
ffffffe0002019e8:	00078513          	mv	a0,a5
ffffffe0002019ec:	06813083          	ld	ra,104(sp)
ffffffe0002019f0:	06013403          	ld	s0,96(sp)
ffffffe0002019f4:	07010113          	addi	sp,sp,112
ffffffe0002019f8:	00008067          	ret

ffffffe0002019fc <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe0002019fc:	f4010113          	addi	sp,sp,-192
ffffffe000201a00:	0a113c23          	sd	ra,184(sp)
ffffffe000201a04:	0a813823          	sd	s0,176(sp)
ffffffe000201a08:	0c010413          	addi	s0,sp,192
ffffffe000201a0c:	f4a43c23          	sd	a0,-168(s0)
ffffffe000201a10:	f4b43823          	sd	a1,-176(s0)
ffffffe000201a14:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000201a18:	f8043023          	sd	zero,-128(s0)
ffffffe000201a1c:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000201a20:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe000201a24:	7a40006f          	j	ffffffe0002021c8 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000201a28:	f8044783          	lbu	a5,-128(s0)
ffffffe000201a2c:	72078e63          	beqz	a5,ffffffe000202168 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000201a30:	f5043783          	ld	a5,-176(s0)
ffffffe000201a34:	0007c783          	lbu	a5,0(a5)
ffffffe000201a38:	00078713          	mv	a4,a5
ffffffe000201a3c:	02300793          	li	a5,35
ffffffe000201a40:	00f71863          	bne	a4,a5,ffffffe000201a50 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe000201a44:	00100793          	li	a5,1
ffffffe000201a48:	f8f40123          	sb	a5,-126(s0)
ffffffe000201a4c:	7700006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000201a50:	f5043783          	ld	a5,-176(s0)
ffffffe000201a54:	0007c783          	lbu	a5,0(a5)
ffffffe000201a58:	00078713          	mv	a4,a5
ffffffe000201a5c:	03000793          	li	a5,48
ffffffe000201a60:	00f71863          	bne	a4,a5,ffffffe000201a70 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe000201a64:	00100793          	li	a5,1
ffffffe000201a68:	f8f401a3          	sb	a5,-125(s0)
ffffffe000201a6c:	7500006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000201a70:	f5043783          	ld	a5,-176(s0)
ffffffe000201a74:	0007c783          	lbu	a5,0(a5)
ffffffe000201a78:	00078713          	mv	a4,a5
ffffffe000201a7c:	06c00793          	li	a5,108
ffffffe000201a80:	04f70063          	beq	a4,a5,ffffffe000201ac0 <vprintfmt+0xc4>
ffffffe000201a84:	f5043783          	ld	a5,-176(s0)
ffffffe000201a88:	0007c783          	lbu	a5,0(a5)
ffffffe000201a8c:	00078713          	mv	a4,a5
ffffffe000201a90:	07a00793          	li	a5,122
ffffffe000201a94:	02f70663          	beq	a4,a5,ffffffe000201ac0 <vprintfmt+0xc4>
ffffffe000201a98:	f5043783          	ld	a5,-176(s0)
ffffffe000201a9c:	0007c783          	lbu	a5,0(a5)
ffffffe000201aa0:	00078713          	mv	a4,a5
ffffffe000201aa4:	07400793          	li	a5,116
ffffffe000201aa8:	00f70c63          	beq	a4,a5,ffffffe000201ac0 <vprintfmt+0xc4>
ffffffe000201aac:	f5043783          	ld	a5,-176(s0)
ffffffe000201ab0:	0007c783          	lbu	a5,0(a5)
ffffffe000201ab4:	00078713          	mv	a4,a5
ffffffe000201ab8:	06a00793          	li	a5,106
ffffffe000201abc:	00f71863          	bne	a4,a5,ffffffe000201acc <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe000201ac0:	00100793          	li	a5,1
ffffffe000201ac4:	f8f400a3          	sb	a5,-127(s0)
ffffffe000201ac8:	6f40006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe000201acc:	f5043783          	ld	a5,-176(s0)
ffffffe000201ad0:	0007c783          	lbu	a5,0(a5)
ffffffe000201ad4:	00078713          	mv	a4,a5
ffffffe000201ad8:	02b00793          	li	a5,43
ffffffe000201adc:	00f71863          	bne	a4,a5,ffffffe000201aec <vprintfmt+0xf0>
                flags.sign = true;
ffffffe000201ae0:	00100793          	li	a5,1
ffffffe000201ae4:	f8f402a3          	sb	a5,-123(s0)
ffffffe000201ae8:	6d40006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe000201aec:	f5043783          	ld	a5,-176(s0)
ffffffe000201af0:	0007c783          	lbu	a5,0(a5)
ffffffe000201af4:	00078713          	mv	a4,a5
ffffffe000201af8:	02000793          	li	a5,32
ffffffe000201afc:	00f71863          	bne	a4,a5,ffffffe000201b0c <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000201b00:	00100793          	li	a5,1
ffffffe000201b04:	f8f40223          	sb	a5,-124(s0)
ffffffe000201b08:	6b40006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000201b0c:	f5043783          	ld	a5,-176(s0)
ffffffe000201b10:	0007c783          	lbu	a5,0(a5)
ffffffe000201b14:	00078713          	mv	a4,a5
ffffffe000201b18:	02a00793          	li	a5,42
ffffffe000201b1c:	00f71e63          	bne	a4,a5,ffffffe000201b38 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000201b20:	f4843783          	ld	a5,-184(s0)
ffffffe000201b24:	00878713          	addi	a4,a5,8
ffffffe000201b28:	f4e43423          	sd	a4,-184(s0)
ffffffe000201b2c:	0007a783          	lw	a5,0(a5)
ffffffe000201b30:	f8f42423          	sw	a5,-120(s0)
ffffffe000201b34:	6880006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000201b38:	f5043783          	ld	a5,-176(s0)
ffffffe000201b3c:	0007c783          	lbu	a5,0(a5)
ffffffe000201b40:	00078713          	mv	a4,a5
ffffffe000201b44:	03000793          	li	a5,48
ffffffe000201b48:	04e7f663          	bgeu	a5,a4,ffffffe000201b94 <vprintfmt+0x198>
ffffffe000201b4c:	f5043783          	ld	a5,-176(s0)
ffffffe000201b50:	0007c783          	lbu	a5,0(a5)
ffffffe000201b54:	00078713          	mv	a4,a5
ffffffe000201b58:	03900793          	li	a5,57
ffffffe000201b5c:	02e7ec63          	bltu	a5,a4,ffffffe000201b94 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000201b60:	f5043783          	ld	a5,-176(s0)
ffffffe000201b64:	f5040713          	addi	a4,s0,-176
ffffffe000201b68:	00a00613          	li	a2,10
ffffffe000201b6c:	00070593          	mv	a1,a4
ffffffe000201b70:	00078513          	mv	a0,a5
ffffffe000201b74:	88dff0ef          	jal	ffffffe000201400 <strtol>
ffffffe000201b78:	00050793          	mv	a5,a0
ffffffe000201b7c:	0007879b          	sext.w	a5,a5
ffffffe000201b80:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe000201b84:	f5043783          	ld	a5,-176(s0)
ffffffe000201b88:	fff78793          	addi	a5,a5,-1
ffffffe000201b8c:	f4f43823          	sd	a5,-176(s0)
ffffffe000201b90:	62c0006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe000201b94:	f5043783          	ld	a5,-176(s0)
ffffffe000201b98:	0007c783          	lbu	a5,0(a5)
ffffffe000201b9c:	00078713          	mv	a4,a5
ffffffe000201ba0:	02e00793          	li	a5,46
ffffffe000201ba4:	06f71863          	bne	a4,a5,ffffffe000201c14 <vprintfmt+0x218>
                fmt++;
ffffffe000201ba8:	f5043783          	ld	a5,-176(s0)
ffffffe000201bac:	00178793          	addi	a5,a5,1
ffffffe000201bb0:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe000201bb4:	f5043783          	ld	a5,-176(s0)
ffffffe000201bb8:	0007c783          	lbu	a5,0(a5)
ffffffe000201bbc:	00078713          	mv	a4,a5
ffffffe000201bc0:	02a00793          	li	a5,42
ffffffe000201bc4:	00f71e63          	bne	a4,a5,ffffffe000201be0 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe000201bc8:	f4843783          	ld	a5,-184(s0)
ffffffe000201bcc:	00878713          	addi	a4,a5,8
ffffffe000201bd0:	f4e43423          	sd	a4,-184(s0)
ffffffe000201bd4:	0007a783          	lw	a5,0(a5)
ffffffe000201bd8:	f8f42623          	sw	a5,-116(s0)
ffffffe000201bdc:	5e00006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe000201be0:	f5043783          	ld	a5,-176(s0)
ffffffe000201be4:	f5040713          	addi	a4,s0,-176
ffffffe000201be8:	00a00613          	li	a2,10
ffffffe000201bec:	00070593          	mv	a1,a4
ffffffe000201bf0:	00078513          	mv	a0,a5
ffffffe000201bf4:	80dff0ef          	jal	ffffffe000201400 <strtol>
ffffffe000201bf8:	00050793          	mv	a5,a0
ffffffe000201bfc:	0007879b          	sext.w	a5,a5
ffffffe000201c00:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe000201c04:	f5043783          	ld	a5,-176(s0)
ffffffe000201c08:	fff78793          	addi	a5,a5,-1
ffffffe000201c0c:	f4f43823          	sd	a5,-176(s0)
ffffffe000201c10:	5ac0006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000201c14:	f5043783          	ld	a5,-176(s0)
ffffffe000201c18:	0007c783          	lbu	a5,0(a5)
ffffffe000201c1c:	00078713          	mv	a4,a5
ffffffe000201c20:	07800793          	li	a5,120
ffffffe000201c24:	02f70663          	beq	a4,a5,ffffffe000201c50 <vprintfmt+0x254>
ffffffe000201c28:	f5043783          	ld	a5,-176(s0)
ffffffe000201c2c:	0007c783          	lbu	a5,0(a5)
ffffffe000201c30:	00078713          	mv	a4,a5
ffffffe000201c34:	05800793          	li	a5,88
ffffffe000201c38:	00f70c63          	beq	a4,a5,ffffffe000201c50 <vprintfmt+0x254>
ffffffe000201c3c:	f5043783          	ld	a5,-176(s0)
ffffffe000201c40:	0007c783          	lbu	a5,0(a5)
ffffffe000201c44:	00078713          	mv	a4,a5
ffffffe000201c48:	07000793          	li	a5,112
ffffffe000201c4c:	30f71263          	bne	a4,a5,ffffffe000201f50 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000201c50:	f5043783          	ld	a5,-176(s0)
ffffffe000201c54:	0007c783          	lbu	a5,0(a5)
ffffffe000201c58:	00078713          	mv	a4,a5
ffffffe000201c5c:	07000793          	li	a5,112
ffffffe000201c60:	00f70663          	beq	a4,a5,ffffffe000201c6c <vprintfmt+0x270>
ffffffe000201c64:	f8144783          	lbu	a5,-127(s0)
ffffffe000201c68:	00078663          	beqz	a5,ffffffe000201c74 <vprintfmt+0x278>
ffffffe000201c6c:	00100793          	li	a5,1
ffffffe000201c70:	0080006f          	j	ffffffe000201c78 <vprintfmt+0x27c>
ffffffe000201c74:	00000793          	li	a5,0
ffffffe000201c78:	faf403a3          	sb	a5,-89(s0)
ffffffe000201c7c:	fa744783          	lbu	a5,-89(s0)
ffffffe000201c80:	0017f793          	andi	a5,a5,1
ffffffe000201c84:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000201c88:	fa744783          	lbu	a5,-89(s0)
ffffffe000201c8c:	0ff7f793          	zext.b	a5,a5
ffffffe000201c90:	00078c63          	beqz	a5,ffffffe000201ca8 <vprintfmt+0x2ac>
ffffffe000201c94:	f4843783          	ld	a5,-184(s0)
ffffffe000201c98:	00878713          	addi	a4,a5,8
ffffffe000201c9c:	f4e43423          	sd	a4,-184(s0)
ffffffe000201ca0:	0007b783          	ld	a5,0(a5)
ffffffe000201ca4:	01c0006f          	j	ffffffe000201cc0 <vprintfmt+0x2c4>
ffffffe000201ca8:	f4843783          	ld	a5,-184(s0)
ffffffe000201cac:	00878713          	addi	a4,a5,8
ffffffe000201cb0:	f4e43423          	sd	a4,-184(s0)
ffffffe000201cb4:	0007a783          	lw	a5,0(a5)
ffffffe000201cb8:	02079793          	slli	a5,a5,0x20
ffffffe000201cbc:	0207d793          	srli	a5,a5,0x20
ffffffe000201cc0:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe000201cc4:	f8c42783          	lw	a5,-116(s0)
ffffffe000201cc8:	02079463          	bnez	a5,ffffffe000201cf0 <vprintfmt+0x2f4>
ffffffe000201ccc:	fe043783          	ld	a5,-32(s0)
ffffffe000201cd0:	02079063          	bnez	a5,ffffffe000201cf0 <vprintfmt+0x2f4>
ffffffe000201cd4:	f5043783          	ld	a5,-176(s0)
ffffffe000201cd8:	0007c783          	lbu	a5,0(a5)
ffffffe000201cdc:	00078713          	mv	a4,a5
ffffffe000201ce0:	07000793          	li	a5,112
ffffffe000201ce4:	00f70663          	beq	a4,a5,ffffffe000201cf0 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe000201ce8:	f8040023          	sb	zero,-128(s0)
ffffffe000201cec:	4d00006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe000201cf0:	f5043783          	ld	a5,-176(s0)
ffffffe000201cf4:	0007c783          	lbu	a5,0(a5)
ffffffe000201cf8:	00078713          	mv	a4,a5
ffffffe000201cfc:	07000793          	li	a5,112
ffffffe000201d00:	00f70a63          	beq	a4,a5,ffffffe000201d14 <vprintfmt+0x318>
ffffffe000201d04:	f8244783          	lbu	a5,-126(s0)
ffffffe000201d08:	00078a63          	beqz	a5,ffffffe000201d1c <vprintfmt+0x320>
ffffffe000201d0c:	fe043783          	ld	a5,-32(s0)
ffffffe000201d10:	00078663          	beqz	a5,ffffffe000201d1c <vprintfmt+0x320>
ffffffe000201d14:	00100793          	li	a5,1
ffffffe000201d18:	0080006f          	j	ffffffe000201d20 <vprintfmt+0x324>
ffffffe000201d1c:	00000793          	li	a5,0
ffffffe000201d20:	faf40323          	sb	a5,-90(s0)
ffffffe000201d24:	fa644783          	lbu	a5,-90(s0)
ffffffe000201d28:	0017f793          	andi	a5,a5,1
ffffffe000201d2c:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000201d30:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe000201d34:	f5043783          	ld	a5,-176(s0)
ffffffe000201d38:	0007c783          	lbu	a5,0(a5)
ffffffe000201d3c:	00078713          	mv	a4,a5
ffffffe000201d40:	05800793          	li	a5,88
ffffffe000201d44:	00f71863          	bne	a4,a5,ffffffe000201d54 <vprintfmt+0x358>
ffffffe000201d48:	00001797          	auipc	a5,0x1
ffffffe000201d4c:	47878793          	addi	a5,a5,1144 # ffffffe0002031c0 <upperxdigits.1>
ffffffe000201d50:	00c0006f          	j	ffffffe000201d5c <vprintfmt+0x360>
ffffffe000201d54:	00001797          	auipc	a5,0x1
ffffffe000201d58:	48478793          	addi	a5,a5,1156 # ffffffe0002031d8 <lowerxdigits.0>
ffffffe000201d5c:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000201d60:	fe043783          	ld	a5,-32(s0)
ffffffe000201d64:	00f7f793          	andi	a5,a5,15
ffffffe000201d68:	f9843703          	ld	a4,-104(s0)
ffffffe000201d6c:	00f70733          	add	a4,a4,a5
ffffffe000201d70:	fdc42783          	lw	a5,-36(s0)
ffffffe000201d74:	0017869b          	addiw	a3,a5,1
ffffffe000201d78:	fcd42e23          	sw	a3,-36(s0)
ffffffe000201d7c:	00074703          	lbu	a4,0(a4)
ffffffe000201d80:	ff078793          	addi	a5,a5,-16
ffffffe000201d84:	008787b3          	add	a5,a5,s0
ffffffe000201d88:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000201d8c:	fe043783          	ld	a5,-32(s0)
ffffffe000201d90:	0047d793          	srli	a5,a5,0x4
ffffffe000201d94:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe000201d98:	fe043783          	ld	a5,-32(s0)
ffffffe000201d9c:	fc0792e3          	bnez	a5,ffffffe000201d60 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe000201da0:	f8c42783          	lw	a5,-116(s0)
ffffffe000201da4:	00078713          	mv	a4,a5
ffffffe000201da8:	fff00793          	li	a5,-1
ffffffe000201dac:	02f71663          	bne	a4,a5,ffffffe000201dd8 <vprintfmt+0x3dc>
ffffffe000201db0:	f8344783          	lbu	a5,-125(s0)
ffffffe000201db4:	02078263          	beqz	a5,ffffffe000201dd8 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe000201db8:	f8842703          	lw	a4,-120(s0)
ffffffe000201dbc:	fa644783          	lbu	a5,-90(s0)
ffffffe000201dc0:	0007879b          	sext.w	a5,a5
ffffffe000201dc4:	0017979b          	slliw	a5,a5,0x1
ffffffe000201dc8:	0007879b          	sext.w	a5,a5
ffffffe000201dcc:	40f707bb          	subw	a5,a4,a5
ffffffe000201dd0:	0007879b          	sext.w	a5,a5
ffffffe000201dd4:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000201dd8:	f8842703          	lw	a4,-120(s0)
ffffffe000201ddc:	fa644783          	lbu	a5,-90(s0)
ffffffe000201de0:	0007879b          	sext.w	a5,a5
ffffffe000201de4:	0017979b          	slliw	a5,a5,0x1
ffffffe000201de8:	0007879b          	sext.w	a5,a5
ffffffe000201dec:	40f707bb          	subw	a5,a4,a5
ffffffe000201df0:	0007871b          	sext.w	a4,a5
ffffffe000201df4:	fdc42783          	lw	a5,-36(s0)
ffffffe000201df8:	f8f42a23          	sw	a5,-108(s0)
ffffffe000201dfc:	f8c42783          	lw	a5,-116(s0)
ffffffe000201e00:	f8f42823          	sw	a5,-112(s0)
ffffffe000201e04:	f9442783          	lw	a5,-108(s0)
ffffffe000201e08:	00078593          	mv	a1,a5
ffffffe000201e0c:	f9042783          	lw	a5,-112(s0)
ffffffe000201e10:	00078613          	mv	a2,a5
ffffffe000201e14:	0006069b          	sext.w	a3,a2
ffffffe000201e18:	0005879b          	sext.w	a5,a1
ffffffe000201e1c:	00f6d463          	bge	a3,a5,ffffffe000201e24 <vprintfmt+0x428>
ffffffe000201e20:	00058613          	mv	a2,a1
ffffffe000201e24:	0006079b          	sext.w	a5,a2
ffffffe000201e28:	40f707bb          	subw	a5,a4,a5
ffffffe000201e2c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201e30:	0280006f          	j	ffffffe000201e58 <vprintfmt+0x45c>
                    putch(' ');
ffffffe000201e34:	f5843783          	ld	a5,-168(s0)
ffffffe000201e38:	02000513          	li	a0,32
ffffffe000201e3c:	000780e7          	jalr	a5
                    ++written;
ffffffe000201e40:	fec42783          	lw	a5,-20(s0)
ffffffe000201e44:	0017879b          	addiw	a5,a5,1
ffffffe000201e48:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000201e4c:	fd842783          	lw	a5,-40(s0)
ffffffe000201e50:	fff7879b          	addiw	a5,a5,-1
ffffffe000201e54:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201e58:	fd842783          	lw	a5,-40(s0)
ffffffe000201e5c:	0007879b          	sext.w	a5,a5
ffffffe000201e60:	fcf04ae3          	bgtz	a5,ffffffe000201e34 <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe000201e64:	fa644783          	lbu	a5,-90(s0)
ffffffe000201e68:	0ff7f793          	zext.b	a5,a5
ffffffe000201e6c:	04078463          	beqz	a5,ffffffe000201eb4 <vprintfmt+0x4b8>
                    putch('0');
ffffffe000201e70:	f5843783          	ld	a5,-168(s0)
ffffffe000201e74:	03000513          	li	a0,48
ffffffe000201e78:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000201e7c:	f5043783          	ld	a5,-176(s0)
ffffffe000201e80:	0007c783          	lbu	a5,0(a5)
ffffffe000201e84:	00078713          	mv	a4,a5
ffffffe000201e88:	05800793          	li	a5,88
ffffffe000201e8c:	00f71663          	bne	a4,a5,ffffffe000201e98 <vprintfmt+0x49c>
ffffffe000201e90:	05800793          	li	a5,88
ffffffe000201e94:	0080006f          	j	ffffffe000201e9c <vprintfmt+0x4a0>
ffffffe000201e98:	07800793          	li	a5,120
ffffffe000201e9c:	f5843703          	ld	a4,-168(s0)
ffffffe000201ea0:	00078513          	mv	a0,a5
ffffffe000201ea4:	000700e7          	jalr	a4
                    written += 2;
ffffffe000201ea8:	fec42783          	lw	a5,-20(s0)
ffffffe000201eac:	0027879b          	addiw	a5,a5,2
ffffffe000201eb0:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000201eb4:	fdc42783          	lw	a5,-36(s0)
ffffffe000201eb8:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201ebc:	0280006f          	j	ffffffe000201ee4 <vprintfmt+0x4e8>
                    putch('0');
ffffffe000201ec0:	f5843783          	ld	a5,-168(s0)
ffffffe000201ec4:	03000513          	li	a0,48
ffffffe000201ec8:	000780e7          	jalr	a5
                    ++written;
ffffffe000201ecc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ed0:	0017879b          	addiw	a5,a5,1
ffffffe000201ed4:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe000201ed8:	fd442783          	lw	a5,-44(s0)
ffffffe000201edc:	0017879b          	addiw	a5,a5,1
ffffffe000201ee0:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201ee4:	f8c42703          	lw	a4,-116(s0)
ffffffe000201ee8:	fd442783          	lw	a5,-44(s0)
ffffffe000201eec:	0007879b          	sext.w	a5,a5
ffffffe000201ef0:	fce7c8e3          	blt	a5,a4,ffffffe000201ec0 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000201ef4:	fdc42783          	lw	a5,-36(s0)
ffffffe000201ef8:	fff7879b          	addiw	a5,a5,-1
ffffffe000201efc:	fcf42823          	sw	a5,-48(s0)
ffffffe000201f00:	03c0006f          	j	ffffffe000201f3c <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000201f04:	fd042783          	lw	a5,-48(s0)
ffffffe000201f08:	ff078793          	addi	a5,a5,-16
ffffffe000201f0c:	008787b3          	add	a5,a5,s0
ffffffe000201f10:	f807c783          	lbu	a5,-128(a5)
ffffffe000201f14:	0007871b          	sext.w	a4,a5
ffffffe000201f18:	f5843783          	ld	a5,-168(s0)
ffffffe000201f1c:	00070513          	mv	a0,a4
ffffffe000201f20:	000780e7          	jalr	a5
                    ++written;
ffffffe000201f24:	fec42783          	lw	a5,-20(s0)
ffffffe000201f28:	0017879b          	addiw	a5,a5,1
ffffffe000201f2c:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000201f30:	fd042783          	lw	a5,-48(s0)
ffffffe000201f34:	fff7879b          	addiw	a5,a5,-1
ffffffe000201f38:	fcf42823          	sw	a5,-48(s0)
ffffffe000201f3c:	fd042783          	lw	a5,-48(s0)
ffffffe000201f40:	0007879b          	sext.w	a5,a5
ffffffe000201f44:	fc07d0e3          	bgez	a5,ffffffe000201f04 <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000201f48:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000201f4c:	2700006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000201f50:	f5043783          	ld	a5,-176(s0)
ffffffe000201f54:	0007c783          	lbu	a5,0(a5)
ffffffe000201f58:	00078713          	mv	a4,a5
ffffffe000201f5c:	06400793          	li	a5,100
ffffffe000201f60:	02f70663          	beq	a4,a5,ffffffe000201f8c <vprintfmt+0x590>
ffffffe000201f64:	f5043783          	ld	a5,-176(s0)
ffffffe000201f68:	0007c783          	lbu	a5,0(a5)
ffffffe000201f6c:	00078713          	mv	a4,a5
ffffffe000201f70:	06900793          	li	a5,105
ffffffe000201f74:	00f70c63          	beq	a4,a5,ffffffe000201f8c <vprintfmt+0x590>
ffffffe000201f78:	f5043783          	ld	a5,-176(s0)
ffffffe000201f7c:	0007c783          	lbu	a5,0(a5)
ffffffe000201f80:	00078713          	mv	a4,a5
ffffffe000201f84:	07500793          	li	a5,117
ffffffe000201f88:	08f71063          	bne	a4,a5,ffffffe000202008 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000201f8c:	f8144783          	lbu	a5,-127(s0)
ffffffe000201f90:	00078c63          	beqz	a5,ffffffe000201fa8 <vprintfmt+0x5ac>
ffffffe000201f94:	f4843783          	ld	a5,-184(s0)
ffffffe000201f98:	00878713          	addi	a4,a5,8
ffffffe000201f9c:	f4e43423          	sd	a4,-184(s0)
ffffffe000201fa0:	0007b783          	ld	a5,0(a5)
ffffffe000201fa4:	0140006f          	j	ffffffe000201fb8 <vprintfmt+0x5bc>
ffffffe000201fa8:	f4843783          	ld	a5,-184(s0)
ffffffe000201fac:	00878713          	addi	a4,a5,8
ffffffe000201fb0:	f4e43423          	sd	a4,-184(s0)
ffffffe000201fb4:	0007a783          	lw	a5,0(a5)
ffffffe000201fb8:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000201fbc:	fa843583          	ld	a1,-88(s0)
ffffffe000201fc0:	f5043783          	ld	a5,-176(s0)
ffffffe000201fc4:	0007c783          	lbu	a5,0(a5)
ffffffe000201fc8:	0007871b          	sext.w	a4,a5
ffffffe000201fcc:	07500793          	li	a5,117
ffffffe000201fd0:	40f707b3          	sub	a5,a4,a5
ffffffe000201fd4:	00f037b3          	snez	a5,a5
ffffffe000201fd8:	0ff7f793          	zext.b	a5,a5
ffffffe000201fdc:	f8040713          	addi	a4,s0,-128
ffffffe000201fe0:	00070693          	mv	a3,a4
ffffffe000201fe4:	00078613          	mv	a2,a5
ffffffe000201fe8:	f5843503          	ld	a0,-168(s0)
ffffffe000201fec:	f08ff0ef          	jal	ffffffe0002016f4 <print_dec_int>
ffffffe000201ff0:	00050793          	mv	a5,a0
ffffffe000201ff4:	fec42703          	lw	a4,-20(s0)
ffffffe000201ff8:	00f707bb          	addw	a5,a4,a5
ffffffe000201ffc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202000:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202004:	1b80006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202008:	f5043783          	ld	a5,-176(s0)
ffffffe00020200c:	0007c783          	lbu	a5,0(a5)
ffffffe000202010:	00078713          	mv	a4,a5
ffffffe000202014:	06e00793          	li	a5,110
ffffffe000202018:	04f71c63          	bne	a4,a5,ffffffe000202070 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe00020201c:	f8144783          	lbu	a5,-127(s0)
ffffffe000202020:	02078463          	beqz	a5,ffffffe000202048 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000202024:	f4843783          	ld	a5,-184(s0)
ffffffe000202028:	00878713          	addi	a4,a5,8
ffffffe00020202c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202030:	0007b783          	ld	a5,0(a5)
ffffffe000202034:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202038:	fec42703          	lw	a4,-20(s0)
ffffffe00020203c:	fb043783          	ld	a5,-80(s0)
ffffffe000202040:	00e7b023          	sd	a4,0(a5)
ffffffe000202044:	0240006f          	j	ffffffe000202068 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000202048:	f4843783          	ld	a5,-184(s0)
ffffffe00020204c:	00878713          	addi	a4,a5,8
ffffffe000202050:	f4e43423          	sd	a4,-184(s0)
ffffffe000202054:	0007b783          	ld	a5,0(a5)
ffffffe000202058:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe00020205c:	fb843783          	ld	a5,-72(s0)
ffffffe000202060:	fec42703          	lw	a4,-20(s0)
ffffffe000202064:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000202068:	f8040023          	sb	zero,-128(s0)
ffffffe00020206c:	1500006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe000202070:	f5043783          	ld	a5,-176(s0)
ffffffe000202074:	0007c783          	lbu	a5,0(a5)
ffffffe000202078:	00078713          	mv	a4,a5
ffffffe00020207c:	07300793          	li	a5,115
ffffffe000202080:	02f71e63          	bne	a4,a5,ffffffe0002020bc <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000202084:	f4843783          	ld	a5,-184(s0)
ffffffe000202088:	00878713          	addi	a4,a5,8
ffffffe00020208c:	f4e43423          	sd	a4,-184(s0)
ffffffe000202090:	0007b783          	ld	a5,0(a5)
ffffffe000202094:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000202098:	fc043583          	ld	a1,-64(s0)
ffffffe00020209c:	f5843503          	ld	a0,-168(s0)
ffffffe0002020a0:	dccff0ef          	jal	ffffffe00020166c <puts_wo_nl>
ffffffe0002020a4:	00050793          	mv	a5,a0
ffffffe0002020a8:	fec42703          	lw	a4,-20(s0)
ffffffe0002020ac:	00f707bb          	addw	a5,a4,a5
ffffffe0002020b0:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe0002020b4:	f8040023          	sb	zero,-128(s0)
ffffffe0002020b8:	1040006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe0002020bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002020c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002020c4:	00078713          	mv	a4,a5
ffffffe0002020c8:	06300793          	li	a5,99
ffffffe0002020cc:	02f71e63          	bne	a4,a5,ffffffe000202108 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe0002020d0:	f4843783          	ld	a5,-184(s0)
ffffffe0002020d4:	00878713          	addi	a4,a5,8
ffffffe0002020d8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002020dc:	0007a783          	lw	a5,0(a5)
ffffffe0002020e0:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe0002020e4:	fcc42703          	lw	a4,-52(s0)
ffffffe0002020e8:	f5843783          	ld	a5,-168(s0)
ffffffe0002020ec:	00070513          	mv	a0,a4
ffffffe0002020f0:	000780e7          	jalr	a5
                ++written;
ffffffe0002020f4:	fec42783          	lw	a5,-20(s0)
ffffffe0002020f8:	0017879b          	addiw	a5,a5,1
ffffffe0002020fc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202100:	f8040023          	sb	zero,-128(s0)
ffffffe000202104:	0b80006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000202108:	f5043783          	ld	a5,-176(s0)
ffffffe00020210c:	0007c783          	lbu	a5,0(a5)
ffffffe000202110:	00078713          	mv	a4,a5
ffffffe000202114:	02500793          	li	a5,37
ffffffe000202118:	02f71263          	bne	a4,a5,ffffffe00020213c <vprintfmt+0x740>
                putch('%');
ffffffe00020211c:	f5843783          	ld	a5,-168(s0)
ffffffe000202120:	02500513          	li	a0,37
ffffffe000202124:	000780e7          	jalr	a5
                ++written;
ffffffe000202128:	fec42783          	lw	a5,-20(s0)
ffffffe00020212c:	0017879b          	addiw	a5,a5,1
ffffffe000202130:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202134:	f8040023          	sb	zero,-128(s0)
ffffffe000202138:	0840006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe00020213c:	f5043783          	ld	a5,-176(s0)
ffffffe000202140:	0007c783          	lbu	a5,0(a5)
ffffffe000202144:	0007871b          	sext.w	a4,a5
ffffffe000202148:	f5843783          	ld	a5,-168(s0)
ffffffe00020214c:	00070513          	mv	a0,a4
ffffffe000202150:	000780e7          	jalr	a5
                ++written;
ffffffe000202154:	fec42783          	lw	a5,-20(s0)
ffffffe000202158:	0017879b          	addiw	a5,a5,1
ffffffe00020215c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202160:	f8040023          	sb	zero,-128(s0)
ffffffe000202164:	0580006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe000202168:	f5043783          	ld	a5,-176(s0)
ffffffe00020216c:	0007c783          	lbu	a5,0(a5)
ffffffe000202170:	00078713          	mv	a4,a5
ffffffe000202174:	02500793          	li	a5,37
ffffffe000202178:	02f71063          	bne	a4,a5,ffffffe000202198 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe00020217c:	f8043023          	sd	zero,-128(s0)
ffffffe000202180:	f8043423          	sd	zero,-120(s0)
ffffffe000202184:	00100793          	li	a5,1
ffffffe000202188:	f8f40023          	sb	a5,-128(s0)
ffffffe00020218c:	fff00793          	li	a5,-1
ffffffe000202190:	f8f42623          	sw	a5,-116(s0)
ffffffe000202194:	0280006f          	j	ffffffe0002021bc <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe000202198:	f5043783          	ld	a5,-176(s0)
ffffffe00020219c:	0007c783          	lbu	a5,0(a5)
ffffffe0002021a0:	0007871b          	sext.w	a4,a5
ffffffe0002021a4:	f5843783          	ld	a5,-168(s0)
ffffffe0002021a8:	00070513          	mv	a0,a4
ffffffe0002021ac:	000780e7          	jalr	a5
            ++written;
ffffffe0002021b0:	fec42783          	lw	a5,-20(s0)
ffffffe0002021b4:	0017879b          	addiw	a5,a5,1
ffffffe0002021b8:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe0002021bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002021c0:	00178793          	addi	a5,a5,1
ffffffe0002021c4:	f4f43823          	sd	a5,-176(s0)
ffffffe0002021c8:	f5043783          	ld	a5,-176(s0)
ffffffe0002021cc:	0007c783          	lbu	a5,0(a5)
ffffffe0002021d0:	84079ce3          	bnez	a5,ffffffe000201a28 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe0002021d4:	fec42783          	lw	a5,-20(s0)
}
ffffffe0002021d8:	00078513          	mv	a0,a5
ffffffe0002021dc:	0b813083          	ld	ra,184(sp)
ffffffe0002021e0:	0b013403          	ld	s0,176(sp)
ffffffe0002021e4:	0c010113          	addi	sp,sp,192
ffffffe0002021e8:	00008067          	ret

ffffffe0002021ec <printk>:

int printk(const char* s, ...) {
ffffffe0002021ec:	f9010113          	addi	sp,sp,-112
ffffffe0002021f0:	02113423          	sd	ra,40(sp)
ffffffe0002021f4:	02813023          	sd	s0,32(sp)
ffffffe0002021f8:	03010413          	addi	s0,sp,48
ffffffe0002021fc:	fca43c23          	sd	a0,-40(s0)
ffffffe000202200:	00b43423          	sd	a1,8(s0)
ffffffe000202204:	00c43823          	sd	a2,16(s0)
ffffffe000202208:	00d43c23          	sd	a3,24(s0)
ffffffe00020220c:	02e43023          	sd	a4,32(s0)
ffffffe000202210:	02f43423          	sd	a5,40(s0)
ffffffe000202214:	03043823          	sd	a6,48(s0)
ffffffe000202218:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe00020221c:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000202220:	04040793          	addi	a5,s0,64
ffffffe000202224:	fcf43823          	sd	a5,-48(s0)
ffffffe000202228:	fd043783          	ld	a5,-48(s0)
ffffffe00020222c:	fc878793          	addi	a5,a5,-56
ffffffe000202230:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000202234:	fe043783          	ld	a5,-32(s0)
ffffffe000202238:	00078613          	mv	a2,a5
ffffffe00020223c:	fd843583          	ld	a1,-40(s0)
ffffffe000202240:	fffff517          	auipc	a0,0xfffff
ffffffe000202244:	11850513          	addi	a0,a0,280 # ffffffe000201358 <putc>
ffffffe000202248:	fb4ff0ef          	jal	ffffffe0002019fc <vprintfmt>
ffffffe00020224c:	00050793          	mv	a5,a0
ffffffe000202250:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000202254:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202258:	00078513          	mv	a0,a5
ffffffe00020225c:	02813083          	ld	ra,40(sp)
ffffffe000202260:	02013403          	ld	s0,32(sp)
ffffffe000202264:	07010113          	addi	sp,sp,112
ffffffe000202268:	00008067          	ret

ffffffe00020226c <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe00020226c:	fe010113          	addi	sp,sp,-32
ffffffe000202270:	00813c23          	sd	s0,24(sp)
ffffffe000202274:	02010413          	addi	s0,sp,32
ffffffe000202278:	00050793          	mv	a5,a0
ffffffe00020227c:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe000202280:	fec42783          	lw	a5,-20(s0)
ffffffe000202284:	fff7879b          	addiw	a5,a5,-1
ffffffe000202288:	0007879b          	sext.w	a5,a5
ffffffe00020228c:	02079713          	slli	a4,a5,0x20
ffffffe000202290:	02075713          	srli	a4,a4,0x20
ffffffe000202294:	00004797          	auipc	a5,0x4
ffffffe000202298:	d8478793          	addi	a5,a5,-636 # ffffffe000206018 <seed>
ffffffe00020229c:	00e7b023          	sd	a4,0(a5)
}
ffffffe0002022a0:	00000013          	nop
ffffffe0002022a4:	01813403          	ld	s0,24(sp)
ffffffe0002022a8:	02010113          	addi	sp,sp,32
ffffffe0002022ac:	00008067          	ret

ffffffe0002022b0 <rand>:

int rand(void) {
ffffffe0002022b0:	ff010113          	addi	sp,sp,-16
ffffffe0002022b4:	00813423          	sd	s0,8(sp)
ffffffe0002022b8:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe0002022bc:	00004797          	auipc	a5,0x4
ffffffe0002022c0:	d5c78793          	addi	a5,a5,-676 # ffffffe000206018 <seed>
ffffffe0002022c4:	0007b703          	ld	a4,0(a5)
ffffffe0002022c8:	00001797          	auipc	a5,0x1
ffffffe0002022cc:	f2878793          	addi	a5,a5,-216 # ffffffe0002031f0 <lowerxdigits.0+0x18>
ffffffe0002022d0:	0007b783          	ld	a5,0(a5)
ffffffe0002022d4:	02f707b3          	mul	a5,a4,a5
ffffffe0002022d8:	00178713          	addi	a4,a5,1
ffffffe0002022dc:	00004797          	auipc	a5,0x4
ffffffe0002022e0:	d3c78793          	addi	a5,a5,-708 # ffffffe000206018 <seed>
ffffffe0002022e4:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe0002022e8:	00004797          	auipc	a5,0x4
ffffffe0002022ec:	d3078793          	addi	a5,a5,-720 # ffffffe000206018 <seed>
ffffffe0002022f0:	0007b783          	ld	a5,0(a5)
ffffffe0002022f4:	0217d793          	srli	a5,a5,0x21
ffffffe0002022f8:	0007879b          	sext.w	a5,a5
}
ffffffe0002022fc:	00078513          	mv	a0,a5
ffffffe000202300:	00813403          	ld	s0,8(sp)
ffffffe000202304:	01010113          	addi	sp,sp,16
ffffffe000202308:	00008067          	ret

ffffffe00020230c <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe00020230c:	fc010113          	addi	sp,sp,-64
ffffffe000202310:	02813c23          	sd	s0,56(sp)
ffffffe000202314:	04010413          	addi	s0,sp,64
ffffffe000202318:	fca43c23          	sd	a0,-40(s0)
ffffffe00020231c:	00058793          	mv	a5,a1
ffffffe000202320:	fcc43423          	sd	a2,-56(s0)
ffffffe000202324:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000202328:	fd843783          	ld	a5,-40(s0)
ffffffe00020232c:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202330:	fe043423          	sd	zero,-24(s0)
ffffffe000202334:	0280006f          	j	ffffffe00020235c <memset+0x50>
        s[i] = c;
ffffffe000202338:	fe043703          	ld	a4,-32(s0)
ffffffe00020233c:	fe843783          	ld	a5,-24(s0)
ffffffe000202340:	00f707b3          	add	a5,a4,a5
ffffffe000202344:	fd442703          	lw	a4,-44(s0)
ffffffe000202348:	0ff77713          	zext.b	a4,a4
ffffffe00020234c:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202350:	fe843783          	ld	a5,-24(s0)
ffffffe000202354:	00178793          	addi	a5,a5,1
ffffffe000202358:	fef43423          	sd	a5,-24(s0)
ffffffe00020235c:	fe843703          	ld	a4,-24(s0)
ffffffe000202360:	fc843783          	ld	a5,-56(s0)
ffffffe000202364:	fcf76ae3          	bltu	a4,a5,ffffffe000202338 <memset+0x2c>
    }
    return dest;
ffffffe000202368:	fd843783          	ld	a5,-40(s0)
}
ffffffe00020236c:	00078513          	mv	a0,a5
ffffffe000202370:	03813403          	ld	s0,56(sp)
ffffffe000202374:	04010113          	addi	sp,sp,64
ffffffe000202378:	00008067          	ret
