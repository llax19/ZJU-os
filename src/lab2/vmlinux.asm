
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern mm_init
    .extern sbi_set_timer
_start:
    
    # set sp with the top of boot_stack
    la sp, boot_stack_top 
    80200000:	00003117          	auipc	sp,0x3
    80200004:	02013103          	ld	sp,32(sp) # 80203020 <_GLOBAL_OFFSET_TABLE_+0x18>

     #memory init
    call mm_init
    80200008:	3a4000ef          	jal	802003ac <mm_init>
    # task init
    call task_init
    8020000c:	3e4000ef          	jal	802003f0 <task_init>
    

    # set stvec
    la a0, _traps
    80200010:	00003517          	auipc	a0,0x3
    80200014:	02053503          	ld	a0,32(a0) # 80203030 <_GLOBAL_OFFSET_TABLE_+0x28>
    csrrw x0, stvec, a0
    80200018:	10551073          	csrw	stvec,a0

    # set sie[stie]=1
    addi a0, x0, 32
    8020001c:	02000513          	li	a0,32
    csrrs x0, sie, a0
    80200020:	10452073          	csrs	sie,a0

    

    # set the first timer interrupt
    rdtime a0
    80200024:	c0102573          	rdtime	a0
    call sbi_set_timer
    80200028:	45d000ef          	jal	80200c84 <sbi_set_timer>

   

    # set sstatus[SIE]=1
    csrrsi x0, sstatus, 2
    8020002c:	10016073          	csrsi	sstatus,2
    
    

    call start_kernel
    80200030:	571000ef          	jal	80200da0 <start_kernel>

0000000080200034 <__switch_to>:
    .equ regbytes, 8
    .globl __switch_to

__switch_to:
    # save state to prev process
    addi a0, a0, 32 #a0 = prev->thread
    80200034:	02050513          	addi	a0,a0,32
    sd ra, 0*regbytes(a0)
    80200038:	00153023          	sd	ra,0(a0)
    sd sp, 1*regbytes(a0)
    8020003c:	00253423          	sd	sp,8(a0)
    sd s0, 2*regbytes(a0)
    80200040:	00853823          	sd	s0,16(a0)
    sd s1, 3*regbytes(a0)
    80200044:	00953c23          	sd	s1,24(a0)
    sd s2, 4*regbytes(a0)
    80200048:	03253023          	sd	s2,32(a0)
    sd s3, 5*regbytes(a0)
    8020004c:	03353423          	sd	s3,40(a0)
    sd s4, 6*regbytes(a0)
    80200050:	03453823          	sd	s4,48(a0)
    sd s5, 7*regbytes(a0)
    80200054:	03553c23          	sd	s5,56(a0)
    sd s6, 8*regbytes(a0)
    80200058:	05653023          	sd	s6,64(a0)
    sd s7, 9*regbytes(a0)
    8020005c:	05753423          	sd	s7,72(a0)
    sd s8, 10*regbytes(a0)
    80200060:	05853823          	sd	s8,80(a0)
    sd s9, 11*regbytes(a0)
    80200064:	05953c23          	sd	s9,88(a0)
    sd s10, 12*regbytes(a0)
    80200068:	07a53023          	sd	s10,96(a0)
    sd s11, 13*regbytes(a0)
    8020006c:	07b53423          	sd	s11,104(a0)



    # restore state from next process
    
    addi a1, a1, 32  #a1 = next->thread
    80200070:	02058593          	addi	a1,a1,32
    ld ra, 0*regbytes(a1)
    80200074:	0005b083          	ld	ra,0(a1)
    ld sp, 1*regbytes(a1)
    80200078:	0085b103          	ld	sp,8(a1)
    ld s0, 2*regbytes(a1)
    8020007c:	0105b403          	ld	s0,16(a1)
    ld s1, 3*regbytes(a1)
    80200080:	0185b483          	ld	s1,24(a1)
    ld s2, 4*regbytes(a1)
    80200084:	0205b903          	ld	s2,32(a1)
    ld s3, 5*regbytes(a1)
    80200088:	0285b983          	ld	s3,40(a1)
    ld s4, 6*regbytes(a1)
    8020008c:	0305ba03          	ld	s4,48(a1)
    ld s5, 7*regbytes(a1)
    80200090:	0385ba83          	ld	s5,56(a1)
    ld s6, 8*regbytes(a1)
    80200094:	0405bb03          	ld	s6,64(a1)
    ld s7, 9*regbytes(a1)
    80200098:	0485bb83          	ld	s7,72(a1)
    ld s8, 10*regbytes(a1)
    8020009c:	0505bc03          	ld	s8,80(a1)
    ld s9, 11*regbytes(a1)
    802000a0:	0585bc83          	ld	s9,88(a1)
    ld s10, 12*regbytes(a1)
    802000a4:	0605bd03          	ld	s10,96(a1)
    ld s11, 13*regbytes(a1)
    802000a8:	0685bd83          	ld	s11,104(a1)
    ret
    802000ac:	00008067          	ret

00000000802000b0 <__dummy>:


__dummy:
    la a0, dummy
    802000b0:	00003517          	auipc	a0,0x3
    802000b4:	f7853503          	ld	a0,-136(a0) # 80203028 <_GLOBAL_OFFSET_TABLE_+0x20>
    csrrw x0, sepc, a0
    802000b8:	14151073          	csrw	sepc,a0
    sret
    802000bc:	10200073          	sret

00000000802000c0 <_traps>:
    

_traps:
    # save 32 registers and sepc to stack
    # csrrw x0, sscratch, sp
    addi sp, sp, -33 * regbytes
    802000c0:	ef810113          	addi	sp,sp,-264
    sd x0, 0*regbytes(sp)
    802000c4:	00013023          	sd	zero,0(sp)
    sd x1, 1*regbytes(sp)
    802000c8:	00113423          	sd	ra,8(sp)
    sd x3, 3*regbytes(sp)
    802000cc:	00313c23          	sd	gp,24(sp)
    sd x4, 4*regbytes(sp)
    802000d0:	02413023          	sd	tp,32(sp)
    sd x5, 5*regbytes(sp)
    802000d4:	02513423          	sd	t0,40(sp)
    sd x6, 6*regbytes(sp)
    802000d8:	02613823          	sd	t1,48(sp)
    sd x7, 7*regbytes(sp)
    802000dc:	02713c23          	sd	t2,56(sp)
    sd x8, 8*regbytes(sp)
    802000e0:	04813023          	sd	s0,64(sp)
    sd x9, 9*regbytes(sp)
    802000e4:	04913423          	sd	s1,72(sp)
    sd x10, 10*regbytes(sp)
    802000e8:	04a13823          	sd	a0,80(sp)
    sd x11, 11*regbytes(sp)
    802000ec:	04b13c23          	sd	a1,88(sp)
    sd x12, 12*regbytes(sp)
    802000f0:	06c13023          	sd	a2,96(sp)
    sd x13, 13*regbytes(sp)
    802000f4:	06d13423          	sd	a3,104(sp)
    sd x14, 14*regbytes(sp)
    802000f8:	06e13823          	sd	a4,112(sp)
    sd x15, 15*regbytes(sp)
    802000fc:	06f13c23          	sd	a5,120(sp)
    sd x16, 16*regbytes(sp)
    80200100:	09013023          	sd	a6,128(sp)
    sd x17, 17*regbytes(sp)
    80200104:	09113423          	sd	a7,136(sp)
    sd x18, 18*regbytes(sp)
    80200108:	09213823          	sd	s2,144(sp)
    sd x19, 19*regbytes(sp)
    8020010c:	09313c23          	sd	s3,152(sp)
    sd x20, 20*regbytes(sp)
    80200110:	0b413023          	sd	s4,160(sp)
    sd x21, 21*regbytes(sp)
    80200114:	0b513423          	sd	s5,168(sp)
    sd x22, 22*regbytes(sp)
    80200118:	0b613823          	sd	s6,176(sp)
    sd x23, 23*regbytes(sp)
    8020011c:	0b713c23          	sd	s7,184(sp)
    sd x24, 24*regbytes(sp)
    80200120:	0d813023          	sd	s8,192(sp)
    sd x25, 25*regbytes(sp)
    80200124:	0d913423          	sd	s9,200(sp)
    sd x26, 26*regbytes(sp)
    80200128:	0da13823          	sd	s10,208(sp)
    sd x27, 27*regbytes(sp)
    8020012c:	0db13c23          	sd	s11,216(sp)
    sd x28, 28*regbytes(sp)
    80200130:	0fc13023          	sd	t3,224(sp)
    sd x29, 29*regbytes(sp)
    80200134:	0fd13423          	sd	t4,232(sp)
    sd x30, 30*regbytes(sp)
    80200138:	0fe13823          	sd	t5,240(sp)
    sd x31, 31*regbytes(sp)
    8020013c:	0ff13c23          	sd	t6,248(sp)
    csrrs a0, sepc, x0
    80200140:	14102573          	csrr	a0,sepc
    sd a0, 32*regbytes(sp)
    80200144:	10a13023          	sd	a0,256(sp)
    sd sp, 2*regbytes(sp)
    80200148:	00213823          	sd	sp,16(sp)

    # call trap_handler
    csrrw a0, scause, x0
    8020014c:	14201573          	csrrw	a0,scause,zero
    csrrw a1, sepc, x0
    80200150:	141015f3          	csrrw	a1,sepc,zero
    call trap_handler
    80200154:	3bd000ef          	jal	80200d10 <trap_handler>
    
    # restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a0, 32*regbytes(sp)
    80200158:	10013503          	ld	a0,256(sp)
    csrrw x0, sepc, a0
    8020015c:	14151073          	csrw	sepc,a0
    ld x1, 1*regbytes(sp)
    80200160:	00813083          	ld	ra,8(sp)
    ld x3, 3*regbytes(sp)
    80200164:	01813183          	ld	gp,24(sp)
    ld x4, 4*regbytes(sp)
    80200168:	02013203          	ld	tp,32(sp)
    ld x5, 5*regbytes(sp)
    8020016c:	02813283          	ld	t0,40(sp)
    ld x6, 6*regbytes(sp)
    80200170:	03013303          	ld	t1,48(sp)
    ld x7, 7*regbytes(sp)
    80200174:	03813383          	ld	t2,56(sp)
    ld x8, 8*regbytes(sp)
    80200178:	04013403          	ld	s0,64(sp)
    ld x9, 9*regbytes(sp)
    8020017c:	04813483          	ld	s1,72(sp)
    ld x10, 10*regbytes(sp)
    80200180:	05013503          	ld	a0,80(sp)
    ld x11, 11*regbytes(sp)
    80200184:	05813583          	ld	a1,88(sp)
    ld x12, 12*regbytes(sp)
    80200188:	06013603          	ld	a2,96(sp)
    ld x13, 13*regbytes(sp)
    8020018c:	06813683          	ld	a3,104(sp)
    ld x14, 14*regbytes(sp)
    80200190:	07013703          	ld	a4,112(sp)
    ld x15, 15*regbytes(sp)
    80200194:	07813783          	ld	a5,120(sp)
    ld x16, 16*regbytes(sp)
    80200198:	08013803          	ld	a6,128(sp)
    ld x17, 17*regbytes(sp)
    8020019c:	08813883          	ld	a7,136(sp)
    ld x18, 18*regbytes(sp)
    802001a0:	09013903          	ld	s2,144(sp)
    ld x19, 19*regbytes(sp)
    802001a4:	09813983          	ld	s3,152(sp)
    ld x20, 20*regbytes(sp)
    802001a8:	0a013a03          	ld	s4,160(sp)
    ld x21, 21*regbytes(sp)
    802001ac:	0a813a83          	ld	s5,168(sp)
    ld x22, 22*regbytes(sp)
    802001b0:	0b013b03          	ld	s6,176(sp)
    ld x23, 23*regbytes(sp)
    802001b4:	0b813b83          	ld	s7,184(sp)
    ld x24, 24*regbytes(sp)
    802001b8:	0c013c03          	ld	s8,192(sp)
    ld x25, 25*regbytes(sp)
    802001bc:	0c813c83          	ld	s9,200(sp)
    ld x26, 26*regbytes(sp)
    802001c0:	0d013d03          	ld	s10,208(sp)
    ld x27, 27*regbytes(sp)
    802001c4:	0d813d83          	ld	s11,216(sp)
    ld x28, 28*regbytes(sp)
    802001c8:	0e013e03          	ld	t3,224(sp)
    ld x29, 29*regbytes(sp)
    802001cc:	0e813e83          	ld	t4,232(sp)
    ld x30, 30*regbytes(sp)
    802001d0:	0f013f03          	ld	t5,240(sp)
    ld x31, 31*regbytes(sp)
    802001d4:	0f813f83          	ld	t6,248(sp)
    ld x2, 2*regbytes(sp)
    802001d8:	01013103          	ld	sp,16(sp)
    addi sp, sp, 33 * regbytes
    802001dc:	10810113          	addi	sp,sp,264
    # return from trap
    sret
    802001e0:	10200073          	sret

00000000802001e4 <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    802001e4:	fe010113          	addi	sp,sp,-32
    802001e8:	00813c23          	sd	s0,24(sp)
    802001ec:	02010413          	addi	s0,sp,32
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
    802001f0:	c01027f3          	rdtime	a5
    802001f4:	fef43423          	sd	a5,-24(s0)
    return cycles;
    802001f8:	fe843783          	ld	a5,-24(s0)
}
    802001fc:	00078513          	mv	a0,a5
    80200200:	01813403          	ld	s0,24(sp)
    80200204:	02010113          	addi	sp,sp,32
    80200208:	00008067          	ret

000000008020020c <clock_set_next_event>:

void clock_set_next_event() {
    8020020c:	fe010113          	addi	sp,sp,-32
    80200210:	00113c23          	sd	ra,24(sp)
    80200214:	00813823          	sd	s0,16(sp)
    80200218:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    8020021c:	fc9ff0ef          	jal	802001e4 <get_cycles>
    80200220:	00050713          	mv	a4,a0
    80200224:	00003797          	auipc	a5,0x3
    80200228:	ddc78793          	addi	a5,a5,-548 # 80203000 <TIMECLOCK>
    8020022c:	0007b783          	ld	a5,0(a5)
    80200230:	00f707b3          	add	a5,a4,a5
    80200234:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
    80200238:	fe843503          	ld	a0,-24(s0)
    8020023c:	249000ef          	jal	80200c84 <sbi_set_timer>
    80200240:	00000013          	nop
    80200244:	01813083          	ld	ra,24(sp)
    80200248:	01013403          	ld	s0,16(sp)
    8020024c:	02010113          	addi	sp,sp,32
    80200250:	00008067          	ret

0000000080200254 <kalloc>:

struct {
    struct run *freelist;
} kmem;

void *kalloc() {
    80200254:	fe010113          	addi	sp,sp,-32
    80200258:	00113c23          	sd	ra,24(sp)
    8020025c:	00813823          	sd	s0,16(sp)
    80200260:	02010413          	addi	s0,sp,32
    struct run *r;

    r = kmem.freelist;
    80200264:	00005797          	auipc	a5,0x5
    80200268:	d9c78793          	addi	a5,a5,-612 # 80205000 <kmem>
    8020026c:	0007b783          	ld	a5,0(a5)
    80200270:	fef43423          	sd	a5,-24(s0)
    kmem.freelist = r->next;
    80200274:	fe843783          	ld	a5,-24(s0)
    80200278:	0007b703          	ld	a4,0(a5)
    8020027c:	00005797          	auipc	a5,0x5
    80200280:	d8478793          	addi	a5,a5,-636 # 80205000 <kmem>
    80200284:	00e7b023          	sd	a4,0(a5)
    
    memset((void *)r, 0x0, PGSIZE);
    80200288:	00001637          	lui	a2,0x1
    8020028c:	00000593          	li	a1,0
    80200290:	fe843503          	ld	a0,-24(s0)
    80200294:	355010ef          	jal	80201de8 <memset>
    return (void *)r;
    80200298:	fe843783          	ld	a5,-24(s0)
}
    8020029c:	00078513          	mv	a0,a5
    802002a0:	01813083          	ld	ra,24(sp)
    802002a4:	01013403          	ld	s0,16(sp)
    802002a8:	02010113          	addi	sp,sp,32
    802002ac:	00008067          	ret

00000000802002b0 <kfree>:

void kfree(void *addr) {
    802002b0:	fd010113          	addi	sp,sp,-48
    802002b4:	02113423          	sd	ra,40(sp)
    802002b8:	02813023          	sd	s0,32(sp)
    802002bc:	03010413          	addi	s0,sp,48
    802002c0:	fca43c23          	sd	a0,-40(s0)
    struct run *r;

    // PGSIZE align 
    *(uintptr_t *)&addr = (uintptr_t)addr & ~(PGSIZE - 1);
    802002c4:	fd843783          	ld	a5,-40(s0)
    802002c8:	00078693          	mv	a3,a5
    802002cc:	fd840793          	addi	a5,s0,-40
    802002d0:	fffff737          	lui	a4,0xfffff
    802002d4:	00e6f733          	and	a4,a3,a4
    802002d8:	00e7b023          	sd	a4,0(a5)

    memset(addr, 0x0, (uint64_t)PGSIZE);
    802002dc:	fd843783          	ld	a5,-40(s0)
    802002e0:	00001637          	lui	a2,0x1
    802002e4:	00000593          	li	a1,0
    802002e8:	00078513          	mv	a0,a5
    802002ec:	2fd010ef          	jal	80201de8 <memset>

    r = (struct run *)addr;
    802002f0:	fd843783          	ld	a5,-40(s0)
    802002f4:	fef43423          	sd	a5,-24(s0)
    r->next = kmem.freelist;
    802002f8:	00005797          	auipc	a5,0x5
    802002fc:	d0878793          	addi	a5,a5,-760 # 80205000 <kmem>
    80200300:	0007b703          	ld	a4,0(a5)
    80200304:	fe843783          	ld	a5,-24(s0)
    80200308:	00e7b023          	sd	a4,0(a5)
    kmem.freelist = r;
    8020030c:	00005797          	auipc	a5,0x5
    80200310:	cf478793          	addi	a5,a5,-780 # 80205000 <kmem>
    80200314:	fe843703          	ld	a4,-24(s0)
    80200318:	00e7b023          	sd	a4,0(a5)

    return;
    8020031c:	00000013          	nop
}
    80200320:	02813083          	ld	ra,40(sp)
    80200324:	02013403          	ld	s0,32(sp)
    80200328:	03010113          	addi	sp,sp,48
    8020032c:	00008067          	ret

0000000080200330 <kfreerange>:

void kfreerange(char *start, char *end) {
    80200330:	fd010113          	addi	sp,sp,-48
    80200334:	02113423          	sd	ra,40(sp)
    80200338:	02813023          	sd	s0,32(sp)
    8020033c:	03010413          	addi	s0,sp,48
    80200340:	fca43c23          	sd	a0,-40(s0)
    80200344:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
    80200348:	fd843703          	ld	a4,-40(s0)
    8020034c:	000017b7          	lui	a5,0x1
    80200350:	fff78793          	addi	a5,a5,-1 # fff <regbytes+0xff7>
    80200354:	00f70733          	add	a4,a4,a5
    80200358:	fffff7b7          	lui	a5,0xfffff
    8020035c:	00f777b3          	and	a5,a4,a5
    80200360:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    80200364:	01c0006f          	j	80200380 <kfreerange+0x50>
        kfree((void *)addr);
    80200368:	fe843503          	ld	a0,-24(s0)
    8020036c:	f45ff0ef          	jal	802002b0 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
    80200370:	fe843703          	ld	a4,-24(s0)
    80200374:	000017b7          	lui	a5,0x1
    80200378:	00f707b3          	add	a5,a4,a5
    8020037c:	fef43423          	sd	a5,-24(s0)
    80200380:	fe843703          	ld	a4,-24(s0)
    80200384:	000017b7          	lui	a5,0x1
    80200388:	00f70733          	add	a4,a4,a5
    8020038c:	fd043783          	ld	a5,-48(s0)
    80200390:	fce7fce3          	bgeu	a5,a4,80200368 <kfreerange+0x38>
    }
}
    80200394:	00000013          	nop
    80200398:	00000013          	nop
    8020039c:	02813083          	ld	ra,40(sp)
    802003a0:	02013403          	ld	s0,32(sp)
    802003a4:	03010113          	addi	sp,sp,48
    802003a8:	00008067          	ret

00000000802003ac <mm_init>:

void mm_init(void) {
    802003ac:	ff010113          	addi	sp,sp,-16
    802003b0:	00113423          	sd	ra,8(sp)
    802003b4:	00813023          	sd	s0,0(sp)
    802003b8:	01010413          	addi	s0,sp,16
    kfreerange(_ekernel, (char *)PHY_END);
    802003bc:	01100793          	li	a5,17
    802003c0:	01b79593          	slli	a1,a5,0x1b
    802003c4:	00003517          	auipc	a0,0x3
    802003c8:	c4c53503          	ld	a0,-948(a0) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>
    802003cc:	f65ff0ef          	jal	80200330 <kfreerange>
    printk("...mm_init done!\n");
    802003d0:	00002517          	auipc	a0,0x2
    802003d4:	c3050513          	addi	a0,a0,-976 # 80202000 <_srodata>
    802003d8:	0f1010ef          	jal	80201cc8 <printk>
}
    802003dc:	00000013          	nop
    802003e0:	00813083          	ld	ra,8(sp)
    802003e4:	00013403          	ld	s0,0(sp)
    802003e8:	01010113          	addi	sp,sp,16
    802003ec:	00008067          	ret

00000000802003f0 <task_init>:

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
    802003f0:	fd010113          	addi	sp,sp,-48
    802003f4:	02113423          	sd	ra,40(sp)
    802003f8:	02813023          	sd	s0,32(sp)
    802003fc:	03010413          	addi	s0,sp,48
    srand(2024);
    80200400:	7e800513          	li	a0,2024
    80200404:	145010ef          	jal	80201d48 <srand>
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle

    char * PageLow = (char *)kalloc();
    80200408:	e4dff0ef          	jal	80200254 <kalloc>
    8020040c:	fea43023          	sd	a0,-32(s0)
    idle = (struct task_struct *)PageLow;
    80200410:	00005797          	auipc	a5,0x5
    80200414:	bf878793          	addi	a5,a5,-1032 # 80205008 <idle>
    80200418:	fe043703          	ld	a4,-32(s0)
    8020041c:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
    80200420:	00005797          	auipc	a5,0x5
    80200424:	be878793          	addi	a5,a5,-1048 # 80205008 <idle>
    80200428:	0007b783          	ld	a5,0(a5)
    8020042c:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
    80200430:	00005797          	auipc	a5,0x5
    80200434:	bd878793          	addi	a5,a5,-1064 # 80205008 <idle>
    80200438:	0007b783          	ld	a5,0(a5)
    8020043c:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
    80200440:	00005797          	auipc	a5,0x5
    80200444:	bc878793          	addi	a5,a5,-1080 # 80205008 <idle>
    80200448:	0007b783          	ld	a5,0(a5)
    8020044c:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
    80200450:	00005797          	auipc	a5,0x5
    80200454:	bb878793          	addi	a5,a5,-1096 # 80205008 <idle>
    80200458:	0007b783          	ld	a5,0(a5)
    8020045c:	0007bc23          	sd	zero,24(a5)
    current = idle;
    80200460:	00005797          	auipc	a5,0x5
    80200464:	ba878793          	addi	a5,a5,-1112 # 80205008 <idle>
    80200468:	0007b703          	ld	a4,0(a5)
    8020046c:	00005797          	auipc	a5,0x5
    80200470:	ba478793          	addi	a5,a5,-1116 # 80205010 <current>
    80200474:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
    80200478:	00005797          	auipc	a5,0x5
    8020047c:	b9078793          	addi	a5,a5,-1136 # 80205008 <idle>
    80200480:	0007b703          	ld	a4,0(a5)
    80200484:	00005797          	auipc	a5,0x5
    80200488:	b9478793          	addi	a5,a5,-1132 # 80205018 <task>
    8020048c:	00e7b023          	sd	a4,0(a5)
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (int i=1 ;i<NR_TASKS; i++){
    80200490:	00100793          	li	a5,1
    80200494:	fef42623          	sw	a5,-20(s0)
    80200498:	1180006f          	j	802005b0 <task_init+0x1c0>
        char * PageLow = (char *)kalloc();
    8020049c:	db9ff0ef          	jal	80200254 <kalloc>
    802004a0:	fca43c23          	sd	a0,-40(s0)
        task[i] = (struct task_struct *)PageLow;
    802004a4:	00005717          	auipc	a4,0x5
    802004a8:	b7470713          	addi	a4,a4,-1164 # 80205018 <task>
    802004ac:	fec42783          	lw	a5,-20(s0)
    802004b0:	00379793          	slli	a5,a5,0x3
    802004b4:	00f707b3          	add	a5,a4,a5
    802004b8:	fd843703          	ld	a4,-40(s0)
    802004bc:	00e7b023          	sd	a4,0(a5)
        task[i]->state = TASK_RUNNING;
    802004c0:	00005717          	auipc	a4,0x5
    802004c4:	b5870713          	addi	a4,a4,-1192 # 80205018 <task>
    802004c8:	fec42783          	lw	a5,-20(s0)
    802004cc:	00379793          	slli	a5,a5,0x3
    802004d0:	00f707b3          	add	a5,a4,a5
    802004d4:	0007b783          	ld	a5,0(a5)
    802004d8:	0007b023          	sd	zero,0(a5)
        task[i]->counter = 0;
    802004dc:	00005717          	auipc	a4,0x5
    802004e0:	b3c70713          	addi	a4,a4,-1220 # 80205018 <task>
    802004e4:	fec42783          	lw	a5,-20(s0)
    802004e8:	00379793          	slli	a5,a5,0x3
    802004ec:	00f707b3          	add	a5,a4,a5
    802004f0:	0007b783          	ld	a5,0(a5)
    802004f4:	0007b423          	sd	zero,8(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
    802004f8:	095010ef          	jal	80201d8c <rand>
    802004fc:	00050793          	mv	a5,a0
    80200500:	00078713          	mv	a4,a5
    80200504:	00a00793          	li	a5,10
    80200508:	02f767bb          	remw	a5,a4,a5
    8020050c:	0007879b          	sext.w	a5,a5
    80200510:	0017879b          	addiw	a5,a5,1
    80200514:	0007869b          	sext.w	a3,a5
    80200518:	00005717          	auipc	a4,0x5
    8020051c:	b0070713          	addi	a4,a4,-1280 # 80205018 <task>
    80200520:	fec42783          	lw	a5,-20(s0)
    80200524:	00379793          	slli	a5,a5,0x3
    80200528:	00f707b3          	add	a5,a4,a5
    8020052c:	0007b783          	ld	a5,0(a5)
    80200530:	00068713          	mv	a4,a3
    80200534:	00e7b823          	sd	a4,16(a5)
        task[i]->pid = i;
    80200538:	00005717          	auipc	a4,0x5
    8020053c:	ae070713          	addi	a4,a4,-1312 # 80205018 <task>
    80200540:	fec42783          	lw	a5,-20(s0)
    80200544:	00379793          	slli	a5,a5,0x3
    80200548:	00f707b3          	add	a5,a4,a5
    8020054c:	0007b783          	ld	a5,0(a5)
    80200550:	fec42703          	lw	a4,-20(s0)
    80200554:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
    80200558:	00005717          	auipc	a4,0x5
    8020055c:	ac070713          	addi	a4,a4,-1344 # 80205018 <task>
    80200560:	fec42783          	lw	a5,-20(s0)
    80200564:	00379793          	slli	a5,a5,0x3
    80200568:	00f707b3          	add	a5,a4,a5
    8020056c:	0007b783          	ld	a5,0(a5)
    80200570:	00003717          	auipc	a4,0x3
    80200574:	aa873703          	ld	a4,-1368(a4) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    80200578:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)PageLow + PGSIZE;
    8020057c:	fd843683          	ld	a3,-40(s0)
    80200580:	00005717          	auipc	a4,0x5
    80200584:	a9870713          	addi	a4,a4,-1384 # 80205018 <task>
    80200588:	fec42783          	lw	a5,-20(s0)
    8020058c:	00379793          	slli	a5,a5,0x3
    80200590:	00f707b3          	add	a5,a4,a5
    80200594:	0007b783          	ld	a5,0(a5)
    80200598:	00001737          	lui	a4,0x1
    8020059c:	00e68733          	add	a4,a3,a4
    802005a0:	02e7b423          	sd	a4,40(a5)
    for (int i=1 ;i<NR_TASKS; i++){
    802005a4:	fec42783          	lw	a5,-20(s0)
    802005a8:	0017879b          	addiw	a5,a5,1
    802005ac:	fef42623          	sw	a5,-20(s0)
    802005b0:	fec42783          	lw	a5,-20(s0)
    802005b4:	0007871b          	sext.w	a4,a5
    802005b8:	01f00793          	li	a5,31
    802005bc:	eee7d0e3          	bge	a5,a4,8020049c <task_init+0xac>
    }

    printk("...task_init done!\n");
    802005c0:	00002517          	auipc	a0,0x2
    802005c4:	a5850513          	addi	a0,a0,-1448 # 80202018 <_srodata+0x18>
    802005c8:	700010ef          	jal	80201cc8 <printk>
}
    802005cc:	00000013          	nop
    802005d0:	02813083          	ld	ra,40(sp)
    802005d4:	02013403          	ld	s0,32(sp)
    802005d8:	03010113          	addi	sp,sp,48
    802005dc:	00008067          	ret

00000000802005e0 <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    802005e0:	fd010113          	addi	sp,sp,-48
    802005e4:	02113423          	sd	ra,40(sp)
    802005e8:	02813023          	sd	s0,32(sp)
    802005ec:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
    802005f0:	3b9ad7b7          	lui	a5,0x3b9ad
    802005f4:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <regbytes+0x3b9ac9ff>
    802005f8:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
    802005fc:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
    80200600:	fff00793          	li	a5,-1
    80200604:	fef42223          	sw	a5,-28(s0)
    printk("First in dummy: current counter = %d\n", current->counter);
    80200608:	00005797          	auipc	a5,0x5
    8020060c:	a0878793          	addi	a5,a5,-1528 # 80205010 <current>
    80200610:	0007b783          	ld	a5,0(a5)
    80200614:	0087b783          	ld	a5,8(a5)
    80200618:	00078593          	mv	a1,a5
    8020061c:	00002517          	auipc	a0,0x2
    80200620:	a1450513          	addi	a0,a0,-1516 # 80202030 <_srodata+0x30>
    80200624:	6a4010ef          	jal	80201cc8 <printk>
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    80200628:	fe442783          	lw	a5,-28(s0)
    8020062c:	0007871b          	sext.w	a4,a5
    80200630:	fff00793          	li	a5,-1
    80200634:	00f70e63          	beq	a4,a5,80200650 <dummy+0x70>
    80200638:	00005797          	auipc	a5,0x5
    8020063c:	9d878793          	addi	a5,a5,-1576 # 80205010 <current>
    80200640:	0007b783          	ld	a5,0(a5)
    80200644:	0087b703          	ld	a4,8(a5)
    80200648:	fe442783          	lw	a5,-28(s0)
    8020064c:	fcf70ee3          	beq	a4,a5,80200628 <dummy+0x48>
    80200650:	00005797          	auipc	a5,0x5
    80200654:	9c078793          	addi	a5,a5,-1600 # 80205010 <current>
    80200658:	0007b783          	ld	a5,0(a5)
    8020065c:	0087b783          	ld	a5,8(a5)
    80200660:	fc0784e3          	beqz	a5,80200628 <dummy+0x48>
            if (current->counter == 1) {
    80200664:	00005797          	auipc	a5,0x5
    80200668:	9ac78793          	addi	a5,a5,-1620 # 80205010 <current>
    8020066c:	0007b783          	ld	a5,0(a5)
    80200670:	0087b703          	ld	a4,8(a5)
    80200674:	00100793          	li	a5,1
    80200678:	00f71e63          	bne	a4,a5,80200694 <dummy+0xb4>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
    8020067c:	00005797          	auipc	a5,0x5
    80200680:	99478793          	addi	a5,a5,-1644 # 80205010 <current>
    80200684:	0007b783          	ld	a5,0(a5)
    80200688:	0087b703          	ld	a4,8(a5)
    8020068c:	fff70713          	addi	a4,a4,-1 # fff <regbytes+0xff7>
    80200690:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
    80200694:	00005797          	auipc	a5,0x5
    80200698:	97c78793          	addi	a5,a5,-1668 # 80205010 <current>
    8020069c:	0007b783          	ld	a5,0(a5)
    802006a0:	0087b783          	ld	a5,8(a5)
    802006a4:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
    802006a8:	fe843783          	ld	a5,-24(s0)
    802006ac:	00178713          	addi	a4,a5,1
    802006b0:	fd843783          	ld	a5,-40(s0)
    802006b4:	02f777b3          	remu	a5,a4,a5
    802006b8:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d, current counter = %d\n", current->pid, auto_inc_local_var, current->counter);
    802006bc:	00005797          	auipc	a5,0x5
    802006c0:	95478793          	addi	a5,a5,-1708 # 80205010 <current>
    802006c4:	0007b783          	ld	a5,0(a5)
    802006c8:	0187b703          	ld	a4,24(a5)
    802006cc:	00005797          	auipc	a5,0x5
    802006d0:	94478793          	addi	a5,a5,-1724 # 80205010 <current>
    802006d4:	0007b783          	ld	a5,0(a5)
    802006d8:	0087b783          	ld	a5,8(a5)
    802006dc:	00078693          	mv	a3,a5
    802006e0:	fe843603          	ld	a2,-24(s0)
    802006e4:	00070593          	mv	a1,a4
    802006e8:	00002517          	auipc	a0,0x2
    802006ec:	97050513          	addi	a0,a0,-1680 # 80202058 <_srodata+0x58>
    802006f0:	5d8010ef          	jal	80201cc8 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
    802006f4:	f35ff06f          	j	80200628 <dummy+0x48>

00000000802006f8 <switch_to>:
    }
}

extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void switch_to(struct task_struct *next) {
    802006f8:	fd010113          	addi	sp,sp,-48
    802006fc:	02113423          	sd	ra,40(sp)
    80200700:	02813023          	sd	s0,32(sp)
    80200704:	03010413          	addi	s0,sp,48
    80200708:	fca43c23          	sd	a0,-40(s0)
    if (current != next) {
    8020070c:	00005797          	auipc	a5,0x5
    80200710:	90478793          	addi	a5,a5,-1788 # 80205010 <current>
    80200714:	0007b783          	ld	a5,0(a5)
    80200718:	fd843703          	ld	a4,-40(s0)
    8020071c:	08f70063          	beq	a4,a5,8020079c <switch_to+0xa4>
        struct task_struct *prev = current;
    80200720:	00005797          	auipc	a5,0x5
    80200724:	8f078793          	addi	a5,a5,-1808 # 80205010 <current>
    80200728:	0007b783          	ld	a5,0(a5)
    8020072c:	fef43423          	sd	a5,-24(s0)
        current = next;
    80200730:	00005797          	auipc	a5,0x5
    80200734:	8e078793          	addi	a5,a5,-1824 # 80205010 <current>
    80200738:	fd843703          	ld	a4,-40(s0)
    8020073c:	00e7b023          	sd	a4,0(a5)
        printk("Switch to PID=%d counter=%d priority=%d\n", current->pid, current->counter, current->priority);
    80200740:	00005797          	auipc	a5,0x5
    80200744:	8d078793          	addi	a5,a5,-1840 # 80205010 <current>
    80200748:	0007b783          	ld	a5,0(a5)
    8020074c:	0187b703          	ld	a4,24(a5)
    80200750:	00005797          	auipc	a5,0x5
    80200754:	8c078793          	addi	a5,a5,-1856 # 80205010 <current>
    80200758:	0007b783          	ld	a5,0(a5)
    8020075c:	0087b603          	ld	a2,8(a5)
    80200760:	00005797          	auipc	a5,0x5
    80200764:	8b078793          	addi	a5,a5,-1872 # 80205010 <current>
    80200768:	0007b783          	ld	a5,0(a5)
    8020076c:	0107b783          	ld	a5,16(a5)
    80200770:	00078693          	mv	a3,a5
    80200774:	00070593          	mv	a1,a4
    80200778:	00002517          	auipc	a0,0x2
    8020077c:	92850513          	addi	a0,a0,-1752 # 802020a0 <_srodata+0xa0>
    80200780:	548010ef          	jal	80201cc8 <printk>
        __switch_to(prev, current);
    80200784:	00005797          	auipc	a5,0x5
    80200788:	88c78793          	addi	a5,a5,-1908 # 80205010 <current>
    8020078c:	0007b783          	ld	a5,0(a5)
    80200790:	00078593          	mv	a1,a5
    80200794:	fe843503          	ld	a0,-24(s0)
    80200798:	89dff0ef          	jal	80200034 <__switch_to>
        
    }
}
    8020079c:	00000013          	nop
    802007a0:	02813083          	ld	ra,40(sp)
    802007a4:	02013403          	ld	s0,32(sp)
    802007a8:	03010113          	addi	sp,sp,48
    802007ac:	00008067          	ret

00000000802007b0 <do_timer>:

void do_timer() {
    802007b0:	ff010113          	addi	sp,sp,-16
    802007b4:	00113423          	sd	ra,8(sp)
    802007b8:	00813023          	sd	s0,0(sp)
    802007bc:	01010413          	addi	s0,sp,16
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
    if (current == idle || current->counter == 0) {
    802007c0:	00005797          	auipc	a5,0x5
    802007c4:	85078793          	addi	a5,a5,-1968 # 80205010 <current>
    802007c8:	0007b703          	ld	a4,0(a5)
    802007cc:	00005797          	auipc	a5,0x5
    802007d0:	83c78793          	addi	a5,a5,-1988 # 80205008 <idle>
    802007d4:	0007b783          	ld	a5,0(a5)
    802007d8:	00f70c63          	beq	a4,a5,802007f0 <do_timer+0x40>
    802007dc:	00005797          	auipc	a5,0x5
    802007e0:	83478793          	addi	a5,a5,-1996 # 80205010 <current>
    802007e4:	0007b783          	ld	a5,0(a5)
    802007e8:	0087b783          	ld	a5,8(a5)
    802007ec:	00079663          	bnez	a5,802007f8 <do_timer+0x48>
        schedule();
    802007f0:	044000ef          	jal	80200834 <schedule>
    802007f4:	0300006f          	j	80200824 <do_timer+0x74>
    } else {
        if (--current->counter) {
    802007f8:	00005797          	auipc	a5,0x5
    802007fc:	81878793          	addi	a5,a5,-2024 # 80205010 <current>
    80200800:	0007b783          	ld	a5,0(a5)
    80200804:	0087b703          	ld	a4,8(a5)
    80200808:	fff70713          	addi	a4,a4,-1
    8020080c:	00e7b423          	sd	a4,8(a5)
    80200810:	0087b783          	ld	a5,8(a5)
    80200814:	00079663          	bnez	a5,80200820 <do_timer+0x70>
            return;
        } else {
            schedule();
    80200818:	01c000ef          	jal	80200834 <schedule>
    8020081c:	0080006f          	j	80200824 <do_timer+0x74>
            return;
    80200820:	00000013          	nop
        }
    }
}
    80200824:	00813083          	ld	ra,8(sp)
    80200828:	00013403          	ld	s0,0(sp)
    8020082c:	01010113          	addi	sp,sp,16
    80200830:	00008067          	ret

0000000080200834 <schedule>:

void schedule() {
    80200834:	fd010113          	addi	sp,sp,-48
    80200838:	02113423          	sd	ra,40(sp)
    8020083c:	02813023          	sd	s0,32(sp)
    80200840:	03010413          	addi	s0,sp,48
    uint64_t max_counter = 0;
    80200844:	fe043423          	sd	zero,-24(s0)
    struct task_struct *next = NULL;
    80200848:	fe043023          	sd	zero,-32(s0)
    for (int i=0; i<NR_TASKS; i++){
    8020084c:	fc042e23          	sw	zero,-36(s0)
    80200850:	0900006f          	j	802008e0 <schedule+0xac>
        if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
    80200854:	00004717          	auipc	a4,0x4
    80200858:	7c470713          	addi	a4,a4,1988 # 80205018 <task>
    8020085c:	fdc42783          	lw	a5,-36(s0)
    80200860:	00379793          	slli	a5,a5,0x3
    80200864:	00f707b3          	add	a5,a4,a5
    80200868:	0007b783          	ld	a5,0(a5)
    8020086c:	0007b783          	ld	a5,0(a5)
    80200870:	06079263          	bnez	a5,802008d4 <schedule+0xa0>
    80200874:	00004717          	auipc	a4,0x4
    80200878:	7a470713          	addi	a4,a4,1956 # 80205018 <task>
    8020087c:	fdc42783          	lw	a5,-36(s0)
    80200880:	00379793          	slli	a5,a5,0x3
    80200884:	00f707b3          	add	a5,a4,a5
    80200888:	0007b783          	ld	a5,0(a5)
    8020088c:	0087b783          	ld	a5,8(a5)
    80200890:	fe843703          	ld	a4,-24(s0)
    80200894:	04f77063          	bgeu	a4,a5,802008d4 <schedule+0xa0>
            max_counter = task[i]->counter;
    80200898:	00004717          	auipc	a4,0x4
    8020089c:	78070713          	addi	a4,a4,1920 # 80205018 <task>
    802008a0:	fdc42783          	lw	a5,-36(s0)
    802008a4:	00379793          	slli	a5,a5,0x3
    802008a8:	00f707b3          	add	a5,a4,a5
    802008ac:	0007b783          	ld	a5,0(a5)
    802008b0:	0087b783          	ld	a5,8(a5)
    802008b4:	fef43423          	sd	a5,-24(s0)
            next = task[i];
    802008b8:	00004717          	auipc	a4,0x4
    802008bc:	76070713          	addi	a4,a4,1888 # 80205018 <task>
    802008c0:	fdc42783          	lw	a5,-36(s0)
    802008c4:	00379793          	slli	a5,a5,0x3
    802008c8:	00f707b3          	add	a5,a4,a5
    802008cc:	0007b783          	ld	a5,0(a5)
    802008d0:	fef43023          	sd	a5,-32(s0)
    for (int i=0; i<NR_TASKS; i++){
    802008d4:	fdc42783          	lw	a5,-36(s0)
    802008d8:	0017879b          	addiw	a5,a5,1
    802008dc:	fcf42e23          	sw	a5,-36(s0)
    802008e0:	fdc42783          	lw	a5,-36(s0)
    802008e4:	0007871b          	sext.w	a4,a5
    802008e8:	01f00793          	li	a5,31
    802008ec:	f6e7d4e3          	bge	a5,a4,80200854 <schedule+0x20>
        }
    }
    if (max_counter == 0) {
    802008f0:	fe843783          	ld	a5,-24(s0)
    802008f4:	16079463          	bnez	a5,80200a5c <schedule+0x228>
        for (int i=0; i<NR_TASKS; i++) {
    802008f8:	fc042c23          	sw	zero,-40(s0)
    802008fc:	0ac0006f          	j	802009a8 <schedule+0x174>
            task[i]->counter = task[i]->priority;
    80200900:	00004717          	auipc	a4,0x4
    80200904:	71870713          	addi	a4,a4,1816 # 80205018 <task>
    80200908:	fd842783          	lw	a5,-40(s0)
    8020090c:	00379793          	slli	a5,a5,0x3
    80200910:	00f707b3          	add	a5,a4,a5
    80200914:	0007b703          	ld	a4,0(a5)
    80200918:	00004697          	auipc	a3,0x4
    8020091c:	70068693          	addi	a3,a3,1792 # 80205018 <task>
    80200920:	fd842783          	lw	a5,-40(s0)
    80200924:	00379793          	slli	a5,a5,0x3
    80200928:	00f687b3          	add	a5,a3,a5
    8020092c:	0007b783          	ld	a5,0(a5)
    80200930:	01073703          	ld	a4,16(a4)
    80200934:	00e7b423          	sd	a4,8(a5)
            printk("SET [PID = %d counter = %d priority = %d]\n", task[i]->pid, task[i]->counter, task[i]->priority);
    80200938:	00004717          	auipc	a4,0x4
    8020093c:	6e070713          	addi	a4,a4,1760 # 80205018 <task>
    80200940:	fd842783          	lw	a5,-40(s0)
    80200944:	00379793          	slli	a5,a5,0x3
    80200948:	00f707b3          	add	a5,a4,a5
    8020094c:	0007b783          	ld	a5,0(a5)
    80200950:	0187b583          	ld	a1,24(a5)
    80200954:	00004717          	auipc	a4,0x4
    80200958:	6c470713          	addi	a4,a4,1732 # 80205018 <task>
    8020095c:	fd842783          	lw	a5,-40(s0)
    80200960:	00379793          	slli	a5,a5,0x3
    80200964:	00f707b3          	add	a5,a4,a5
    80200968:	0007b783          	ld	a5,0(a5)
    8020096c:	0087b603          	ld	a2,8(a5)
    80200970:	00004717          	auipc	a4,0x4
    80200974:	6a870713          	addi	a4,a4,1704 # 80205018 <task>
    80200978:	fd842783          	lw	a5,-40(s0)
    8020097c:	00379793          	slli	a5,a5,0x3
    80200980:	00f707b3          	add	a5,a4,a5
    80200984:	0007b783          	ld	a5,0(a5)
    80200988:	0107b783          	ld	a5,16(a5)
    8020098c:	00078693          	mv	a3,a5
    80200990:	00001517          	auipc	a0,0x1
    80200994:	74050513          	addi	a0,a0,1856 # 802020d0 <_srodata+0xd0>
    80200998:	330010ef          	jal	80201cc8 <printk>
        for (int i=0; i<NR_TASKS; i++) {
    8020099c:	fd842783          	lw	a5,-40(s0)
    802009a0:	0017879b          	addiw	a5,a5,1
    802009a4:	fcf42c23          	sw	a5,-40(s0)
    802009a8:	fd842783          	lw	a5,-40(s0)
    802009ac:	0007871b          	sext.w	a4,a5
    802009b0:	01f00793          	li	a5,31
    802009b4:	f4e7d6e3          	bge	a5,a4,80200900 <schedule+0xcc>
        }
        for (int i=0; i<NR_TASKS; i++){
    802009b8:	fc042a23          	sw	zero,-44(s0)
    802009bc:	0900006f          	j	80200a4c <schedule+0x218>
            if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
    802009c0:	00004717          	auipc	a4,0x4
    802009c4:	65870713          	addi	a4,a4,1624 # 80205018 <task>
    802009c8:	fd442783          	lw	a5,-44(s0)
    802009cc:	00379793          	slli	a5,a5,0x3
    802009d0:	00f707b3          	add	a5,a4,a5
    802009d4:	0007b783          	ld	a5,0(a5)
    802009d8:	0007b783          	ld	a5,0(a5)
    802009dc:	06079263          	bnez	a5,80200a40 <schedule+0x20c>
    802009e0:	00004717          	auipc	a4,0x4
    802009e4:	63870713          	addi	a4,a4,1592 # 80205018 <task>
    802009e8:	fd442783          	lw	a5,-44(s0)
    802009ec:	00379793          	slli	a5,a5,0x3
    802009f0:	00f707b3          	add	a5,a4,a5
    802009f4:	0007b783          	ld	a5,0(a5)
    802009f8:	0087b783          	ld	a5,8(a5)
    802009fc:	fe843703          	ld	a4,-24(s0)
    80200a00:	04f77063          	bgeu	a4,a5,80200a40 <schedule+0x20c>
                max_counter = task[i]->counter;
    80200a04:	00004717          	auipc	a4,0x4
    80200a08:	61470713          	addi	a4,a4,1556 # 80205018 <task>
    80200a0c:	fd442783          	lw	a5,-44(s0)
    80200a10:	00379793          	slli	a5,a5,0x3
    80200a14:	00f707b3          	add	a5,a4,a5
    80200a18:	0007b783          	ld	a5,0(a5)
    80200a1c:	0087b783          	ld	a5,8(a5)
    80200a20:	fef43423          	sd	a5,-24(s0)
                next = task[i];
    80200a24:	00004717          	auipc	a4,0x4
    80200a28:	5f470713          	addi	a4,a4,1524 # 80205018 <task>
    80200a2c:	fd442783          	lw	a5,-44(s0)
    80200a30:	00379793          	slli	a5,a5,0x3
    80200a34:	00f707b3          	add	a5,a4,a5
    80200a38:	0007b783          	ld	a5,0(a5)
    80200a3c:	fef43023          	sd	a5,-32(s0)
        for (int i=0; i<NR_TASKS; i++){
    80200a40:	fd442783          	lw	a5,-44(s0)
    80200a44:	0017879b          	addiw	a5,a5,1
    80200a48:	fcf42a23          	sw	a5,-44(s0)
    80200a4c:	fd442783          	lw	a5,-44(s0)
    80200a50:	0007871b          	sext.w	a4,a5
    80200a54:	01f00793          	li	a5,31
    80200a58:	f6e7d4e3          	bge	a5,a4,802009c0 <schedule+0x18c>
            }
        }
    }
    if (next == NULL) {
    80200a5c:	fe043783          	ld	a5,-32(s0)
    80200a60:	02079063          	bnez	a5,80200a80 <schedule+0x24c>
        printk("Error: no available thread to run!\n");
    80200a64:	00001517          	auipc	a0,0x1
    80200a68:	69c50513          	addi	a0,a0,1692 # 80202100 <_srodata+0x100>
    80200a6c:	25c010ef          	jal	80201cc8 <printk>
        next = idle;
    80200a70:	00004797          	auipc	a5,0x4
    80200a74:	59878793          	addi	a5,a5,1432 # 80205008 <idle>
    80200a78:	0007b783          	ld	a5,0(a5)
    80200a7c:	fef43023          	sd	a5,-32(s0)
    }
    switch_to(next);
    80200a80:	fe043503          	ld	a0,-32(s0)
    80200a84:	c75ff0ef          	jal	802006f8 <switch_to>
}
    80200a88:	00000013          	nop
    80200a8c:	02813083          	ld	ra,40(sp)
    80200a90:	02013403          	ld	s0,32(sp)
    80200a94:	03010113          	addi	sp,sp,48
    80200a98:	00008067          	ret

0000000080200a9c <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    80200a9c:	f9010113          	addi	sp,sp,-112
    80200aa0:	06813423          	sd	s0,104(sp)
    80200aa4:	07010413          	addi	s0,sp,112
    80200aa8:	fca43423          	sd	a0,-56(s0)
    80200aac:	fcb43023          	sd	a1,-64(s0)
    80200ab0:	fac43c23          	sd	a2,-72(s0)
    80200ab4:	fad43823          	sd	a3,-80(s0)
    80200ab8:	fae43423          	sd	a4,-88(s0)
    80200abc:	faf43023          	sd	a5,-96(s0)
    80200ac0:	f9043c23          	sd	a6,-104(s0)
    80200ac4:	f9143823          	sd	a7,-112(s0)
    struct sbiret ret;
    asm volatile(
    80200ac8:	fc843783          	ld	a5,-56(s0)
    80200acc:	fc043703          	ld	a4,-64(s0)
    80200ad0:	fb843683          	ld	a3,-72(s0)
    80200ad4:	fb043603          	ld	a2,-80(s0)
    80200ad8:	fa843583          	ld	a1,-88(s0)
    80200adc:	fa043503          	ld	a0,-96(s0)
    80200ae0:	f9843803          	ld	a6,-104(s0)
    80200ae4:	f9043883          	ld	a7,-112(s0)
    80200ae8:	00078893          	mv	a7,a5
    80200aec:	00070813          	mv	a6,a4
    80200af0:	00068513          	mv	a0,a3
    80200af4:	00060593          	mv	a1,a2
    80200af8:	00058613          	mv	a2,a1
    80200afc:	00050693          	mv	a3,a0
    80200b00:	00080713          	mv	a4,a6
    80200b04:	00088793          	mv	a5,a7
    80200b08:	00000073          	ecall
    80200b0c:	00050713          	mv	a4,a0
    80200b10:	00058793          	mv	a5,a1
    80200b14:	fce43823          	sd	a4,-48(s0)
    80200b18:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1"
        : [error] "=r" (ret.error), [value] "=r" (ret.value)
        : [eid]"r"(eid), [fid]"r"(fid), [arg0]"r"(arg0), [arg1]"r"(arg1), [arg2]"r"(arg2), [arg3]"r"(arg3), [arg4]"r"(arg4), [arg5]"r"(arg5)
        : "memory"
    );
    return ret;
    80200b1c:	fd043783          	ld	a5,-48(s0)
    80200b20:	fef43023          	sd	a5,-32(s0)
    80200b24:	fd843783          	ld	a5,-40(s0)
    80200b28:	fef43423          	sd	a5,-24(s0)
    80200b2c:	fe043703          	ld	a4,-32(s0)
    80200b30:	fe843783          	ld	a5,-24(s0)
    80200b34:	00070313          	mv	t1,a4
    80200b38:	00078393          	mv	t2,a5
    80200b3c:	00030713          	mv	a4,t1
    80200b40:	00038793          	mv	a5,t2
}
    80200b44:	00070513          	mv	a0,a4
    80200b48:	00078593          	mv	a1,a5
    80200b4c:	06813403          	ld	s0,104(sp)
    80200b50:	07010113          	addi	sp,sp,112
    80200b54:	00008067          	ret

0000000080200b58 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    80200b58:	fc010113          	addi	sp,sp,-64
    80200b5c:	02113c23          	sd	ra,56(sp)
    80200b60:	02813823          	sd	s0,48(sp)
    80200b64:	03213423          	sd	s2,40(sp)
    80200b68:	03313023          	sd	s3,32(sp)
    80200b6c:	04010413          	addi	s0,sp,64
    80200b70:	00050793          	mv	a5,a0
    80200b74:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);;
    80200b78:	fcf44603          	lbu	a2,-49(s0)
    80200b7c:	00000893          	li	a7,0
    80200b80:	00000813          	li	a6,0
    80200b84:	00000793          	li	a5,0
    80200b88:	00000713          	li	a4,0
    80200b8c:	00000693          	li	a3,0
    80200b90:	00200593          	li	a1,2
    80200b94:	44424537          	lui	a0,0x44424
    80200b98:	34e50513          	addi	a0,a0,846 # 4442434e <regbytes+0x44424346>
    80200b9c:	f01ff0ef          	jal	80200a9c <sbi_ecall>
    80200ba0:	00050713          	mv	a4,a0
    80200ba4:	00058793          	mv	a5,a1
    80200ba8:	fce43823          	sd	a4,-48(s0)
    80200bac:	fcf43c23          	sd	a5,-40(s0)
    80200bb0:	fd043703          	ld	a4,-48(s0)
    80200bb4:	fd843783          	ld	a5,-40(s0)
    80200bb8:	00070913          	mv	s2,a4
    80200bbc:	00078993          	mv	s3,a5
    80200bc0:	00090713          	mv	a4,s2
    80200bc4:	00098793          	mv	a5,s3
}
    80200bc8:	00070513          	mv	a0,a4
    80200bcc:	00078593          	mv	a1,a5
    80200bd0:	03813083          	ld	ra,56(sp)
    80200bd4:	03013403          	ld	s0,48(sp)
    80200bd8:	02813903          	ld	s2,40(sp)
    80200bdc:	02013983          	ld	s3,32(sp)
    80200be0:	04010113          	addi	sp,sp,64
    80200be4:	00008067          	ret

0000000080200be8 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200be8:	fc010113          	addi	sp,sp,-64
    80200bec:	02113c23          	sd	ra,56(sp)
    80200bf0:	02813823          	sd	s0,48(sp)
    80200bf4:	03213423          	sd	s2,40(sp)
    80200bf8:	03313023          	sd	s3,32(sp)
    80200bfc:	04010413          	addi	s0,sp,64
    80200c00:	00050793          	mv	a5,a0
    80200c04:	00058713          	mv	a4,a1
    80200c08:	fcf42623          	sw	a5,-52(s0)
    80200c0c:	00070793          	mv	a5,a4
    80200c10:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0x0, reset_type, reset_reason, 0, 0, 0, 0);;
    80200c14:	fcc46603          	lwu	a2,-52(s0)
    80200c18:	fc846683          	lwu	a3,-56(s0)
    80200c1c:	00000893          	li	a7,0
    80200c20:	00000813          	li	a6,0
    80200c24:	00000793          	li	a5,0
    80200c28:	00000713          	li	a4,0
    80200c2c:	00000593          	li	a1,0
    80200c30:	53525537          	lui	a0,0x53525
    80200c34:	35450513          	addi	a0,a0,852 # 53525354 <regbytes+0x5352534c>
    80200c38:	e65ff0ef          	jal	80200a9c <sbi_ecall>
    80200c3c:	00050713          	mv	a4,a0
    80200c40:	00058793          	mv	a5,a1
    80200c44:	fce43823          	sd	a4,-48(s0)
    80200c48:	fcf43c23          	sd	a5,-40(s0)
    80200c4c:	fd043703          	ld	a4,-48(s0)
    80200c50:	fd843783          	ld	a5,-40(s0)
    80200c54:	00070913          	mv	s2,a4
    80200c58:	00078993          	mv	s3,a5
    80200c5c:	00090713          	mv	a4,s2
    80200c60:	00098793          	mv	a5,s3
}
    80200c64:	00070513          	mv	a0,a4
    80200c68:	00078593          	mv	a1,a5
    80200c6c:	03813083          	ld	ra,56(sp)
    80200c70:	03013403          	ld	s0,48(sp)
    80200c74:	02813903          	ld	s2,40(sp)
    80200c78:	02013983          	ld	s3,32(sp)
    80200c7c:	04010113          	addi	sp,sp,64
    80200c80:	00008067          	ret

0000000080200c84 <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
    80200c84:	fc010113          	addi	sp,sp,-64
    80200c88:	02113c23          	sd	ra,56(sp)
    80200c8c:	02813823          	sd	s0,48(sp)
    80200c90:	03213423          	sd	s2,40(sp)
    80200c94:	03313023          	sd	s3,32(sp)
    80200c98:	04010413          	addi	s0,sp,64
    80200c9c:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0x0, stime_value, 0, 0, 0, 0, 0);
    80200ca0:	00000893          	li	a7,0
    80200ca4:	00000813          	li	a6,0
    80200ca8:	00000793          	li	a5,0
    80200cac:	00000713          	li	a4,0
    80200cb0:	00000693          	li	a3,0
    80200cb4:	fc843603          	ld	a2,-56(s0)
    80200cb8:	00000593          	li	a1,0
    80200cbc:	54495537          	lui	a0,0x54495
    80200cc0:	d4550513          	addi	a0,a0,-699 # 54494d45 <regbytes+0x54494d3d>
    80200cc4:	dd9ff0ef          	jal	80200a9c <sbi_ecall>
    80200cc8:	00050713          	mv	a4,a0
    80200ccc:	00058793          	mv	a5,a1
    80200cd0:	fce43823          	sd	a4,-48(s0)
    80200cd4:	fcf43c23          	sd	a5,-40(s0)
    80200cd8:	fd043703          	ld	a4,-48(s0)
    80200cdc:	fd843783          	ld	a5,-40(s0)
    80200ce0:	00070913          	mv	s2,a4
    80200ce4:	00078993          	mv	s3,a5
    80200ce8:	00090713          	mv	a4,s2
    80200cec:	00098793          	mv	a5,s3
    80200cf0:	00070513          	mv	a0,a4
    80200cf4:	00078593          	mv	a1,a5
    80200cf8:	03813083          	ld	ra,56(sp)
    80200cfc:	03013403          	ld	s0,48(sp)
    80200d00:	02813903          	ld	s2,40(sp)
    80200d04:	02013983          	ld	s3,32(sp)
    80200d08:	04010113          	addi	sp,sp,64
    80200d0c:	00008067          	ret

0000000080200d10 <trap_handler>:
#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"
extern void do_timer();
void trap_handler(uint64_t scause, uint64_t sepc) {
    80200d10:	fd010113          	addi	sp,sp,-48
    80200d14:	02113423          	sd	ra,40(sp)
    80200d18:	02813023          	sd	s0,32(sp)
    80200d1c:	03010413          	addi	s0,sp,48
    80200d20:	fca43c23          	sd	a0,-40(s0)
    80200d24:	fcb43823          	sd	a1,-48(s0)
    uint64_t flag = scause >> 63;
    80200d28:	fd843783          	ld	a5,-40(s0)
    80200d2c:	03f7d793          	srli	a5,a5,0x3f
    80200d30:	fef43423          	sd	a5,-24(s0)
    uint64_t cause = scause & 0x7FFFFFFFFFFFFFFF;
    80200d34:	fd843703          	ld	a4,-40(s0)
    80200d38:	fff00793          	li	a5,-1
    80200d3c:	0017d793          	srli	a5,a5,0x1
    80200d40:	00f777b3          	and	a5,a4,a5
    80200d44:	fef43023          	sd	a5,-32(s0)

    if(flag) {//interrupt
    80200d48:	fe843783          	ld	a5,-24(s0)
    80200d4c:	02078863          	beqz	a5,80200d7c <trap_handler+0x6c>
        if(cause == 5) {
    80200d50:	fe043703          	ld	a4,-32(s0)
    80200d54:	00500793          	li	a5,5
    80200d58:	00f71863          	bne	a4,a5,80200d68 <trap_handler+0x58>
            // uint64_t ret = csr_read(sstatus);
            // csr_write(sscratch, ret);
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            
            clock_set_next_event();
    80200d5c:	cb0ff0ef          	jal	8020020c <clock_set_next_event>
            do_timer();
    80200d60:	a51ff0ef          	jal	802007b0 <do_timer>
        }
    }
    else {
        printk("[S] Exception: %d\n", cause);
    }
    80200d64:	0280006f          	j	80200d8c <trap_handler+0x7c>
            printk("[S] Interrupt: %d\n", cause);
    80200d68:	fe043583          	ld	a1,-32(s0)
    80200d6c:	00001517          	auipc	a0,0x1
    80200d70:	3bc50513          	addi	a0,a0,956 # 80202128 <_srodata+0x128>
    80200d74:	755000ef          	jal	80201cc8 <printk>
    80200d78:	0140006f          	j	80200d8c <trap_handler+0x7c>
        printk("[S] Exception: %d\n", cause);
    80200d7c:	fe043583          	ld	a1,-32(s0)
    80200d80:	00001517          	auipc	a0,0x1
    80200d84:	3c050513          	addi	a0,a0,960 # 80202140 <_srodata+0x140>
    80200d88:	741000ef          	jal	80201cc8 <printk>
    80200d8c:	00000013          	nop
    80200d90:	02813083          	ld	ra,40(sp)
    80200d94:	02013403          	ld	s0,32(sp)
    80200d98:	03010113          	addi	sp,sp,48
    80200d9c:	00008067          	ret

0000000080200da0 <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
    80200da0:	ff010113          	addi	sp,sp,-16
    80200da4:	00113423          	sd	ra,8(sp)
    80200da8:	00813023          	sd	s0,0(sp)
    80200dac:	01010413          	addi	s0,sp,16
    printk("2024");
    80200db0:	00001517          	auipc	a0,0x1
    80200db4:	3a850513          	addi	a0,a0,936 # 80202158 <_srodata+0x158>
    80200db8:	711000ef          	jal	80201cc8 <printk>
    printk(" ZJU Operating System\n");
    80200dbc:	00001517          	auipc	a0,0x1
    80200dc0:	3a450513          	addi	a0,a0,932 # 80202160 <_srodata+0x160>
    80200dc4:	705000ef          	jal	80201cc8 <printk>

    test();
    80200dc8:	01c000ef          	jal	80200de4 <test>
    return 0;
    80200dcc:	00000793          	li	a5,0
}
    80200dd0:	00078513          	mv	a0,a5
    80200dd4:	00813083          	ld	ra,8(sp)
    80200dd8:	00013403          	ld	s0,0(sp)
    80200ddc:	01010113          	addi	sp,sp,16
    80200de0:	00008067          	ret

0000000080200de4 <test>:
#include "printk.h"

void test() {
    80200de4:	fe010113          	addi	sp,sp,-32
    80200de8:	00113c23          	sd	ra,24(sp)
    80200dec:	00813823          	sd	s0,16(sp)
    80200df0:	02010413          	addi	s0,sp,32
    int i = 0;
    80200df4:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
    80200df8:	fec42783          	lw	a5,-20(s0)
    80200dfc:	0017879b          	addiw	a5,a5,1
    80200e00:	fef42623          	sw	a5,-20(s0)
    80200e04:	fec42783          	lw	a5,-20(s0)
    80200e08:	00078713          	mv	a4,a5
    80200e0c:	05f5e7b7          	lui	a5,0x5f5e
    80200e10:	1007879b          	addiw	a5,a5,256 # 5f5e100 <regbytes+0x5f5e0f8>
    80200e14:	02f767bb          	remw	a5,a4,a5
    80200e18:	0007879b          	sext.w	a5,a5
    80200e1c:	fc079ee3          	bnez	a5,80200df8 <test+0x14>
            printk("kernel is running!\n");
    80200e20:	00001517          	auipc	a0,0x1
    80200e24:	35850513          	addi	a0,a0,856 # 80202178 <_srodata+0x178>
    80200e28:	6a1000ef          	jal	80201cc8 <printk>
            i = 0;
    80200e2c:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
    80200e30:	fc9ff06f          	j	80200df8 <test+0x14>

0000000080200e34 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    80200e34:	fe010113          	addi	sp,sp,-32
    80200e38:	00113c23          	sd	ra,24(sp)
    80200e3c:	00813823          	sd	s0,16(sp)
    80200e40:	02010413          	addi	s0,sp,32
    80200e44:	00050793          	mv	a5,a0
    80200e48:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    80200e4c:	fec42783          	lw	a5,-20(s0)
    80200e50:	0ff7f793          	zext.b	a5,a5
    80200e54:	00078513          	mv	a0,a5
    80200e58:	d01ff0ef          	jal	80200b58 <sbi_debug_console_write_byte>
    return (char)c;
    80200e5c:	fec42783          	lw	a5,-20(s0)
    80200e60:	0ff7f793          	zext.b	a5,a5
    80200e64:	0007879b          	sext.w	a5,a5
}
    80200e68:	00078513          	mv	a0,a5
    80200e6c:	01813083          	ld	ra,24(sp)
    80200e70:	01013403          	ld	s0,16(sp)
    80200e74:	02010113          	addi	sp,sp,32
    80200e78:	00008067          	ret

0000000080200e7c <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    80200e7c:	fe010113          	addi	sp,sp,-32
    80200e80:	00813c23          	sd	s0,24(sp)
    80200e84:	02010413          	addi	s0,sp,32
    80200e88:	00050793          	mv	a5,a0
    80200e8c:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    80200e90:	fec42783          	lw	a5,-20(s0)
    80200e94:	0007871b          	sext.w	a4,a5
    80200e98:	02000793          	li	a5,32
    80200e9c:	02f70263          	beq	a4,a5,80200ec0 <isspace+0x44>
    80200ea0:	fec42783          	lw	a5,-20(s0)
    80200ea4:	0007871b          	sext.w	a4,a5
    80200ea8:	00800793          	li	a5,8
    80200eac:	00e7de63          	bge	a5,a4,80200ec8 <isspace+0x4c>
    80200eb0:	fec42783          	lw	a5,-20(s0)
    80200eb4:	0007871b          	sext.w	a4,a5
    80200eb8:	00d00793          	li	a5,13
    80200ebc:	00e7c663          	blt	a5,a4,80200ec8 <isspace+0x4c>
    80200ec0:	00100793          	li	a5,1
    80200ec4:	0080006f          	j	80200ecc <isspace+0x50>
    80200ec8:	00000793          	li	a5,0
}
    80200ecc:	00078513          	mv	a0,a5
    80200ed0:	01813403          	ld	s0,24(sp)
    80200ed4:	02010113          	addi	sp,sp,32
    80200ed8:	00008067          	ret

0000000080200edc <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    80200edc:	fb010113          	addi	sp,sp,-80
    80200ee0:	04113423          	sd	ra,72(sp)
    80200ee4:	04813023          	sd	s0,64(sp)
    80200ee8:	05010413          	addi	s0,sp,80
    80200eec:	fca43423          	sd	a0,-56(s0)
    80200ef0:	fcb43023          	sd	a1,-64(s0)
    80200ef4:	00060793          	mv	a5,a2
    80200ef8:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    80200efc:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    80200f00:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    80200f04:	fc843783          	ld	a5,-56(s0)
    80200f08:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    80200f0c:	0100006f          	j	80200f1c <strtol+0x40>
        p++;
    80200f10:	fd843783          	ld	a5,-40(s0)
    80200f14:	00178793          	addi	a5,a5,1
    80200f18:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    80200f1c:	fd843783          	ld	a5,-40(s0)
    80200f20:	0007c783          	lbu	a5,0(a5)
    80200f24:	0007879b          	sext.w	a5,a5
    80200f28:	00078513          	mv	a0,a5
    80200f2c:	f51ff0ef          	jal	80200e7c <isspace>
    80200f30:	00050793          	mv	a5,a0
    80200f34:	fc079ee3          	bnez	a5,80200f10 <strtol+0x34>
    }

    if (*p == '-') {
    80200f38:	fd843783          	ld	a5,-40(s0)
    80200f3c:	0007c783          	lbu	a5,0(a5)
    80200f40:	00078713          	mv	a4,a5
    80200f44:	02d00793          	li	a5,45
    80200f48:	00f71e63          	bne	a4,a5,80200f64 <strtol+0x88>
        neg = true;
    80200f4c:	00100793          	li	a5,1
    80200f50:	fef403a3          	sb	a5,-25(s0)
        p++;
    80200f54:	fd843783          	ld	a5,-40(s0)
    80200f58:	00178793          	addi	a5,a5,1
    80200f5c:	fcf43c23          	sd	a5,-40(s0)
    80200f60:	0240006f          	j	80200f84 <strtol+0xa8>
    } else if (*p == '+') {
    80200f64:	fd843783          	ld	a5,-40(s0)
    80200f68:	0007c783          	lbu	a5,0(a5)
    80200f6c:	00078713          	mv	a4,a5
    80200f70:	02b00793          	li	a5,43
    80200f74:	00f71863          	bne	a4,a5,80200f84 <strtol+0xa8>
        p++;
    80200f78:	fd843783          	ld	a5,-40(s0)
    80200f7c:	00178793          	addi	a5,a5,1
    80200f80:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    80200f84:	fbc42783          	lw	a5,-68(s0)
    80200f88:	0007879b          	sext.w	a5,a5
    80200f8c:	06079c63          	bnez	a5,80201004 <strtol+0x128>
        if (*p == '0') {
    80200f90:	fd843783          	ld	a5,-40(s0)
    80200f94:	0007c783          	lbu	a5,0(a5)
    80200f98:	00078713          	mv	a4,a5
    80200f9c:	03000793          	li	a5,48
    80200fa0:	04f71e63          	bne	a4,a5,80200ffc <strtol+0x120>
            p++;
    80200fa4:	fd843783          	ld	a5,-40(s0)
    80200fa8:	00178793          	addi	a5,a5,1
    80200fac:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    80200fb0:	fd843783          	ld	a5,-40(s0)
    80200fb4:	0007c783          	lbu	a5,0(a5)
    80200fb8:	00078713          	mv	a4,a5
    80200fbc:	07800793          	li	a5,120
    80200fc0:	00f70c63          	beq	a4,a5,80200fd8 <strtol+0xfc>
    80200fc4:	fd843783          	ld	a5,-40(s0)
    80200fc8:	0007c783          	lbu	a5,0(a5)
    80200fcc:	00078713          	mv	a4,a5
    80200fd0:	05800793          	li	a5,88
    80200fd4:	00f71e63          	bne	a4,a5,80200ff0 <strtol+0x114>
                base = 16;
    80200fd8:	01000793          	li	a5,16
    80200fdc:	faf42e23          	sw	a5,-68(s0)
                p++;
    80200fe0:	fd843783          	ld	a5,-40(s0)
    80200fe4:	00178793          	addi	a5,a5,1
    80200fe8:	fcf43c23          	sd	a5,-40(s0)
    80200fec:	0180006f          	j	80201004 <strtol+0x128>
            } else {
                base = 8;
    80200ff0:	00800793          	li	a5,8
    80200ff4:	faf42e23          	sw	a5,-68(s0)
    80200ff8:	00c0006f          	j	80201004 <strtol+0x128>
            }
        } else {
            base = 10;
    80200ffc:	00a00793          	li	a5,10
    80201000:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    80201004:	fd843783          	ld	a5,-40(s0)
    80201008:	0007c783          	lbu	a5,0(a5)
    8020100c:	00078713          	mv	a4,a5
    80201010:	02f00793          	li	a5,47
    80201014:	02e7f863          	bgeu	a5,a4,80201044 <strtol+0x168>
    80201018:	fd843783          	ld	a5,-40(s0)
    8020101c:	0007c783          	lbu	a5,0(a5)
    80201020:	00078713          	mv	a4,a5
    80201024:	03900793          	li	a5,57
    80201028:	00e7ee63          	bltu	a5,a4,80201044 <strtol+0x168>
            digit = *p - '0';
    8020102c:	fd843783          	ld	a5,-40(s0)
    80201030:	0007c783          	lbu	a5,0(a5)
    80201034:	0007879b          	sext.w	a5,a5
    80201038:	fd07879b          	addiw	a5,a5,-48
    8020103c:	fcf42a23          	sw	a5,-44(s0)
    80201040:	0800006f          	j	802010c0 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    80201044:	fd843783          	ld	a5,-40(s0)
    80201048:	0007c783          	lbu	a5,0(a5)
    8020104c:	00078713          	mv	a4,a5
    80201050:	06000793          	li	a5,96
    80201054:	02e7f863          	bgeu	a5,a4,80201084 <strtol+0x1a8>
    80201058:	fd843783          	ld	a5,-40(s0)
    8020105c:	0007c783          	lbu	a5,0(a5)
    80201060:	00078713          	mv	a4,a5
    80201064:	07a00793          	li	a5,122
    80201068:	00e7ee63          	bltu	a5,a4,80201084 <strtol+0x1a8>
            digit = *p - ('a' - 10);
    8020106c:	fd843783          	ld	a5,-40(s0)
    80201070:	0007c783          	lbu	a5,0(a5)
    80201074:	0007879b          	sext.w	a5,a5
    80201078:	fa97879b          	addiw	a5,a5,-87
    8020107c:	fcf42a23          	sw	a5,-44(s0)
    80201080:	0400006f          	j	802010c0 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    80201084:	fd843783          	ld	a5,-40(s0)
    80201088:	0007c783          	lbu	a5,0(a5)
    8020108c:	00078713          	mv	a4,a5
    80201090:	04000793          	li	a5,64
    80201094:	06e7f863          	bgeu	a5,a4,80201104 <strtol+0x228>
    80201098:	fd843783          	ld	a5,-40(s0)
    8020109c:	0007c783          	lbu	a5,0(a5)
    802010a0:	00078713          	mv	a4,a5
    802010a4:	05a00793          	li	a5,90
    802010a8:	04e7ee63          	bltu	a5,a4,80201104 <strtol+0x228>
            digit = *p - ('A' - 10);
    802010ac:	fd843783          	ld	a5,-40(s0)
    802010b0:	0007c783          	lbu	a5,0(a5)
    802010b4:	0007879b          	sext.w	a5,a5
    802010b8:	fc97879b          	addiw	a5,a5,-55
    802010bc:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    802010c0:	fd442783          	lw	a5,-44(s0)
    802010c4:	00078713          	mv	a4,a5
    802010c8:	fbc42783          	lw	a5,-68(s0)
    802010cc:	0007071b          	sext.w	a4,a4
    802010d0:	0007879b          	sext.w	a5,a5
    802010d4:	02f75663          	bge	a4,a5,80201100 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    802010d8:	fbc42703          	lw	a4,-68(s0)
    802010dc:	fe843783          	ld	a5,-24(s0)
    802010e0:	02f70733          	mul	a4,a4,a5
    802010e4:	fd442783          	lw	a5,-44(s0)
    802010e8:	00f707b3          	add	a5,a4,a5
    802010ec:	fef43423          	sd	a5,-24(s0)
        p++;
    802010f0:	fd843783          	ld	a5,-40(s0)
    802010f4:	00178793          	addi	a5,a5,1
    802010f8:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    802010fc:	f09ff06f          	j	80201004 <strtol+0x128>
            break;
    80201100:	00000013          	nop
    }

    if (endptr) {
    80201104:	fc043783          	ld	a5,-64(s0)
    80201108:	00078863          	beqz	a5,80201118 <strtol+0x23c>
        *endptr = (char *)p;
    8020110c:	fc043783          	ld	a5,-64(s0)
    80201110:	fd843703          	ld	a4,-40(s0)
    80201114:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    80201118:	fe744783          	lbu	a5,-25(s0)
    8020111c:	0ff7f793          	zext.b	a5,a5
    80201120:	00078863          	beqz	a5,80201130 <strtol+0x254>
    80201124:	fe843783          	ld	a5,-24(s0)
    80201128:	40f007b3          	neg	a5,a5
    8020112c:	0080006f          	j	80201134 <strtol+0x258>
    80201130:	fe843783          	ld	a5,-24(s0)
}
    80201134:	00078513          	mv	a0,a5
    80201138:	04813083          	ld	ra,72(sp)
    8020113c:	04013403          	ld	s0,64(sp)
    80201140:	05010113          	addi	sp,sp,80
    80201144:	00008067          	ret

0000000080201148 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    80201148:	fd010113          	addi	sp,sp,-48
    8020114c:	02113423          	sd	ra,40(sp)
    80201150:	02813023          	sd	s0,32(sp)
    80201154:	03010413          	addi	s0,sp,48
    80201158:	fca43c23          	sd	a0,-40(s0)
    8020115c:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    80201160:	fd043783          	ld	a5,-48(s0)
    80201164:	00079863          	bnez	a5,80201174 <puts_wo_nl+0x2c>
        s = "(null)";
    80201168:	00001797          	auipc	a5,0x1
    8020116c:	02878793          	addi	a5,a5,40 # 80202190 <_srodata+0x190>
    80201170:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    80201174:	fd043783          	ld	a5,-48(s0)
    80201178:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    8020117c:	0240006f          	j	802011a0 <puts_wo_nl+0x58>
        putch(*p++);
    80201180:	fe843783          	ld	a5,-24(s0)
    80201184:	00178713          	addi	a4,a5,1
    80201188:	fee43423          	sd	a4,-24(s0)
    8020118c:	0007c783          	lbu	a5,0(a5)
    80201190:	0007871b          	sext.w	a4,a5
    80201194:	fd843783          	ld	a5,-40(s0)
    80201198:	00070513          	mv	a0,a4
    8020119c:	000780e7          	jalr	a5
    while (*p) {
    802011a0:	fe843783          	ld	a5,-24(s0)
    802011a4:	0007c783          	lbu	a5,0(a5)
    802011a8:	fc079ce3          	bnez	a5,80201180 <puts_wo_nl+0x38>
    }
    return p - s;
    802011ac:	fe843703          	ld	a4,-24(s0)
    802011b0:	fd043783          	ld	a5,-48(s0)
    802011b4:	40f707b3          	sub	a5,a4,a5
    802011b8:	0007879b          	sext.w	a5,a5
}
    802011bc:	00078513          	mv	a0,a5
    802011c0:	02813083          	ld	ra,40(sp)
    802011c4:	02013403          	ld	s0,32(sp)
    802011c8:	03010113          	addi	sp,sp,48
    802011cc:	00008067          	ret

00000000802011d0 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    802011d0:	f9010113          	addi	sp,sp,-112
    802011d4:	06113423          	sd	ra,104(sp)
    802011d8:	06813023          	sd	s0,96(sp)
    802011dc:	07010413          	addi	s0,sp,112
    802011e0:	faa43423          	sd	a0,-88(s0)
    802011e4:	fab43023          	sd	a1,-96(s0)
    802011e8:	00060793          	mv	a5,a2
    802011ec:	f8d43823          	sd	a3,-112(s0)
    802011f0:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    802011f4:	f9f44783          	lbu	a5,-97(s0)
    802011f8:	0ff7f793          	zext.b	a5,a5
    802011fc:	02078663          	beqz	a5,80201228 <print_dec_int+0x58>
    80201200:	fa043703          	ld	a4,-96(s0)
    80201204:	fff00793          	li	a5,-1
    80201208:	03f79793          	slli	a5,a5,0x3f
    8020120c:	00f71e63          	bne	a4,a5,80201228 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    80201210:	00001597          	auipc	a1,0x1
    80201214:	f8858593          	addi	a1,a1,-120 # 80202198 <_srodata+0x198>
    80201218:	fa843503          	ld	a0,-88(s0)
    8020121c:	f2dff0ef          	jal	80201148 <puts_wo_nl>
    80201220:	00050793          	mv	a5,a0
    80201224:	2a00006f          	j	802014c4 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    80201228:	f9043783          	ld	a5,-112(s0)
    8020122c:	00c7a783          	lw	a5,12(a5)
    80201230:	00079a63          	bnez	a5,80201244 <print_dec_int+0x74>
    80201234:	fa043783          	ld	a5,-96(s0)
    80201238:	00079663          	bnez	a5,80201244 <print_dec_int+0x74>
        return 0;
    8020123c:	00000793          	li	a5,0
    80201240:	2840006f          	j	802014c4 <print_dec_int+0x2f4>
    }

    bool neg = false;
    80201244:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    80201248:	f9f44783          	lbu	a5,-97(s0)
    8020124c:	0ff7f793          	zext.b	a5,a5
    80201250:	02078063          	beqz	a5,80201270 <print_dec_int+0xa0>
    80201254:	fa043783          	ld	a5,-96(s0)
    80201258:	0007dc63          	bgez	a5,80201270 <print_dec_int+0xa0>
        neg = true;
    8020125c:	00100793          	li	a5,1
    80201260:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    80201264:	fa043783          	ld	a5,-96(s0)
    80201268:	40f007b3          	neg	a5,a5
    8020126c:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    80201270:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    80201274:	f9f44783          	lbu	a5,-97(s0)
    80201278:	0ff7f793          	zext.b	a5,a5
    8020127c:	02078863          	beqz	a5,802012ac <print_dec_int+0xdc>
    80201280:	fef44783          	lbu	a5,-17(s0)
    80201284:	0ff7f793          	zext.b	a5,a5
    80201288:	00079e63          	bnez	a5,802012a4 <print_dec_int+0xd4>
    8020128c:	f9043783          	ld	a5,-112(s0)
    80201290:	0057c783          	lbu	a5,5(a5)
    80201294:	00079863          	bnez	a5,802012a4 <print_dec_int+0xd4>
    80201298:	f9043783          	ld	a5,-112(s0)
    8020129c:	0047c783          	lbu	a5,4(a5)
    802012a0:	00078663          	beqz	a5,802012ac <print_dec_int+0xdc>
    802012a4:	00100793          	li	a5,1
    802012a8:	0080006f          	j	802012b0 <print_dec_int+0xe0>
    802012ac:	00000793          	li	a5,0
    802012b0:	fcf40ba3          	sb	a5,-41(s0)
    802012b4:	fd744783          	lbu	a5,-41(s0)
    802012b8:	0017f793          	andi	a5,a5,1
    802012bc:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    802012c0:	fa043703          	ld	a4,-96(s0)
    802012c4:	00a00793          	li	a5,10
    802012c8:	02f777b3          	remu	a5,a4,a5
    802012cc:	0ff7f713          	zext.b	a4,a5
    802012d0:	fe842783          	lw	a5,-24(s0)
    802012d4:	0017869b          	addiw	a3,a5,1
    802012d8:	fed42423          	sw	a3,-24(s0)
    802012dc:	0307071b          	addiw	a4,a4,48
    802012e0:	0ff77713          	zext.b	a4,a4
    802012e4:	ff078793          	addi	a5,a5,-16
    802012e8:	008787b3          	add	a5,a5,s0
    802012ec:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    802012f0:	fa043703          	ld	a4,-96(s0)
    802012f4:	00a00793          	li	a5,10
    802012f8:	02f757b3          	divu	a5,a4,a5
    802012fc:	faf43023          	sd	a5,-96(s0)
    } while (num);
    80201300:	fa043783          	ld	a5,-96(s0)
    80201304:	fa079ee3          	bnez	a5,802012c0 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    80201308:	f9043783          	ld	a5,-112(s0)
    8020130c:	00c7a783          	lw	a5,12(a5)
    80201310:	00078713          	mv	a4,a5
    80201314:	fff00793          	li	a5,-1
    80201318:	02f71063          	bne	a4,a5,80201338 <print_dec_int+0x168>
    8020131c:	f9043783          	ld	a5,-112(s0)
    80201320:	0037c783          	lbu	a5,3(a5)
    80201324:	00078a63          	beqz	a5,80201338 <print_dec_int+0x168>
        flags->prec = flags->width;
    80201328:	f9043783          	ld	a5,-112(s0)
    8020132c:	0087a703          	lw	a4,8(a5)
    80201330:	f9043783          	ld	a5,-112(s0)
    80201334:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    80201338:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    8020133c:	f9043783          	ld	a5,-112(s0)
    80201340:	0087a703          	lw	a4,8(a5)
    80201344:	fe842783          	lw	a5,-24(s0)
    80201348:	fcf42823          	sw	a5,-48(s0)
    8020134c:	f9043783          	ld	a5,-112(s0)
    80201350:	00c7a783          	lw	a5,12(a5)
    80201354:	fcf42623          	sw	a5,-52(s0)
    80201358:	fd042783          	lw	a5,-48(s0)
    8020135c:	00078593          	mv	a1,a5
    80201360:	fcc42783          	lw	a5,-52(s0)
    80201364:	00078613          	mv	a2,a5
    80201368:	0006069b          	sext.w	a3,a2
    8020136c:	0005879b          	sext.w	a5,a1
    80201370:	00f6d463          	bge	a3,a5,80201378 <print_dec_int+0x1a8>
    80201374:	00058613          	mv	a2,a1
    80201378:	0006079b          	sext.w	a5,a2
    8020137c:	40f707bb          	subw	a5,a4,a5
    80201380:	0007871b          	sext.w	a4,a5
    80201384:	fd744783          	lbu	a5,-41(s0)
    80201388:	0007879b          	sext.w	a5,a5
    8020138c:	40f707bb          	subw	a5,a4,a5
    80201390:	fef42023          	sw	a5,-32(s0)
    80201394:	0280006f          	j	802013bc <print_dec_int+0x1ec>
        putch(' ');
    80201398:	fa843783          	ld	a5,-88(s0)
    8020139c:	02000513          	li	a0,32
    802013a0:	000780e7          	jalr	a5
        ++written;
    802013a4:	fe442783          	lw	a5,-28(s0)
    802013a8:	0017879b          	addiw	a5,a5,1
    802013ac:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    802013b0:	fe042783          	lw	a5,-32(s0)
    802013b4:	fff7879b          	addiw	a5,a5,-1
    802013b8:	fef42023          	sw	a5,-32(s0)
    802013bc:	fe042783          	lw	a5,-32(s0)
    802013c0:	0007879b          	sext.w	a5,a5
    802013c4:	fcf04ae3          	bgtz	a5,80201398 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    802013c8:	fd744783          	lbu	a5,-41(s0)
    802013cc:	0ff7f793          	zext.b	a5,a5
    802013d0:	04078463          	beqz	a5,80201418 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    802013d4:	fef44783          	lbu	a5,-17(s0)
    802013d8:	0ff7f793          	zext.b	a5,a5
    802013dc:	00078663          	beqz	a5,802013e8 <print_dec_int+0x218>
    802013e0:	02d00793          	li	a5,45
    802013e4:	01c0006f          	j	80201400 <print_dec_int+0x230>
    802013e8:	f9043783          	ld	a5,-112(s0)
    802013ec:	0057c783          	lbu	a5,5(a5)
    802013f0:	00078663          	beqz	a5,802013fc <print_dec_int+0x22c>
    802013f4:	02b00793          	li	a5,43
    802013f8:	0080006f          	j	80201400 <print_dec_int+0x230>
    802013fc:	02000793          	li	a5,32
    80201400:	fa843703          	ld	a4,-88(s0)
    80201404:	00078513          	mv	a0,a5
    80201408:	000700e7          	jalr	a4
        ++written;
    8020140c:	fe442783          	lw	a5,-28(s0)
    80201410:	0017879b          	addiw	a5,a5,1
    80201414:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80201418:	fe842783          	lw	a5,-24(s0)
    8020141c:	fcf42e23          	sw	a5,-36(s0)
    80201420:	0280006f          	j	80201448 <print_dec_int+0x278>
        putch('0');
    80201424:	fa843783          	ld	a5,-88(s0)
    80201428:	03000513          	li	a0,48
    8020142c:	000780e7          	jalr	a5
        ++written;
    80201430:	fe442783          	lw	a5,-28(s0)
    80201434:	0017879b          	addiw	a5,a5,1
    80201438:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    8020143c:	fdc42783          	lw	a5,-36(s0)
    80201440:	0017879b          	addiw	a5,a5,1
    80201444:	fcf42e23          	sw	a5,-36(s0)
    80201448:	f9043783          	ld	a5,-112(s0)
    8020144c:	00c7a703          	lw	a4,12(a5)
    80201450:	fd744783          	lbu	a5,-41(s0)
    80201454:	0007879b          	sext.w	a5,a5
    80201458:	40f707bb          	subw	a5,a4,a5
    8020145c:	0007871b          	sext.w	a4,a5
    80201460:	fdc42783          	lw	a5,-36(s0)
    80201464:	0007879b          	sext.w	a5,a5
    80201468:	fae7cee3          	blt	a5,a4,80201424 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    8020146c:	fe842783          	lw	a5,-24(s0)
    80201470:	fff7879b          	addiw	a5,a5,-1
    80201474:	fcf42c23          	sw	a5,-40(s0)
    80201478:	03c0006f          	j	802014b4 <print_dec_int+0x2e4>
        putch(buf[i]);
    8020147c:	fd842783          	lw	a5,-40(s0)
    80201480:	ff078793          	addi	a5,a5,-16
    80201484:	008787b3          	add	a5,a5,s0
    80201488:	fc87c783          	lbu	a5,-56(a5)
    8020148c:	0007871b          	sext.w	a4,a5
    80201490:	fa843783          	ld	a5,-88(s0)
    80201494:	00070513          	mv	a0,a4
    80201498:	000780e7          	jalr	a5
        ++written;
    8020149c:	fe442783          	lw	a5,-28(s0)
    802014a0:	0017879b          	addiw	a5,a5,1
    802014a4:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    802014a8:	fd842783          	lw	a5,-40(s0)
    802014ac:	fff7879b          	addiw	a5,a5,-1
    802014b0:	fcf42c23          	sw	a5,-40(s0)
    802014b4:	fd842783          	lw	a5,-40(s0)
    802014b8:	0007879b          	sext.w	a5,a5
    802014bc:	fc07d0e3          	bgez	a5,8020147c <print_dec_int+0x2ac>
    }

    return written;
    802014c0:	fe442783          	lw	a5,-28(s0)
}
    802014c4:	00078513          	mv	a0,a5
    802014c8:	06813083          	ld	ra,104(sp)
    802014cc:	06013403          	ld	s0,96(sp)
    802014d0:	07010113          	addi	sp,sp,112
    802014d4:	00008067          	ret

00000000802014d8 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    802014d8:	f4010113          	addi	sp,sp,-192
    802014dc:	0a113c23          	sd	ra,184(sp)
    802014e0:	0a813823          	sd	s0,176(sp)
    802014e4:	0c010413          	addi	s0,sp,192
    802014e8:	f4a43c23          	sd	a0,-168(s0)
    802014ec:	f4b43823          	sd	a1,-176(s0)
    802014f0:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    802014f4:	f8043023          	sd	zero,-128(s0)
    802014f8:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    802014fc:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    80201500:	7a40006f          	j	80201ca4 <vprintfmt+0x7cc>
        if (flags.in_format) {
    80201504:	f8044783          	lbu	a5,-128(s0)
    80201508:	72078e63          	beqz	a5,80201c44 <vprintfmt+0x76c>
            if (*fmt == '#') {
    8020150c:	f5043783          	ld	a5,-176(s0)
    80201510:	0007c783          	lbu	a5,0(a5)
    80201514:	00078713          	mv	a4,a5
    80201518:	02300793          	li	a5,35
    8020151c:	00f71863          	bne	a4,a5,8020152c <vprintfmt+0x54>
                flags.sharpflag = true;
    80201520:	00100793          	li	a5,1
    80201524:	f8f40123          	sb	a5,-126(s0)
    80201528:	7700006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    8020152c:	f5043783          	ld	a5,-176(s0)
    80201530:	0007c783          	lbu	a5,0(a5)
    80201534:	00078713          	mv	a4,a5
    80201538:	03000793          	li	a5,48
    8020153c:	00f71863          	bne	a4,a5,8020154c <vprintfmt+0x74>
                flags.zeroflag = true;
    80201540:	00100793          	li	a5,1
    80201544:	f8f401a3          	sb	a5,-125(s0)
    80201548:	7500006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    8020154c:	f5043783          	ld	a5,-176(s0)
    80201550:	0007c783          	lbu	a5,0(a5)
    80201554:	00078713          	mv	a4,a5
    80201558:	06c00793          	li	a5,108
    8020155c:	04f70063          	beq	a4,a5,8020159c <vprintfmt+0xc4>
    80201560:	f5043783          	ld	a5,-176(s0)
    80201564:	0007c783          	lbu	a5,0(a5)
    80201568:	00078713          	mv	a4,a5
    8020156c:	07a00793          	li	a5,122
    80201570:	02f70663          	beq	a4,a5,8020159c <vprintfmt+0xc4>
    80201574:	f5043783          	ld	a5,-176(s0)
    80201578:	0007c783          	lbu	a5,0(a5)
    8020157c:	00078713          	mv	a4,a5
    80201580:	07400793          	li	a5,116
    80201584:	00f70c63          	beq	a4,a5,8020159c <vprintfmt+0xc4>
    80201588:	f5043783          	ld	a5,-176(s0)
    8020158c:	0007c783          	lbu	a5,0(a5)
    80201590:	00078713          	mv	a4,a5
    80201594:	06a00793          	li	a5,106
    80201598:	00f71863          	bne	a4,a5,802015a8 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    8020159c:	00100793          	li	a5,1
    802015a0:	f8f400a3          	sb	a5,-127(s0)
    802015a4:	6f40006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    802015a8:	f5043783          	ld	a5,-176(s0)
    802015ac:	0007c783          	lbu	a5,0(a5)
    802015b0:	00078713          	mv	a4,a5
    802015b4:	02b00793          	li	a5,43
    802015b8:	00f71863          	bne	a4,a5,802015c8 <vprintfmt+0xf0>
                flags.sign = true;
    802015bc:	00100793          	li	a5,1
    802015c0:	f8f402a3          	sb	a5,-123(s0)
    802015c4:	6d40006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    802015c8:	f5043783          	ld	a5,-176(s0)
    802015cc:	0007c783          	lbu	a5,0(a5)
    802015d0:	00078713          	mv	a4,a5
    802015d4:	02000793          	li	a5,32
    802015d8:	00f71863          	bne	a4,a5,802015e8 <vprintfmt+0x110>
                flags.spaceflag = true;
    802015dc:	00100793          	li	a5,1
    802015e0:	f8f40223          	sb	a5,-124(s0)
    802015e4:	6b40006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    802015e8:	f5043783          	ld	a5,-176(s0)
    802015ec:	0007c783          	lbu	a5,0(a5)
    802015f0:	00078713          	mv	a4,a5
    802015f4:	02a00793          	li	a5,42
    802015f8:	00f71e63          	bne	a4,a5,80201614 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    802015fc:	f4843783          	ld	a5,-184(s0)
    80201600:	00878713          	addi	a4,a5,8
    80201604:	f4e43423          	sd	a4,-184(s0)
    80201608:	0007a783          	lw	a5,0(a5)
    8020160c:	f8f42423          	sw	a5,-120(s0)
    80201610:	6880006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    80201614:	f5043783          	ld	a5,-176(s0)
    80201618:	0007c783          	lbu	a5,0(a5)
    8020161c:	00078713          	mv	a4,a5
    80201620:	03000793          	li	a5,48
    80201624:	04e7f663          	bgeu	a5,a4,80201670 <vprintfmt+0x198>
    80201628:	f5043783          	ld	a5,-176(s0)
    8020162c:	0007c783          	lbu	a5,0(a5)
    80201630:	00078713          	mv	a4,a5
    80201634:	03900793          	li	a5,57
    80201638:	02e7ec63          	bltu	a5,a4,80201670 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    8020163c:	f5043783          	ld	a5,-176(s0)
    80201640:	f5040713          	addi	a4,s0,-176
    80201644:	00a00613          	li	a2,10
    80201648:	00070593          	mv	a1,a4
    8020164c:	00078513          	mv	a0,a5
    80201650:	88dff0ef          	jal	80200edc <strtol>
    80201654:	00050793          	mv	a5,a0
    80201658:	0007879b          	sext.w	a5,a5
    8020165c:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    80201660:	f5043783          	ld	a5,-176(s0)
    80201664:	fff78793          	addi	a5,a5,-1
    80201668:	f4f43823          	sd	a5,-176(s0)
    8020166c:	62c0006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    80201670:	f5043783          	ld	a5,-176(s0)
    80201674:	0007c783          	lbu	a5,0(a5)
    80201678:	00078713          	mv	a4,a5
    8020167c:	02e00793          	li	a5,46
    80201680:	06f71863          	bne	a4,a5,802016f0 <vprintfmt+0x218>
                fmt++;
    80201684:	f5043783          	ld	a5,-176(s0)
    80201688:	00178793          	addi	a5,a5,1
    8020168c:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    80201690:	f5043783          	ld	a5,-176(s0)
    80201694:	0007c783          	lbu	a5,0(a5)
    80201698:	00078713          	mv	a4,a5
    8020169c:	02a00793          	li	a5,42
    802016a0:	00f71e63          	bne	a4,a5,802016bc <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    802016a4:	f4843783          	ld	a5,-184(s0)
    802016a8:	00878713          	addi	a4,a5,8
    802016ac:	f4e43423          	sd	a4,-184(s0)
    802016b0:	0007a783          	lw	a5,0(a5)
    802016b4:	f8f42623          	sw	a5,-116(s0)
    802016b8:	5e00006f          	j	80201c98 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    802016bc:	f5043783          	ld	a5,-176(s0)
    802016c0:	f5040713          	addi	a4,s0,-176
    802016c4:	00a00613          	li	a2,10
    802016c8:	00070593          	mv	a1,a4
    802016cc:	00078513          	mv	a0,a5
    802016d0:	80dff0ef          	jal	80200edc <strtol>
    802016d4:	00050793          	mv	a5,a0
    802016d8:	0007879b          	sext.w	a5,a5
    802016dc:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    802016e0:	f5043783          	ld	a5,-176(s0)
    802016e4:	fff78793          	addi	a5,a5,-1
    802016e8:	f4f43823          	sd	a5,-176(s0)
    802016ec:	5ac0006f          	j	80201c98 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    802016f0:	f5043783          	ld	a5,-176(s0)
    802016f4:	0007c783          	lbu	a5,0(a5)
    802016f8:	00078713          	mv	a4,a5
    802016fc:	07800793          	li	a5,120
    80201700:	02f70663          	beq	a4,a5,8020172c <vprintfmt+0x254>
    80201704:	f5043783          	ld	a5,-176(s0)
    80201708:	0007c783          	lbu	a5,0(a5)
    8020170c:	00078713          	mv	a4,a5
    80201710:	05800793          	li	a5,88
    80201714:	00f70c63          	beq	a4,a5,8020172c <vprintfmt+0x254>
    80201718:	f5043783          	ld	a5,-176(s0)
    8020171c:	0007c783          	lbu	a5,0(a5)
    80201720:	00078713          	mv	a4,a5
    80201724:	07000793          	li	a5,112
    80201728:	30f71263          	bne	a4,a5,80201a2c <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    8020172c:	f5043783          	ld	a5,-176(s0)
    80201730:	0007c783          	lbu	a5,0(a5)
    80201734:	00078713          	mv	a4,a5
    80201738:	07000793          	li	a5,112
    8020173c:	00f70663          	beq	a4,a5,80201748 <vprintfmt+0x270>
    80201740:	f8144783          	lbu	a5,-127(s0)
    80201744:	00078663          	beqz	a5,80201750 <vprintfmt+0x278>
    80201748:	00100793          	li	a5,1
    8020174c:	0080006f          	j	80201754 <vprintfmt+0x27c>
    80201750:	00000793          	li	a5,0
    80201754:	faf403a3          	sb	a5,-89(s0)
    80201758:	fa744783          	lbu	a5,-89(s0)
    8020175c:	0017f793          	andi	a5,a5,1
    80201760:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    80201764:	fa744783          	lbu	a5,-89(s0)
    80201768:	0ff7f793          	zext.b	a5,a5
    8020176c:	00078c63          	beqz	a5,80201784 <vprintfmt+0x2ac>
    80201770:	f4843783          	ld	a5,-184(s0)
    80201774:	00878713          	addi	a4,a5,8
    80201778:	f4e43423          	sd	a4,-184(s0)
    8020177c:	0007b783          	ld	a5,0(a5)
    80201780:	01c0006f          	j	8020179c <vprintfmt+0x2c4>
    80201784:	f4843783          	ld	a5,-184(s0)
    80201788:	00878713          	addi	a4,a5,8
    8020178c:	f4e43423          	sd	a4,-184(s0)
    80201790:	0007a783          	lw	a5,0(a5)
    80201794:	02079793          	slli	a5,a5,0x20
    80201798:	0207d793          	srli	a5,a5,0x20
    8020179c:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    802017a0:	f8c42783          	lw	a5,-116(s0)
    802017a4:	02079463          	bnez	a5,802017cc <vprintfmt+0x2f4>
    802017a8:	fe043783          	ld	a5,-32(s0)
    802017ac:	02079063          	bnez	a5,802017cc <vprintfmt+0x2f4>
    802017b0:	f5043783          	ld	a5,-176(s0)
    802017b4:	0007c783          	lbu	a5,0(a5)
    802017b8:	00078713          	mv	a4,a5
    802017bc:	07000793          	li	a5,112
    802017c0:	00f70663          	beq	a4,a5,802017cc <vprintfmt+0x2f4>
                    flags.in_format = false;
    802017c4:	f8040023          	sb	zero,-128(s0)
    802017c8:	4d00006f          	j	80201c98 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    802017cc:	f5043783          	ld	a5,-176(s0)
    802017d0:	0007c783          	lbu	a5,0(a5)
    802017d4:	00078713          	mv	a4,a5
    802017d8:	07000793          	li	a5,112
    802017dc:	00f70a63          	beq	a4,a5,802017f0 <vprintfmt+0x318>
    802017e0:	f8244783          	lbu	a5,-126(s0)
    802017e4:	00078a63          	beqz	a5,802017f8 <vprintfmt+0x320>
    802017e8:	fe043783          	ld	a5,-32(s0)
    802017ec:	00078663          	beqz	a5,802017f8 <vprintfmt+0x320>
    802017f0:	00100793          	li	a5,1
    802017f4:	0080006f          	j	802017fc <vprintfmt+0x324>
    802017f8:	00000793          	li	a5,0
    802017fc:	faf40323          	sb	a5,-90(s0)
    80201800:	fa644783          	lbu	a5,-90(s0)
    80201804:	0017f793          	andi	a5,a5,1
    80201808:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    8020180c:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    80201810:	f5043783          	ld	a5,-176(s0)
    80201814:	0007c783          	lbu	a5,0(a5)
    80201818:	00078713          	mv	a4,a5
    8020181c:	05800793          	li	a5,88
    80201820:	00f71863          	bne	a4,a5,80201830 <vprintfmt+0x358>
    80201824:	00001797          	auipc	a5,0x1
    80201828:	98c78793          	addi	a5,a5,-1652 # 802021b0 <upperxdigits.1>
    8020182c:	00c0006f          	j	80201838 <vprintfmt+0x360>
    80201830:	00001797          	auipc	a5,0x1
    80201834:	99878793          	addi	a5,a5,-1640 # 802021c8 <lowerxdigits.0>
    80201838:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    8020183c:	fe043783          	ld	a5,-32(s0)
    80201840:	00f7f793          	andi	a5,a5,15
    80201844:	f9843703          	ld	a4,-104(s0)
    80201848:	00f70733          	add	a4,a4,a5
    8020184c:	fdc42783          	lw	a5,-36(s0)
    80201850:	0017869b          	addiw	a3,a5,1
    80201854:	fcd42e23          	sw	a3,-36(s0)
    80201858:	00074703          	lbu	a4,0(a4)
    8020185c:	ff078793          	addi	a5,a5,-16
    80201860:	008787b3          	add	a5,a5,s0
    80201864:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    80201868:	fe043783          	ld	a5,-32(s0)
    8020186c:	0047d793          	srli	a5,a5,0x4
    80201870:	fef43023          	sd	a5,-32(s0)
                } while (num);
    80201874:	fe043783          	ld	a5,-32(s0)
    80201878:	fc0792e3          	bnez	a5,8020183c <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    8020187c:	f8c42783          	lw	a5,-116(s0)
    80201880:	00078713          	mv	a4,a5
    80201884:	fff00793          	li	a5,-1
    80201888:	02f71663          	bne	a4,a5,802018b4 <vprintfmt+0x3dc>
    8020188c:	f8344783          	lbu	a5,-125(s0)
    80201890:	02078263          	beqz	a5,802018b4 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    80201894:	f8842703          	lw	a4,-120(s0)
    80201898:	fa644783          	lbu	a5,-90(s0)
    8020189c:	0007879b          	sext.w	a5,a5
    802018a0:	0017979b          	slliw	a5,a5,0x1
    802018a4:	0007879b          	sext.w	a5,a5
    802018a8:	40f707bb          	subw	a5,a4,a5
    802018ac:	0007879b          	sext.w	a5,a5
    802018b0:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    802018b4:	f8842703          	lw	a4,-120(s0)
    802018b8:	fa644783          	lbu	a5,-90(s0)
    802018bc:	0007879b          	sext.w	a5,a5
    802018c0:	0017979b          	slliw	a5,a5,0x1
    802018c4:	0007879b          	sext.w	a5,a5
    802018c8:	40f707bb          	subw	a5,a4,a5
    802018cc:	0007871b          	sext.w	a4,a5
    802018d0:	fdc42783          	lw	a5,-36(s0)
    802018d4:	f8f42a23          	sw	a5,-108(s0)
    802018d8:	f8c42783          	lw	a5,-116(s0)
    802018dc:	f8f42823          	sw	a5,-112(s0)
    802018e0:	f9442783          	lw	a5,-108(s0)
    802018e4:	00078593          	mv	a1,a5
    802018e8:	f9042783          	lw	a5,-112(s0)
    802018ec:	00078613          	mv	a2,a5
    802018f0:	0006069b          	sext.w	a3,a2
    802018f4:	0005879b          	sext.w	a5,a1
    802018f8:	00f6d463          	bge	a3,a5,80201900 <vprintfmt+0x428>
    802018fc:	00058613          	mv	a2,a1
    80201900:	0006079b          	sext.w	a5,a2
    80201904:	40f707bb          	subw	a5,a4,a5
    80201908:	fcf42c23          	sw	a5,-40(s0)
    8020190c:	0280006f          	j	80201934 <vprintfmt+0x45c>
                    putch(' ');
    80201910:	f5843783          	ld	a5,-168(s0)
    80201914:	02000513          	li	a0,32
    80201918:	000780e7          	jalr	a5
                    ++written;
    8020191c:	fec42783          	lw	a5,-20(s0)
    80201920:	0017879b          	addiw	a5,a5,1
    80201924:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201928:	fd842783          	lw	a5,-40(s0)
    8020192c:	fff7879b          	addiw	a5,a5,-1
    80201930:	fcf42c23          	sw	a5,-40(s0)
    80201934:	fd842783          	lw	a5,-40(s0)
    80201938:	0007879b          	sext.w	a5,a5
    8020193c:	fcf04ae3          	bgtz	a5,80201910 <vprintfmt+0x438>
                }

                if (prefix) {
    80201940:	fa644783          	lbu	a5,-90(s0)
    80201944:	0ff7f793          	zext.b	a5,a5
    80201948:	04078463          	beqz	a5,80201990 <vprintfmt+0x4b8>
                    putch('0');
    8020194c:	f5843783          	ld	a5,-168(s0)
    80201950:	03000513          	li	a0,48
    80201954:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    80201958:	f5043783          	ld	a5,-176(s0)
    8020195c:	0007c783          	lbu	a5,0(a5)
    80201960:	00078713          	mv	a4,a5
    80201964:	05800793          	li	a5,88
    80201968:	00f71663          	bne	a4,a5,80201974 <vprintfmt+0x49c>
    8020196c:	05800793          	li	a5,88
    80201970:	0080006f          	j	80201978 <vprintfmt+0x4a0>
    80201974:	07800793          	li	a5,120
    80201978:	f5843703          	ld	a4,-168(s0)
    8020197c:	00078513          	mv	a0,a5
    80201980:	000700e7          	jalr	a4
                    written += 2;
    80201984:	fec42783          	lw	a5,-20(s0)
    80201988:	0027879b          	addiw	a5,a5,2
    8020198c:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    80201990:	fdc42783          	lw	a5,-36(s0)
    80201994:	fcf42a23          	sw	a5,-44(s0)
    80201998:	0280006f          	j	802019c0 <vprintfmt+0x4e8>
                    putch('0');
    8020199c:	f5843783          	ld	a5,-168(s0)
    802019a0:	03000513          	li	a0,48
    802019a4:	000780e7          	jalr	a5
                    ++written;
    802019a8:	fec42783          	lw	a5,-20(s0)
    802019ac:	0017879b          	addiw	a5,a5,1
    802019b0:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    802019b4:	fd442783          	lw	a5,-44(s0)
    802019b8:	0017879b          	addiw	a5,a5,1
    802019bc:	fcf42a23          	sw	a5,-44(s0)
    802019c0:	f8c42703          	lw	a4,-116(s0)
    802019c4:	fd442783          	lw	a5,-44(s0)
    802019c8:	0007879b          	sext.w	a5,a5
    802019cc:	fce7c8e3          	blt	a5,a4,8020199c <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    802019d0:	fdc42783          	lw	a5,-36(s0)
    802019d4:	fff7879b          	addiw	a5,a5,-1
    802019d8:	fcf42823          	sw	a5,-48(s0)
    802019dc:	03c0006f          	j	80201a18 <vprintfmt+0x540>
                    putch(buf[i]);
    802019e0:	fd042783          	lw	a5,-48(s0)
    802019e4:	ff078793          	addi	a5,a5,-16
    802019e8:	008787b3          	add	a5,a5,s0
    802019ec:	f807c783          	lbu	a5,-128(a5)
    802019f0:	0007871b          	sext.w	a4,a5
    802019f4:	f5843783          	ld	a5,-168(s0)
    802019f8:	00070513          	mv	a0,a4
    802019fc:	000780e7          	jalr	a5
                    ++written;
    80201a00:	fec42783          	lw	a5,-20(s0)
    80201a04:	0017879b          	addiw	a5,a5,1
    80201a08:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    80201a0c:	fd042783          	lw	a5,-48(s0)
    80201a10:	fff7879b          	addiw	a5,a5,-1
    80201a14:	fcf42823          	sw	a5,-48(s0)
    80201a18:	fd042783          	lw	a5,-48(s0)
    80201a1c:	0007879b          	sext.w	a5,a5
    80201a20:	fc07d0e3          	bgez	a5,802019e0 <vprintfmt+0x508>
                }

                flags.in_format = false;
    80201a24:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201a28:	2700006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201a2c:	f5043783          	ld	a5,-176(s0)
    80201a30:	0007c783          	lbu	a5,0(a5)
    80201a34:	00078713          	mv	a4,a5
    80201a38:	06400793          	li	a5,100
    80201a3c:	02f70663          	beq	a4,a5,80201a68 <vprintfmt+0x590>
    80201a40:	f5043783          	ld	a5,-176(s0)
    80201a44:	0007c783          	lbu	a5,0(a5)
    80201a48:	00078713          	mv	a4,a5
    80201a4c:	06900793          	li	a5,105
    80201a50:	00f70c63          	beq	a4,a5,80201a68 <vprintfmt+0x590>
    80201a54:	f5043783          	ld	a5,-176(s0)
    80201a58:	0007c783          	lbu	a5,0(a5)
    80201a5c:	00078713          	mv	a4,a5
    80201a60:	07500793          	li	a5,117
    80201a64:	08f71063          	bne	a4,a5,80201ae4 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    80201a68:	f8144783          	lbu	a5,-127(s0)
    80201a6c:	00078c63          	beqz	a5,80201a84 <vprintfmt+0x5ac>
    80201a70:	f4843783          	ld	a5,-184(s0)
    80201a74:	00878713          	addi	a4,a5,8
    80201a78:	f4e43423          	sd	a4,-184(s0)
    80201a7c:	0007b783          	ld	a5,0(a5)
    80201a80:	0140006f          	j	80201a94 <vprintfmt+0x5bc>
    80201a84:	f4843783          	ld	a5,-184(s0)
    80201a88:	00878713          	addi	a4,a5,8
    80201a8c:	f4e43423          	sd	a4,-184(s0)
    80201a90:	0007a783          	lw	a5,0(a5)
    80201a94:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    80201a98:	fa843583          	ld	a1,-88(s0)
    80201a9c:	f5043783          	ld	a5,-176(s0)
    80201aa0:	0007c783          	lbu	a5,0(a5)
    80201aa4:	0007871b          	sext.w	a4,a5
    80201aa8:	07500793          	li	a5,117
    80201aac:	40f707b3          	sub	a5,a4,a5
    80201ab0:	00f037b3          	snez	a5,a5
    80201ab4:	0ff7f793          	zext.b	a5,a5
    80201ab8:	f8040713          	addi	a4,s0,-128
    80201abc:	00070693          	mv	a3,a4
    80201ac0:	00078613          	mv	a2,a5
    80201ac4:	f5843503          	ld	a0,-168(s0)
    80201ac8:	f08ff0ef          	jal	802011d0 <print_dec_int>
    80201acc:	00050793          	mv	a5,a0
    80201ad0:	fec42703          	lw	a4,-20(s0)
    80201ad4:	00f707bb          	addw	a5,a4,a5
    80201ad8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201adc:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201ae0:	1b80006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    80201ae4:	f5043783          	ld	a5,-176(s0)
    80201ae8:	0007c783          	lbu	a5,0(a5)
    80201aec:	00078713          	mv	a4,a5
    80201af0:	06e00793          	li	a5,110
    80201af4:	04f71c63          	bne	a4,a5,80201b4c <vprintfmt+0x674>
                if (flags.longflag) {
    80201af8:	f8144783          	lbu	a5,-127(s0)
    80201afc:	02078463          	beqz	a5,80201b24 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    80201b00:	f4843783          	ld	a5,-184(s0)
    80201b04:	00878713          	addi	a4,a5,8
    80201b08:	f4e43423          	sd	a4,-184(s0)
    80201b0c:	0007b783          	ld	a5,0(a5)
    80201b10:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    80201b14:	fec42703          	lw	a4,-20(s0)
    80201b18:	fb043783          	ld	a5,-80(s0)
    80201b1c:	00e7b023          	sd	a4,0(a5)
    80201b20:	0240006f          	j	80201b44 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    80201b24:	f4843783          	ld	a5,-184(s0)
    80201b28:	00878713          	addi	a4,a5,8
    80201b2c:	f4e43423          	sd	a4,-184(s0)
    80201b30:	0007b783          	ld	a5,0(a5)
    80201b34:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    80201b38:	fb843783          	ld	a5,-72(s0)
    80201b3c:	fec42703          	lw	a4,-20(s0)
    80201b40:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    80201b44:	f8040023          	sb	zero,-128(s0)
    80201b48:	1500006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    80201b4c:	f5043783          	ld	a5,-176(s0)
    80201b50:	0007c783          	lbu	a5,0(a5)
    80201b54:	00078713          	mv	a4,a5
    80201b58:	07300793          	li	a5,115
    80201b5c:	02f71e63          	bne	a4,a5,80201b98 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    80201b60:	f4843783          	ld	a5,-184(s0)
    80201b64:	00878713          	addi	a4,a5,8
    80201b68:	f4e43423          	sd	a4,-184(s0)
    80201b6c:	0007b783          	ld	a5,0(a5)
    80201b70:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    80201b74:	fc043583          	ld	a1,-64(s0)
    80201b78:	f5843503          	ld	a0,-168(s0)
    80201b7c:	dccff0ef          	jal	80201148 <puts_wo_nl>
    80201b80:	00050793          	mv	a5,a0
    80201b84:	fec42703          	lw	a4,-20(s0)
    80201b88:	00f707bb          	addw	a5,a4,a5
    80201b8c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201b90:	f8040023          	sb	zero,-128(s0)
    80201b94:	1040006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    80201b98:	f5043783          	ld	a5,-176(s0)
    80201b9c:	0007c783          	lbu	a5,0(a5)
    80201ba0:	00078713          	mv	a4,a5
    80201ba4:	06300793          	li	a5,99
    80201ba8:	02f71e63          	bne	a4,a5,80201be4 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    80201bac:	f4843783          	ld	a5,-184(s0)
    80201bb0:	00878713          	addi	a4,a5,8
    80201bb4:	f4e43423          	sd	a4,-184(s0)
    80201bb8:	0007a783          	lw	a5,0(a5)
    80201bbc:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    80201bc0:	fcc42703          	lw	a4,-52(s0)
    80201bc4:	f5843783          	ld	a5,-168(s0)
    80201bc8:	00070513          	mv	a0,a4
    80201bcc:	000780e7          	jalr	a5
                ++written;
    80201bd0:	fec42783          	lw	a5,-20(s0)
    80201bd4:	0017879b          	addiw	a5,a5,1
    80201bd8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201bdc:	f8040023          	sb	zero,-128(s0)
    80201be0:	0b80006f          	j	80201c98 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    80201be4:	f5043783          	ld	a5,-176(s0)
    80201be8:	0007c783          	lbu	a5,0(a5)
    80201bec:	00078713          	mv	a4,a5
    80201bf0:	02500793          	li	a5,37
    80201bf4:	02f71263          	bne	a4,a5,80201c18 <vprintfmt+0x740>
                putch('%');
    80201bf8:	f5843783          	ld	a5,-168(s0)
    80201bfc:	02500513          	li	a0,37
    80201c00:	000780e7          	jalr	a5
                ++written;
    80201c04:	fec42783          	lw	a5,-20(s0)
    80201c08:	0017879b          	addiw	a5,a5,1
    80201c0c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201c10:	f8040023          	sb	zero,-128(s0)
    80201c14:	0840006f          	j	80201c98 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    80201c18:	f5043783          	ld	a5,-176(s0)
    80201c1c:	0007c783          	lbu	a5,0(a5)
    80201c20:	0007871b          	sext.w	a4,a5
    80201c24:	f5843783          	ld	a5,-168(s0)
    80201c28:	00070513          	mv	a0,a4
    80201c2c:	000780e7          	jalr	a5
                ++written;
    80201c30:	fec42783          	lw	a5,-20(s0)
    80201c34:	0017879b          	addiw	a5,a5,1
    80201c38:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201c3c:	f8040023          	sb	zero,-128(s0)
    80201c40:	0580006f          	j	80201c98 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    80201c44:	f5043783          	ld	a5,-176(s0)
    80201c48:	0007c783          	lbu	a5,0(a5)
    80201c4c:	00078713          	mv	a4,a5
    80201c50:	02500793          	li	a5,37
    80201c54:	02f71063          	bne	a4,a5,80201c74 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    80201c58:	f8043023          	sd	zero,-128(s0)
    80201c5c:	f8043423          	sd	zero,-120(s0)
    80201c60:	00100793          	li	a5,1
    80201c64:	f8f40023          	sb	a5,-128(s0)
    80201c68:	fff00793          	li	a5,-1
    80201c6c:	f8f42623          	sw	a5,-116(s0)
    80201c70:	0280006f          	j	80201c98 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    80201c74:	f5043783          	ld	a5,-176(s0)
    80201c78:	0007c783          	lbu	a5,0(a5)
    80201c7c:	0007871b          	sext.w	a4,a5
    80201c80:	f5843783          	ld	a5,-168(s0)
    80201c84:	00070513          	mv	a0,a4
    80201c88:	000780e7          	jalr	a5
            ++written;
    80201c8c:	fec42783          	lw	a5,-20(s0)
    80201c90:	0017879b          	addiw	a5,a5,1
    80201c94:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    80201c98:	f5043783          	ld	a5,-176(s0)
    80201c9c:	00178793          	addi	a5,a5,1
    80201ca0:	f4f43823          	sd	a5,-176(s0)
    80201ca4:	f5043783          	ld	a5,-176(s0)
    80201ca8:	0007c783          	lbu	a5,0(a5)
    80201cac:	84079ce3          	bnez	a5,80201504 <vprintfmt+0x2c>
        }
    }

    return written;
    80201cb0:	fec42783          	lw	a5,-20(s0)
}
    80201cb4:	00078513          	mv	a0,a5
    80201cb8:	0b813083          	ld	ra,184(sp)
    80201cbc:	0b013403          	ld	s0,176(sp)
    80201cc0:	0c010113          	addi	sp,sp,192
    80201cc4:	00008067          	ret

0000000080201cc8 <printk>:

int printk(const char* s, ...) {
    80201cc8:	f9010113          	addi	sp,sp,-112
    80201ccc:	02113423          	sd	ra,40(sp)
    80201cd0:	02813023          	sd	s0,32(sp)
    80201cd4:	03010413          	addi	s0,sp,48
    80201cd8:	fca43c23          	sd	a0,-40(s0)
    80201cdc:	00b43423          	sd	a1,8(s0)
    80201ce0:	00c43823          	sd	a2,16(s0)
    80201ce4:	00d43c23          	sd	a3,24(s0)
    80201ce8:	02e43023          	sd	a4,32(s0)
    80201cec:	02f43423          	sd	a5,40(s0)
    80201cf0:	03043823          	sd	a6,48(s0)
    80201cf4:	03143c23          	sd	a7,56(s0)
    int res = 0;
    80201cf8:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    80201cfc:	04040793          	addi	a5,s0,64
    80201d00:	fcf43823          	sd	a5,-48(s0)
    80201d04:	fd043783          	ld	a5,-48(s0)
    80201d08:	fc878793          	addi	a5,a5,-56
    80201d0c:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    80201d10:	fe043783          	ld	a5,-32(s0)
    80201d14:	00078613          	mv	a2,a5
    80201d18:	fd843583          	ld	a1,-40(s0)
    80201d1c:	fffff517          	auipc	a0,0xfffff
    80201d20:	11850513          	addi	a0,a0,280 # 80200e34 <putc>
    80201d24:	fb4ff0ef          	jal	802014d8 <vprintfmt>
    80201d28:	00050793          	mv	a5,a0
    80201d2c:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    80201d30:	fec42783          	lw	a5,-20(s0)
}
    80201d34:	00078513          	mv	a0,a5
    80201d38:	02813083          	ld	ra,40(sp)
    80201d3c:	02013403          	ld	s0,32(sp)
    80201d40:	07010113          	addi	sp,sp,112
    80201d44:	00008067          	ret

0000000080201d48 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
    80201d48:	fe010113          	addi	sp,sp,-32
    80201d4c:	00813c23          	sd	s0,24(sp)
    80201d50:	02010413          	addi	s0,sp,32
    80201d54:	00050793          	mv	a5,a0
    80201d58:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
    80201d5c:	fec42783          	lw	a5,-20(s0)
    80201d60:	fff7879b          	addiw	a5,a5,-1
    80201d64:	0007879b          	sext.w	a5,a5
    80201d68:	02079713          	slli	a4,a5,0x20
    80201d6c:	02075713          	srli	a4,a4,0x20
    80201d70:	00003797          	auipc	a5,0x3
    80201d74:	3a878793          	addi	a5,a5,936 # 80205118 <seed>
    80201d78:	00e7b023          	sd	a4,0(a5)
}
    80201d7c:	00000013          	nop
    80201d80:	01813403          	ld	s0,24(sp)
    80201d84:	02010113          	addi	sp,sp,32
    80201d88:	00008067          	ret

0000000080201d8c <rand>:

int rand(void) {
    80201d8c:	ff010113          	addi	sp,sp,-16
    80201d90:	00813423          	sd	s0,8(sp)
    80201d94:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
    80201d98:	00003797          	auipc	a5,0x3
    80201d9c:	38078793          	addi	a5,a5,896 # 80205118 <seed>
    80201da0:	0007b703          	ld	a4,0(a5)
    80201da4:	00000797          	auipc	a5,0x0
    80201da8:	43c78793          	addi	a5,a5,1084 # 802021e0 <lowerxdigits.0+0x18>
    80201dac:	0007b783          	ld	a5,0(a5)
    80201db0:	02f707b3          	mul	a5,a4,a5
    80201db4:	00178713          	addi	a4,a5,1
    80201db8:	00003797          	auipc	a5,0x3
    80201dbc:	36078793          	addi	a5,a5,864 # 80205118 <seed>
    80201dc0:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
    80201dc4:	00003797          	auipc	a5,0x3
    80201dc8:	35478793          	addi	a5,a5,852 # 80205118 <seed>
    80201dcc:	0007b783          	ld	a5,0(a5)
    80201dd0:	0217d793          	srli	a5,a5,0x21
    80201dd4:	0007879b          	sext.w	a5,a5
}
    80201dd8:	00078513          	mv	a0,a5
    80201ddc:	00813403          	ld	s0,8(sp)
    80201de0:	01010113          	addi	sp,sp,16
    80201de4:	00008067          	ret

0000000080201de8 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
    80201de8:	fc010113          	addi	sp,sp,-64
    80201dec:	02813c23          	sd	s0,56(sp)
    80201df0:	04010413          	addi	s0,sp,64
    80201df4:	fca43c23          	sd	a0,-40(s0)
    80201df8:	00058793          	mv	a5,a1
    80201dfc:	fcc43423          	sd	a2,-56(s0)
    80201e00:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
    80201e04:	fd843783          	ld	a5,-40(s0)
    80201e08:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
    80201e0c:	fe043423          	sd	zero,-24(s0)
    80201e10:	0280006f          	j	80201e38 <memset+0x50>
        s[i] = c;
    80201e14:	fe043703          	ld	a4,-32(s0)
    80201e18:	fe843783          	ld	a5,-24(s0)
    80201e1c:	00f707b3          	add	a5,a4,a5
    80201e20:	fd442703          	lw	a4,-44(s0)
    80201e24:	0ff77713          	zext.b	a4,a4
    80201e28:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
    80201e2c:	fe843783          	ld	a5,-24(s0)
    80201e30:	00178793          	addi	a5,a5,1
    80201e34:	fef43423          	sd	a5,-24(s0)
    80201e38:	fe843703          	ld	a4,-24(s0)
    80201e3c:	fc843783          	ld	a5,-56(s0)
    80201e40:	fcf76ae3          	bltu	a4,a5,80201e14 <memset+0x2c>
    }
    return dest;
    80201e44:	fd843783          	ld	a5,-40(s0)
}
    80201e48:	00078513          	mv	a0,a5
    80201e4c:	03813403          	ld	s0,56(sp)
    80201e50:	04010113          	addi	sp,sp,64
    80201e54:	00008067          	ret
