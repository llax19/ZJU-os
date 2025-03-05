
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

ffffffe000200000 <_skernel>:
    .extern _stext
    .extern _srodata
    .extern clock_set_next_event
_start:
    
    la sp, boot_stack_top 
ffffffe000200000:	00008117          	auipc	sp,0x8
ffffffe000200004:	00010113          	mv	sp,sp

    
    call setup_vm
ffffffe000200008:	0c5010ef          	jal	ffffffe0002018cc <setup_vm>
    call relocate
ffffffe00020000c:	02c000ef          	jal	ffffffe000200038 <relocate>
    call mm_init
ffffffe000200010:	285000ef          	jal	ffffffe000200a94 <mm_init>

    call setup_vm_final
ffffffe000200014:	17d010ef          	jal	ffffffe000201990 <setup_vm_final>

    call task_init  
ffffffe000200018:	48d000ef          	jal	ffffffe000200ca4 <task_init>

    la a0, _traps
ffffffe00020001c:	00000517          	auipc	a0,0x0
ffffffe000200020:	14850513          	addi	a0,a0,328 # ffffffe000200164 <_traps>
    csrrw x0, stvec, a0
ffffffe000200024:	10551073          	csrw	stvec,a0
    call clock_set_next_event
ffffffe000200028:	2bc000ef          	jal	ffffffe0002002e4 <clock_set_next_event>
    
    addi a0, x0, 32
ffffffe00020002c:	02000513          	li	a0,32
    csrrs x0, sie, a0
ffffffe000200030:	10452073          	csrs	sie,a0
    
    call start_kernel
ffffffe000200034:	595010ef          	jal	ffffffe000201dc8 <start_kernel>

ffffffe000200038 <relocate>:

relocate:
    li a1, 0xffffffdf80000000
ffffffe000200038:	fbf0059b          	addiw	a1,zero,-65
ffffffe00020003c:	01f59593          	slli	a1,a1,0x1f
    add ra, ra, a1
ffffffe000200040:	00b080b3          	add	ra,ra,a1
    add sp, sp, a1
ffffffe000200044:	00b10133          	add	sp,sp,a1

    # need a fence to ensure the new translations are in use
    sfence.vma zero, zero
ffffffe000200048:	12000073          	sfence.vma

    la a0, early_pgtbl
ffffffe00020004c:	0000e517          	auipc	a0,0xe
ffffffe000200050:	fb450513          	addi	a0,a0,-76 # ffffffe00020e000 <early_pgtbl>
    slli a0, a0, 8
ffffffe000200054:	00851513          	slli	a0,a0,0x8
    srli a0, a0, 20
ffffffe000200058:	01455513          	srli	a0,a0,0x14
    addi a1, x0, 8
ffffffe00020005c:	00800593          	li	a1,8
    slli a1, a1, 60
ffffffe000200060:	03c59593          	slli	a1,a1,0x3c
    add a0, a0, a1
ffffffe000200064:	00b50533          	add	a0,a0,a1
    csrw satp, a0
ffffffe000200068:	18051073          	csrw	satp,a0
    ret
ffffffe00020006c:	00008067          	ret

ffffffe000200070 <__switch_to>:
    .equ regbytes, 8
    .globl __switch_to

__switch_to:
    # save state to prev process
    addi a0, a0, 32 #a0 = prev->thread
ffffffe000200070:	02050513          	addi	a0,a0,32
    sd ra, 0*regbytes(a0)
ffffffe000200074:	00153023          	sd	ra,0(a0)
    sd sp, 1*regbytes(a0)
ffffffe000200078:	00253423          	sd	sp,8(a0)
    sd s0, 2*regbytes(a0)
ffffffe00020007c:	00853823          	sd	s0,16(a0)
    sd s1, 3*regbytes(a0)
ffffffe000200080:	00953c23          	sd	s1,24(a0)
    sd s2, 4*regbytes(a0)
ffffffe000200084:	03253023          	sd	s2,32(a0)
    sd s3, 5*regbytes(a0)
ffffffe000200088:	03353423          	sd	s3,40(a0)
    sd s4, 6*regbytes(a0)
ffffffe00020008c:	03453823          	sd	s4,48(a0)
    sd s5, 7*regbytes(a0)
ffffffe000200090:	03553c23          	sd	s5,56(a0)
    sd s6, 8*regbytes(a0)
ffffffe000200094:	05653023          	sd	s6,64(a0)
    sd s7, 9*regbytes(a0)
ffffffe000200098:	05753423          	sd	s7,72(a0)
    sd s8, 10*regbytes(a0)
ffffffe00020009c:	05853823          	sd	s8,80(a0)
    sd s9, 11*regbytes(a0)
ffffffe0002000a0:	05953c23          	sd	s9,88(a0)
    sd s10, 12*regbytes(a0)
ffffffe0002000a4:	07a53023          	sd	s10,96(a0)
    sd s11, 13*regbytes(a0)
ffffffe0002000a8:	07b53423          	sd	s11,104(a0)
    csrr t0, sepc
ffffffe0002000ac:	141022f3          	csrr	t0,sepc
    sd t0, 14*regbytes(a0)
ffffffe0002000b0:	06553823          	sd	t0,112(a0)
    csrr t0, sstatus
ffffffe0002000b4:	100022f3          	csrr	t0,sstatus
    sd t0, 15*regbytes(a0)
ffffffe0002000b8:	06553c23          	sd	t0,120(a0)
    csrr t0, sscratch
ffffffe0002000bc:	140022f3          	csrr	t0,sscratch
    sd t0, 16*regbytes(a0)
ffffffe0002000c0:	08553023          	sd	t0,128(a0)
    csrr t0, satp
ffffffe0002000c4:	180022f3          	csrr	t0,satp
    li t1, 0xffffffdf80000000
ffffffe0002000c8:	fbf0031b          	addiw	t1,zero,-65
ffffffe0002000cc:	01f31313          	slli	t1,t1,0x1f
    slli t0, t0, 12
ffffffe0002000d0:	00c29293          	slli	t0,t0,0xc
    add t0, t0, t1
ffffffe0002000d4:	006282b3          	add	t0,t0,t1
    sd t0, 17*regbytes(a0)
ffffffe0002000d8:	08553423          	sd	t0,136(a0)



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
    ld t0, 14*regbytes(a1)
ffffffe000200118:	0705b283          	ld	t0,112(a1)
    csrw sepc, t0
ffffffe00020011c:	14129073          	csrw	sepc,t0
    ld t0, 15*regbytes(a1)
ffffffe000200120:	0785b283          	ld	t0,120(a1)
    csrs sstatus, t0
ffffffe000200124:	1002a073          	csrs	sstatus,t0
    ld t0, 16*regbytes(a1)
ffffffe000200128:	0805b283          	ld	t0,128(a1)
    csrw sscratch, t0
ffffffe00020012c:	14029073          	csrw	sscratch,t0
    ld t0, 17*regbytes(a1)
ffffffe000200130:	0885b283          	ld	t0,136(a1)
    li t1, 0xffffffdf80000000
ffffffe000200134:	fbf0031b          	addiw	t1,zero,-65
ffffffe000200138:	01f31313          	slli	t1,t1,0x1f
    sub t0, t0, t1
ffffffe00020013c:	406282b3          	sub	t0,t0,t1
    srli t0, t0, 12
ffffffe000200140:	00c2d293          	srli	t0,t0,0xc
    li t1, 0x8000000000000000
ffffffe000200144:	fff0031b          	addiw	t1,zero,-1
ffffffe000200148:	03f31313          	slli	t1,t1,0x3f
    add t0, t0, t1
ffffffe00020014c:	006282b3          	add	t0,t0,t1
    csrw satp, t0
ffffffe000200150:	18029073          	csrw	satp,t0
    sfence.vma zero, zero
ffffffe000200154:	12000073          	sfence.vma
    ret
ffffffe000200158:	00008067          	ret

ffffffe00020015c <__dummy>:


__dummy:
    csrrw sp, sscratch, sp
ffffffe00020015c:	14011173          	csrrw	sp,sscratch,sp
    sret
ffffffe000200160:	10200073          	sret

ffffffe000200164 <_traps>:
    

_traps:
    csrrw tp, sscratch, tp
ffffffe000200164:	14021273          	csrrw	tp,sscratch,tp
    bnez tp, USER_TRAP
ffffffe000200168:	00021663          	bnez	tp,ffffffe000200174 <USER_TRAP>
    #this is a kernel thread
    csrrw tp, sscratch, tp
ffffffe00020016c:	14021273          	csrrw	tp,sscratch,tp
    j TRAP
ffffffe000200170:	00c0006f          	j	ffffffe00020017c <TRAP>

ffffffe000200174 <USER_TRAP>:
USER_TRAP:
    csrrw tp, sscratch, tp
ffffffe000200174:	14021273          	csrrw	tp,sscratch,tp
    csrrw sp, sscratch, sp
ffffffe000200178:	14011173          	csrrw	sp,sscratch,sp

ffffffe00020017c <TRAP>:
TRAP:
    addi sp, sp, -33 * regbytes
ffffffe00020017c:	ef810113          	addi	sp,sp,-264 # ffffffe000207ef8 <_sbss+0xef8>
    sd x0, 0*regbytes(sp)
ffffffe000200180:	00013023          	sd	zero,0(sp)
    sd x1, 1*regbytes(sp)
ffffffe000200184:	00113423          	sd	ra,8(sp)
    sd x3, 3*regbytes(sp)
ffffffe000200188:	00313c23          	sd	gp,24(sp)
    sd x4, 4*regbytes(sp)
ffffffe00020018c:	02413023          	sd	tp,32(sp)
    sd x5, 5*regbytes(sp)
ffffffe000200190:	02513423          	sd	t0,40(sp)
    sd x6, 6*regbytes(sp)
ffffffe000200194:	02613823          	sd	t1,48(sp)
    sd x7, 7*regbytes(sp)
ffffffe000200198:	02713c23          	sd	t2,56(sp)
    sd x8, 8*regbytes(sp)
ffffffe00020019c:	04813023          	sd	s0,64(sp)
    sd x9, 9*regbytes(sp)
ffffffe0002001a0:	04913423          	sd	s1,72(sp)
    sd x10, 10*regbytes(sp)
ffffffe0002001a4:	04a13823          	sd	a0,80(sp)
    sd x11, 11*regbytes(sp)
ffffffe0002001a8:	04b13c23          	sd	a1,88(sp)
    sd x12, 12*regbytes(sp)
ffffffe0002001ac:	06c13023          	sd	a2,96(sp)
    sd x13, 13*regbytes(sp)
ffffffe0002001b0:	06d13423          	sd	a3,104(sp)
    sd x14, 14*regbytes(sp)
ffffffe0002001b4:	06e13823          	sd	a4,112(sp)
    sd x15, 15*regbytes(sp)
ffffffe0002001b8:	06f13c23          	sd	a5,120(sp)
    sd x16, 16*regbytes(sp)
ffffffe0002001bc:	09013023          	sd	a6,128(sp)
    sd x17, 17*regbytes(sp)
ffffffe0002001c0:	09113423          	sd	a7,136(sp)
    sd x18, 18*regbytes(sp)
ffffffe0002001c4:	09213823          	sd	s2,144(sp)
    sd x19, 19*regbytes(sp)
ffffffe0002001c8:	09313c23          	sd	s3,152(sp)
    sd x20, 20*regbytes(sp)
ffffffe0002001cc:	0b413023          	sd	s4,160(sp)
    sd x21, 21*regbytes(sp)
ffffffe0002001d0:	0b513423          	sd	s5,168(sp)
    sd x22, 22*regbytes(sp)
ffffffe0002001d4:	0b613823          	sd	s6,176(sp)
    sd x23, 23*regbytes(sp)
ffffffe0002001d8:	0b713c23          	sd	s7,184(sp)
    sd x24, 24*regbytes(sp)
ffffffe0002001dc:	0d813023          	sd	s8,192(sp)
    sd x25, 25*regbytes(sp)
ffffffe0002001e0:	0d913423          	sd	s9,200(sp)
    sd x26, 26*regbytes(sp)
ffffffe0002001e4:	0da13823          	sd	s10,208(sp)
    sd x27, 27*regbytes(sp)
ffffffe0002001e8:	0db13c23          	sd	s11,216(sp)
    sd x28, 28*regbytes(sp)
ffffffe0002001ec:	0fc13023          	sd	t3,224(sp)
    sd x29, 29*regbytes(sp)
ffffffe0002001f0:	0fd13423          	sd	t4,232(sp)
    sd x30, 30*regbytes(sp)
ffffffe0002001f4:	0fe13823          	sd	t5,240(sp)
    sd x31, 31*regbytes(sp)
ffffffe0002001f8:	0ff13c23          	sd	t6,248(sp)
    csrrs a0, sepc, x0
ffffffe0002001fc:	14102573          	csrr	a0,sepc
    sd a0, 32*regbytes(sp)
ffffffe000200200:	10a13023          	sd	a0,256(sp)
    sd sp, 2*regbytes(sp)
ffffffe000200204:	00213823          	sd	sp,16(sp)
    # call trap_handler
    csrrw a0, scause, x0
ffffffe000200208:	14201573          	csrrw	a0,scause,zero
    csrrw a1, sepc, x0
ffffffe00020020c:	141015f3          	csrrw	a1,sepc,zero
    add a2, sp, x0
ffffffe000200210:	00010633          	add	a2,sp,zero
    call trap_handler
ffffffe000200214:	574010ef          	jal	ffffffe000201788 <trap_handler>
    
    # restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a0, 32*regbytes(sp)
ffffffe000200218:	10013503          	ld	a0,256(sp)
    csrrw x0, sepc, a0
ffffffe00020021c:	14151073          	csrw	sepc,a0
    ld x1, 1*regbytes(sp)
ffffffe000200220:	00813083          	ld	ra,8(sp)
    ld x3, 3*regbytes(sp)
ffffffe000200224:	01813183          	ld	gp,24(sp)
    ld x4, 4*regbytes(sp)
ffffffe000200228:	02013203          	ld	tp,32(sp)
    ld x5, 5*regbytes(sp)
ffffffe00020022c:	02813283          	ld	t0,40(sp)
    ld x6, 6*regbytes(sp)
ffffffe000200230:	03013303          	ld	t1,48(sp)
    ld x7, 7*regbytes(sp)
ffffffe000200234:	03813383          	ld	t2,56(sp)
    ld x8, 8*regbytes(sp)
ffffffe000200238:	04013403          	ld	s0,64(sp)
    ld x9, 9*regbytes(sp)
ffffffe00020023c:	04813483          	ld	s1,72(sp)
    ld x10, 10*regbytes(sp)
ffffffe000200240:	05013503          	ld	a0,80(sp)
    ld x11, 11*regbytes(sp)
ffffffe000200244:	05813583          	ld	a1,88(sp)
    ld x12, 12*regbytes(sp)
ffffffe000200248:	06013603          	ld	a2,96(sp)
    ld x13, 13*regbytes(sp)
ffffffe00020024c:	06813683          	ld	a3,104(sp)
    ld x14, 14*regbytes(sp)
ffffffe000200250:	07013703          	ld	a4,112(sp)
    ld x15, 15*regbytes(sp)
ffffffe000200254:	07813783          	ld	a5,120(sp)
    ld x16, 16*regbytes(sp)
ffffffe000200258:	08013803          	ld	a6,128(sp)
    ld x17, 17*regbytes(sp)
ffffffe00020025c:	08813883          	ld	a7,136(sp)
    ld x18, 18*regbytes(sp)
ffffffe000200260:	09013903          	ld	s2,144(sp)
    ld x19, 19*regbytes(sp)
ffffffe000200264:	09813983          	ld	s3,152(sp)
    ld x20, 20*regbytes(sp)
ffffffe000200268:	0a013a03          	ld	s4,160(sp)
    ld x21, 21*regbytes(sp)
ffffffe00020026c:	0a813a83          	ld	s5,168(sp)
    ld x22, 22*regbytes(sp)
ffffffe000200270:	0b013b03          	ld	s6,176(sp)
    ld x23, 23*regbytes(sp)
ffffffe000200274:	0b813b83          	ld	s7,184(sp)
    ld x24, 24*regbytes(sp)
ffffffe000200278:	0c013c03          	ld	s8,192(sp)
    ld x25, 25*regbytes(sp)
ffffffe00020027c:	0c813c83          	ld	s9,200(sp)
    ld x26, 26*regbytes(sp)
ffffffe000200280:	0d013d03          	ld	s10,208(sp)
    ld x27, 27*regbytes(sp)
ffffffe000200284:	0d813d83          	ld	s11,216(sp)
    ld x28, 28*regbytes(sp)
ffffffe000200288:	0e013e03          	ld	t3,224(sp)
    ld x29, 29*regbytes(sp)
ffffffe00020028c:	0e813e83          	ld	t4,232(sp)
    ld x30, 30*regbytes(sp)
ffffffe000200290:	0f013f03          	ld	t5,240(sp)
    ld x31, 31*regbytes(sp)
ffffffe000200294:	0f813f83          	ld	t6,248(sp)
    ld x2, 2*regbytes(sp)
ffffffe000200298:	01013103          	ld	sp,16(sp)
    addi sp, sp, 33 * regbytes
ffffffe00020029c:	10810113          	addi	sp,sp,264
    # return from trap
    csrrw tp, sscratch, tp
ffffffe0002002a0:	14021273          	csrrw	tp,sscratch,tp
    bnez tp, USER_RET
ffffffe0002002a4:	00021663          	bnez	tp,ffffffe0002002b0 <USER_RET>
    csrrw tp, sscratch, tp
ffffffe0002002a8:	14021273          	csrrw	tp,sscratch,tp
    j RET
ffffffe0002002ac:	00c0006f          	j	ffffffe0002002b8 <RET>

ffffffe0002002b0 <USER_RET>:
USER_RET:
    csrrw tp, sscratch, tp
ffffffe0002002b0:	14021273          	csrrw	tp,sscratch,tp
    csrrw sp, sscratch, sp
ffffffe0002002b4:	14011173          	csrrw	sp,sscratch,sp

ffffffe0002002b8 <RET>:
RET:
    sret
ffffffe0002002b8:	10200073          	sret

ffffffe0002002bc <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
ffffffe0002002bc:	fe010113          	addi	sp,sp,-32
ffffffe0002002c0:	00813c23          	sd	s0,24(sp)
ffffffe0002002c4:	02010413          	addi	s0,sp,32
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
ffffffe0002002c8:	c01027f3          	rdtime	a5
ffffffe0002002cc:	fef43423          	sd	a5,-24(s0)
    return cycles;
ffffffe0002002d0:	fe843783          	ld	a5,-24(s0)
}
ffffffe0002002d4:	00078513          	mv	a0,a5
ffffffe0002002d8:	01813403          	ld	s0,24(sp)
ffffffe0002002dc:	02010113          	addi	sp,sp,32
ffffffe0002002e0:	00008067          	ret

ffffffe0002002e4 <clock_set_next_event>:

void clock_set_next_event() {
ffffffe0002002e4:	fe010113          	addi	sp,sp,-32
ffffffe0002002e8:	00113c23          	sd	ra,24(sp)
ffffffe0002002ec:	00813823          	sd	s0,16(sp)
ffffffe0002002f0:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
ffffffe0002002f4:	fc9ff0ef          	jal	ffffffe0002002bc <get_cycles>
ffffffe0002002f8:	00050713          	mv	a4,a0
ffffffe0002002fc:	00004797          	auipc	a5,0x4
ffffffe000200300:	d0478793          	addi	a5,a5,-764 # ffffffe000204000 <TIMECLOCK>
ffffffe000200304:	0007b783          	ld	a5,0(a5)
ffffffe000200308:	00f707b3          	add	a5,a4,a5
ffffffe00020030c:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
ffffffe000200310:	fe843503          	ld	a0,-24(s0)
ffffffe000200314:	32c010ef          	jal	ffffffe000201640 <sbi_set_timer>
ffffffe000200318:	00000013          	nop
ffffffe00020031c:	01813083          	ld	ra,24(sp)
ffffffe000200320:	01013403          	ld	s0,16(sp)
ffffffe000200324:	02010113          	addi	sp,sp,32
ffffffe000200328:	00008067          	ret

ffffffe00020032c <fixsize>:
#define MAX(a, b) ((a) > (b) ? (a) : (b))

void *free_page_start = &_ekernel;
struct buddy buddy;

static uint64_t fixsize(uint64_t size) {
ffffffe00020032c:	fe010113          	addi	sp,sp,-32
ffffffe000200330:	00813c23          	sd	s0,24(sp)
ffffffe000200334:	02010413          	addi	s0,sp,32
ffffffe000200338:	fea43423          	sd	a0,-24(s0)
    size --;
ffffffe00020033c:	fe843783          	ld	a5,-24(s0)
ffffffe000200340:	fff78793          	addi	a5,a5,-1
ffffffe000200344:	fef43423          	sd	a5,-24(s0)
    size |= size >> 1;
ffffffe000200348:	fe843783          	ld	a5,-24(s0)
ffffffe00020034c:	0017d793          	srli	a5,a5,0x1
ffffffe000200350:	fe843703          	ld	a4,-24(s0)
ffffffe000200354:	00f767b3          	or	a5,a4,a5
ffffffe000200358:	fef43423          	sd	a5,-24(s0)
    size |= size >> 2;
ffffffe00020035c:	fe843783          	ld	a5,-24(s0)
ffffffe000200360:	0027d793          	srli	a5,a5,0x2
ffffffe000200364:	fe843703          	ld	a4,-24(s0)
ffffffe000200368:	00f767b3          	or	a5,a4,a5
ffffffe00020036c:	fef43423          	sd	a5,-24(s0)
    size |= size >> 4;
ffffffe000200370:	fe843783          	ld	a5,-24(s0)
ffffffe000200374:	0047d793          	srli	a5,a5,0x4
ffffffe000200378:	fe843703          	ld	a4,-24(s0)
ffffffe00020037c:	00f767b3          	or	a5,a4,a5
ffffffe000200380:	fef43423          	sd	a5,-24(s0)
    size |= size >> 8;
ffffffe000200384:	fe843783          	ld	a5,-24(s0)
ffffffe000200388:	0087d793          	srli	a5,a5,0x8
ffffffe00020038c:	fe843703          	ld	a4,-24(s0)
ffffffe000200390:	00f767b3          	or	a5,a4,a5
ffffffe000200394:	fef43423          	sd	a5,-24(s0)
    size |= size >> 16;
ffffffe000200398:	fe843783          	ld	a5,-24(s0)
ffffffe00020039c:	0107d793          	srli	a5,a5,0x10
ffffffe0002003a0:	fe843703          	ld	a4,-24(s0)
ffffffe0002003a4:	00f767b3          	or	a5,a4,a5
ffffffe0002003a8:	fef43423          	sd	a5,-24(s0)
    size |= size >> 32;
ffffffe0002003ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002003b0:	0207d793          	srli	a5,a5,0x20
ffffffe0002003b4:	fe843703          	ld	a4,-24(s0)
ffffffe0002003b8:	00f767b3          	or	a5,a4,a5
ffffffe0002003bc:	fef43423          	sd	a5,-24(s0)
    return size + 1;
ffffffe0002003c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003c4:	00178793          	addi	a5,a5,1
}
ffffffe0002003c8:	00078513          	mv	a0,a5
ffffffe0002003cc:	01813403          	ld	s0,24(sp)
ffffffe0002003d0:	02010113          	addi	sp,sp,32
ffffffe0002003d4:	00008067          	ret

ffffffe0002003d8 <buddy_init>:

void buddy_init() {
ffffffe0002003d8:	fd010113          	addi	sp,sp,-48
ffffffe0002003dc:	02113423          	sd	ra,40(sp)
ffffffe0002003e0:	02813023          	sd	s0,32(sp)
ffffffe0002003e4:	03010413          	addi	s0,sp,48
    uint64_t buddy_size = (uint64_t)PHY_SIZE / PGSIZE;
ffffffe0002003e8:	000087b7          	lui	a5,0x8
ffffffe0002003ec:	fef43423          	sd	a5,-24(s0)

    if (!IS_POWER_OF_2(buddy_size))
ffffffe0002003f0:	fe843783          	ld	a5,-24(s0)
ffffffe0002003f4:	fff78713          	addi	a4,a5,-1 # 7fff <PGSIZE+0x6fff>
ffffffe0002003f8:	fe843783          	ld	a5,-24(s0)
ffffffe0002003fc:	00f777b3          	and	a5,a4,a5
ffffffe000200400:	00078863          	beqz	a5,ffffffe000200410 <buddy_init+0x38>
        buddy_size = fixsize(buddy_size);
ffffffe000200404:	fe843503          	ld	a0,-24(s0)
ffffffe000200408:	f25ff0ef          	jal	ffffffe00020032c <fixsize>
ffffffe00020040c:	fea43423          	sd	a0,-24(s0)

    buddy.size = buddy_size;
ffffffe000200410:	00008797          	auipc	a5,0x8
ffffffe000200414:	c1078793          	addi	a5,a5,-1008 # ffffffe000208020 <buddy>
ffffffe000200418:	fe843703          	ld	a4,-24(s0)
ffffffe00020041c:	00e7b023          	sd	a4,0(a5)
    buddy.bitmap = free_page_start;
ffffffe000200420:	00004797          	auipc	a5,0x4
ffffffe000200424:	be878793          	addi	a5,a5,-1048 # ffffffe000204008 <free_page_start>
ffffffe000200428:	0007b703          	ld	a4,0(a5)
ffffffe00020042c:	00008797          	auipc	a5,0x8
ffffffe000200430:	bf478793          	addi	a5,a5,-1036 # ffffffe000208020 <buddy>
ffffffe000200434:	00e7b423          	sd	a4,8(a5)
    free_page_start += 2 * buddy.size * sizeof(*buddy.bitmap);
ffffffe000200438:	00004797          	auipc	a5,0x4
ffffffe00020043c:	bd078793          	addi	a5,a5,-1072 # ffffffe000204008 <free_page_start>
ffffffe000200440:	0007b703          	ld	a4,0(a5)
ffffffe000200444:	00008797          	auipc	a5,0x8
ffffffe000200448:	bdc78793          	addi	a5,a5,-1060 # ffffffe000208020 <buddy>
ffffffe00020044c:	0007b783          	ld	a5,0(a5)
ffffffe000200450:	00479793          	slli	a5,a5,0x4
ffffffe000200454:	00f70733          	add	a4,a4,a5
ffffffe000200458:	00004797          	auipc	a5,0x4
ffffffe00020045c:	bb078793          	addi	a5,a5,-1104 # ffffffe000204008 <free_page_start>
ffffffe000200460:	00e7b023          	sd	a4,0(a5)
    memset(buddy.bitmap, 0, 2 * buddy.size * sizeof(*buddy.bitmap));
ffffffe000200464:	00008797          	auipc	a5,0x8
ffffffe000200468:	bbc78793          	addi	a5,a5,-1092 # ffffffe000208020 <buddy>
ffffffe00020046c:	0087b703          	ld	a4,8(a5)
ffffffe000200470:	00008797          	auipc	a5,0x8
ffffffe000200474:	bb078793          	addi	a5,a5,-1104 # ffffffe000208020 <buddy>
ffffffe000200478:	0007b783          	ld	a5,0(a5)
ffffffe00020047c:	00479793          	slli	a5,a5,0x4
ffffffe000200480:	00078613          	mv	a2,a5
ffffffe000200484:	00000593          	li	a1,0
ffffffe000200488:	00070513          	mv	a0,a4
ffffffe00020048c:	189020ef          	jal	ffffffe000202e14 <memset>

    uint64_t node_size = buddy.size * 2;
ffffffe000200490:	00008797          	auipc	a5,0x8
ffffffe000200494:	b9078793          	addi	a5,a5,-1136 # ffffffe000208020 <buddy>
ffffffe000200498:	0007b783          	ld	a5,0(a5)
ffffffe00020049c:	00179793          	slli	a5,a5,0x1
ffffffe0002004a0:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004a4:	fc043c23          	sd	zero,-40(s0)
ffffffe0002004a8:	0500006f          	j	ffffffe0002004f8 <buddy_init+0x120>
        if (IS_POWER_OF_2(i + 1))
ffffffe0002004ac:	fd843783          	ld	a5,-40(s0)
ffffffe0002004b0:	00178713          	addi	a4,a5,1
ffffffe0002004b4:	fd843783          	ld	a5,-40(s0)
ffffffe0002004b8:	00f777b3          	and	a5,a4,a5
ffffffe0002004bc:	00079863          	bnez	a5,ffffffe0002004cc <buddy_init+0xf4>
            node_size /= 2;
ffffffe0002004c0:	fe043783          	ld	a5,-32(s0)
ffffffe0002004c4:	0017d793          	srli	a5,a5,0x1
ffffffe0002004c8:	fef43023          	sd	a5,-32(s0)
        buddy.bitmap[i] = node_size;
ffffffe0002004cc:	00008797          	auipc	a5,0x8
ffffffe0002004d0:	b5478793          	addi	a5,a5,-1196 # ffffffe000208020 <buddy>
ffffffe0002004d4:	0087b703          	ld	a4,8(a5)
ffffffe0002004d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002004dc:	00379793          	slli	a5,a5,0x3
ffffffe0002004e0:	00f707b3          	add	a5,a4,a5
ffffffe0002004e4:	fe043703          	ld	a4,-32(s0)
ffffffe0002004e8:	00e7b023          	sd	a4,0(a5)
    for (uint64_t i = 0; i < 2 * buddy.size - 1; ++i) {
ffffffe0002004ec:	fd843783          	ld	a5,-40(s0)
ffffffe0002004f0:	00178793          	addi	a5,a5,1
ffffffe0002004f4:	fcf43c23          	sd	a5,-40(s0)
ffffffe0002004f8:	00008797          	auipc	a5,0x8
ffffffe0002004fc:	b2878793          	addi	a5,a5,-1240 # ffffffe000208020 <buddy>
ffffffe000200500:	0007b783          	ld	a5,0(a5)
ffffffe000200504:	00179793          	slli	a5,a5,0x1
ffffffe000200508:	fff78793          	addi	a5,a5,-1
ffffffe00020050c:	fd843703          	ld	a4,-40(s0)
ffffffe000200510:	f8f76ee3          	bltu	a4,a5,ffffffe0002004ac <buddy_init+0xd4>
    }

    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200514:	fc043823          	sd	zero,-48(s0)
ffffffe000200518:	0180006f          	j	ffffffe000200530 <buddy_init+0x158>
        buddy_alloc(1);
ffffffe00020051c:	00100513          	li	a0,1
ffffffe000200520:	1fc000ef          	jal	ffffffe00020071c <buddy_alloc>
    for (uint64_t pfn = 0; (uint64_t)PFN2PHYS(pfn) < VA2PA((uint64_t)free_page_start); ++pfn) {
ffffffe000200524:	fd043783          	ld	a5,-48(s0)
ffffffe000200528:	00178793          	addi	a5,a5,1
ffffffe00020052c:	fcf43823          	sd	a5,-48(s0)
ffffffe000200530:	fd043783          	ld	a5,-48(s0)
ffffffe000200534:	00c79713          	slli	a4,a5,0xc
ffffffe000200538:	00100793          	li	a5,1
ffffffe00020053c:	01f79793          	slli	a5,a5,0x1f
ffffffe000200540:	00f70733          	add	a4,a4,a5
ffffffe000200544:	00004797          	auipc	a5,0x4
ffffffe000200548:	ac478793          	addi	a5,a5,-1340 # ffffffe000204008 <free_page_start>
ffffffe00020054c:	0007b783          	ld	a5,0(a5)
ffffffe000200550:	00078693          	mv	a3,a5
ffffffe000200554:	04100793          	li	a5,65
ffffffe000200558:	01f79793          	slli	a5,a5,0x1f
ffffffe00020055c:	00f687b3          	add	a5,a3,a5
ffffffe000200560:	faf76ee3          	bltu	a4,a5,ffffffe00020051c <buddy_init+0x144>
    }

    printk("...buddy_init done!\n");
ffffffe000200564:	00003517          	auipc	a0,0x3
ffffffe000200568:	a9c50513          	addi	a0,a0,-1380 # ffffffe000203000 <_srodata>
ffffffe00020056c:	788020ef          	jal	ffffffe000202cf4 <printk>
    return;
ffffffe000200570:	00000013          	nop
}
ffffffe000200574:	02813083          	ld	ra,40(sp)
ffffffe000200578:	02013403          	ld	s0,32(sp)
ffffffe00020057c:	03010113          	addi	sp,sp,48
ffffffe000200580:	00008067          	ret

ffffffe000200584 <buddy_free>:

void buddy_free(uint64_t pfn) {
ffffffe000200584:	fc010113          	addi	sp,sp,-64
ffffffe000200588:	02813c23          	sd	s0,56(sp)
ffffffe00020058c:	04010413          	addi	s0,sp,64
ffffffe000200590:	fca43423          	sd	a0,-56(s0)
    uint64_t node_size, index = 0;
ffffffe000200594:	fe043023          	sd	zero,-32(s0)
    uint64_t left_longest, right_longest;

    node_size = 1;
ffffffe000200598:	00100793          	li	a5,1
ffffffe00020059c:	fef43423          	sd	a5,-24(s0)
    index = pfn + buddy.size - 1;
ffffffe0002005a0:	00008797          	auipc	a5,0x8
ffffffe0002005a4:	a8078793          	addi	a5,a5,-1408 # ffffffe000208020 <buddy>
ffffffe0002005a8:	0007b703          	ld	a4,0(a5)
ffffffe0002005ac:	fc843783          	ld	a5,-56(s0)
ffffffe0002005b0:	00f707b3          	add	a5,a4,a5
ffffffe0002005b4:	fff78793          	addi	a5,a5,-1
ffffffe0002005b8:	fef43023          	sd	a5,-32(s0)

    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005bc:	02c0006f          	j	ffffffe0002005e8 <buddy_free+0x64>
        node_size *= 2;
ffffffe0002005c0:	fe843783          	ld	a5,-24(s0)
ffffffe0002005c4:	00179793          	slli	a5,a5,0x1
ffffffe0002005c8:	fef43423          	sd	a5,-24(s0)
        if (index == 0)
ffffffe0002005cc:	fe043783          	ld	a5,-32(s0)
ffffffe0002005d0:	02078e63          	beqz	a5,ffffffe00020060c <buddy_free+0x88>
    for (; buddy.bitmap[index]; index = PARENT(index)) {
ffffffe0002005d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002005d8:	00178793          	addi	a5,a5,1
ffffffe0002005dc:	0017d793          	srli	a5,a5,0x1
ffffffe0002005e0:	fff78793          	addi	a5,a5,-1
ffffffe0002005e4:	fef43023          	sd	a5,-32(s0)
ffffffe0002005e8:	00008797          	auipc	a5,0x8
ffffffe0002005ec:	a3878793          	addi	a5,a5,-1480 # ffffffe000208020 <buddy>
ffffffe0002005f0:	0087b703          	ld	a4,8(a5)
ffffffe0002005f4:	fe043783          	ld	a5,-32(s0)
ffffffe0002005f8:	00379793          	slli	a5,a5,0x3
ffffffe0002005fc:	00f707b3          	add	a5,a4,a5
ffffffe000200600:	0007b783          	ld	a5,0(a5)
ffffffe000200604:	fa079ee3          	bnez	a5,ffffffe0002005c0 <buddy_free+0x3c>
ffffffe000200608:	0080006f          	j	ffffffe000200610 <buddy_free+0x8c>
            break;
ffffffe00020060c:	00000013          	nop
    }

    buddy.bitmap[index] = node_size;
ffffffe000200610:	00008797          	auipc	a5,0x8
ffffffe000200614:	a1078793          	addi	a5,a5,-1520 # ffffffe000208020 <buddy>
ffffffe000200618:	0087b703          	ld	a4,8(a5)
ffffffe00020061c:	fe043783          	ld	a5,-32(s0)
ffffffe000200620:	00379793          	slli	a5,a5,0x3
ffffffe000200624:	00f707b3          	add	a5,a4,a5
ffffffe000200628:	fe843703          	ld	a4,-24(s0)
ffffffe00020062c:	00e7b023          	sd	a4,0(a5)

    while (index) {
ffffffe000200630:	0d00006f          	j	ffffffe000200700 <buddy_free+0x17c>
        index = PARENT(index);
ffffffe000200634:	fe043783          	ld	a5,-32(s0)
ffffffe000200638:	00178793          	addi	a5,a5,1
ffffffe00020063c:	0017d793          	srli	a5,a5,0x1
ffffffe000200640:	fff78793          	addi	a5,a5,-1
ffffffe000200644:	fef43023          	sd	a5,-32(s0)
        node_size *= 2;
ffffffe000200648:	fe843783          	ld	a5,-24(s0)
ffffffe00020064c:	00179793          	slli	a5,a5,0x1
ffffffe000200650:	fef43423          	sd	a5,-24(s0)

        left_longest = buddy.bitmap[LEFT_LEAF(index)];
ffffffe000200654:	00008797          	auipc	a5,0x8
ffffffe000200658:	9cc78793          	addi	a5,a5,-1588 # ffffffe000208020 <buddy>
ffffffe00020065c:	0087b703          	ld	a4,8(a5)
ffffffe000200660:	fe043783          	ld	a5,-32(s0)
ffffffe000200664:	00479793          	slli	a5,a5,0x4
ffffffe000200668:	00878793          	addi	a5,a5,8
ffffffe00020066c:	00f707b3          	add	a5,a4,a5
ffffffe000200670:	0007b783          	ld	a5,0(a5)
ffffffe000200674:	fcf43c23          	sd	a5,-40(s0)
        right_longest = buddy.bitmap[RIGHT_LEAF(index)];
ffffffe000200678:	00008797          	auipc	a5,0x8
ffffffe00020067c:	9a878793          	addi	a5,a5,-1624 # ffffffe000208020 <buddy>
ffffffe000200680:	0087b703          	ld	a4,8(a5)
ffffffe000200684:	fe043783          	ld	a5,-32(s0)
ffffffe000200688:	00178793          	addi	a5,a5,1
ffffffe00020068c:	00479793          	slli	a5,a5,0x4
ffffffe000200690:	00f707b3          	add	a5,a4,a5
ffffffe000200694:	0007b783          	ld	a5,0(a5)
ffffffe000200698:	fcf43823          	sd	a5,-48(s0)

        if (left_longest + right_longest == node_size) 
ffffffe00020069c:	fd843703          	ld	a4,-40(s0)
ffffffe0002006a0:	fd043783          	ld	a5,-48(s0)
ffffffe0002006a4:	00f707b3          	add	a5,a4,a5
ffffffe0002006a8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006ac:	02f71463          	bne	a4,a5,ffffffe0002006d4 <buddy_free+0x150>
            buddy.bitmap[index] = node_size;
ffffffe0002006b0:	00008797          	auipc	a5,0x8
ffffffe0002006b4:	97078793          	addi	a5,a5,-1680 # ffffffe000208020 <buddy>
ffffffe0002006b8:	0087b703          	ld	a4,8(a5)
ffffffe0002006bc:	fe043783          	ld	a5,-32(s0)
ffffffe0002006c0:	00379793          	slli	a5,a5,0x3
ffffffe0002006c4:	00f707b3          	add	a5,a4,a5
ffffffe0002006c8:	fe843703          	ld	a4,-24(s0)
ffffffe0002006cc:	00e7b023          	sd	a4,0(a5)
ffffffe0002006d0:	0300006f          	j	ffffffe000200700 <buddy_free+0x17c>
        else
            buddy.bitmap[index] = MAX(left_longest, right_longest);
ffffffe0002006d4:	00008797          	auipc	a5,0x8
ffffffe0002006d8:	94c78793          	addi	a5,a5,-1716 # ffffffe000208020 <buddy>
ffffffe0002006dc:	0087b703          	ld	a4,8(a5)
ffffffe0002006e0:	fe043783          	ld	a5,-32(s0)
ffffffe0002006e4:	00379793          	slli	a5,a5,0x3
ffffffe0002006e8:	00f706b3          	add	a3,a4,a5
ffffffe0002006ec:	fd843703          	ld	a4,-40(s0)
ffffffe0002006f0:	fd043783          	ld	a5,-48(s0)
ffffffe0002006f4:	00e7f463          	bgeu	a5,a4,ffffffe0002006fc <buddy_free+0x178>
ffffffe0002006f8:	00070793          	mv	a5,a4
ffffffe0002006fc:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe000200700:	fe043783          	ld	a5,-32(s0)
ffffffe000200704:	f20798e3          	bnez	a5,ffffffe000200634 <buddy_free+0xb0>
    }
}
ffffffe000200708:	00000013          	nop
ffffffe00020070c:	00000013          	nop
ffffffe000200710:	03813403          	ld	s0,56(sp)
ffffffe000200714:	04010113          	addi	sp,sp,64
ffffffe000200718:	00008067          	ret

ffffffe00020071c <buddy_alloc>:

uint64_t buddy_alloc(uint64_t nrpages) {
ffffffe00020071c:	fc010113          	addi	sp,sp,-64
ffffffe000200720:	02113c23          	sd	ra,56(sp)
ffffffe000200724:	02813823          	sd	s0,48(sp)
ffffffe000200728:	04010413          	addi	s0,sp,64
ffffffe00020072c:	fca43423          	sd	a0,-56(s0)
    uint64_t index = 0;
ffffffe000200730:	fe043423          	sd	zero,-24(s0)
    uint64_t node_size;
    uint64_t pfn = 0;
ffffffe000200734:	fc043c23          	sd	zero,-40(s0)

    if (nrpages <= 0)
ffffffe000200738:	fc843783          	ld	a5,-56(s0)
ffffffe00020073c:	00079863          	bnez	a5,ffffffe00020074c <buddy_alloc+0x30>
        nrpages = 1;
ffffffe000200740:	00100793          	li	a5,1
ffffffe000200744:	fcf43423          	sd	a5,-56(s0)
ffffffe000200748:	0240006f          	j	ffffffe00020076c <buddy_alloc+0x50>
    else if (!IS_POWER_OF_2(nrpages))
ffffffe00020074c:	fc843783          	ld	a5,-56(s0)
ffffffe000200750:	fff78713          	addi	a4,a5,-1
ffffffe000200754:	fc843783          	ld	a5,-56(s0)
ffffffe000200758:	00f777b3          	and	a5,a4,a5
ffffffe00020075c:	00078863          	beqz	a5,ffffffe00020076c <buddy_alloc+0x50>
        nrpages = fixsize(nrpages);
ffffffe000200760:	fc843503          	ld	a0,-56(s0)
ffffffe000200764:	bc9ff0ef          	jal	ffffffe00020032c <fixsize>
ffffffe000200768:	fca43423          	sd	a0,-56(s0)

    if (buddy.bitmap[index] < nrpages)
ffffffe00020076c:	00008797          	auipc	a5,0x8
ffffffe000200770:	8b478793          	addi	a5,a5,-1868 # ffffffe000208020 <buddy>
ffffffe000200774:	0087b703          	ld	a4,8(a5)
ffffffe000200778:	fe843783          	ld	a5,-24(s0)
ffffffe00020077c:	00379793          	slli	a5,a5,0x3
ffffffe000200780:	00f707b3          	add	a5,a4,a5
ffffffe000200784:	0007b783          	ld	a5,0(a5)
ffffffe000200788:	fc843703          	ld	a4,-56(s0)
ffffffe00020078c:	00e7f663          	bgeu	a5,a4,ffffffe000200798 <buddy_alloc+0x7c>
        return 0;
ffffffe000200790:	00000793          	li	a5,0
ffffffe000200794:	1480006f          	j	ffffffe0002008dc <buddy_alloc+0x1c0>

    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe000200798:	00008797          	auipc	a5,0x8
ffffffe00020079c:	88878793          	addi	a5,a5,-1912 # ffffffe000208020 <buddy>
ffffffe0002007a0:	0007b783          	ld	a5,0(a5)
ffffffe0002007a4:	fef43023          	sd	a5,-32(s0)
ffffffe0002007a8:	05c0006f          	j	ffffffe000200804 <buddy_alloc+0xe8>
        if (buddy.bitmap[LEFT_LEAF(index)] >= nrpages)
ffffffe0002007ac:	00008797          	auipc	a5,0x8
ffffffe0002007b0:	87478793          	addi	a5,a5,-1932 # ffffffe000208020 <buddy>
ffffffe0002007b4:	0087b703          	ld	a4,8(a5)
ffffffe0002007b8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007bc:	00479793          	slli	a5,a5,0x4
ffffffe0002007c0:	00878793          	addi	a5,a5,8
ffffffe0002007c4:	00f707b3          	add	a5,a4,a5
ffffffe0002007c8:	0007b783          	ld	a5,0(a5)
ffffffe0002007cc:	fc843703          	ld	a4,-56(s0)
ffffffe0002007d0:	00e7ec63          	bltu	a5,a4,ffffffe0002007e8 <buddy_alloc+0xcc>
            index = LEFT_LEAF(index);
ffffffe0002007d4:	fe843783          	ld	a5,-24(s0)
ffffffe0002007d8:	00179793          	slli	a5,a5,0x1
ffffffe0002007dc:	00178793          	addi	a5,a5,1
ffffffe0002007e0:	fef43423          	sd	a5,-24(s0)
ffffffe0002007e4:	0140006f          	j	ffffffe0002007f8 <buddy_alloc+0xdc>
        else
            index = RIGHT_LEAF(index);
ffffffe0002007e8:	fe843783          	ld	a5,-24(s0)
ffffffe0002007ec:	00178793          	addi	a5,a5,1
ffffffe0002007f0:	00179793          	slli	a5,a5,0x1
ffffffe0002007f4:	fef43423          	sd	a5,-24(s0)
    for(node_size = buddy.size; node_size != nrpages; node_size /= 2 ) {
ffffffe0002007f8:	fe043783          	ld	a5,-32(s0)
ffffffe0002007fc:	0017d793          	srli	a5,a5,0x1
ffffffe000200800:	fef43023          	sd	a5,-32(s0)
ffffffe000200804:	fe043703          	ld	a4,-32(s0)
ffffffe000200808:	fc843783          	ld	a5,-56(s0)
ffffffe00020080c:	faf710e3          	bne	a4,a5,ffffffe0002007ac <buddy_alloc+0x90>
    }

    buddy.bitmap[index] = 0;
ffffffe000200810:	00008797          	auipc	a5,0x8
ffffffe000200814:	81078793          	addi	a5,a5,-2032 # ffffffe000208020 <buddy>
ffffffe000200818:	0087b703          	ld	a4,8(a5)
ffffffe00020081c:	fe843783          	ld	a5,-24(s0)
ffffffe000200820:	00379793          	slli	a5,a5,0x3
ffffffe000200824:	00f707b3          	add	a5,a4,a5
ffffffe000200828:	0007b023          	sd	zero,0(a5)
    pfn = (index + 1) * node_size - buddy.size;
ffffffe00020082c:	fe843783          	ld	a5,-24(s0)
ffffffe000200830:	00178713          	addi	a4,a5,1
ffffffe000200834:	fe043783          	ld	a5,-32(s0)
ffffffe000200838:	02f70733          	mul	a4,a4,a5
ffffffe00020083c:	00007797          	auipc	a5,0x7
ffffffe000200840:	7e478793          	addi	a5,a5,2020 # ffffffe000208020 <buddy>
ffffffe000200844:	0007b783          	ld	a5,0(a5)
ffffffe000200848:	40f707b3          	sub	a5,a4,a5
ffffffe00020084c:	fcf43c23          	sd	a5,-40(s0)

    while (index) {
ffffffe000200850:	0800006f          	j	ffffffe0002008d0 <buddy_alloc+0x1b4>
        index = PARENT(index);
ffffffe000200854:	fe843783          	ld	a5,-24(s0)
ffffffe000200858:	00178793          	addi	a5,a5,1
ffffffe00020085c:	0017d793          	srli	a5,a5,0x1
ffffffe000200860:	fff78793          	addi	a5,a5,-1
ffffffe000200864:	fef43423          	sd	a5,-24(s0)
        buddy.bitmap[index] = 
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe000200868:	00007797          	auipc	a5,0x7
ffffffe00020086c:	7b878793          	addi	a5,a5,1976 # ffffffe000208020 <buddy>
ffffffe000200870:	0087b703          	ld	a4,8(a5)
ffffffe000200874:	fe843783          	ld	a5,-24(s0)
ffffffe000200878:	00178793          	addi	a5,a5,1
ffffffe00020087c:	00479793          	slli	a5,a5,0x4
ffffffe000200880:	00f707b3          	add	a5,a4,a5
ffffffe000200884:	0007b603          	ld	a2,0(a5)
ffffffe000200888:	00007797          	auipc	a5,0x7
ffffffe00020088c:	79878793          	addi	a5,a5,1944 # ffffffe000208020 <buddy>
ffffffe000200890:	0087b703          	ld	a4,8(a5)
ffffffe000200894:	fe843783          	ld	a5,-24(s0)
ffffffe000200898:	00479793          	slli	a5,a5,0x4
ffffffe00020089c:	00878793          	addi	a5,a5,8
ffffffe0002008a0:	00f707b3          	add	a5,a4,a5
ffffffe0002008a4:	0007b703          	ld	a4,0(a5)
        buddy.bitmap[index] = 
ffffffe0002008a8:	00007797          	auipc	a5,0x7
ffffffe0002008ac:	77878793          	addi	a5,a5,1912 # ffffffe000208020 <buddy>
ffffffe0002008b0:	0087b683          	ld	a3,8(a5)
ffffffe0002008b4:	fe843783          	ld	a5,-24(s0)
ffffffe0002008b8:	00379793          	slli	a5,a5,0x3
ffffffe0002008bc:	00f686b3          	add	a3,a3,a5
            MAX(buddy.bitmap[LEFT_LEAF(index)], buddy.bitmap[RIGHT_LEAF(index)]);
ffffffe0002008c0:	00060793          	mv	a5,a2
ffffffe0002008c4:	00e7f463          	bgeu	a5,a4,ffffffe0002008cc <buddy_alloc+0x1b0>
ffffffe0002008c8:	00070793          	mv	a5,a4
        buddy.bitmap[index] = 
ffffffe0002008cc:	00f6b023          	sd	a5,0(a3)
    while (index) {
ffffffe0002008d0:	fe843783          	ld	a5,-24(s0)
ffffffe0002008d4:	f80790e3          	bnez	a5,ffffffe000200854 <buddy_alloc+0x138>
    }
    
    return pfn;
ffffffe0002008d8:	fd843783          	ld	a5,-40(s0)
}
ffffffe0002008dc:	00078513          	mv	a0,a5
ffffffe0002008e0:	03813083          	ld	ra,56(sp)
ffffffe0002008e4:	03013403          	ld	s0,48(sp)
ffffffe0002008e8:	04010113          	addi	sp,sp,64
ffffffe0002008ec:	00008067          	ret

ffffffe0002008f0 <alloc_pages>:


void *alloc_pages(uint64_t nrpages) {
ffffffe0002008f0:	fd010113          	addi	sp,sp,-48
ffffffe0002008f4:	02113423          	sd	ra,40(sp)
ffffffe0002008f8:	02813023          	sd	s0,32(sp)
ffffffe0002008fc:	03010413          	addi	s0,sp,48
ffffffe000200900:	fca43c23          	sd	a0,-40(s0)
    uint64_t pfn = buddy_alloc(nrpages);
ffffffe000200904:	fd843503          	ld	a0,-40(s0)
ffffffe000200908:	e15ff0ef          	jal	ffffffe00020071c <buddy_alloc>
ffffffe00020090c:	fea43423          	sd	a0,-24(s0)
    if (pfn == 0)
ffffffe000200910:	fe843783          	ld	a5,-24(s0)
ffffffe000200914:	00079663          	bnez	a5,ffffffe000200920 <alloc_pages+0x30>
        return 0;
ffffffe000200918:	00000793          	li	a5,0
ffffffe00020091c:	0180006f          	j	ffffffe000200934 <alloc_pages+0x44>
    return (void *)(PA2VA(PFN2PHYS(pfn)));
ffffffe000200920:	fe843783          	ld	a5,-24(s0)
ffffffe000200924:	00c79713          	slli	a4,a5,0xc
ffffffe000200928:	fff00793          	li	a5,-1
ffffffe00020092c:	02579793          	slli	a5,a5,0x25
ffffffe000200930:	00f707b3          	add	a5,a4,a5
}
ffffffe000200934:	00078513          	mv	a0,a5
ffffffe000200938:	02813083          	ld	ra,40(sp)
ffffffe00020093c:	02013403          	ld	s0,32(sp)
ffffffe000200940:	03010113          	addi	sp,sp,48
ffffffe000200944:	00008067          	ret

ffffffe000200948 <alloc_page>:

void *alloc_page() {
ffffffe000200948:	ff010113          	addi	sp,sp,-16
ffffffe00020094c:	00113423          	sd	ra,8(sp)
ffffffe000200950:	00813023          	sd	s0,0(sp)
ffffffe000200954:	01010413          	addi	s0,sp,16
    return alloc_pages(1);
ffffffe000200958:	00100513          	li	a0,1
ffffffe00020095c:	f95ff0ef          	jal	ffffffe0002008f0 <alloc_pages>
ffffffe000200960:	00050793          	mv	a5,a0
}
ffffffe000200964:	00078513          	mv	a0,a5
ffffffe000200968:	00813083          	ld	ra,8(sp)
ffffffe00020096c:	00013403          	ld	s0,0(sp)
ffffffe000200970:	01010113          	addi	sp,sp,16
ffffffe000200974:	00008067          	ret

ffffffe000200978 <free_pages>:

void free_pages(void *va) {
ffffffe000200978:	fe010113          	addi	sp,sp,-32
ffffffe00020097c:	00113c23          	sd	ra,24(sp)
ffffffe000200980:	00813823          	sd	s0,16(sp)
ffffffe000200984:	02010413          	addi	s0,sp,32
ffffffe000200988:	fea43423          	sd	a0,-24(s0)
    buddy_free(PHYS2PFN(VA2PA((uint64_t)va)));
ffffffe00020098c:	fe843703          	ld	a4,-24(s0)
ffffffe000200990:	00100793          	li	a5,1
ffffffe000200994:	02579793          	slli	a5,a5,0x25
ffffffe000200998:	00f707b3          	add	a5,a4,a5
ffffffe00020099c:	00c7d793          	srli	a5,a5,0xc
ffffffe0002009a0:	00078513          	mv	a0,a5
ffffffe0002009a4:	be1ff0ef          	jal	ffffffe000200584 <buddy_free>
}
ffffffe0002009a8:	00000013          	nop
ffffffe0002009ac:	01813083          	ld	ra,24(sp)
ffffffe0002009b0:	01013403          	ld	s0,16(sp)
ffffffe0002009b4:	02010113          	addi	sp,sp,32
ffffffe0002009b8:	00008067          	ret

ffffffe0002009bc <kalloc>:

void *kalloc() {
ffffffe0002009bc:	ff010113          	addi	sp,sp,-16
ffffffe0002009c0:	00113423          	sd	ra,8(sp)
ffffffe0002009c4:	00813023          	sd	s0,0(sp)
ffffffe0002009c8:	01010413          	addi	s0,sp,16
    // r = kmem.freelist;
    // kmem.freelist = r->next;
    
    // memset((void *)r, 0x0, PGSIZE);
    // return (void *)r;
    return alloc_page();
ffffffe0002009cc:	f7dff0ef          	jal	ffffffe000200948 <alloc_page>
ffffffe0002009d0:	00050793          	mv	a5,a0
}
ffffffe0002009d4:	00078513          	mv	a0,a5
ffffffe0002009d8:	00813083          	ld	ra,8(sp)
ffffffe0002009dc:	00013403          	ld	s0,0(sp)
ffffffe0002009e0:	01010113          	addi	sp,sp,16
ffffffe0002009e4:	00008067          	ret

ffffffe0002009e8 <kfree>:

void kfree(void *addr) {
ffffffe0002009e8:	fe010113          	addi	sp,sp,-32
ffffffe0002009ec:	00113c23          	sd	ra,24(sp)
ffffffe0002009f0:	00813823          	sd	s0,16(sp)
ffffffe0002009f4:	02010413          	addi	s0,sp,32
ffffffe0002009f8:	fea43423          	sd	a0,-24(s0)
    // memset(addr, 0x0, (uint64_t)PGSIZE);

    // r = (struct run *)addr;
    // r->next = kmem.freelist;
    // kmem.freelist = r;
    free_pages(addr);
ffffffe0002009fc:	fe843503          	ld	a0,-24(s0)
ffffffe000200a00:	f79ff0ef          	jal	ffffffe000200978 <free_pages>

    return;
ffffffe000200a04:	00000013          	nop
}
ffffffe000200a08:	01813083          	ld	ra,24(sp)
ffffffe000200a0c:	01013403          	ld	s0,16(sp)
ffffffe000200a10:	02010113          	addi	sp,sp,32
ffffffe000200a14:	00008067          	ret

ffffffe000200a18 <kfreerange>:

void kfreerange(char *start, char *end) {
ffffffe000200a18:	fd010113          	addi	sp,sp,-48
ffffffe000200a1c:	02113423          	sd	ra,40(sp)
ffffffe000200a20:	02813023          	sd	s0,32(sp)
ffffffe000200a24:	03010413          	addi	s0,sp,48
ffffffe000200a28:	fca43c23          	sd	a0,-40(s0)
ffffffe000200a2c:	fcb43823          	sd	a1,-48(s0)
    char *addr = (char *)PGROUNDUP((uintptr_t)start);
ffffffe000200a30:	fd843703          	ld	a4,-40(s0)
ffffffe000200a34:	000017b7          	lui	a5,0x1
ffffffe000200a38:	fff78793          	addi	a5,a5,-1 # fff <regbytes+0xff7>
ffffffe000200a3c:	00f70733          	add	a4,a4,a5
ffffffe000200a40:	fffff7b7          	lui	a5,0xfffff
ffffffe000200a44:	00f777b3          	and	a5,a4,a5
ffffffe000200a48:	fef43423          	sd	a5,-24(s0)
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a4c:	01c0006f          	j	ffffffe000200a68 <kfreerange+0x50>
        kfree((void *)addr);
ffffffe000200a50:	fe843503          	ld	a0,-24(s0)
ffffffe000200a54:	f95ff0ef          	jal	ffffffe0002009e8 <kfree>
    for (; (uintptr_t)(addr) + PGSIZE <= (uintptr_t)end; addr += PGSIZE) {
ffffffe000200a58:	fe843703          	ld	a4,-24(s0)
ffffffe000200a5c:	000017b7          	lui	a5,0x1
ffffffe000200a60:	00f707b3          	add	a5,a4,a5
ffffffe000200a64:	fef43423          	sd	a5,-24(s0)
ffffffe000200a68:	fe843703          	ld	a4,-24(s0)
ffffffe000200a6c:	000017b7          	lui	a5,0x1
ffffffe000200a70:	00f70733          	add	a4,a4,a5
ffffffe000200a74:	fd043783          	ld	a5,-48(s0)
ffffffe000200a78:	fce7fce3          	bgeu	a5,a4,ffffffe000200a50 <kfreerange+0x38>
    }
}
ffffffe000200a7c:	00000013          	nop
ffffffe000200a80:	00000013          	nop
ffffffe000200a84:	02813083          	ld	ra,40(sp)
ffffffe000200a88:	02013403          	ld	s0,32(sp)
ffffffe000200a8c:	03010113          	addi	sp,sp,48
ffffffe000200a90:	00008067          	ret

ffffffe000200a94 <mm_init>:

void mm_init(void) {
ffffffe000200a94:	ff010113          	addi	sp,sp,-16
ffffffe000200a98:	00113423          	sd	ra,8(sp)
ffffffe000200a9c:	00813023          	sd	s0,0(sp)
ffffffe000200aa0:	01010413          	addi	s0,sp,16
    // kfreerange(_ekernel, (char *)PHY_END+PA2VA_OFFSET);
    buddy_init();
ffffffe000200aa4:	935ff0ef          	jal	ffffffe0002003d8 <buddy_init>
    printk("...mm_init done!\n");
ffffffe000200aa8:	00002517          	auipc	a0,0x2
ffffffe000200aac:	57050513          	addi	a0,a0,1392 # ffffffe000203018 <_srodata+0x18>
ffffffe000200ab0:	244020ef          	jal	ffffffe000202cf4 <printk>
}
ffffffe000200ab4:	00000013          	nop
ffffffe000200ab8:	00813083          	ld	ra,8(sp)
ffffffe000200abc:	00013403          	ld	s0,0(sp)
ffffffe000200ac0:	01010113          	addi	sp,sp,16
ffffffe000200ac4:	00008067          	ret

ffffffe000200ac8 <load_program>:
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

uint64_t proc_pg_dir[NR_TASKS][512] __attribute__((__aligned__(0x1000)));

void load_program(struct task_struct *task) {
ffffffe000200ac8:	fa010113          	addi	sp,sp,-96
ffffffe000200acc:	04113c23          	sd	ra,88(sp)
ffffffe000200ad0:	04813823          	sd	s0,80(sp)
ffffffe000200ad4:	06010413          	addi	s0,sp,96
ffffffe000200ad8:	faa43423          	sd	a0,-88(s0)
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
ffffffe000200adc:	00004797          	auipc	a5,0x4
ffffffe000200ae0:	52478793          	addi	a5,a5,1316 # ffffffe000205000 <_sramdisk>
ffffffe000200ae4:	fef43023          	sd	a5,-32(s0)
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
ffffffe000200ae8:	fe043783          	ld	a5,-32(s0)
ffffffe000200aec:	0207b703          	ld	a4,32(a5)
ffffffe000200af0:	00004797          	auipc	a5,0x4
ffffffe000200af4:	51078793          	addi	a5,a5,1296 # ffffffe000205000 <_sramdisk>
ffffffe000200af8:	00f707b3          	add	a5,a4,a5
ffffffe000200afc:	fcf43c23          	sd	a5,-40(s0)
    uint64_t offset = (uint64_t)(ehdr->e_entry&0xFFF);
ffffffe000200b00:	fe043783          	ld	a5,-32(s0)
ffffffe000200b04:	0187b703          	ld	a4,24(a5)
ffffffe000200b08:	000017b7          	lui	a5,0x1
ffffffe000200b0c:	fff78793          	addi	a5,a5,-1 # fff <regbytes+0xff7>
ffffffe000200b10:	00f777b3          	and	a5,a4,a5
ffffffe000200b14:	fcf43823          	sd	a5,-48(s0)
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000200b18:	fe042623          	sw	zero,-20(s0)
ffffffe000200b1c:	14c0006f          	j	ffffffe000200c68 <load_program+0x1a0>
        Elf64_Phdr *phdr = phdrs + i;
ffffffe000200b20:	fec42703          	lw	a4,-20(s0)
ffffffe000200b24:	00070793          	mv	a5,a4
ffffffe000200b28:	00379793          	slli	a5,a5,0x3
ffffffe000200b2c:	40e787b3          	sub	a5,a5,a4
ffffffe000200b30:	00379793          	slli	a5,a5,0x3
ffffffe000200b34:	00078713          	mv	a4,a5
ffffffe000200b38:	fd843783          	ld	a5,-40(s0)
ffffffe000200b3c:	00e787b3          	add	a5,a5,a4
ffffffe000200b40:	fcf43423          	sd	a5,-56(s0)
        if (phdr->p_type == PT_LOAD) {
ffffffe000200b44:	fc843783          	ld	a5,-56(s0)
ffffffe000200b48:	0007a783          	lw	a5,0(a5)
ffffffe000200b4c:	00078713          	mv	a4,a5
ffffffe000200b50:	00100793          	li	a5,1
ffffffe000200b54:	10f71463          	bne	a4,a5,ffffffe000200c5c <load_program+0x194>
            uint64_t page_count = (phdr->p_memsz + offset + PGSIZE - 1) / PGSIZE;
ffffffe000200b58:	fc843783          	ld	a5,-56(s0)
ffffffe000200b5c:	0287b703          	ld	a4,40(a5)
ffffffe000200b60:	fd043783          	ld	a5,-48(s0)
ffffffe000200b64:	00f70733          	add	a4,a4,a5
ffffffe000200b68:	000017b7          	lui	a5,0x1
ffffffe000200b6c:	fff78793          	addi	a5,a5,-1 # fff <regbytes+0xff7>
ffffffe000200b70:	00f707b3          	add	a5,a4,a5
ffffffe000200b74:	00c7d793          	srli	a5,a5,0xc
ffffffe000200b78:	fcf43023          	sd	a5,-64(s0)
            char *seg = (char *)alloc_pages(page_count);
ffffffe000200b7c:	fc043503          	ld	a0,-64(s0)
ffffffe000200b80:	d71ff0ef          	jal	ffffffe0002008f0 <alloc_pages>
ffffffe000200b84:	faa43c23          	sd	a0,-72(s0)
            memcpy((seg+offset), _sramdisk+phdr->p_offset, phdr->p_filesz);
ffffffe000200b88:	fb843703          	ld	a4,-72(s0)
ffffffe000200b8c:	fd043783          	ld	a5,-48(s0)
ffffffe000200b90:	00f706b3          	add	a3,a4,a5
ffffffe000200b94:	fc843783          	ld	a5,-56(s0)
ffffffe000200b98:	0087b703          	ld	a4,8(a5)
ffffffe000200b9c:	00004797          	auipc	a5,0x4
ffffffe000200ba0:	46478793          	addi	a5,a5,1124 # ffffffe000205000 <_sramdisk>
ffffffe000200ba4:	00f70733          	add	a4,a4,a5
ffffffe000200ba8:	fc843783          	ld	a5,-56(s0)
ffffffe000200bac:	0207b783          	ld	a5,32(a5)
ffffffe000200bb0:	00078613          	mv	a2,a5
ffffffe000200bb4:	00070593          	mv	a1,a4
ffffffe000200bb8:	00068513          	mv	a0,a3
ffffffe000200bbc:	2c8020ef          	jal	ffffffe000202e84 <memcpy>
            memset(seg+offset+phdr->p_filesz, 0, phdr->p_memsz - phdr->p_filesz);
ffffffe000200bc0:	fc843783          	ld	a5,-56(s0)
ffffffe000200bc4:	0207b703          	ld	a4,32(a5)
ffffffe000200bc8:	fd043783          	ld	a5,-48(s0)
ffffffe000200bcc:	00f707b3          	add	a5,a4,a5
ffffffe000200bd0:	fb843703          	ld	a4,-72(s0)
ffffffe000200bd4:	00f706b3          	add	a3,a4,a5
ffffffe000200bd8:	fc843783          	ld	a5,-56(s0)
ffffffe000200bdc:	0287b703          	ld	a4,40(a5)
ffffffe000200be0:	fc843783          	ld	a5,-56(s0)
ffffffe000200be4:	0207b783          	ld	a5,32(a5)
ffffffe000200be8:	40f707b3          	sub	a5,a4,a5
ffffffe000200bec:	00078613          	mv	a2,a5
ffffffe000200bf0:	00000593          	li	a1,0
ffffffe000200bf4:	00068513          	mv	a0,a3
ffffffe000200bf8:	21c020ef          	jal	ffffffe000202e14 <memset>
            create_mapping(
                proc_pg_dir[task->pid], 
ffffffe000200bfc:	fa843783          	ld	a5,-88(s0)
ffffffe000200c00:	0187b783          	ld	a5,24(a5)
ffffffe000200c04:	00c79713          	slli	a4,a5,0xc
ffffffe000200c08:	00008797          	auipc	a5,0x8
ffffffe000200c0c:	3f878793          	addi	a5,a5,1016 # ffffffe000209000 <proc_pg_dir>
ffffffe000200c10:	00f70533          	add	a0,a4,a5
            create_mapping(
ffffffe000200c14:	fc843783          	ld	a5,-56(s0)
ffffffe000200c18:	0107b583          	ld	a1,16(a5)
                phdr->p_vaddr, 
                (uint64_t)seg-PA2VA_OFFSET, 
ffffffe000200c1c:	fb843703          	ld	a4,-72(s0)
            create_mapping(
ffffffe000200c20:	04100793          	li	a5,65
ffffffe000200c24:	01f79793          	slli	a5,a5,0x1f
ffffffe000200c28:	00f70633          	add	a2,a4,a5
ffffffe000200c2c:	fc843783          	ld	a5,-56(s0)
ffffffe000200c30:	0287b683          	ld	a3,40(a5)
                phdr->p_memsz, 
                (uint64_t)((phdr->p_flags<<1) | 0x11)
ffffffe000200c34:	fc843783          	ld	a5,-56(s0)
ffffffe000200c38:	0047a783          	lw	a5,4(a5)
ffffffe000200c3c:	0017979b          	slliw	a5,a5,0x1
ffffffe000200c40:	0007879b          	sext.w	a5,a5
ffffffe000200c44:	0117e793          	ori	a5,a5,17
ffffffe000200c48:	0007879b          	sext.w	a5,a5
            create_mapping(
ffffffe000200c4c:	02079793          	slli	a5,a5,0x20
ffffffe000200c50:	0207d793          	srli	a5,a5,0x20
ffffffe000200c54:	00078713          	mv	a4,a5
ffffffe000200c58:	6c5000ef          	jal	ffffffe000201b1c <create_mapping>
    for (int i = 0; i < ehdr->e_phnum; ++i) {
ffffffe000200c5c:	fec42783          	lw	a5,-20(s0)
ffffffe000200c60:	0017879b          	addiw	a5,a5,1
ffffffe000200c64:	fef42623          	sw	a5,-20(s0)
ffffffe000200c68:	fe043783          	ld	a5,-32(s0)
ffffffe000200c6c:	0387d783          	lhu	a5,56(a5)
ffffffe000200c70:	0007871b          	sext.w	a4,a5
ffffffe000200c74:	fec42783          	lw	a5,-20(s0)
ffffffe000200c78:	0007879b          	sext.w	a5,a5
ffffffe000200c7c:	eae7c2e3          	blt	a5,a4,ffffffe000200b20 <load_program+0x58>
            );
        }
    }
    task->thread.sepc = (uint64_t)ehdr->e_entry;
ffffffe000200c80:	fe043783          	ld	a5,-32(s0)
ffffffe000200c84:	0187b703          	ld	a4,24(a5)
ffffffe000200c88:	fa843783          	ld	a5,-88(s0)
ffffffe000200c8c:	08e7b823          	sd	a4,144(a5)
}
ffffffe000200c90:	00000013          	nop
ffffffe000200c94:	05813083          	ld	ra,88(sp)
ffffffe000200c98:	05013403          	ld	s0,80(sp)
ffffffe000200c9c:	06010113          	addi	sp,sp,96
ffffffe000200ca0:	00008067          	ret

ffffffe000200ca4 <task_init>:

void task_init() {
ffffffe000200ca4:	fd010113          	addi	sp,sp,-48
ffffffe000200ca8:	02113423          	sd	ra,40(sp)
ffffffe000200cac:	02813023          	sd	s0,32(sp)
ffffffe000200cb0:	03010413          	addi	s0,sp,48
    srand(2024);
ffffffe000200cb4:	7e800513          	li	a0,2024
ffffffe000200cb8:	0bc020ef          	jal	ffffffe000202d74 <srand>
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle
    
    char * PageLow = (char *)kalloc();
ffffffe000200cbc:	d01ff0ef          	jal	ffffffe0002009bc <kalloc>
ffffffe000200cc0:	fea43023          	sd	a0,-32(s0)
    idle = (struct task_struct *)PageLow;
ffffffe000200cc4:	00007797          	auipc	a5,0x7
ffffffe000200cc8:	34478793          	addi	a5,a5,836 # ffffffe000208008 <idle>
ffffffe000200ccc:	fe043703          	ld	a4,-32(s0)
ffffffe000200cd0:	00e7b023          	sd	a4,0(a5)
    idle->state = TASK_RUNNING;
ffffffe000200cd4:	00007797          	auipc	a5,0x7
ffffffe000200cd8:	33478793          	addi	a5,a5,820 # ffffffe000208008 <idle>
ffffffe000200cdc:	0007b783          	ld	a5,0(a5)
ffffffe000200ce0:	0007b023          	sd	zero,0(a5)
    idle->counter = 0;
ffffffe000200ce4:	00007797          	auipc	a5,0x7
ffffffe000200ce8:	32478793          	addi	a5,a5,804 # ffffffe000208008 <idle>
ffffffe000200cec:	0007b783          	ld	a5,0(a5)
ffffffe000200cf0:	0007b423          	sd	zero,8(a5)
    idle->priority = 0;
ffffffe000200cf4:	00007797          	auipc	a5,0x7
ffffffe000200cf8:	31478793          	addi	a5,a5,788 # ffffffe000208008 <idle>
ffffffe000200cfc:	0007b783          	ld	a5,0(a5)
ffffffe000200d00:	0007b823          	sd	zero,16(a5)
    idle->pid = 0;
ffffffe000200d04:	00007797          	auipc	a5,0x7
ffffffe000200d08:	30478793          	addi	a5,a5,772 # ffffffe000208008 <idle>
ffffffe000200d0c:	0007b783          	ld	a5,0(a5)
ffffffe000200d10:	0007bc23          	sd	zero,24(a5)
    current = idle;
ffffffe000200d14:	00007797          	auipc	a5,0x7
ffffffe000200d18:	2f478793          	addi	a5,a5,756 # ffffffe000208008 <idle>
ffffffe000200d1c:	0007b703          	ld	a4,0(a5)
ffffffe000200d20:	00007797          	auipc	a5,0x7
ffffffe000200d24:	2f078793          	addi	a5,a5,752 # ffffffe000208010 <current>
ffffffe000200d28:	00e7b023          	sd	a4,0(a5)
    task[0] = idle;
ffffffe000200d2c:	00007797          	auipc	a5,0x7
ffffffe000200d30:	2dc78793          	addi	a5,a5,732 # ffffffe000208008 <idle>
ffffffe000200d34:	0007b703          	ld	a4,0(a5)
ffffffe000200d38:	00007797          	auipc	a5,0x7
ffffffe000200d3c:	2f878793          	addi	a5,a5,760 # ffffffe000208030 <task>
ffffffe000200d40:	00e7b023          	sd	a4,0(a5)
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (int i=1 ;i<NR_TASKS; i++){
ffffffe000200d44:	00100793          	li	a5,1
ffffffe000200d48:	fef42623          	sw	a5,-20(s0)
ffffffe000200d4c:	2200006f          	j	ffffffe000200f6c <task_init+0x2c8>
        char * PageLow = (char *)kalloc();
ffffffe000200d50:	c6dff0ef          	jal	ffffffe0002009bc <kalloc>
ffffffe000200d54:	fca43c23          	sd	a0,-40(s0)
        task[i] = (struct task_struct *)PageLow;
ffffffe000200d58:	00007717          	auipc	a4,0x7
ffffffe000200d5c:	2d870713          	addi	a4,a4,728 # ffffffe000208030 <task>
ffffffe000200d60:	fec42783          	lw	a5,-20(s0)
ffffffe000200d64:	00379793          	slli	a5,a5,0x3
ffffffe000200d68:	00f707b3          	add	a5,a4,a5
ffffffe000200d6c:	fd843703          	ld	a4,-40(s0)
ffffffe000200d70:	00e7b023          	sd	a4,0(a5)
        task[i]->state = TASK_RUNNING;
ffffffe000200d74:	00007717          	auipc	a4,0x7
ffffffe000200d78:	2bc70713          	addi	a4,a4,700 # ffffffe000208030 <task>
ffffffe000200d7c:	fec42783          	lw	a5,-20(s0)
ffffffe000200d80:	00379793          	slli	a5,a5,0x3
ffffffe000200d84:	00f707b3          	add	a5,a4,a5
ffffffe000200d88:	0007b783          	ld	a5,0(a5)
ffffffe000200d8c:	0007b023          	sd	zero,0(a5)
        task[i]->counter = 0;
ffffffe000200d90:	00007717          	auipc	a4,0x7
ffffffe000200d94:	2a070713          	addi	a4,a4,672 # ffffffe000208030 <task>
ffffffe000200d98:	fec42783          	lw	a5,-20(s0)
ffffffe000200d9c:	00379793          	slli	a5,a5,0x3
ffffffe000200da0:	00f707b3          	add	a5,a4,a5
ffffffe000200da4:	0007b783          	ld	a5,0(a5)
ffffffe000200da8:	0007b423          	sd	zero,8(a5)
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
ffffffe000200dac:	00c020ef          	jal	ffffffe000202db8 <rand>
ffffffe000200db0:	00050793          	mv	a5,a0
ffffffe000200db4:	00078713          	mv	a4,a5
ffffffe000200db8:	00a00793          	li	a5,10
ffffffe000200dbc:	02f767bb          	remw	a5,a4,a5
ffffffe000200dc0:	0007879b          	sext.w	a5,a5
ffffffe000200dc4:	0017879b          	addiw	a5,a5,1
ffffffe000200dc8:	0007869b          	sext.w	a3,a5
ffffffe000200dcc:	00007717          	auipc	a4,0x7
ffffffe000200dd0:	26470713          	addi	a4,a4,612 # ffffffe000208030 <task>
ffffffe000200dd4:	fec42783          	lw	a5,-20(s0)
ffffffe000200dd8:	00379793          	slli	a5,a5,0x3
ffffffe000200ddc:	00f707b3          	add	a5,a4,a5
ffffffe000200de0:	0007b783          	ld	a5,0(a5)
ffffffe000200de4:	00068713          	mv	a4,a3
ffffffe000200de8:	00e7b823          	sd	a4,16(a5)
        task[i]->pid = i;
ffffffe000200dec:	00007717          	auipc	a4,0x7
ffffffe000200df0:	24470713          	addi	a4,a4,580 # ffffffe000208030 <task>
ffffffe000200df4:	fec42783          	lw	a5,-20(s0)
ffffffe000200df8:	00379793          	slli	a5,a5,0x3
ffffffe000200dfc:	00f707b3          	add	a5,a4,a5
ffffffe000200e00:	0007b783          	ld	a5,0(a5)
ffffffe000200e04:	fec42703          	lw	a4,-20(s0)
ffffffe000200e08:	00e7bc23          	sd	a4,24(a5)
        task[i]->thread.ra = (uint64_t)__dummy;
ffffffe000200e0c:	00007717          	auipc	a4,0x7
ffffffe000200e10:	22470713          	addi	a4,a4,548 # ffffffe000208030 <task>
ffffffe000200e14:	fec42783          	lw	a5,-20(s0)
ffffffe000200e18:	00379793          	slli	a5,a5,0x3
ffffffe000200e1c:	00f707b3          	add	a5,a4,a5
ffffffe000200e20:	0007b783          	ld	a5,0(a5)
ffffffe000200e24:	fffff717          	auipc	a4,0xfffff
ffffffe000200e28:	33870713          	addi	a4,a4,824 # ffffffe00020015c <__dummy>
ffffffe000200e2c:	02e7b023          	sd	a4,32(a5)
        task[i]->thread.sp = (uint64_t)PageLow + PGSIZE;
ffffffe000200e30:	fd843683          	ld	a3,-40(s0)
ffffffe000200e34:	00007717          	auipc	a4,0x7
ffffffe000200e38:	1fc70713          	addi	a4,a4,508 # ffffffe000208030 <task>
ffffffe000200e3c:	fec42783          	lw	a5,-20(s0)
ffffffe000200e40:	00379793          	slli	a5,a5,0x3
ffffffe000200e44:	00f707b3          	add	a5,a4,a5
ffffffe000200e48:	0007b783          	ld	a5,0(a5)
ffffffe000200e4c:	00001737          	lui	a4,0x1
ffffffe000200e50:	00e68733          	add	a4,a3,a4
ffffffe000200e54:	02e7b423          	sd	a4,40(a5)
        //SPP 8,SPIE 5,SUM 18
        //SPP is set to 0 to return user mode, SPIE is set to 1 to enable interrupts after sret, and SUM is set to 1 to allow S-mode access to U-mode memory.
        // task[i]->thread.sepc = (uint64_t)USER_START;
        task[i]->thread.sstatus = 0x40020;
ffffffe000200e58:	00007717          	auipc	a4,0x7
ffffffe000200e5c:	1d870713          	addi	a4,a4,472 # ffffffe000208030 <task>
ffffffe000200e60:	fec42783          	lw	a5,-20(s0)
ffffffe000200e64:	00379793          	slli	a5,a5,0x3
ffffffe000200e68:	00f707b3          	add	a5,a4,a5
ffffffe000200e6c:	0007b783          	ld	a5,0(a5)
ffffffe000200e70:	00040737          	lui	a4,0x40
ffffffe000200e74:	02070713          	addi	a4,a4,32 # 40020 <PGSIZE+0x3f020>
ffffffe000200e78:	08e7bc23          	sd	a4,152(a5)
        task[i]->thread.sscratch = (uint64_t)USER_END;//sp of U-mode
ffffffe000200e7c:	00007717          	auipc	a4,0x7
ffffffe000200e80:	1b470713          	addi	a4,a4,436 # ffffffe000208030 <task>
ffffffe000200e84:	fec42783          	lw	a5,-20(s0)
ffffffe000200e88:	00379793          	slli	a5,a5,0x3
ffffffe000200e8c:	00f707b3          	add	a5,a4,a5
ffffffe000200e90:	0007b783          	ld	a5,0(a5)
ffffffe000200e94:	00100713          	li	a4,1
ffffffe000200e98:	02671713          	slli	a4,a4,0x26
ffffffe000200e9c:	0ae7b023          	sd	a4,160(a5)

        memcpy(proc_pg_dir[i], swapper_pg_dir, PGSIZE);
ffffffe000200ea0:	fec42783          	lw	a5,-20(s0)
ffffffe000200ea4:	00c79713          	slli	a4,a5,0xc
ffffffe000200ea8:	00008797          	auipc	a5,0x8
ffffffe000200eac:	15878793          	addi	a5,a5,344 # ffffffe000209000 <proc_pg_dir>
ffffffe000200eb0:	00f707b3          	add	a5,a4,a5
ffffffe000200eb4:	00001637          	lui	a2,0x1
ffffffe000200eb8:	0000e597          	auipc	a1,0xe
ffffffe000200ebc:	14858593          	addi	a1,a1,328 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000200ec0:	00078513          	mv	a0,a5
ffffffe000200ec4:	7c1010ef          	jal	ffffffe000202e84 <memcpy>
        //     (uint64_t)USER_START,
        //     (uint64_t)((uint64_t)(suapp)-PA2VA_OFFSET), 
        //     (uint64_t)(page_count*PGSIZE), 
        //     0x1F
        // );
        load_program(task[i]);
ffffffe000200ec8:	00007717          	auipc	a4,0x7
ffffffe000200ecc:	16870713          	addi	a4,a4,360 # ffffffe000208030 <task>
ffffffe000200ed0:	fec42783          	lw	a5,-20(s0)
ffffffe000200ed4:	00379793          	slli	a5,a5,0x3
ffffffe000200ed8:	00f707b3          	add	a5,a4,a5
ffffffe000200edc:	0007b783          	ld	a5,0(a5)
ffffffe000200ee0:	00078513          	mv	a0,a5
ffffffe000200ee4:	be5ff0ef          	jal	ffffffe000200ac8 <load_program>
        
        uint64_t *stack = (uint64_t *)kalloc();
ffffffe000200ee8:	ad5ff0ef          	jal	ffffffe0002009bc <kalloc>
ffffffe000200eec:	fca43823          	sd	a0,-48(s0)
        create_mapping(
            proc_pg_dir[i], 
ffffffe000200ef0:	fec42783          	lw	a5,-20(s0)
ffffffe000200ef4:	00c79713          	slli	a4,a5,0xc
ffffffe000200ef8:	00008797          	auipc	a5,0x8
ffffffe000200efc:	10878793          	addi	a5,a5,264 # ffffffe000209000 <proc_pg_dir>
ffffffe000200f00:	00f70533          	add	a0,a4,a5
            (uint64_t)USER_END-PGSIZE,
            (uint64_t)stack-PA2VA_OFFSET, 
ffffffe000200f04:	fd043703          	ld	a4,-48(s0)
        create_mapping(
ffffffe000200f08:	04100793          	li	a5,65
ffffffe000200f0c:	01f79793          	slli	a5,a5,0x1f
ffffffe000200f10:	00f707b3          	add	a5,a4,a5
ffffffe000200f14:	01700713          	li	a4,23
ffffffe000200f18:	000016b7          	lui	a3,0x1
ffffffe000200f1c:	00078613          	mv	a2,a5
ffffffe000200f20:	040007b7          	lui	a5,0x4000
ffffffe000200f24:	fff78793          	addi	a5,a5,-1 # 3ffffff <OPENSBI_SIZE+0x3dfffff>
ffffffe000200f28:	00c79593          	slli	a1,a5,0xc
ffffffe000200f2c:	3f1000ef          	jal	ffffffe000201b1c <create_mapping>
            0x17
        ); 
        // uint64_t virtual = (uint64_t)proc_pg_dir[i]-PA2VA_OFFSET;
        // uint64_t value = (uint64_t)(virtual>>12);
        // value += 0x8000000000000000;
        task[i]->pgd = proc_pg_dir[i];
ffffffe000200f30:	00007717          	auipc	a4,0x7
ffffffe000200f34:	10070713          	addi	a4,a4,256 # ffffffe000208030 <task>
ffffffe000200f38:	fec42783          	lw	a5,-20(s0)
ffffffe000200f3c:	00379793          	slli	a5,a5,0x3
ffffffe000200f40:	00f707b3          	add	a5,a4,a5
ffffffe000200f44:	0007b783          	ld	a5,0(a5)
ffffffe000200f48:	fec42703          	lw	a4,-20(s0)
ffffffe000200f4c:	00c71693          	slli	a3,a4,0xc
ffffffe000200f50:	00008717          	auipc	a4,0x8
ffffffe000200f54:	0b070713          	addi	a4,a4,176 # ffffffe000209000 <proc_pg_dir>
ffffffe000200f58:	00e68733          	add	a4,a3,a4
ffffffe000200f5c:	0ae7b423          	sd	a4,168(a5)
    for (int i=1 ;i<NR_TASKS; i++){
ffffffe000200f60:	fec42783          	lw	a5,-20(s0)
ffffffe000200f64:	0017879b          	addiw	a5,a5,1
ffffffe000200f68:	fef42623          	sw	a5,-20(s0)
ffffffe000200f6c:	fec42783          	lw	a5,-20(s0)
ffffffe000200f70:	0007871b          	sext.w	a4,a5
ffffffe000200f74:	00400793          	li	a5,4
ffffffe000200f78:	dce7dce3          	bge	a5,a4,ffffffe000200d50 <task_init+0xac>
        
    }

    printk("...task_init done!\n");
ffffffe000200f7c:	00002517          	auipc	a0,0x2
ffffffe000200f80:	0b450513          	addi	a0,a0,180 # ffffffe000203030 <_srodata+0x30>
ffffffe000200f84:	571010ef          	jal	ffffffe000202cf4 <printk>
}
ffffffe000200f88:	00000013          	nop
ffffffe000200f8c:	02813083          	ld	ra,40(sp)
ffffffe000200f90:	02013403          	ld	s0,32(sp)
ffffffe000200f94:	03010113          	addi	sp,sp,48
ffffffe000200f98:	00008067          	ret

ffffffe000200f9c <dummy>:
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
ffffffe000200f9c:	fd010113          	addi	sp,sp,-48
ffffffe000200fa0:	02113423          	sd	ra,40(sp)
ffffffe000200fa4:	02813023          	sd	s0,32(sp)
ffffffe000200fa8:	03010413          	addi	s0,sp,48
    uint64_t MOD = 1000000007;
ffffffe000200fac:	3b9ad7b7          	lui	a5,0x3b9ad
ffffffe000200fb0:	a0778793          	addi	a5,a5,-1529 # 3b9aca07 <PHY_SIZE+0x339aca07>
ffffffe000200fb4:	fcf43c23          	sd	a5,-40(s0)
    uint64_t auto_inc_local_var = 0;
ffffffe000200fb8:	fe043423          	sd	zero,-24(s0)
    int last_counter = -1;
ffffffe000200fbc:	fff00793          	li	a5,-1
ffffffe000200fc0:	fef42223          	sw	a5,-28(s0)
    printk("First in dummy: current counter = %d\n", current->counter);
ffffffe000200fc4:	00007797          	auipc	a5,0x7
ffffffe000200fc8:	04c78793          	addi	a5,a5,76 # ffffffe000208010 <current>
ffffffe000200fcc:	0007b783          	ld	a5,0(a5)
ffffffe000200fd0:	0087b783          	ld	a5,8(a5)
ffffffe000200fd4:	00078593          	mv	a1,a5
ffffffe000200fd8:	00002517          	auipc	a0,0x2
ffffffe000200fdc:	07050513          	addi	a0,a0,112 # ffffffe000203048 <_srodata+0x48>
ffffffe000200fe0:	515010ef          	jal	ffffffe000202cf4 <printk>
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe000200fe4:	fe442783          	lw	a5,-28(s0)
ffffffe000200fe8:	0007871b          	sext.w	a4,a5
ffffffe000200fec:	fff00793          	li	a5,-1
ffffffe000200ff0:	00f70e63          	beq	a4,a5,ffffffe00020100c <dummy+0x70>
ffffffe000200ff4:	00007797          	auipc	a5,0x7
ffffffe000200ff8:	01c78793          	addi	a5,a5,28 # ffffffe000208010 <current>
ffffffe000200ffc:	0007b783          	ld	a5,0(a5)
ffffffe000201000:	0087b703          	ld	a4,8(a5)
ffffffe000201004:	fe442783          	lw	a5,-28(s0)
ffffffe000201008:	fcf70ee3          	beq	a4,a5,ffffffe000200fe4 <dummy+0x48>
ffffffe00020100c:	00007797          	auipc	a5,0x7
ffffffe000201010:	00478793          	addi	a5,a5,4 # ffffffe000208010 <current>
ffffffe000201014:	0007b783          	ld	a5,0(a5)
ffffffe000201018:	0087b783          	ld	a5,8(a5)
ffffffe00020101c:	fc0784e3          	beqz	a5,ffffffe000200fe4 <dummy+0x48>
            if (current->counter == 1) {
ffffffe000201020:	00007797          	auipc	a5,0x7
ffffffe000201024:	ff078793          	addi	a5,a5,-16 # ffffffe000208010 <current>
ffffffe000201028:	0007b783          	ld	a5,0(a5)
ffffffe00020102c:	0087b703          	ld	a4,8(a5)
ffffffe000201030:	00100793          	li	a5,1
ffffffe000201034:	00f71e63          	bne	a4,a5,ffffffe000201050 <dummy+0xb4>
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
ffffffe000201038:	00007797          	auipc	a5,0x7
ffffffe00020103c:	fd878793          	addi	a5,a5,-40 # ffffffe000208010 <current>
ffffffe000201040:	0007b783          	ld	a5,0(a5)
ffffffe000201044:	0087b703          	ld	a4,8(a5)
ffffffe000201048:	fff70713          	addi	a4,a4,-1
ffffffe00020104c:	00e7b423          	sd	a4,8(a5)
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
ffffffe000201050:	00007797          	auipc	a5,0x7
ffffffe000201054:	fc078793          	addi	a5,a5,-64 # ffffffe000208010 <current>
ffffffe000201058:	0007b783          	ld	a5,0(a5)
ffffffe00020105c:	0087b783          	ld	a5,8(a5)
ffffffe000201060:	fef42223          	sw	a5,-28(s0)
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
ffffffe000201064:	fe843783          	ld	a5,-24(s0)
ffffffe000201068:	00178713          	addi	a4,a5,1
ffffffe00020106c:	fd843783          	ld	a5,-40(s0)
ffffffe000201070:	02f777b3          	remu	a5,a4,a5
ffffffe000201074:	fef43423          	sd	a5,-24(s0)
            printk("[PID = %d] is running. auto_inc_local_var = %d, current counter = %d\n", current->pid, auto_inc_local_var, current->counter);
ffffffe000201078:	00007797          	auipc	a5,0x7
ffffffe00020107c:	f9878793          	addi	a5,a5,-104 # ffffffe000208010 <current>
ffffffe000201080:	0007b783          	ld	a5,0(a5)
ffffffe000201084:	0187b703          	ld	a4,24(a5)
ffffffe000201088:	00007797          	auipc	a5,0x7
ffffffe00020108c:	f8878793          	addi	a5,a5,-120 # ffffffe000208010 <current>
ffffffe000201090:	0007b783          	ld	a5,0(a5)
ffffffe000201094:	0087b783          	ld	a5,8(a5)
ffffffe000201098:	00078693          	mv	a3,a5
ffffffe00020109c:	fe843603          	ld	a2,-24(s0)
ffffffe0002010a0:	00070593          	mv	a1,a4
ffffffe0002010a4:	00002517          	auipc	a0,0x2
ffffffe0002010a8:	fcc50513          	addi	a0,a0,-52 # ffffffe000203070 <_srodata+0x70>
ffffffe0002010ac:	449010ef          	jal	ffffffe000202cf4 <printk>
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
ffffffe0002010b0:	f35ff06f          	j	ffffffe000200fe4 <dummy+0x48>

ffffffe0002010b4 <switch_to>:
    }
}

extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void switch_to(struct task_struct *next) {
ffffffe0002010b4:	fd010113          	addi	sp,sp,-48
ffffffe0002010b8:	02113423          	sd	ra,40(sp)
ffffffe0002010bc:	02813023          	sd	s0,32(sp)
ffffffe0002010c0:	03010413          	addi	s0,sp,48
ffffffe0002010c4:	fca43c23          	sd	a0,-40(s0)
    if (current != next) {
ffffffe0002010c8:	00007797          	auipc	a5,0x7
ffffffe0002010cc:	f4878793          	addi	a5,a5,-184 # ffffffe000208010 <current>
ffffffe0002010d0:	0007b783          	ld	a5,0(a5)
ffffffe0002010d4:	fd843703          	ld	a4,-40(s0)
ffffffe0002010d8:	08f70063          	beq	a4,a5,ffffffe000201158 <switch_to+0xa4>
        struct task_struct *prev = current;
ffffffe0002010dc:	00007797          	auipc	a5,0x7
ffffffe0002010e0:	f3478793          	addi	a5,a5,-204 # ffffffe000208010 <current>
ffffffe0002010e4:	0007b783          	ld	a5,0(a5)
ffffffe0002010e8:	fef43423          	sd	a5,-24(s0)
        current = next;
ffffffe0002010ec:	00007797          	auipc	a5,0x7
ffffffe0002010f0:	f2478793          	addi	a5,a5,-220 # ffffffe000208010 <current>
ffffffe0002010f4:	fd843703          	ld	a4,-40(s0)
ffffffe0002010f8:	00e7b023          	sd	a4,0(a5)
        printk("Switch to PID=%d counter=%d priority=%d\n", current->pid, current->counter, current->priority);
ffffffe0002010fc:	00007797          	auipc	a5,0x7
ffffffe000201100:	f1478793          	addi	a5,a5,-236 # ffffffe000208010 <current>
ffffffe000201104:	0007b783          	ld	a5,0(a5)
ffffffe000201108:	0187b703          	ld	a4,24(a5)
ffffffe00020110c:	00007797          	auipc	a5,0x7
ffffffe000201110:	f0478793          	addi	a5,a5,-252 # ffffffe000208010 <current>
ffffffe000201114:	0007b783          	ld	a5,0(a5)
ffffffe000201118:	0087b603          	ld	a2,8(a5)
ffffffe00020111c:	00007797          	auipc	a5,0x7
ffffffe000201120:	ef478793          	addi	a5,a5,-268 # ffffffe000208010 <current>
ffffffe000201124:	0007b783          	ld	a5,0(a5)
ffffffe000201128:	0107b783          	ld	a5,16(a5)
ffffffe00020112c:	00078693          	mv	a3,a5
ffffffe000201130:	00070593          	mv	a1,a4
ffffffe000201134:	00002517          	auipc	a0,0x2
ffffffe000201138:	f8450513          	addi	a0,a0,-124 # ffffffe0002030b8 <_srodata+0xb8>
ffffffe00020113c:	3b9010ef          	jal	ffffffe000202cf4 <printk>
        __switch_to(prev, current);
ffffffe000201140:	00007797          	auipc	a5,0x7
ffffffe000201144:	ed078793          	addi	a5,a5,-304 # ffffffe000208010 <current>
ffffffe000201148:	0007b783          	ld	a5,0(a5)
ffffffe00020114c:	00078593          	mv	a1,a5
ffffffe000201150:	fe843503          	ld	a0,-24(s0)
ffffffe000201154:	f1dfe0ef          	jal	ffffffe000200070 <__switch_to>
        
    }
}
ffffffe000201158:	00000013          	nop
ffffffe00020115c:	02813083          	ld	ra,40(sp)
ffffffe000201160:	02013403          	ld	s0,32(sp)
ffffffe000201164:	03010113          	addi	sp,sp,48
ffffffe000201168:	00008067          	ret

ffffffe00020116c <do_timer>:

void do_timer() {
ffffffe00020116c:	ff010113          	addi	sp,sp,-16
ffffffe000201170:	00113423          	sd	ra,8(sp)
ffffffe000201174:	00813023          	sd	s0,0(sp)
ffffffe000201178:	01010413          	addi	s0,sp,16
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
    if (current == idle || current->counter == 0) {
ffffffe00020117c:	00007797          	auipc	a5,0x7
ffffffe000201180:	e9478793          	addi	a5,a5,-364 # ffffffe000208010 <current>
ffffffe000201184:	0007b703          	ld	a4,0(a5)
ffffffe000201188:	00007797          	auipc	a5,0x7
ffffffe00020118c:	e8078793          	addi	a5,a5,-384 # ffffffe000208008 <idle>
ffffffe000201190:	0007b783          	ld	a5,0(a5)
ffffffe000201194:	00f70c63          	beq	a4,a5,ffffffe0002011ac <do_timer+0x40>
ffffffe000201198:	00007797          	auipc	a5,0x7
ffffffe00020119c:	e7878793          	addi	a5,a5,-392 # ffffffe000208010 <current>
ffffffe0002011a0:	0007b783          	ld	a5,0(a5)
ffffffe0002011a4:	0087b783          	ld	a5,8(a5)
ffffffe0002011a8:	00079663          	bnez	a5,ffffffe0002011b4 <do_timer+0x48>
        schedule();
ffffffe0002011ac:	044000ef          	jal	ffffffe0002011f0 <schedule>
ffffffe0002011b0:	0300006f          	j	ffffffe0002011e0 <do_timer+0x74>
    } else {
        if (--current->counter) {
ffffffe0002011b4:	00007797          	auipc	a5,0x7
ffffffe0002011b8:	e5c78793          	addi	a5,a5,-420 # ffffffe000208010 <current>
ffffffe0002011bc:	0007b783          	ld	a5,0(a5)
ffffffe0002011c0:	0087b703          	ld	a4,8(a5)
ffffffe0002011c4:	fff70713          	addi	a4,a4,-1
ffffffe0002011c8:	00e7b423          	sd	a4,8(a5)
ffffffe0002011cc:	0087b783          	ld	a5,8(a5)
ffffffe0002011d0:	00079663          	bnez	a5,ffffffe0002011dc <do_timer+0x70>
            return;
        } else {
            schedule();
ffffffe0002011d4:	01c000ef          	jal	ffffffe0002011f0 <schedule>
ffffffe0002011d8:	0080006f          	j	ffffffe0002011e0 <do_timer+0x74>
            return;
ffffffe0002011dc:	00000013          	nop
        }
    }
}
ffffffe0002011e0:	00813083          	ld	ra,8(sp)
ffffffe0002011e4:	00013403          	ld	s0,0(sp)
ffffffe0002011e8:	01010113          	addi	sp,sp,16
ffffffe0002011ec:	00008067          	ret

ffffffe0002011f0 <schedule>:

void schedule() {
ffffffe0002011f0:	fd010113          	addi	sp,sp,-48
ffffffe0002011f4:	02113423          	sd	ra,40(sp)
ffffffe0002011f8:	02813023          	sd	s0,32(sp)
ffffffe0002011fc:	03010413          	addi	s0,sp,48
    uint64_t max_counter = 0;
ffffffe000201200:	fe043423          	sd	zero,-24(s0)
    struct task_struct *next = NULL;
ffffffe000201204:	fe043023          	sd	zero,-32(s0)
    for (int i=0; i<NR_TASKS; i++){
ffffffe000201208:	fc042e23          	sw	zero,-36(s0)
ffffffe00020120c:	0900006f          	j	ffffffe00020129c <schedule+0xac>
        if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
ffffffe000201210:	00007717          	auipc	a4,0x7
ffffffe000201214:	e2070713          	addi	a4,a4,-480 # ffffffe000208030 <task>
ffffffe000201218:	fdc42783          	lw	a5,-36(s0)
ffffffe00020121c:	00379793          	slli	a5,a5,0x3
ffffffe000201220:	00f707b3          	add	a5,a4,a5
ffffffe000201224:	0007b783          	ld	a5,0(a5)
ffffffe000201228:	0007b783          	ld	a5,0(a5)
ffffffe00020122c:	06079263          	bnez	a5,ffffffe000201290 <schedule+0xa0>
ffffffe000201230:	00007717          	auipc	a4,0x7
ffffffe000201234:	e0070713          	addi	a4,a4,-512 # ffffffe000208030 <task>
ffffffe000201238:	fdc42783          	lw	a5,-36(s0)
ffffffe00020123c:	00379793          	slli	a5,a5,0x3
ffffffe000201240:	00f707b3          	add	a5,a4,a5
ffffffe000201244:	0007b783          	ld	a5,0(a5)
ffffffe000201248:	0087b783          	ld	a5,8(a5)
ffffffe00020124c:	fe843703          	ld	a4,-24(s0)
ffffffe000201250:	04f77063          	bgeu	a4,a5,ffffffe000201290 <schedule+0xa0>
            max_counter = task[i]->counter;
ffffffe000201254:	00007717          	auipc	a4,0x7
ffffffe000201258:	ddc70713          	addi	a4,a4,-548 # ffffffe000208030 <task>
ffffffe00020125c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201260:	00379793          	slli	a5,a5,0x3
ffffffe000201264:	00f707b3          	add	a5,a4,a5
ffffffe000201268:	0007b783          	ld	a5,0(a5)
ffffffe00020126c:	0087b783          	ld	a5,8(a5)
ffffffe000201270:	fef43423          	sd	a5,-24(s0)
            next = task[i];
ffffffe000201274:	00007717          	auipc	a4,0x7
ffffffe000201278:	dbc70713          	addi	a4,a4,-580 # ffffffe000208030 <task>
ffffffe00020127c:	fdc42783          	lw	a5,-36(s0)
ffffffe000201280:	00379793          	slli	a5,a5,0x3
ffffffe000201284:	00f707b3          	add	a5,a4,a5
ffffffe000201288:	0007b783          	ld	a5,0(a5)
ffffffe00020128c:	fef43023          	sd	a5,-32(s0)
    for (int i=0; i<NR_TASKS; i++){
ffffffe000201290:	fdc42783          	lw	a5,-36(s0)
ffffffe000201294:	0017879b          	addiw	a5,a5,1
ffffffe000201298:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020129c:	fdc42783          	lw	a5,-36(s0)
ffffffe0002012a0:	0007871b          	sext.w	a4,a5
ffffffe0002012a4:	00400793          	li	a5,4
ffffffe0002012a8:	f6e7d4e3          	bge	a5,a4,ffffffe000201210 <schedule+0x20>
        }
    }
    if (max_counter == 0) {
ffffffe0002012ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002012b0:	16079463          	bnez	a5,ffffffe000201418 <schedule+0x228>
        for (int i=0; i<NR_TASKS; i++) {
ffffffe0002012b4:	fc042c23          	sw	zero,-40(s0)
ffffffe0002012b8:	0ac0006f          	j	ffffffe000201364 <schedule+0x174>
            task[i]->counter = task[i]->priority;
ffffffe0002012bc:	00007717          	auipc	a4,0x7
ffffffe0002012c0:	d7470713          	addi	a4,a4,-652 # ffffffe000208030 <task>
ffffffe0002012c4:	fd842783          	lw	a5,-40(s0)
ffffffe0002012c8:	00379793          	slli	a5,a5,0x3
ffffffe0002012cc:	00f707b3          	add	a5,a4,a5
ffffffe0002012d0:	0007b703          	ld	a4,0(a5)
ffffffe0002012d4:	00007697          	auipc	a3,0x7
ffffffe0002012d8:	d5c68693          	addi	a3,a3,-676 # ffffffe000208030 <task>
ffffffe0002012dc:	fd842783          	lw	a5,-40(s0)
ffffffe0002012e0:	00379793          	slli	a5,a5,0x3
ffffffe0002012e4:	00f687b3          	add	a5,a3,a5
ffffffe0002012e8:	0007b783          	ld	a5,0(a5)
ffffffe0002012ec:	01073703          	ld	a4,16(a4)
ffffffe0002012f0:	00e7b423          	sd	a4,8(a5)
            printk("SET [PID = %d counter = %d priority = %d]\n", task[i]->pid, task[i]->counter, task[i]->priority);
ffffffe0002012f4:	00007717          	auipc	a4,0x7
ffffffe0002012f8:	d3c70713          	addi	a4,a4,-708 # ffffffe000208030 <task>
ffffffe0002012fc:	fd842783          	lw	a5,-40(s0)
ffffffe000201300:	00379793          	slli	a5,a5,0x3
ffffffe000201304:	00f707b3          	add	a5,a4,a5
ffffffe000201308:	0007b783          	ld	a5,0(a5)
ffffffe00020130c:	0187b583          	ld	a1,24(a5)
ffffffe000201310:	00007717          	auipc	a4,0x7
ffffffe000201314:	d2070713          	addi	a4,a4,-736 # ffffffe000208030 <task>
ffffffe000201318:	fd842783          	lw	a5,-40(s0)
ffffffe00020131c:	00379793          	slli	a5,a5,0x3
ffffffe000201320:	00f707b3          	add	a5,a4,a5
ffffffe000201324:	0007b783          	ld	a5,0(a5)
ffffffe000201328:	0087b603          	ld	a2,8(a5)
ffffffe00020132c:	00007717          	auipc	a4,0x7
ffffffe000201330:	d0470713          	addi	a4,a4,-764 # ffffffe000208030 <task>
ffffffe000201334:	fd842783          	lw	a5,-40(s0)
ffffffe000201338:	00379793          	slli	a5,a5,0x3
ffffffe00020133c:	00f707b3          	add	a5,a4,a5
ffffffe000201340:	0007b783          	ld	a5,0(a5)
ffffffe000201344:	0107b783          	ld	a5,16(a5)
ffffffe000201348:	00078693          	mv	a3,a5
ffffffe00020134c:	00002517          	auipc	a0,0x2
ffffffe000201350:	d9c50513          	addi	a0,a0,-612 # ffffffe0002030e8 <_srodata+0xe8>
ffffffe000201354:	1a1010ef          	jal	ffffffe000202cf4 <printk>
        for (int i=0; i<NR_TASKS; i++) {
ffffffe000201358:	fd842783          	lw	a5,-40(s0)
ffffffe00020135c:	0017879b          	addiw	a5,a5,1
ffffffe000201360:	fcf42c23          	sw	a5,-40(s0)
ffffffe000201364:	fd842783          	lw	a5,-40(s0)
ffffffe000201368:	0007871b          	sext.w	a4,a5
ffffffe00020136c:	00400793          	li	a5,4
ffffffe000201370:	f4e7d6e3          	bge	a5,a4,ffffffe0002012bc <schedule+0xcc>
        }
        for (int i=0; i<NR_TASKS; i++){
ffffffe000201374:	fc042a23          	sw	zero,-44(s0)
ffffffe000201378:	0900006f          	j	ffffffe000201408 <schedule+0x218>
            if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
ffffffe00020137c:	00007717          	auipc	a4,0x7
ffffffe000201380:	cb470713          	addi	a4,a4,-844 # ffffffe000208030 <task>
ffffffe000201384:	fd442783          	lw	a5,-44(s0)
ffffffe000201388:	00379793          	slli	a5,a5,0x3
ffffffe00020138c:	00f707b3          	add	a5,a4,a5
ffffffe000201390:	0007b783          	ld	a5,0(a5)
ffffffe000201394:	0007b783          	ld	a5,0(a5)
ffffffe000201398:	06079263          	bnez	a5,ffffffe0002013fc <schedule+0x20c>
ffffffe00020139c:	00007717          	auipc	a4,0x7
ffffffe0002013a0:	c9470713          	addi	a4,a4,-876 # ffffffe000208030 <task>
ffffffe0002013a4:	fd442783          	lw	a5,-44(s0)
ffffffe0002013a8:	00379793          	slli	a5,a5,0x3
ffffffe0002013ac:	00f707b3          	add	a5,a4,a5
ffffffe0002013b0:	0007b783          	ld	a5,0(a5)
ffffffe0002013b4:	0087b783          	ld	a5,8(a5)
ffffffe0002013b8:	fe843703          	ld	a4,-24(s0)
ffffffe0002013bc:	04f77063          	bgeu	a4,a5,ffffffe0002013fc <schedule+0x20c>
                max_counter = task[i]->counter;
ffffffe0002013c0:	00007717          	auipc	a4,0x7
ffffffe0002013c4:	c7070713          	addi	a4,a4,-912 # ffffffe000208030 <task>
ffffffe0002013c8:	fd442783          	lw	a5,-44(s0)
ffffffe0002013cc:	00379793          	slli	a5,a5,0x3
ffffffe0002013d0:	00f707b3          	add	a5,a4,a5
ffffffe0002013d4:	0007b783          	ld	a5,0(a5)
ffffffe0002013d8:	0087b783          	ld	a5,8(a5)
ffffffe0002013dc:	fef43423          	sd	a5,-24(s0)
                next = task[i];
ffffffe0002013e0:	00007717          	auipc	a4,0x7
ffffffe0002013e4:	c5070713          	addi	a4,a4,-944 # ffffffe000208030 <task>
ffffffe0002013e8:	fd442783          	lw	a5,-44(s0)
ffffffe0002013ec:	00379793          	slli	a5,a5,0x3
ffffffe0002013f0:	00f707b3          	add	a5,a4,a5
ffffffe0002013f4:	0007b783          	ld	a5,0(a5)
ffffffe0002013f8:	fef43023          	sd	a5,-32(s0)
        for (int i=0; i<NR_TASKS; i++){
ffffffe0002013fc:	fd442783          	lw	a5,-44(s0)
ffffffe000201400:	0017879b          	addiw	a5,a5,1
ffffffe000201404:	fcf42a23          	sw	a5,-44(s0)
ffffffe000201408:	fd442783          	lw	a5,-44(s0)
ffffffe00020140c:	0007871b          	sext.w	a4,a5
ffffffe000201410:	00400793          	li	a5,4
ffffffe000201414:	f6e7d4e3          	bge	a5,a4,ffffffe00020137c <schedule+0x18c>
            }
        }
    }
    if (next == NULL) {
ffffffe000201418:	fe043783          	ld	a5,-32(s0)
ffffffe00020141c:	02079063          	bnez	a5,ffffffe00020143c <schedule+0x24c>
        printk("Error: no available thread to run!\n");
ffffffe000201420:	00002517          	auipc	a0,0x2
ffffffe000201424:	cf850513          	addi	a0,a0,-776 # ffffffe000203118 <_srodata+0x118>
ffffffe000201428:	0cd010ef          	jal	ffffffe000202cf4 <printk>
        next = idle;
ffffffe00020142c:	00007797          	auipc	a5,0x7
ffffffe000201430:	bdc78793          	addi	a5,a5,-1060 # ffffffe000208008 <idle>
ffffffe000201434:	0007b783          	ld	a5,0(a5)
ffffffe000201438:	fef43023          	sd	a5,-32(s0)
    }
    switch_to(next);
ffffffe00020143c:	fe043503          	ld	a0,-32(s0)
ffffffe000201440:	c75ff0ef          	jal	ffffffe0002010b4 <switch_to>
}
ffffffe000201444:	00000013          	nop
ffffffe000201448:	02813083          	ld	ra,40(sp)
ffffffe00020144c:	02013403          	ld	s0,32(sp)
ffffffe000201450:	03010113          	addi	sp,sp,48
ffffffe000201454:	00008067          	ret

ffffffe000201458 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
ffffffe000201458:	f9010113          	addi	sp,sp,-112
ffffffe00020145c:	06813423          	sd	s0,104(sp)
ffffffe000201460:	07010413          	addi	s0,sp,112
ffffffe000201464:	fca43423          	sd	a0,-56(s0)
ffffffe000201468:	fcb43023          	sd	a1,-64(s0)
ffffffe00020146c:	fac43c23          	sd	a2,-72(s0)
ffffffe000201470:	fad43823          	sd	a3,-80(s0)
ffffffe000201474:	fae43423          	sd	a4,-88(s0)
ffffffe000201478:	faf43023          	sd	a5,-96(s0)
ffffffe00020147c:	f9043c23          	sd	a6,-104(s0)
ffffffe000201480:	f9143823          	sd	a7,-112(s0)
    struct sbiret ret;
    asm volatile(
ffffffe000201484:	fc843783          	ld	a5,-56(s0)
ffffffe000201488:	fc043703          	ld	a4,-64(s0)
ffffffe00020148c:	fb843683          	ld	a3,-72(s0)
ffffffe000201490:	fb043603          	ld	a2,-80(s0)
ffffffe000201494:	fa843583          	ld	a1,-88(s0)
ffffffe000201498:	fa043503          	ld	a0,-96(s0)
ffffffe00020149c:	f9843803          	ld	a6,-104(s0)
ffffffe0002014a0:	f9043883          	ld	a7,-112(s0)
ffffffe0002014a4:	00078893          	mv	a7,a5
ffffffe0002014a8:	00070813          	mv	a6,a4
ffffffe0002014ac:	00068513          	mv	a0,a3
ffffffe0002014b0:	00060593          	mv	a1,a2
ffffffe0002014b4:	00058613          	mv	a2,a1
ffffffe0002014b8:	00050693          	mv	a3,a0
ffffffe0002014bc:	00080713          	mv	a4,a6
ffffffe0002014c0:	00088793          	mv	a5,a7
ffffffe0002014c4:	00000073          	ecall
ffffffe0002014c8:	00050713          	mv	a4,a0
ffffffe0002014cc:	00058793          	mv	a5,a1
ffffffe0002014d0:	fce43823          	sd	a4,-48(s0)
ffffffe0002014d4:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1"
        : [error] "=r" (ret.error), [value] "=r" (ret.value)
        : [eid]"r"(eid), [fid]"r"(fid), [arg0]"r"(arg0), [arg1]"r"(arg1), [arg2]"r"(arg2), [arg3]"r"(arg3), [arg4]"r"(arg4), [arg5]"r"(arg5)
        : "memory"
    );
    return ret;
ffffffe0002014d8:	fd043783          	ld	a5,-48(s0)
ffffffe0002014dc:	fef43023          	sd	a5,-32(s0)
ffffffe0002014e0:	fd843783          	ld	a5,-40(s0)
ffffffe0002014e4:	fef43423          	sd	a5,-24(s0)
ffffffe0002014e8:	fe043703          	ld	a4,-32(s0)
ffffffe0002014ec:	fe843783          	ld	a5,-24(s0)
ffffffe0002014f0:	00070313          	mv	t1,a4
ffffffe0002014f4:	00078393          	mv	t2,a5
ffffffe0002014f8:	00030713          	mv	a4,t1
ffffffe0002014fc:	00038793          	mv	a5,t2
}
ffffffe000201500:	00070513          	mv	a0,a4
ffffffe000201504:	00078593          	mv	a1,a5
ffffffe000201508:	06813403          	ld	s0,104(sp)
ffffffe00020150c:	07010113          	addi	sp,sp,112
ffffffe000201510:	00008067          	ret

ffffffe000201514 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
ffffffe000201514:	fc010113          	addi	sp,sp,-64
ffffffe000201518:	02113c23          	sd	ra,56(sp)
ffffffe00020151c:	02813823          	sd	s0,48(sp)
ffffffe000201520:	03213423          	sd	s2,40(sp)
ffffffe000201524:	03313023          	sd	s3,32(sp)
ffffffe000201528:	04010413          	addi	s0,sp,64
ffffffe00020152c:	00050793          	mv	a5,a0
ffffffe000201530:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);;
ffffffe000201534:	fcf44603          	lbu	a2,-49(s0)
ffffffe000201538:	00000893          	li	a7,0
ffffffe00020153c:	00000813          	li	a6,0
ffffffe000201540:	00000793          	li	a5,0
ffffffe000201544:	00000713          	li	a4,0
ffffffe000201548:	00000693          	li	a3,0
ffffffe00020154c:	00200593          	li	a1,2
ffffffe000201550:	44424537          	lui	a0,0x44424
ffffffe000201554:	34e50513          	addi	a0,a0,846 # 4442434e <PHY_SIZE+0x3c42434e>
ffffffe000201558:	f01ff0ef          	jal	ffffffe000201458 <sbi_ecall>
ffffffe00020155c:	00050713          	mv	a4,a0
ffffffe000201560:	00058793          	mv	a5,a1
ffffffe000201564:	fce43823          	sd	a4,-48(s0)
ffffffe000201568:	fcf43c23          	sd	a5,-40(s0)
ffffffe00020156c:	fd043703          	ld	a4,-48(s0)
ffffffe000201570:	fd843783          	ld	a5,-40(s0)
ffffffe000201574:	00070913          	mv	s2,a4
ffffffe000201578:	00078993          	mv	s3,a5
ffffffe00020157c:	00090713          	mv	a4,s2
ffffffe000201580:	00098793          	mv	a5,s3
}
ffffffe000201584:	00070513          	mv	a0,a4
ffffffe000201588:	00078593          	mv	a1,a5
ffffffe00020158c:	03813083          	ld	ra,56(sp)
ffffffe000201590:	03013403          	ld	s0,48(sp)
ffffffe000201594:	02813903          	ld	s2,40(sp)
ffffffe000201598:	02013983          	ld	s3,32(sp)
ffffffe00020159c:	04010113          	addi	sp,sp,64
ffffffe0002015a0:	00008067          	ret

ffffffe0002015a4 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
ffffffe0002015a4:	fc010113          	addi	sp,sp,-64
ffffffe0002015a8:	02113c23          	sd	ra,56(sp)
ffffffe0002015ac:	02813823          	sd	s0,48(sp)
ffffffe0002015b0:	03213423          	sd	s2,40(sp)
ffffffe0002015b4:	03313023          	sd	s3,32(sp)
ffffffe0002015b8:	04010413          	addi	s0,sp,64
ffffffe0002015bc:	00050793          	mv	a5,a0
ffffffe0002015c0:	00058713          	mv	a4,a1
ffffffe0002015c4:	fcf42623          	sw	a5,-52(s0)
ffffffe0002015c8:	00070793          	mv	a5,a4
ffffffe0002015cc:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0x0, reset_type, reset_reason, 0, 0, 0, 0);;
ffffffe0002015d0:	fcc46603          	lwu	a2,-52(s0)
ffffffe0002015d4:	fc846683          	lwu	a3,-56(s0)
ffffffe0002015d8:	00000893          	li	a7,0
ffffffe0002015dc:	00000813          	li	a6,0
ffffffe0002015e0:	00000793          	li	a5,0
ffffffe0002015e4:	00000713          	li	a4,0
ffffffe0002015e8:	00000593          	li	a1,0
ffffffe0002015ec:	53525537          	lui	a0,0x53525
ffffffe0002015f0:	35450513          	addi	a0,a0,852 # 53525354 <PHY_SIZE+0x4b525354>
ffffffe0002015f4:	e65ff0ef          	jal	ffffffe000201458 <sbi_ecall>
ffffffe0002015f8:	00050713          	mv	a4,a0
ffffffe0002015fc:	00058793          	mv	a5,a1
ffffffe000201600:	fce43823          	sd	a4,-48(s0)
ffffffe000201604:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201608:	fd043703          	ld	a4,-48(s0)
ffffffe00020160c:	fd843783          	ld	a5,-40(s0)
ffffffe000201610:	00070913          	mv	s2,a4
ffffffe000201614:	00078993          	mv	s3,a5
ffffffe000201618:	00090713          	mv	a4,s2
ffffffe00020161c:	00098793          	mv	a5,s3
}
ffffffe000201620:	00070513          	mv	a0,a4
ffffffe000201624:	00078593          	mv	a1,a5
ffffffe000201628:	03813083          	ld	ra,56(sp)
ffffffe00020162c:	03013403          	ld	s0,48(sp)
ffffffe000201630:	02813903          	ld	s2,40(sp)
ffffffe000201634:	02013983          	ld	s3,32(sp)
ffffffe000201638:	04010113          	addi	sp,sp,64
ffffffe00020163c:	00008067          	ret

ffffffe000201640 <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
ffffffe000201640:	fc010113          	addi	sp,sp,-64
ffffffe000201644:	02113c23          	sd	ra,56(sp)
ffffffe000201648:	02813823          	sd	s0,48(sp)
ffffffe00020164c:	03213423          	sd	s2,40(sp)
ffffffe000201650:	03313023          	sd	s3,32(sp)
ffffffe000201654:	04010413          	addi	s0,sp,64
ffffffe000201658:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0x0, stime_value, 0, 0, 0, 0, 0);
ffffffe00020165c:	00000893          	li	a7,0
ffffffe000201660:	00000813          	li	a6,0
ffffffe000201664:	00000793          	li	a5,0
ffffffe000201668:	00000713          	li	a4,0
ffffffe00020166c:	00000693          	li	a3,0
ffffffe000201670:	fc843603          	ld	a2,-56(s0)
ffffffe000201674:	00000593          	li	a1,0
ffffffe000201678:	54495537          	lui	a0,0x54495
ffffffe00020167c:	d4550513          	addi	a0,a0,-699 # 54494d45 <PHY_SIZE+0x4c494d45>
ffffffe000201680:	dd9ff0ef          	jal	ffffffe000201458 <sbi_ecall>
ffffffe000201684:	00050713          	mv	a4,a0
ffffffe000201688:	00058793          	mv	a5,a1
ffffffe00020168c:	fce43823          	sd	a4,-48(s0)
ffffffe000201690:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201694:	fd043703          	ld	a4,-48(s0)
ffffffe000201698:	fd843783          	ld	a5,-40(s0)
ffffffe00020169c:	00070913          	mv	s2,a4
ffffffe0002016a0:	00078993          	mv	s3,a5
ffffffe0002016a4:	00090713          	mv	a4,s2
ffffffe0002016a8:	00098793          	mv	a5,s3
ffffffe0002016ac:	00070513          	mv	a0,a4
ffffffe0002016b0:	00078593          	mv	a1,a5
ffffffe0002016b4:	03813083          	ld	ra,56(sp)
ffffffe0002016b8:	03013403          	ld	s0,48(sp)
ffffffe0002016bc:	02813903          	ld	s2,40(sp)
ffffffe0002016c0:	02013983          	ld	s3,32(sp)
ffffffe0002016c4:	04010113          	addi	sp,sp,64
ffffffe0002016c8:	00008067          	ret

ffffffe0002016cc <sys_getpid>:
#include "syscall.h"
#include "stdint.h"
#include "proc.h"

extern struct task_struct *current;
uint64_t sys_getpid() {
ffffffe0002016cc:	ff010113          	addi	sp,sp,-16
ffffffe0002016d0:	00813423          	sd	s0,8(sp)
ffffffe0002016d4:	01010413          	addi	s0,sp,16
    return current->pid;
ffffffe0002016d8:	00007797          	auipc	a5,0x7
ffffffe0002016dc:	93878793          	addi	a5,a5,-1736 # ffffffe000208010 <current>
ffffffe0002016e0:	0007b783          	ld	a5,0(a5)
ffffffe0002016e4:	0187b783          	ld	a5,24(a5)
}
ffffffe0002016e8:	00078513          	mv	a0,a5
ffffffe0002016ec:	00813403          	ld	s0,8(sp)
ffffffe0002016f0:	01010113          	addi	sp,sp,16
ffffffe0002016f4:	00008067          	ret

ffffffe0002016f8 <sys_write>:

uint64_t sys_write(uint64_t fd, const char* buf, uint64_t count) {
ffffffe0002016f8:	fc010113          	addi	sp,sp,-64
ffffffe0002016fc:	02113c23          	sd	ra,56(sp)
ffffffe000201700:	02813823          	sd	s0,48(sp)
ffffffe000201704:	04010413          	addi	s0,sp,64
ffffffe000201708:	fca43c23          	sd	a0,-40(s0)
ffffffe00020170c:	fcb43823          	sd	a1,-48(s0)
ffffffe000201710:	fcc43423          	sd	a2,-56(s0)
    if (fd != 1) {
ffffffe000201714:	fd843703          	ld	a4,-40(s0)
ffffffe000201718:	00100793          	li	a5,1
ffffffe00020171c:	00f70663          	beq	a4,a5,ffffffe000201728 <sys_write+0x30>
        return -1;
ffffffe000201720:	fff00793          	li	a5,-1
ffffffe000201724:	0500006f          	j	ffffffe000201774 <sys_write+0x7c>
    }
    int i=0;
ffffffe000201728:	fe042623          	sw	zero,-20(s0)
    for (i=0; i<count; i++) {
ffffffe00020172c:	fe042623          	sw	zero,-20(s0)
ffffffe000201730:	0340006f          	j	ffffffe000201764 <sys_write+0x6c>
        printk("%c", buf[i]);
ffffffe000201734:	fec42783          	lw	a5,-20(s0)
ffffffe000201738:	fd043703          	ld	a4,-48(s0)
ffffffe00020173c:	00f707b3          	add	a5,a4,a5
ffffffe000201740:	0007c783          	lbu	a5,0(a5)
ffffffe000201744:	0007879b          	sext.w	a5,a5
ffffffe000201748:	00078593          	mv	a1,a5
ffffffe00020174c:	00002517          	auipc	a0,0x2
ffffffe000201750:	9f450513          	addi	a0,a0,-1548 # ffffffe000203140 <_srodata+0x140>
ffffffe000201754:	5a0010ef          	jal	ffffffe000202cf4 <printk>
    for (i=0; i<count; i++) {
ffffffe000201758:	fec42783          	lw	a5,-20(s0)
ffffffe00020175c:	0017879b          	addiw	a5,a5,1
ffffffe000201760:	fef42623          	sw	a5,-20(s0)
ffffffe000201764:	fec42783          	lw	a5,-20(s0)
ffffffe000201768:	fc843703          	ld	a4,-56(s0)
ffffffe00020176c:	fce7e4e3          	bltu	a5,a4,ffffffe000201734 <sys_write+0x3c>
    }
    return i;
ffffffe000201770:	fec42783          	lw	a5,-20(s0)
ffffffe000201774:	00078513          	mv	a0,a5
ffffffe000201778:	03813083          	ld	ra,56(sp)
ffffffe00020177c:	03013403          	ld	s0,48(sp)
ffffffe000201780:	04010113          	addi	sp,sp,64
ffffffe000201784:	00008067          	ret

ffffffe000201788 <trap_handler>:
#include "clock.h"
#include "defs.h"
#include "syscall.h"
extern void do_timer();

void trap_handler(uint64_t scause, uint64_t sepc, struct pt_regs *regs ) {
ffffffe000201788:	fa010113          	addi	sp,sp,-96
ffffffe00020178c:	04113c23          	sd	ra,88(sp)
ffffffe000201790:	04813823          	sd	s0,80(sp)
ffffffe000201794:	06010413          	addi	s0,sp,96
ffffffe000201798:	faa43c23          	sd	a0,-72(s0)
ffffffe00020179c:	fab43823          	sd	a1,-80(s0)
ffffffe0002017a0:	fac43423          	sd	a2,-88(s0)
    uint64_t flag = scause >> 63;
ffffffe0002017a4:	fb843783          	ld	a5,-72(s0)
ffffffe0002017a8:	03f7d793          	srli	a5,a5,0x3f
ffffffe0002017ac:	fef43423          	sd	a5,-24(s0)
    uint64_t cause = scause & 0x7FFFFFFFFFFFFFFF;
ffffffe0002017b0:	fb843703          	ld	a4,-72(s0)
ffffffe0002017b4:	fff00793          	li	a5,-1
ffffffe0002017b8:	0017d793          	srli	a5,a5,0x1
ffffffe0002017bc:	00f777b3          	and	a5,a4,a5
ffffffe0002017c0:	fef43023          	sd	a5,-32(s0)

    if(flag) {//interrupt
ffffffe0002017c4:	fe843783          	ld	a5,-24(s0)
ffffffe0002017c8:	02078863          	beqz	a5,ffffffe0002017f8 <trap_handler+0x70>
        if(cause == 5) {
ffffffe0002017cc:	fe043703          	ld	a4,-32(s0)
ffffffe0002017d0:	00500793          	li	a5,5
ffffffe0002017d4:	00f71863          	bne	a4,a5,ffffffe0002017e4 <trap_handler+0x5c>
            // uint64_t ret = csr_read(sstatus);
            // csr_write(sscratch, ret);
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            
            clock_set_next_event();
ffffffe0002017d8:	b0dfe0ef          	jal	ffffffe0002002e4 <clock_set_next_event>
            do_timer();
ffffffe0002017dc:	991ff0ef          	jal	ffffffe00020116c <do_timer>
            }
            regs->sepc += 4;
        }
        else Err(RED "[S] Exception: %d\n", cause);
    }
ffffffe0002017e0:	0dc0006f          	j	ffffffe0002018bc <trap_handler+0x134>
            printk("[S] Interrupt: %d\n", cause);
ffffffe0002017e4:	fe043583          	ld	a1,-32(s0)
ffffffe0002017e8:	00002517          	auipc	a0,0x2
ffffffe0002017ec:	96050513          	addi	a0,a0,-1696 # ffffffe000203148 <_srodata+0x148>
ffffffe0002017f0:	504010ef          	jal	ffffffe000202cf4 <printk>
ffffffe0002017f4:	0c80006f          	j	ffffffe0002018bc <trap_handler+0x134>
        if (cause == 8) {
ffffffe0002017f8:	fe043703          	ld	a4,-32(s0)
ffffffe0002017fc:	00800793          	li	a5,8
ffffffe000201800:	08f71863          	bne	a4,a5,ffffffe000201890 <trap_handler+0x108>
            if(regs->x17 == SYS_GETPID) {
ffffffe000201804:	fa843783          	ld	a5,-88(s0)
ffffffe000201808:	0887b703          	ld	a4,136(a5)
ffffffe00020180c:	0ac00793          	li	a5,172
ffffffe000201810:	00f71e63          	bne	a4,a5,ffffffe00020182c <trap_handler+0xa4>
                uint64_t ret = sys_getpid();
ffffffe000201814:	eb9ff0ef          	jal	ffffffe0002016cc <sys_getpid>
ffffffe000201818:	fca43423          	sd	a0,-56(s0)
                regs->x10 = ret;
ffffffe00020181c:	fa843783          	ld	a5,-88(s0)
ffffffe000201820:	fc843703          	ld	a4,-56(s0)
ffffffe000201824:	04e7b823          	sd	a4,80(a5)
ffffffe000201828:	0500006f          	j	ffffffe000201878 <trap_handler+0xf0>
            } else if (regs->x17 == SYS_WRITE) {
ffffffe00020182c:	fa843783          	ld	a5,-88(s0)
ffffffe000201830:	0887b703          	ld	a4,136(a5)
ffffffe000201834:	04000793          	li	a5,64
ffffffe000201838:	04f71063          	bne	a4,a5,ffffffe000201878 <trap_handler+0xf0>
                const char *buf = (char *)regs->x11;
ffffffe00020183c:	fa843783          	ld	a5,-88(s0)
ffffffe000201840:	0587b783          	ld	a5,88(a5)
ffffffe000201844:	fcf43c23          	sd	a5,-40(s0)
                uint64_t ret = sys_write(regs->x10, buf, regs->x12);
ffffffe000201848:	fa843783          	ld	a5,-88(s0)
ffffffe00020184c:	0507b703          	ld	a4,80(a5)
ffffffe000201850:	fa843783          	ld	a5,-88(s0)
ffffffe000201854:	0607b783          	ld	a5,96(a5)
ffffffe000201858:	00078613          	mv	a2,a5
ffffffe00020185c:	fd843583          	ld	a1,-40(s0)
ffffffe000201860:	00070513          	mv	a0,a4
ffffffe000201864:	e95ff0ef          	jal	ffffffe0002016f8 <sys_write>
ffffffe000201868:	fca43823          	sd	a0,-48(s0)
                regs->x10 = ret;
ffffffe00020186c:	fa843783          	ld	a5,-88(s0)
ffffffe000201870:	fd043703          	ld	a4,-48(s0)
ffffffe000201874:	04e7b823          	sd	a4,80(a5)
            regs->sepc += 4;
ffffffe000201878:	fa843783          	ld	a5,-88(s0)
ffffffe00020187c:	1007b783          	ld	a5,256(a5)
ffffffe000201880:	00478713          	addi	a4,a5,4
ffffffe000201884:	fa843783          	ld	a5,-88(s0)
ffffffe000201888:	10e7b023          	sd	a4,256(a5)
ffffffe00020188c:	0300006f          	j	ffffffe0002018bc <trap_handler+0x134>
        else Err(RED "[S] Exception: %d\n", cause);
ffffffe000201890:	fe043703          	ld	a4,-32(s0)
ffffffe000201894:	00002697          	auipc	a3,0x2
ffffffe000201898:	90468693          	addi	a3,a3,-1788 # ffffffe000203198 <__func__.0>
ffffffe00020189c:	02500613          	li	a2,37
ffffffe0002018a0:	00002597          	auipc	a1,0x2
ffffffe0002018a4:	8c058593          	addi	a1,a1,-1856 # ffffffe000203160 <_srodata+0x160>
ffffffe0002018a8:	00002517          	auipc	a0,0x2
ffffffe0002018ac:	8c050513          	addi	a0,a0,-1856 # ffffffe000203168 <_srodata+0x168>
ffffffe0002018b0:	444010ef          	jal	ffffffe000202cf4 <printk>
ffffffe0002018b4:	00000013          	nop
ffffffe0002018b8:	ffdff06f          	j	ffffffe0002018b4 <trap_handler+0x12c>
ffffffe0002018bc:	05813083          	ld	ra,88(sp)
ffffffe0002018c0:	05013403          	ld	s0,80(sp)
ffffffe0002018c4:	06010113          	addi	sp,sp,96
ffffffe0002018c8:	00008067          	ret

ffffffe0002018cc <setup_vm>:
extern char _erodata[];
extern char _sdata[];
/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
ffffffe0002018cc:	fe010113          	addi	sp,sp,-32
ffffffe0002018d0:	00813c23          	sd	s0,24(sp)
ffffffe0002018d4:	02010413          	addi	s0,sp,32
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/
    for (int i = 0; i < 512; i++) {
ffffffe0002018d8:	fe042623          	sw	zero,-20(s0)
ffffffe0002018dc:	0900006f          	j	ffffffe00020196c <setup_vm+0xa0>
        if(i==2) early_pgtbl[i] = (uint64_t)0x2000000F;
ffffffe0002018e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002018e4:	0007871b          	sext.w	a4,a5
ffffffe0002018e8:	00200793          	li	a5,2
ffffffe0002018ec:	02f71463          	bne	a4,a5,ffffffe000201914 <setup_vm+0x48>
ffffffe0002018f0:	0000c717          	auipc	a4,0xc
ffffffe0002018f4:	71070713          	addi	a4,a4,1808 # ffffffe00020e000 <early_pgtbl>
ffffffe0002018f8:	fec42783          	lw	a5,-20(s0)
ffffffe0002018fc:	00379793          	slli	a5,a5,0x3
ffffffe000201900:	00f707b3          	add	a5,a4,a5
ffffffe000201904:	20000737          	lui	a4,0x20000
ffffffe000201908:	00f70713          	addi	a4,a4,15 # 2000000f <PHY_SIZE+0x1800000f>
ffffffe00020190c:	00e7b023          	sd	a4,0(a5)
ffffffe000201910:	0500006f          	j	ffffffe000201960 <setup_vm+0x94>
        else if (i==384) early_pgtbl[i] = (uint64_t)0x2000000F;
ffffffe000201914:	fec42783          	lw	a5,-20(s0)
ffffffe000201918:	0007871b          	sext.w	a4,a5
ffffffe00020191c:	18000793          	li	a5,384
ffffffe000201920:	02f71463          	bne	a4,a5,ffffffe000201948 <setup_vm+0x7c>
ffffffe000201924:	0000c717          	auipc	a4,0xc
ffffffe000201928:	6dc70713          	addi	a4,a4,1756 # ffffffe00020e000 <early_pgtbl>
ffffffe00020192c:	fec42783          	lw	a5,-20(s0)
ffffffe000201930:	00379793          	slli	a5,a5,0x3
ffffffe000201934:	00f707b3          	add	a5,a4,a5
ffffffe000201938:	20000737          	lui	a4,0x20000
ffffffe00020193c:	00f70713          	addi	a4,a4,15 # 2000000f <PHY_SIZE+0x1800000f>
ffffffe000201940:	00e7b023          	sd	a4,0(a5)
ffffffe000201944:	01c0006f          	j	ffffffe000201960 <setup_vm+0x94>
        else early_pgtbl[i] = (uint64_t)0x0;
ffffffe000201948:	0000c717          	auipc	a4,0xc
ffffffe00020194c:	6b870713          	addi	a4,a4,1720 # ffffffe00020e000 <early_pgtbl>
ffffffe000201950:	fec42783          	lw	a5,-20(s0)
ffffffe000201954:	00379793          	slli	a5,a5,0x3
ffffffe000201958:	00f707b3          	add	a5,a4,a5
ffffffe00020195c:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
ffffffe000201960:	fec42783          	lw	a5,-20(s0)
ffffffe000201964:	0017879b          	addiw	a5,a5,1
ffffffe000201968:	fef42623          	sw	a5,-20(s0)
ffffffe00020196c:	fec42783          	lw	a5,-20(s0)
ffffffe000201970:	0007871b          	sext.w	a4,a5
ffffffe000201974:	1ff00793          	li	a5,511
ffffffe000201978:	f6e7d4e3          	bge	a5,a4,ffffffe0002018e0 <setup_vm+0x14>
    }
}
ffffffe00020197c:	00000013          	nop
ffffffe000201980:	00000013          	nop
ffffffe000201984:	01813403          	ld	s0,24(sp)
ffffffe000201988:	02010113          	addi	sp,sp,32
ffffffe00020198c:	00008067          	ret

ffffffe000201990 <setup_vm_final>:

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final() {
ffffffe000201990:	fd010113          	addi	sp,sp,-48
ffffffe000201994:	02113423          	sd	ra,40(sp)
ffffffe000201998:	02813023          	sd	s0,32(sp)
ffffffe00020199c:	03010413          	addi	s0,sp,48
    memset(swapper_pg_dir, 0x0, PGSIZE);
ffffffe0002019a0:	00001637          	lui	a2,0x1
ffffffe0002019a4:	00000593          	li	a1,0
ffffffe0002019a8:	0000d517          	auipc	a0,0xd
ffffffe0002019ac:	65850513          	addi	a0,a0,1624 # ffffffe00020f000 <swapper_pg_dir>
ffffffe0002019b0:	464010ef          	jal	ffffffe000202e14 <memset>

    // No OpenSBI mapping required
    for (int i = 0; i < 512; i++) {
ffffffe0002019b4:	fe042623          	sw	zero,-20(s0)
ffffffe0002019b8:	0280006f          	j	ffffffe0002019e0 <setup_vm_final+0x50>
        swapper_pg_dir[i] = (uint64_t)0x0;
ffffffe0002019bc:	0000d717          	auipc	a4,0xd
ffffffe0002019c0:	64470713          	addi	a4,a4,1604 # ffffffe00020f000 <swapper_pg_dir>
ffffffe0002019c4:	fec42783          	lw	a5,-20(s0)
ffffffe0002019c8:	00379793          	slli	a5,a5,0x3
ffffffe0002019cc:	00f707b3          	add	a5,a4,a5
ffffffe0002019d0:	0007b023          	sd	zero,0(a5)
    for (int i = 0; i < 512; i++) {
ffffffe0002019d4:	fec42783          	lw	a5,-20(s0)
ffffffe0002019d8:	0017879b          	addiw	a5,a5,1
ffffffe0002019dc:	fef42623          	sw	a5,-20(s0)
ffffffe0002019e0:	fec42783          	lw	a5,-20(s0)
ffffffe0002019e4:	0007871b          	sext.w	a4,a5
ffffffe0002019e8:	1ff00793          	li	a5,511
ffffffe0002019ec:	fce7d8e3          	bge	a5,a4,ffffffe0002019bc <setup_vm_final+0x2c>
    }
    // mapping kernel text X|-|R|V
    create_mapping(
ffffffe0002019f0:	ffffe597          	auipc	a1,0xffffe
ffffffe0002019f4:	61058593          	addi	a1,a1,1552 # ffffffe000200000 <_skernel>
        swapper_pg_dir, 
        (uint64_t)_stext, 
        (uint64_t)((uint64_t)_stext-PA2VA_OFFSET), 
ffffffe0002019f8:	ffffe717          	auipc	a4,0xffffe
ffffffe0002019fc:	60870713          	addi	a4,a4,1544 # ffffffe000200000 <_skernel>
    create_mapping(
ffffffe000201a00:	04100793          	li	a5,65
ffffffe000201a04:	01f79793          	slli	a5,a5,0x1f
ffffffe000201a08:	00f70633          	add	a2,a4,a5
        (uint64_t)((uint64_t)_etext-(uint64_t)_stext), 
ffffffe000201a0c:	00001717          	auipc	a4,0x1
ffffffe000201a10:	4f470713          	addi	a4,a4,1268 # ffffffe000202f00 <_etext>
ffffffe000201a14:	ffffe797          	auipc	a5,0xffffe
ffffffe000201a18:	5ec78793          	addi	a5,a5,1516 # ffffffe000200000 <_skernel>
    create_mapping(
ffffffe000201a1c:	40f707b3          	sub	a5,a4,a5
ffffffe000201a20:	00b00713          	li	a4,11
ffffffe000201a24:	00078693          	mv	a3,a5
ffffffe000201a28:	0000d517          	auipc	a0,0xd
ffffffe000201a2c:	5d850513          	addi	a0,a0,1496 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000201a30:	0ec000ef          	jal	ffffffe000201b1c <create_mapping>
        (uint64_t)0x0B
    );

    // mapping kernel rodata -|-|R|V
    create_mapping(
ffffffe000201a34:	00001597          	auipc	a1,0x1
ffffffe000201a38:	5cc58593          	addi	a1,a1,1484 # ffffffe000203000 <_srodata>
        swapper_pg_dir, 
        (uint64_t)_srodata, 
        (uint64_t)((uint64_t)_srodata-PA2VA_OFFSET), 
ffffffe000201a3c:	00001717          	auipc	a4,0x1
ffffffe000201a40:	5c470713          	addi	a4,a4,1476 # ffffffe000203000 <_srodata>
    create_mapping(
ffffffe000201a44:	04100793          	li	a5,65
ffffffe000201a48:	01f79793          	slli	a5,a5,0x1f
ffffffe000201a4c:	00f70633          	add	a2,a4,a5
        (uint64_t)((uint64_t)_erodata-(uint64_t)_srodata), 
ffffffe000201a50:	00001717          	auipc	a4,0x1
ffffffe000201a54:	7e870713          	addi	a4,a4,2024 # ffffffe000203238 <_erodata>
ffffffe000201a58:	00001797          	auipc	a5,0x1
ffffffe000201a5c:	5a878793          	addi	a5,a5,1448 # ffffffe000203000 <_srodata>
    create_mapping(
ffffffe000201a60:	40f707b3          	sub	a5,a4,a5
ffffffe000201a64:	00300713          	li	a4,3
ffffffe000201a68:	00078693          	mv	a3,a5
ffffffe000201a6c:	0000d517          	auipc	a0,0xd
ffffffe000201a70:	59450513          	addi	a0,a0,1428 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000201a74:	0a8000ef          	jal	ffffffe000201b1c <create_mapping>
        (uint64_t)0x03
    );

    // mapping other memory -|W|R|V
    create_mapping(
ffffffe000201a78:	00002597          	auipc	a1,0x2
ffffffe000201a7c:	58858593          	addi	a1,a1,1416 # ffffffe000204000 <TIMECLOCK>
        swapper_pg_dir, 
        (uint64_t)_sdata, 
        (uint64_t)((uint64_t) _sdata-PA2VA_OFFSET), 
ffffffe000201a80:	00002717          	auipc	a4,0x2
ffffffe000201a84:	58070713          	addi	a4,a4,1408 # ffffffe000204000 <TIMECLOCK>
    create_mapping(
ffffffe000201a88:	04100793          	li	a5,65
ffffffe000201a8c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201a90:	00f70633          	add	a2,a4,a5
        (uint64_t)(PHY_END+PA2VA_OFFSET-(uint64_t)_sdata), 
ffffffe000201a94:	00002797          	auipc	a5,0x2
ffffffe000201a98:	56c78793          	addi	a5,a5,1388 # ffffffe000204000 <TIMECLOCK>
    create_mapping(
ffffffe000201a9c:	c0100713          	li	a4,-1023
ffffffe000201aa0:	01b71713          	slli	a4,a4,0x1b
ffffffe000201aa4:	40f707b3          	sub	a5,a4,a5
ffffffe000201aa8:	00700713          	li	a4,7
ffffffe000201aac:	00078693          	mv	a3,a5
ffffffe000201ab0:	0000d517          	auipc	a0,0xd
ffffffe000201ab4:	55050513          	addi	a0,a0,1360 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000201ab8:	064000ef          	jal	ffffffe000201b1c <create_mapping>
        (uint64_t)0x07
    );

    // set satp with swapper_pg_dir
    uint64_t virtual = (uint64_t)swapper_pg_dir-PA2VA_OFFSET;
ffffffe000201abc:	0000d717          	auipc	a4,0xd
ffffffe000201ac0:	54470713          	addi	a4,a4,1348 # ffffffe00020f000 <swapper_pg_dir>
ffffffe000201ac4:	04100793          	li	a5,65
ffffffe000201ac8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201acc:	00f707b3          	add	a5,a4,a5
ffffffe000201ad0:	fef43023          	sd	a5,-32(s0)
    uint64_t value = (uint64_t)(virtual>>12);
ffffffe000201ad4:	fe043783          	ld	a5,-32(s0)
ffffffe000201ad8:	00c7d793          	srli	a5,a5,0xc
ffffffe000201adc:	fcf43c23          	sd	a5,-40(s0)
    value += 0x8000000000000000;
ffffffe000201ae0:	fd843703          	ld	a4,-40(s0)
ffffffe000201ae4:	fff00793          	li	a5,-1
ffffffe000201ae8:	03f79793          	slli	a5,a5,0x3f
ffffffe000201aec:	00f707b3          	add	a5,a4,a5
ffffffe000201af0:	fcf43c23          	sd	a5,-40(s0)
    csr_write(satp, value);
ffffffe000201af4:	fd843783          	ld	a5,-40(s0)
ffffffe000201af8:	fcf43823          	sd	a5,-48(s0)
ffffffe000201afc:	fd043783          	ld	a5,-48(s0)
ffffffe000201b00:	18079073          	csrw	satp,a5
    // flush TLB
    asm volatile("sfence.vma zero, zero");
ffffffe000201b04:	12000073          	sfence.vma
    return;
ffffffe000201b08:	00000013          	nop
}
ffffffe000201b0c:	02813083          	ld	ra,40(sp)
ffffffe000201b10:	02013403          	ld	s0,32(sp)
ffffffe000201b14:	03010113          	addi	sp,sp,48
ffffffe000201b18:	00008067          	ret

ffffffe000201b1c <create_mapping>:


/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
ffffffe000201b1c:	f4010113          	addi	sp,sp,-192
ffffffe000201b20:	0a113c23          	sd	ra,184(sp)
ffffffe000201b24:	0a813823          	sd	s0,176(sp)
ffffffe000201b28:	0c010413          	addi	s0,sp,192
ffffffe000201b2c:	f6a43423          	sd	a0,-152(s0)
ffffffe000201b30:	f6b43023          	sd	a1,-160(s0)
ffffffe000201b34:	f4c43c23          	sd	a2,-168(s0)
ffffffe000201b38:	f4d43823          	sd	a3,-176(s0)
ffffffe000201b3c:	f4e43423          	sd	a4,-184(s0)
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
    uint64_t vpn0 = ((uint64_t)va<<43)>>55;
ffffffe000201b40:	f6043783          	ld	a5,-160(s0)
ffffffe000201b44:	02b79793          	slli	a5,a5,0x2b
ffffffe000201b48:	0377d793          	srli	a5,a5,0x37
ffffffe000201b4c:	fef43423          	sd	a5,-24(s0)
    uint64_t vpn1 = ((uint64_t)va<<34)>>55;
ffffffe000201b50:	f6043783          	ld	a5,-160(s0)
ffffffe000201b54:	02279793          	slli	a5,a5,0x22
ffffffe000201b58:	0377d793          	srli	a5,a5,0x37
ffffffe000201b5c:	fef43023          	sd	a5,-32(s0)
    uint64_t vpn2 = ((uint64_t)va<<25)>>55;
ffffffe000201b60:	f6043783          	ld	a5,-160(s0)
ffffffe000201b64:	01979793          	slli	a5,a5,0x19
ffffffe000201b68:	0377d793          	srli	a5,a5,0x37
ffffffe000201b6c:	fcf43023          	sd	a5,-64(s0)
    uint64_t *pgtbl_entry = &pgtbl[vpn2];
ffffffe000201b70:	fc043783          	ld	a5,-64(s0)
ffffffe000201b74:	00379793          	slli	a5,a5,0x3
ffffffe000201b78:	f6843703          	ld	a4,-152(s0)
ffffffe000201b7c:	00f707b3          	add	a5,a4,a5
ffffffe000201b80:	faf43c23          	sd	a5,-72(s0)
    uint64_t *second_pgtbl;
    //创建二级页表
    if(!(*pgtbl_entry & 0x1)) {
ffffffe000201b84:	fb843783          	ld	a5,-72(s0)
ffffffe000201b88:	0007b783          	ld	a5,0(a5)
ffffffe000201b8c:	0017f793          	andi	a5,a5,1
ffffffe000201b90:	04079c63          	bnez	a5,ffffffe000201be8 <create_mapping+0xcc>
        //这里新的kalloc出来的是虚拟地址
        uint64_t *new_pgtbl = (uint64_t *)kalloc();
ffffffe000201b94:	e29fe0ef          	jal	ffffffe0002009bc <kalloc>
ffffffe000201b98:	00050793          	mv	a5,a0
ffffffe000201b9c:	faf43823          	sd	a5,-80(s0)
        // printk("new_pgtbl = %lx\n", new_pgtbl);
        //这里存进页表项的是物理地址
        uint64_t phy_pgt = (uint64_t)((uint64_t)new_pgtbl - PA2VA_OFFSET)>>12;
ffffffe000201ba0:	fb043703          	ld	a4,-80(s0)
ffffffe000201ba4:	04100793          	li	a5,65
ffffffe000201ba8:	01f79793          	slli	a5,a5,0x1f
ffffffe000201bac:	00f707b3          	add	a5,a4,a5
ffffffe000201bb0:	00c7d793          	srli	a5,a5,0xc
ffffffe000201bb4:	faf43423          	sd	a5,-88(s0)
        // printk("phy_pgt = %lx\n", phy_pgt);
        *pgtbl_entry = phy_pgt;
ffffffe000201bb8:	fb843783          	ld	a5,-72(s0)
ffffffe000201bbc:	fa843703          	ld	a4,-88(s0)
ffffffe000201bc0:	00e7b023          	sd	a4,0(a5)
        *pgtbl_entry = (uint64_t)((*pgtbl_entry << 10) + 0x1);   
ffffffe000201bc4:	fb843783          	ld	a5,-72(s0)
ffffffe000201bc8:	0007b783          	ld	a5,0(a5)
ffffffe000201bcc:	00a79793          	slli	a5,a5,0xa
ffffffe000201bd0:	00178713          	addi	a4,a5,1
ffffffe000201bd4:	fb843783          	ld	a5,-72(s0)
ffffffe000201bd8:	00e7b023          	sd	a4,0(a5)
        second_pgtbl = new_pgtbl; 
ffffffe000201bdc:	fb043783          	ld	a5,-80(s0)
ffffffe000201be0:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201be4:	0300006f          	j	ffffffe000201c14 <create_mapping+0xf8>
    }
    //找到二级页表的物理地址，然后转化成虚拟地址去访问
    else {
        second_pgtbl = (uint64_t*)((uint64_t)(*pgtbl_entry<<10)>>20<<12);
ffffffe000201be8:	fb843783          	ld	a5,-72(s0)
ffffffe000201bec:	0007b783          	ld	a5,0(a5)
ffffffe000201bf0:	00a79793          	slli	a5,a5,0xa
ffffffe000201bf4:	0147d793          	srli	a5,a5,0x14
ffffffe000201bf8:	00c79793          	slli	a5,a5,0xc
ffffffe000201bfc:	fcf43c23          	sd	a5,-40(s0)
        second_pgtbl = (uint64_t *)((uint64_t)second_pgtbl + PA2VA_OFFSET);
ffffffe000201c00:	fd843703          	ld	a4,-40(s0)
ffffffe000201c04:	fbf00793          	li	a5,-65
ffffffe000201c08:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c0c:	00f707b3          	add	a5,a4,a5
ffffffe000201c10:	fcf43c23          	sd	a5,-40(s0)
    }
    uint64_t count = 0;
ffffffe000201c14:	fc043823          	sd	zero,-48(s0)
    while ((signed)sz > 0) {
ffffffe000201c18:	18c0006f          	j	ffffffe000201da4 <create_mapping+0x288>
        uint64_t huge_pgsize = 0x200000;//2MiB
ffffffe000201c1c:	002007b7          	lui	a5,0x200
ffffffe000201c20:	faf43023          	sd	a5,-96(s0)
        uint64_t *second_pgtbl_entry = &second_pgtbl[vpn1];
ffffffe000201c24:	fe043783          	ld	a5,-32(s0)
ffffffe000201c28:	00379793          	slli	a5,a5,0x3
ffffffe000201c2c:	fd843703          	ld	a4,-40(s0)
ffffffe000201c30:	00f707b3          	add	a5,a4,a5
ffffffe000201c34:	f8f43c23          	sd	a5,-104(s0)
        uint64_t *third_pgtbl;
        if (!(*second_pgtbl_entry & 0x1)) {
ffffffe000201c38:	f9843783          	ld	a5,-104(s0)
ffffffe000201c3c:	0007b783          	ld	a5,0(a5) # 200000 <OPENSBI_SIZE>
ffffffe000201c40:	0017f793          	andi	a5,a5,1
ffffffe000201c44:	04079c63          	bnez	a5,ffffffe000201c9c <create_mapping+0x180>
            uint64_t *new_pgtbl = (uint64_t *)kalloc();
ffffffe000201c48:	d75fe0ef          	jal	ffffffe0002009bc <kalloc>
ffffffe000201c4c:	00050793          	mv	a5,a0
ffffffe000201c50:	f8f43823          	sd	a5,-112(s0)
            uint64_t phy_pgt = (uint64_t)((uint64_t) new_pgtbl - PA2VA_OFFSET)>>12;
ffffffe000201c54:	f9043703          	ld	a4,-112(s0)
ffffffe000201c58:	04100793          	li	a5,65
ffffffe000201c5c:	01f79793          	slli	a5,a5,0x1f
ffffffe000201c60:	00f707b3          	add	a5,a4,a5
ffffffe000201c64:	00c7d793          	srli	a5,a5,0xc
ffffffe000201c68:	f8f43423          	sd	a5,-120(s0)
            *second_pgtbl_entry = phy_pgt;
ffffffe000201c6c:	f9843783          	ld	a5,-104(s0)
ffffffe000201c70:	f8843703          	ld	a4,-120(s0)
ffffffe000201c74:	00e7b023          	sd	a4,0(a5)
            *second_pgtbl_entry = (uint64_t)((*second_pgtbl_entry << 10)+0x1);
ffffffe000201c78:	f9843783          	ld	a5,-104(s0)
ffffffe000201c7c:	0007b783          	ld	a5,0(a5)
ffffffe000201c80:	00a79793          	slli	a5,a5,0xa
ffffffe000201c84:	00178713          	addi	a4,a5,1
ffffffe000201c88:	f9843783          	ld	a5,-104(s0)
ffffffe000201c8c:	00e7b023          	sd	a4,0(a5)
            third_pgtbl = new_pgtbl;
ffffffe000201c90:	f9043783          	ld	a5,-112(s0)
ffffffe000201c94:	fcf43423          	sd	a5,-56(s0)
ffffffe000201c98:	0300006f          	j	ffffffe000201cc8 <create_mapping+0x1ac>
        }
        else {
            third_pgtbl = (uint64_t*)((uint64_t)(*second_pgtbl_entry<<10)>>20<<12);
ffffffe000201c9c:	f9843783          	ld	a5,-104(s0)
ffffffe000201ca0:	0007b783          	ld	a5,0(a5)
ffffffe000201ca4:	00a79793          	slli	a5,a5,0xa
ffffffe000201ca8:	0147d793          	srli	a5,a5,0x14
ffffffe000201cac:	00c79793          	slli	a5,a5,0xc
ffffffe000201cb0:	fcf43423          	sd	a5,-56(s0)
            third_pgtbl = (uint64_t *)((uint64_t)third_pgtbl + PA2VA_OFFSET);
ffffffe000201cb4:	fc843703          	ld	a4,-56(s0)
ffffffe000201cb8:	fbf00793          	li	a5,-65
ffffffe000201cbc:	01f79793          	slli	a5,a5,0x1f
ffffffe000201cc0:	00f707b3          	add	a5,a4,a5
ffffffe000201cc4:	fcf43423          	sd	a5,-56(s0)
        }
        uint64_t entries = huge_pgsize/PGSIZE;//2MiB/4KiB=512
ffffffe000201cc8:	fa043783          	ld	a5,-96(s0)
ffffffe000201ccc:	00c7d793          	srli	a5,a5,0xc
ffffffe000201cd0:	f8f43023          	sd	a5,-128(s0)
        while((signed)sz > 0 && vpn0 < entries) {
ffffffe000201cd4:	0a80006f          	j	ffffffe000201d7c <create_mapping+0x260>
            uint64_t *third_pgtbl_entry = &third_pgtbl[vpn0];
ffffffe000201cd8:	fe843783          	ld	a5,-24(s0)
ffffffe000201cdc:	00379793          	slli	a5,a5,0x3
ffffffe000201ce0:	fc843703          	ld	a4,-56(s0)
ffffffe000201ce4:	00f707b3          	add	a5,a4,a5
ffffffe000201ce8:	f6f43c23          	sd	a5,-136(s0)
            if (!(*third_pgtbl_entry & 0x1)) {
ffffffe000201cec:	f7843783          	ld	a5,-136(s0)
ffffffe000201cf0:	0007b783          	ld	a5,0(a5)
ffffffe000201cf4:	0017f793          	andi	a5,a5,1
ffffffe000201cf8:	04079e63          	bnez	a5,ffffffe000201d54 <create_mapping+0x238>
                *third_pgtbl_entry = (uint64_t)(pa + count*PGSIZE)>>12;
ffffffe000201cfc:	fd043783          	ld	a5,-48(s0)
ffffffe000201d00:	00c79713          	slli	a4,a5,0xc
ffffffe000201d04:	f5843783          	ld	a5,-168(s0)
ffffffe000201d08:	00f707b3          	add	a5,a4,a5
ffffffe000201d0c:	00c7d713          	srli	a4,a5,0xc
ffffffe000201d10:	f7843783          	ld	a5,-136(s0)
ffffffe000201d14:	00e7b023          	sd	a4,0(a5)
                *third_pgtbl_entry = (uint64_t)((*third_pgtbl_entry << 10)+perm);
ffffffe000201d18:	f7843783          	ld	a5,-136(s0)
ffffffe000201d1c:	0007b783          	ld	a5,0(a5)
ffffffe000201d20:	00a79713          	slli	a4,a5,0xa
ffffffe000201d24:	f4843783          	ld	a5,-184(s0)
ffffffe000201d28:	00f70733          	add	a4,a4,a5
ffffffe000201d2c:	f7843783          	ld	a5,-136(s0)
ffffffe000201d30:	00e7b023          	sd	a4,0(a5)
                // third_pgtbl[vpn0] = *third_pgtbl_entry;
                count++;
ffffffe000201d34:	fd043783          	ld	a5,-48(s0)
ffffffe000201d38:	00178793          	addi	a5,a5,1
ffffffe000201d3c:	fcf43823          	sd	a5,-48(s0)
                sz -= PGSIZE;
ffffffe000201d40:	f5043703          	ld	a4,-176(s0)
ffffffe000201d44:	fffff7b7          	lui	a5,0xfffff
ffffffe000201d48:	00f707b3          	add	a5,a4,a5
ffffffe000201d4c:	f4f43823          	sd	a5,-176(s0)
ffffffe000201d50:	0200006f          	j	ffffffe000201d70 <create_mapping+0x254>
            } else {
                *third_pgtbl_entry = (uint64_t)((*third_pgtbl_entry>>10<<10)+perm);
ffffffe000201d54:	f7843783          	ld	a5,-136(s0)
ffffffe000201d58:	0007b783          	ld	a5,0(a5) # fffffffffffff000 <VM_END+0xfffff000>
ffffffe000201d5c:	c007f713          	andi	a4,a5,-1024
ffffffe000201d60:	f4843783          	ld	a5,-184(s0)
ffffffe000201d64:	00f70733          	add	a4,a4,a5
ffffffe000201d68:	f7843783          	ld	a5,-136(s0)
ffffffe000201d6c:	00e7b023          	sd	a4,0(a5)
            }
            vpn0++;
ffffffe000201d70:	fe843783          	ld	a5,-24(s0)
ffffffe000201d74:	00178793          	addi	a5,a5,1
ffffffe000201d78:	fef43423          	sd	a5,-24(s0)
        while((signed)sz > 0 && vpn0 < entries) {
ffffffe000201d7c:	f5043783          	ld	a5,-176(s0)
ffffffe000201d80:	0007879b          	sext.w	a5,a5
ffffffe000201d84:	00f05863          	blez	a5,ffffffe000201d94 <create_mapping+0x278>
ffffffe000201d88:	fe843703          	ld	a4,-24(s0)
ffffffe000201d8c:	f8043783          	ld	a5,-128(s0)
ffffffe000201d90:	f4f764e3          	bltu	a4,a5,ffffffe000201cd8 <create_mapping+0x1bc>
        }
        vpn1++;
ffffffe000201d94:	fe043783          	ld	a5,-32(s0)
ffffffe000201d98:	00178793          	addi	a5,a5,1
ffffffe000201d9c:	fef43023          	sd	a5,-32(s0)
        vpn0 = 0;
ffffffe000201da0:	fe043423          	sd	zero,-24(s0)
    while ((signed)sz > 0) {
ffffffe000201da4:	f5043783          	ld	a5,-176(s0)
ffffffe000201da8:	0007879b          	sext.w	a5,a5
ffffffe000201dac:	e6f048e3          	bgtz	a5,ffffffe000201c1c <create_mapping+0x100>
    }
    

}
ffffffe000201db0:	00000013          	nop
ffffffe000201db4:	00000013          	nop
ffffffe000201db8:	0b813083          	ld	ra,184(sp)
ffffffe000201dbc:	0b013403          	ld	s0,176(sp)
ffffffe000201dc0:	0c010113          	addi	sp,sp,192
ffffffe000201dc4:	00008067          	ret

ffffffe000201dc8 <start_kernel>:

extern void test();
extern char _stext[];
extern char _srodata[];

int start_kernel() {
ffffffe000201dc8:	ff010113          	addi	sp,sp,-16
ffffffe000201dcc:	00113423          	sd	ra,8(sp)
ffffffe000201dd0:	00813023          	sd	s0,0(sp)
ffffffe000201dd4:	01010413          	addi	s0,sp,16
    printk("2024");
ffffffe000201dd8:	00001517          	auipc	a0,0x1
ffffffe000201ddc:	3d050513          	addi	a0,a0,976 # ffffffe0002031a8 <__func__.0+0x10>
ffffffe000201de0:	715000ef          	jal	ffffffe000202cf4 <printk>
    printk(" ZJU Operating System\n");
ffffffe000201de4:	00001517          	auipc	a0,0x1
ffffffe000201de8:	3cc50513          	addi	a0,a0,972 # ffffffe0002031b0 <__func__.0+0x18>
ffffffe000201dec:	709000ef          	jal	ffffffe000202cf4 <printk>
    // printk("rodata = %c\n", _srodata[1]);
    // _stext[1] = 'X';
    // _srodata[1] = 'X';
    // printk("text after modify= %c\n", _stext[1]);
    // printk("rodata after modify= %c\n", _srodata[1]);
    schedule();
ffffffe000201df0:	c00ff0ef          	jal	ffffffe0002011f0 <schedule>
    test();
ffffffe000201df4:	01c000ef          	jal	ffffffe000201e10 <test>
    return 0;
ffffffe000201df8:	00000793          	li	a5,0
}
ffffffe000201dfc:	00078513          	mv	a0,a5
ffffffe000201e00:	00813083          	ld	ra,8(sp)
ffffffe000201e04:	00013403          	ld	s0,0(sp)
ffffffe000201e08:	01010113          	addi	sp,sp,16
ffffffe000201e0c:	00008067          	ret

ffffffe000201e10 <test>:
#include "printk.h"

void test() {
ffffffe000201e10:	fe010113          	addi	sp,sp,-32
ffffffe000201e14:	00113c23          	sd	ra,24(sp)
ffffffe000201e18:	00813823          	sd	s0,16(sp)
ffffffe000201e1c:	02010413          	addi	s0,sp,32
    int i = 0;
ffffffe000201e20:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
ffffffe000201e24:	fec42783          	lw	a5,-20(s0)
ffffffe000201e28:	0017879b          	addiw	a5,a5,1
ffffffe000201e2c:	fef42623          	sw	a5,-20(s0)
ffffffe000201e30:	fec42783          	lw	a5,-20(s0)
ffffffe000201e34:	00078713          	mv	a4,a5
ffffffe000201e38:	05f5e7b7          	lui	a5,0x5f5e
ffffffe000201e3c:	1007879b          	addiw	a5,a5,256 # 5f5e100 <OPENSBI_SIZE+0x5d5e100>
ffffffe000201e40:	02f767bb          	remw	a5,a4,a5
ffffffe000201e44:	0007879b          	sext.w	a5,a5
ffffffe000201e48:	fc079ee3          	bnez	a5,ffffffe000201e24 <test+0x14>
            printk("kernel is running!\n");
ffffffe000201e4c:	00001517          	auipc	a0,0x1
ffffffe000201e50:	37c50513          	addi	a0,a0,892 # ffffffe0002031c8 <__func__.0+0x30>
ffffffe000201e54:	6a1000ef          	jal	ffffffe000202cf4 <printk>
            i = 0;
ffffffe000201e58:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
ffffffe000201e5c:	fc9ff06f          	j	ffffffe000201e24 <test+0x14>

ffffffe000201e60 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
ffffffe000201e60:	fe010113          	addi	sp,sp,-32
ffffffe000201e64:	00113c23          	sd	ra,24(sp)
ffffffe000201e68:	00813823          	sd	s0,16(sp)
ffffffe000201e6c:	02010413          	addi	s0,sp,32
ffffffe000201e70:	00050793          	mv	a5,a0
ffffffe000201e74:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
ffffffe000201e78:	fec42783          	lw	a5,-20(s0)
ffffffe000201e7c:	0ff7f793          	zext.b	a5,a5
ffffffe000201e80:	00078513          	mv	a0,a5
ffffffe000201e84:	e90ff0ef          	jal	ffffffe000201514 <sbi_debug_console_write_byte>
    return (char)c;
ffffffe000201e88:	fec42783          	lw	a5,-20(s0)
ffffffe000201e8c:	0ff7f793          	zext.b	a5,a5
ffffffe000201e90:	0007879b          	sext.w	a5,a5
}
ffffffe000201e94:	00078513          	mv	a0,a5
ffffffe000201e98:	01813083          	ld	ra,24(sp)
ffffffe000201e9c:	01013403          	ld	s0,16(sp)
ffffffe000201ea0:	02010113          	addi	sp,sp,32
ffffffe000201ea4:	00008067          	ret

ffffffe000201ea8 <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
ffffffe000201ea8:	fe010113          	addi	sp,sp,-32
ffffffe000201eac:	00813c23          	sd	s0,24(sp)
ffffffe000201eb0:	02010413          	addi	s0,sp,32
ffffffe000201eb4:	00050793          	mv	a5,a0
ffffffe000201eb8:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
ffffffe000201ebc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ec0:	0007871b          	sext.w	a4,a5
ffffffe000201ec4:	02000793          	li	a5,32
ffffffe000201ec8:	02f70263          	beq	a4,a5,ffffffe000201eec <isspace+0x44>
ffffffe000201ecc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ed0:	0007871b          	sext.w	a4,a5
ffffffe000201ed4:	00800793          	li	a5,8
ffffffe000201ed8:	00e7de63          	bge	a5,a4,ffffffe000201ef4 <isspace+0x4c>
ffffffe000201edc:	fec42783          	lw	a5,-20(s0)
ffffffe000201ee0:	0007871b          	sext.w	a4,a5
ffffffe000201ee4:	00d00793          	li	a5,13
ffffffe000201ee8:	00e7c663          	blt	a5,a4,ffffffe000201ef4 <isspace+0x4c>
ffffffe000201eec:	00100793          	li	a5,1
ffffffe000201ef0:	0080006f          	j	ffffffe000201ef8 <isspace+0x50>
ffffffe000201ef4:	00000793          	li	a5,0
}
ffffffe000201ef8:	00078513          	mv	a0,a5
ffffffe000201efc:	01813403          	ld	s0,24(sp)
ffffffe000201f00:	02010113          	addi	sp,sp,32
ffffffe000201f04:	00008067          	ret

ffffffe000201f08 <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
ffffffe000201f08:	fb010113          	addi	sp,sp,-80
ffffffe000201f0c:	04113423          	sd	ra,72(sp)
ffffffe000201f10:	04813023          	sd	s0,64(sp)
ffffffe000201f14:	05010413          	addi	s0,sp,80
ffffffe000201f18:	fca43423          	sd	a0,-56(s0)
ffffffe000201f1c:	fcb43023          	sd	a1,-64(s0)
ffffffe000201f20:	00060793          	mv	a5,a2
ffffffe000201f24:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
ffffffe000201f28:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
ffffffe000201f2c:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
ffffffe000201f30:	fc843783          	ld	a5,-56(s0)
ffffffe000201f34:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
ffffffe000201f38:	0100006f          	j	ffffffe000201f48 <strtol+0x40>
        p++;
ffffffe000201f3c:	fd843783          	ld	a5,-40(s0)
ffffffe000201f40:	00178793          	addi	a5,a5,1
ffffffe000201f44:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
ffffffe000201f48:	fd843783          	ld	a5,-40(s0)
ffffffe000201f4c:	0007c783          	lbu	a5,0(a5)
ffffffe000201f50:	0007879b          	sext.w	a5,a5
ffffffe000201f54:	00078513          	mv	a0,a5
ffffffe000201f58:	f51ff0ef          	jal	ffffffe000201ea8 <isspace>
ffffffe000201f5c:	00050793          	mv	a5,a0
ffffffe000201f60:	fc079ee3          	bnez	a5,ffffffe000201f3c <strtol+0x34>
    }

    if (*p == '-') {
ffffffe000201f64:	fd843783          	ld	a5,-40(s0)
ffffffe000201f68:	0007c783          	lbu	a5,0(a5)
ffffffe000201f6c:	00078713          	mv	a4,a5
ffffffe000201f70:	02d00793          	li	a5,45
ffffffe000201f74:	00f71e63          	bne	a4,a5,ffffffe000201f90 <strtol+0x88>
        neg = true;
ffffffe000201f78:	00100793          	li	a5,1
ffffffe000201f7c:	fef403a3          	sb	a5,-25(s0)
        p++;
ffffffe000201f80:	fd843783          	ld	a5,-40(s0)
ffffffe000201f84:	00178793          	addi	a5,a5,1
ffffffe000201f88:	fcf43c23          	sd	a5,-40(s0)
ffffffe000201f8c:	0240006f          	j	ffffffe000201fb0 <strtol+0xa8>
    } else if (*p == '+') {
ffffffe000201f90:	fd843783          	ld	a5,-40(s0)
ffffffe000201f94:	0007c783          	lbu	a5,0(a5)
ffffffe000201f98:	00078713          	mv	a4,a5
ffffffe000201f9c:	02b00793          	li	a5,43
ffffffe000201fa0:	00f71863          	bne	a4,a5,ffffffe000201fb0 <strtol+0xa8>
        p++;
ffffffe000201fa4:	fd843783          	ld	a5,-40(s0)
ffffffe000201fa8:	00178793          	addi	a5,a5,1
ffffffe000201fac:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
ffffffe000201fb0:	fbc42783          	lw	a5,-68(s0)
ffffffe000201fb4:	0007879b          	sext.w	a5,a5
ffffffe000201fb8:	06079c63          	bnez	a5,ffffffe000202030 <strtol+0x128>
        if (*p == '0') {
ffffffe000201fbc:	fd843783          	ld	a5,-40(s0)
ffffffe000201fc0:	0007c783          	lbu	a5,0(a5)
ffffffe000201fc4:	00078713          	mv	a4,a5
ffffffe000201fc8:	03000793          	li	a5,48
ffffffe000201fcc:	04f71e63          	bne	a4,a5,ffffffe000202028 <strtol+0x120>
            p++;
ffffffe000201fd0:	fd843783          	ld	a5,-40(s0)
ffffffe000201fd4:	00178793          	addi	a5,a5,1
ffffffe000201fd8:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
ffffffe000201fdc:	fd843783          	ld	a5,-40(s0)
ffffffe000201fe0:	0007c783          	lbu	a5,0(a5)
ffffffe000201fe4:	00078713          	mv	a4,a5
ffffffe000201fe8:	07800793          	li	a5,120
ffffffe000201fec:	00f70c63          	beq	a4,a5,ffffffe000202004 <strtol+0xfc>
ffffffe000201ff0:	fd843783          	ld	a5,-40(s0)
ffffffe000201ff4:	0007c783          	lbu	a5,0(a5)
ffffffe000201ff8:	00078713          	mv	a4,a5
ffffffe000201ffc:	05800793          	li	a5,88
ffffffe000202000:	00f71e63          	bne	a4,a5,ffffffe00020201c <strtol+0x114>
                base = 16;
ffffffe000202004:	01000793          	li	a5,16
ffffffe000202008:	faf42e23          	sw	a5,-68(s0)
                p++;
ffffffe00020200c:	fd843783          	ld	a5,-40(s0)
ffffffe000202010:	00178793          	addi	a5,a5,1
ffffffe000202014:	fcf43c23          	sd	a5,-40(s0)
ffffffe000202018:	0180006f          	j	ffffffe000202030 <strtol+0x128>
            } else {
                base = 8;
ffffffe00020201c:	00800793          	li	a5,8
ffffffe000202020:	faf42e23          	sw	a5,-68(s0)
ffffffe000202024:	00c0006f          	j	ffffffe000202030 <strtol+0x128>
            }
        } else {
            base = 10;
ffffffe000202028:	00a00793          	li	a5,10
ffffffe00020202c:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
ffffffe000202030:	fd843783          	ld	a5,-40(s0)
ffffffe000202034:	0007c783          	lbu	a5,0(a5)
ffffffe000202038:	00078713          	mv	a4,a5
ffffffe00020203c:	02f00793          	li	a5,47
ffffffe000202040:	02e7f863          	bgeu	a5,a4,ffffffe000202070 <strtol+0x168>
ffffffe000202044:	fd843783          	ld	a5,-40(s0)
ffffffe000202048:	0007c783          	lbu	a5,0(a5)
ffffffe00020204c:	00078713          	mv	a4,a5
ffffffe000202050:	03900793          	li	a5,57
ffffffe000202054:	00e7ee63          	bltu	a5,a4,ffffffe000202070 <strtol+0x168>
            digit = *p - '0';
ffffffe000202058:	fd843783          	ld	a5,-40(s0)
ffffffe00020205c:	0007c783          	lbu	a5,0(a5)
ffffffe000202060:	0007879b          	sext.w	a5,a5
ffffffe000202064:	fd07879b          	addiw	a5,a5,-48
ffffffe000202068:	fcf42a23          	sw	a5,-44(s0)
ffffffe00020206c:	0800006f          	j	ffffffe0002020ec <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
ffffffe000202070:	fd843783          	ld	a5,-40(s0)
ffffffe000202074:	0007c783          	lbu	a5,0(a5)
ffffffe000202078:	00078713          	mv	a4,a5
ffffffe00020207c:	06000793          	li	a5,96
ffffffe000202080:	02e7f863          	bgeu	a5,a4,ffffffe0002020b0 <strtol+0x1a8>
ffffffe000202084:	fd843783          	ld	a5,-40(s0)
ffffffe000202088:	0007c783          	lbu	a5,0(a5)
ffffffe00020208c:	00078713          	mv	a4,a5
ffffffe000202090:	07a00793          	li	a5,122
ffffffe000202094:	00e7ee63          	bltu	a5,a4,ffffffe0002020b0 <strtol+0x1a8>
            digit = *p - ('a' - 10);
ffffffe000202098:	fd843783          	ld	a5,-40(s0)
ffffffe00020209c:	0007c783          	lbu	a5,0(a5)
ffffffe0002020a0:	0007879b          	sext.w	a5,a5
ffffffe0002020a4:	fa97879b          	addiw	a5,a5,-87
ffffffe0002020a8:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002020ac:	0400006f          	j	ffffffe0002020ec <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
ffffffe0002020b0:	fd843783          	ld	a5,-40(s0)
ffffffe0002020b4:	0007c783          	lbu	a5,0(a5)
ffffffe0002020b8:	00078713          	mv	a4,a5
ffffffe0002020bc:	04000793          	li	a5,64
ffffffe0002020c0:	06e7f863          	bgeu	a5,a4,ffffffe000202130 <strtol+0x228>
ffffffe0002020c4:	fd843783          	ld	a5,-40(s0)
ffffffe0002020c8:	0007c783          	lbu	a5,0(a5)
ffffffe0002020cc:	00078713          	mv	a4,a5
ffffffe0002020d0:	05a00793          	li	a5,90
ffffffe0002020d4:	04e7ee63          	bltu	a5,a4,ffffffe000202130 <strtol+0x228>
            digit = *p - ('A' - 10);
ffffffe0002020d8:	fd843783          	ld	a5,-40(s0)
ffffffe0002020dc:	0007c783          	lbu	a5,0(a5)
ffffffe0002020e0:	0007879b          	sext.w	a5,a5
ffffffe0002020e4:	fc97879b          	addiw	a5,a5,-55
ffffffe0002020e8:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
ffffffe0002020ec:	fd442783          	lw	a5,-44(s0)
ffffffe0002020f0:	00078713          	mv	a4,a5
ffffffe0002020f4:	fbc42783          	lw	a5,-68(s0)
ffffffe0002020f8:	0007071b          	sext.w	a4,a4
ffffffe0002020fc:	0007879b          	sext.w	a5,a5
ffffffe000202100:	02f75663          	bge	a4,a5,ffffffe00020212c <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
ffffffe000202104:	fbc42703          	lw	a4,-68(s0)
ffffffe000202108:	fe843783          	ld	a5,-24(s0)
ffffffe00020210c:	02f70733          	mul	a4,a4,a5
ffffffe000202110:	fd442783          	lw	a5,-44(s0)
ffffffe000202114:	00f707b3          	add	a5,a4,a5
ffffffe000202118:	fef43423          	sd	a5,-24(s0)
        p++;
ffffffe00020211c:	fd843783          	ld	a5,-40(s0)
ffffffe000202120:	00178793          	addi	a5,a5,1
ffffffe000202124:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
ffffffe000202128:	f09ff06f          	j	ffffffe000202030 <strtol+0x128>
            break;
ffffffe00020212c:	00000013          	nop
    }

    if (endptr) {
ffffffe000202130:	fc043783          	ld	a5,-64(s0)
ffffffe000202134:	00078863          	beqz	a5,ffffffe000202144 <strtol+0x23c>
        *endptr = (char *)p;
ffffffe000202138:	fc043783          	ld	a5,-64(s0)
ffffffe00020213c:	fd843703          	ld	a4,-40(s0)
ffffffe000202140:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
ffffffe000202144:	fe744783          	lbu	a5,-25(s0)
ffffffe000202148:	0ff7f793          	zext.b	a5,a5
ffffffe00020214c:	00078863          	beqz	a5,ffffffe00020215c <strtol+0x254>
ffffffe000202150:	fe843783          	ld	a5,-24(s0)
ffffffe000202154:	40f007b3          	neg	a5,a5
ffffffe000202158:	0080006f          	j	ffffffe000202160 <strtol+0x258>
ffffffe00020215c:	fe843783          	ld	a5,-24(s0)
}
ffffffe000202160:	00078513          	mv	a0,a5
ffffffe000202164:	04813083          	ld	ra,72(sp)
ffffffe000202168:	04013403          	ld	s0,64(sp)
ffffffe00020216c:	05010113          	addi	sp,sp,80
ffffffe000202170:	00008067          	ret

ffffffe000202174 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
ffffffe000202174:	fd010113          	addi	sp,sp,-48
ffffffe000202178:	02113423          	sd	ra,40(sp)
ffffffe00020217c:	02813023          	sd	s0,32(sp)
ffffffe000202180:	03010413          	addi	s0,sp,48
ffffffe000202184:	fca43c23          	sd	a0,-40(s0)
ffffffe000202188:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
ffffffe00020218c:	fd043783          	ld	a5,-48(s0)
ffffffe000202190:	00079863          	bnez	a5,ffffffe0002021a0 <puts_wo_nl+0x2c>
        s = "(null)";
ffffffe000202194:	00001797          	auipc	a5,0x1
ffffffe000202198:	04c78793          	addi	a5,a5,76 # ffffffe0002031e0 <__func__.0+0x48>
ffffffe00020219c:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
ffffffe0002021a0:	fd043783          	ld	a5,-48(s0)
ffffffe0002021a4:	fef43423          	sd	a5,-24(s0)
    while (*p) {
ffffffe0002021a8:	0240006f          	j	ffffffe0002021cc <puts_wo_nl+0x58>
        putch(*p++);
ffffffe0002021ac:	fe843783          	ld	a5,-24(s0)
ffffffe0002021b0:	00178713          	addi	a4,a5,1
ffffffe0002021b4:	fee43423          	sd	a4,-24(s0)
ffffffe0002021b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002021bc:	0007871b          	sext.w	a4,a5
ffffffe0002021c0:	fd843783          	ld	a5,-40(s0)
ffffffe0002021c4:	00070513          	mv	a0,a4
ffffffe0002021c8:	000780e7          	jalr	a5
    while (*p) {
ffffffe0002021cc:	fe843783          	ld	a5,-24(s0)
ffffffe0002021d0:	0007c783          	lbu	a5,0(a5)
ffffffe0002021d4:	fc079ce3          	bnez	a5,ffffffe0002021ac <puts_wo_nl+0x38>
    }
    return p - s;
ffffffe0002021d8:	fe843703          	ld	a4,-24(s0)
ffffffe0002021dc:	fd043783          	ld	a5,-48(s0)
ffffffe0002021e0:	40f707b3          	sub	a5,a4,a5
ffffffe0002021e4:	0007879b          	sext.w	a5,a5
}
ffffffe0002021e8:	00078513          	mv	a0,a5
ffffffe0002021ec:	02813083          	ld	ra,40(sp)
ffffffe0002021f0:	02013403          	ld	s0,32(sp)
ffffffe0002021f4:	03010113          	addi	sp,sp,48
ffffffe0002021f8:	00008067          	ret

ffffffe0002021fc <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
ffffffe0002021fc:	f9010113          	addi	sp,sp,-112
ffffffe000202200:	06113423          	sd	ra,104(sp)
ffffffe000202204:	06813023          	sd	s0,96(sp)
ffffffe000202208:	07010413          	addi	s0,sp,112
ffffffe00020220c:	faa43423          	sd	a0,-88(s0)
ffffffe000202210:	fab43023          	sd	a1,-96(s0)
ffffffe000202214:	00060793          	mv	a5,a2
ffffffe000202218:	f8d43823          	sd	a3,-112(s0)
ffffffe00020221c:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
ffffffe000202220:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202224:	0ff7f793          	zext.b	a5,a5
ffffffe000202228:	02078663          	beqz	a5,ffffffe000202254 <print_dec_int+0x58>
ffffffe00020222c:	fa043703          	ld	a4,-96(s0)
ffffffe000202230:	fff00793          	li	a5,-1
ffffffe000202234:	03f79793          	slli	a5,a5,0x3f
ffffffe000202238:	00f71e63          	bne	a4,a5,ffffffe000202254 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
ffffffe00020223c:	00001597          	auipc	a1,0x1
ffffffe000202240:	fac58593          	addi	a1,a1,-84 # ffffffe0002031e8 <__func__.0+0x50>
ffffffe000202244:	fa843503          	ld	a0,-88(s0)
ffffffe000202248:	f2dff0ef          	jal	ffffffe000202174 <puts_wo_nl>
ffffffe00020224c:	00050793          	mv	a5,a0
ffffffe000202250:	2a00006f          	j	ffffffe0002024f0 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
ffffffe000202254:	f9043783          	ld	a5,-112(s0)
ffffffe000202258:	00c7a783          	lw	a5,12(a5)
ffffffe00020225c:	00079a63          	bnez	a5,ffffffe000202270 <print_dec_int+0x74>
ffffffe000202260:	fa043783          	ld	a5,-96(s0)
ffffffe000202264:	00079663          	bnez	a5,ffffffe000202270 <print_dec_int+0x74>
        return 0;
ffffffe000202268:	00000793          	li	a5,0
ffffffe00020226c:	2840006f          	j	ffffffe0002024f0 <print_dec_int+0x2f4>
    }

    bool neg = false;
ffffffe000202270:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
ffffffe000202274:	f9f44783          	lbu	a5,-97(s0)
ffffffe000202278:	0ff7f793          	zext.b	a5,a5
ffffffe00020227c:	02078063          	beqz	a5,ffffffe00020229c <print_dec_int+0xa0>
ffffffe000202280:	fa043783          	ld	a5,-96(s0)
ffffffe000202284:	0007dc63          	bgez	a5,ffffffe00020229c <print_dec_int+0xa0>
        neg = true;
ffffffe000202288:	00100793          	li	a5,1
ffffffe00020228c:	fef407a3          	sb	a5,-17(s0)
        num = -num;
ffffffe000202290:	fa043783          	ld	a5,-96(s0)
ffffffe000202294:	40f007b3          	neg	a5,a5
ffffffe000202298:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
ffffffe00020229c:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
ffffffe0002022a0:	f9f44783          	lbu	a5,-97(s0)
ffffffe0002022a4:	0ff7f793          	zext.b	a5,a5
ffffffe0002022a8:	02078863          	beqz	a5,ffffffe0002022d8 <print_dec_int+0xdc>
ffffffe0002022ac:	fef44783          	lbu	a5,-17(s0)
ffffffe0002022b0:	0ff7f793          	zext.b	a5,a5
ffffffe0002022b4:	00079e63          	bnez	a5,ffffffe0002022d0 <print_dec_int+0xd4>
ffffffe0002022b8:	f9043783          	ld	a5,-112(s0)
ffffffe0002022bc:	0057c783          	lbu	a5,5(a5)
ffffffe0002022c0:	00079863          	bnez	a5,ffffffe0002022d0 <print_dec_int+0xd4>
ffffffe0002022c4:	f9043783          	ld	a5,-112(s0)
ffffffe0002022c8:	0047c783          	lbu	a5,4(a5)
ffffffe0002022cc:	00078663          	beqz	a5,ffffffe0002022d8 <print_dec_int+0xdc>
ffffffe0002022d0:	00100793          	li	a5,1
ffffffe0002022d4:	0080006f          	j	ffffffe0002022dc <print_dec_int+0xe0>
ffffffe0002022d8:	00000793          	li	a5,0
ffffffe0002022dc:	fcf40ba3          	sb	a5,-41(s0)
ffffffe0002022e0:	fd744783          	lbu	a5,-41(s0)
ffffffe0002022e4:	0017f793          	andi	a5,a5,1
ffffffe0002022e8:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
ffffffe0002022ec:	fa043703          	ld	a4,-96(s0)
ffffffe0002022f0:	00a00793          	li	a5,10
ffffffe0002022f4:	02f777b3          	remu	a5,a4,a5
ffffffe0002022f8:	0ff7f713          	zext.b	a4,a5
ffffffe0002022fc:	fe842783          	lw	a5,-24(s0)
ffffffe000202300:	0017869b          	addiw	a3,a5,1
ffffffe000202304:	fed42423          	sw	a3,-24(s0)
ffffffe000202308:	0307071b          	addiw	a4,a4,48
ffffffe00020230c:	0ff77713          	zext.b	a4,a4
ffffffe000202310:	ff078793          	addi	a5,a5,-16
ffffffe000202314:	008787b3          	add	a5,a5,s0
ffffffe000202318:	fce78423          	sb	a4,-56(a5)
        num /= 10;
ffffffe00020231c:	fa043703          	ld	a4,-96(s0)
ffffffe000202320:	00a00793          	li	a5,10
ffffffe000202324:	02f757b3          	divu	a5,a4,a5
ffffffe000202328:	faf43023          	sd	a5,-96(s0)
    } while (num);
ffffffe00020232c:	fa043783          	ld	a5,-96(s0)
ffffffe000202330:	fa079ee3          	bnez	a5,ffffffe0002022ec <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
ffffffe000202334:	f9043783          	ld	a5,-112(s0)
ffffffe000202338:	00c7a783          	lw	a5,12(a5)
ffffffe00020233c:	00078713          	mv	a4,a5
ffffffe000202340:	fff00793          	li	a5,-1
ffffffe000202344:	02f71063          	bne	a4,a5,ffffffe000202364 <print_dec_int+0x168>
ffffffe000202348:	f9043783          	ld	a5,-112(s0)
ffffffe00020234c:	0037c783          	lbu	a5,3(a5)
ffffffe000202350:	00078a63          	beqz	a5,ffffffe000202364 <print_dec_int+0x168>
        flags->prec = flags->width;
ffffffe000202354:	f9043783          	ld	a5,-112(s0)
ffffffe000202358:	0087a703          	lw	a4,8(a5)
ffffffe00020235c:	f9043783          	ld	a5,-112(s0)
ffffffe000202360:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
ffffffe000202364:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe000202368:	f9043783          	ld	a5,-112(s0)
ffffffe00020236c:	0087a703          	lw	a4,8(a5)
ffffffe000202370:	fe842783          	lw	a5,-24(s0)
ffffffe000202374:	fcf42823          	sw	a5,-48(s0)
ffffffe000202378:	f9043783          	ld	a5,-112(s0)
ffffffe00020237c:	00c7a783          	lw	a5,12(a5)
ffffffe000202380:	fcf42623          	sw	a5,-52(s0)
ffffffe000202384:	fd042783          	lw	a5,-48(s0)
ffffffe000202388:	00078593          	mv	a1,a5
ffffffe00020238c:	fcc42783          	lw	a5,-52(s0)
ffffffe000202390:	00078613          	mv	a2,a5
ffffffe000202394:	0006069b          	sext.w	a3,a2
ffffffe000202398:	0005879b          	sext.w	a5,a1
ffffffe00020239c:	00f6d463          	bge	a3,a5,ffffffe0002023a4 <print_dec_int+0x1a8>
ffffffe0002023a0:	00058613          	mv	a2,a1
ffffffe0002023a4:	0006079b          	sext.w	a5,a2
ffffffe0002023a8:	40f707bb          	subw	a5,a4,a5
ffffffe0002023ac:	0007871b          	sext.w	a4,a5
ffffffe0002023b0:	fd744783          	lbu	a5,-41(s0)
ffffffe0002023b4:	0007879b          	sext.w	a5,a5
ffffffe0002023b8:	40f707bb          	subw	a5,a4,a5
ffffffe0002023bc:	fef42023          	sw	a5,-32(s0)
ffffffe0002023c0:	0280006f          	j	ffffffe0002023e8 <print_dec_int+0x1ec>
        putch(' ');
ffffffe0002023c4:	fa843783          	ld	a5,-88(s0)
ffffffe0002023c8:	02000513          	li	a0,32
ffffffe0002023cc:	000780e7          	jalr	a5
        ++written;
ffffffe0002023d0:	fe442783          	lw	a5,-28(s0)
ffffffe0002023d4:	0017879b          	addiw	a5,a5,1
ffffffe0002023d8:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
ffffffe0002023dc:	fe042783          	lw	a5,-32(s0)
ffffffe0002023e0:	fff7879b          	addiw	a5,a5,-1
ffffffe0002023e4:	fef42023          	sw	a5,-32(s0)
ffffffe0002023e8:	fe042783          	lw	a5,-32(s0)
ffffffe0002023ec:	0007879b          	sext.w	a5,a5
ffffffe0002023f0:	fcf04ae3          	bgtz	a5,ffffffe0002023c4 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
ffffffe0002023f4:	fd744783          	lbu	a5,-41(s0)
ffffffe0002023f8:	0ff7f793          	zext.b	a5,a5
ffffffe0002023fc:	04078463          	beqz	a5,ffffffe000202444 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
ffffffe000202400:	fef44783          	lbu	a5,-17(s0)
ffffffe000202404:	0ff7f793          	zext.b	a5,a5
ffffffe000202408:	00078663          	beqz	a5,ffffffe000202414 <print_dec_int+0x218>
ffffffe00020240c:	02d00793          	li	a5,45
ffffffe000202410:	01c0006f          	j	ffffffe00020242c <print_dec_int+0x230>
ffffffe000202414:	f9043783          	ld	a5,-112(s0)
ffffffe000202418:	0057c783          	lbu	a5,5(a5)
ffffffe00020241c:	00078663          	beqz	a5,ffffffe000202428 <print_dec_int+0x22c>
ffffffe000202420:	02b00793          	li	a5,43
ffffffe000202424:	0080006f          	j	ffffffe00020242c <print_dec_int+0x230>
ffffffe000202428:	02000793          	li	a5,32
ffffffe00020242c:	fa843703          	ld	a4,-88(s0)
ffffffe000202430:	00078513          	mv	a0,a5
ffffffe000202434:	000700e7          	jalr	a4
        ++written;
ffffffe000202438:	fe442783          	lw	a5,-28(s0)
ffffffe00020243c:	0017879b          	addiw	a5,a5,1
ffffffe000202440:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202444:	fe842783          	lw	a5,-24(s0)
ffffffe000202448:	fcf42e23          	sw	a5,-36(s0)
ffffffe00020244c:	0280006f          	j	ffffffe000202474 <print_dec_int+0x278>
        putch('0');
ffffffe000202450:	fa843783          	ld	a5,-88(s0)
ffffffe000202454:	03000513          	li	a0,48
ffffffe000202458:	000780e7          	jalr	a5
        ++written;
ffffffe00020245c:	fe442783          	lw	a5,-28(s0)
ffffffe000202460:	0017879b          	addiw	a5,a5,1
ffffffe000202464:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
ffffffe000202468:	fdc42783          	lw	a5,-36(s0)
ffffffe00020246c:	0017879b          	addiw	a5,a5,1
ffffffe000202470:	fcf42e23          	sw	a5,-36(s0)
ffffffe000202474:	f9043783          	ld	a5,-112(s0)
ffffffe000202478:	00c7a703          	lw	a4,12(a5)
ffffffe00020247c:	fd744783          	lbu	a5,-41(s0)
ffffffe000202480:	0007879b          	sext.w	a5,a5
ffffffe000202484:	40f707bb          	subw	a5,a4,a5
ffffffe000202488:	0007871b          	sext.w	a4,a5
ffffffe00020248c:	fdc42783          	lw	a5,-36(s0)
ffffffe000202490:	0007879b          	sext.w	a5,a5
ffffffe000202494:	fae7cee3          	blt	a5,a4,ffffffe000202450 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe000202498:	fe842783          	lw	a5,-24(s0)
ffffffe00020249c:	fff7879b          	addiw	a5,a5,-1
ffffffe0002024a0:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002024a4:	03c0006f          	j	ffffffe0002024e0 <print_dec_int+0x2e4>
        putch(buf[i]);
ffffffe0002024a8:	fd842783          	lw	a5,-40(s0)
ffffffe0002024ac:	ff078793          	addi	a5,a5,-16
ffffffe0002024b0:	008787b3          	add	a5,a5,s0
ffffffe0002024b4:	fc87c783          	lbu	a5,-56(a5)
ffffffe0002024b8:	0007871b          	sext.w	a4,a5
ffffffe0002024bc:	fa843783          	ld	a5,-88(s0)
ffffffe0002024c0:	00070513          	mv	a0,a4
ffffffe0002024c4:	000780e7          	jalr	a5
        ++written;
ffffffe0002024c8:	fe442783          	lw	a5,-28(s0)
ffffffe0002024cc:	0017879b          	addiw	a5,a5,1
ffffffe0002024d0:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
ffffffe0002024d4:	fd842783          	lw	a5,-40(s0)
ffffffe0002024d8:	fff7879b          	addiw	a5,a5,-1
ffffffe0002024dc:	fcf42c23          	sw	a5,-40(s0)
ffffffe0002024e0:	fd842783          	lw	a5,-40(s0)
ffffffe0002024e4:	0007879b          	sext.w	a5,a5
ffffffe0002024e8:	fc07d0e3          	bgez	a5,ffffffe0002024a8 <print_dec_int+0x2ac>
    }

    return written;
ffffffe0002024ec:	fe442783          	lw	a5,-28(s0)
}
ffffffe0002024f0:	00078513          	mv	a0,a5
ffffffe0002024f4:	06813083          	ld	ra,104(sp)
ffffffe0002024f8:	06013403          	ld	s0,96(sp)
ffffffe0002024fc:	07010113          	addi	sp,sp,112
ffffffe000202500:	00008067          	ret

ffffffe000202504 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
ffffffe000202504:	f4010113          	addi	sp,sp,-192
ffffffe000202508:	0a113c23          	sd	ra,184(sp)
ffffffe00020250c:	0a813823          	sd	s0,176(sp)
ffffffe000202510:	0c010413          	addi	s0,sp,192
ffffffe000202514:	f4a43c23          	sd	a0,-168(s0)
ffffffe000202518:	f4b43823          	sd	a1,-176(s0)
ffffffe00020251c:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
ffffffe000202520:	f8043023          	sd	zero,-128(s0)
ffffffe000202524:	f8043423          	sd	zero,-120(s0)

    int written = 0;
ffffffe000202528:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
ffffffe00020252c:	7a40006f          	j	ffffffe000202cd0 <vprintfmt+0x7cc>
        if (flags.in_format) {
ffffffe000202530:	f8044783          	lbu	a5,-128(s0)
ffffffe000202534:	72078e63          	beqz	a5,ffffffe000202c70 <vprintfmt+0x76c>
            if (*fmt == '#') {
ffffffe000202538:	f5043783          	ld	a5,-176(s0)
ffffffe00020253c:	0007c783          	lbu	a5,0(a5)
ffffffe000202540:	00078713          	mv	a4,a5
ffffffe000202544:	02300793          	li	a5,35
ffffffe000202548:	00f71863          	bne	a4,a5,ffffffe000202558 <vprintfmt+0x54>
                flags.sharpflag = true;
ffffffe00020254c:	00100793          	li	a5,1
ffffffe000202550:	f8f40123          	sb	a5,-126(s0)
ffffffe000202554:	7700006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
ffffffe000202558:	f5043783          	ld	a5,-176(s0)
ffffffe00020255c:	0007c783          	lbu	a5,0(a5)
ffffffe000202560:	00078713          	mv	a4,a5
ffffffe000202564:	03000793          	li	a5,48
ffffffe000202568:	00f71863          	bne	a4,a5,ffffffe000202578 <vprintfmt+0x74>
                flags.zeroflag = true;
ffffffe00020256c:	00100793          	li	a5,1
ffffffe000202570:	f8f401a3          	sb	a5,-125(s0)
ffffffe000202574:	7500006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
ffffffe000202578:	f5043783          	ld	a5,-176(s0)
ffffffe00020257c:	0007c783          	lbu	a5,0(a5)
ffffffe000202580:	00078713          	mv	a4,a5
ffffffe000202584:	06c00793          	li	a5,108
ffffffe000202588:	04f70063          	beq	a4,a5,ffffffe0002025c8 <vprintfmt+0xc4>
ffffffe00020258c:	f5043783          	ld	a5,-176(s0)
ffffffe000202590:	0007c783          	lbu	a5,0(a5)
ffffffe000202594:	00078713          	mv	a4,a5
ffffffe000202598:	07a00793          	li	a5,122
ffffffe00020259c:	02f70663          	beq	a4,a5,ffffffe0002025c8 <vprintfmt+0xc4>
ffffffe0002025a0:	f5043783          	ld	a5,-176(s0)
ffffffe0002025a4:	0007c783          	lbu	a5,0(a5)
ffffffe0002025a8:	00078713          	mv	a4,a5
ffffffe0002025ac:	07400793          	li	a5,116
ffffffe0002025b0:	00f70c63          	beq	a4,a5,ffffffe0002025c8 <vprintfmt+0xc4>
ffffffe0002025b4:	f5043783          	ld	a5,-176(s0)
ffffffe0002025b8:	0007c783          	lbu	a5,0(a5)
ffffffe0002025bc:	00078713          	mv	a4,a5
ffffffe0002025c0:	06a00793          	li	a5,106
ffffffe0002025c4:	00f71863          	bne	a4,a5,ffffffe0002025d4 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
ffffffe0002025c8:	00100793          	li	a5,1
ffffffe0002025cc:	f8f400a3          	sb	a5,-127(s0)
ffffffe0002025d0:	6f40006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
ffffffe0002025d4:	f5043783          	ld	a5,-176(s0)
ffffffe0002025d8:	0007c783          	lbu	a5,0(a5)
ffffffe0002025dc:	00078713          	mv	a4,a5
ffffffe0002025e0:	02b00793          	li	a5,43
ffffffe0002025e4:	00f71863          	bne	a4,a5,ffffffe0002025f4 <vprintfmt+0xf0>
                flags.sign = true;
ffffffe0002025e8:	00100793          	li	a5,1
ffffffe0002025ec:	f8f402a3          	sb	a5,-123(s0)
ffffffe0002025f0:	6d40006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
ffffffe0002025f4:	f5043783          	ld	a5,-176(s0)
ffffffe0002025f8:	0007c783          	lbu	a5,0(a5)
ffffffe0002025fc:	00078713          	mv	a4,a5
ffffffe000202600:	02000793          	li	a5,32
ffffffe000202604:	00f71863          	bne	a4,a5,ffffffe000202614 <vprintfmt+0x110>
                flags.spaceflag = true;
ffffffe000202608:	00100793          	li	a5,1
ffffffe00020260c:	f8f40223          	sb	a5,-124(s0)
ffffffe000202610:	6b40006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
ffffffe000202614:	f5043783          	ld	a5,-176(s0)
ffffffe000202618:	0007c783          	lbu	a5,0(a5)
ffffffe00020261c:	00078713          	mv	a4,a5
ffffffe000202620:	02a00793          	li	a5,42
ffffffe000202624:	00f71e63          	bne	a4,a5,ffffffe000202640 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
ffffffe000202628:	f4843783          	ld	a5,-184(s0)
ffffffe00020262c:	00878713          	addi	a4,a5,8
ffffffe000202630:	f4e43423          	sd	a4,-184(s0)
ffffffe000202634:	0007a783          	lw	a5,0(a5)
ffffffe000202638:	f8f42423          	sw	a5,-120(s0)
ffffffe00020263c:	6880006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
ffffffe000202640:	f5043783          	ld	a5,-176(s0)
ffffffe000202644:	0007c783          	lbu	a5,0(a5)
ffffffe000202648:	00078713          	mv	a4,a5
ffffffe00020264c:	03000793          	li	a5,48
ffffffe000202650:	04e7f663          	bgeu	a5,a4,ffffffe00020269c <vprintfmt+0x198>
ffffffe000202654:	f5043783          	ld	a5,-176(s0)
ffffffe000202658:	0007c783          	lbu	a5,0(a5)
ffffffe00020265c:	00078713          	mv	a4,a5
ffffffe000202660:	03900793          	li	a5,57
ffffffe000202664:	02e7ec63          	bltu	a5,a4,ffffffe00020269c <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
ffffffe000202668:	f5043783          	ld	a5,-176(s0)
ffffffe00020266c:	f5040713          	addi	a4,s0,-176
ffffffe000202670:	00a00613          	li	a2,10
ffffffe000202674:	00070593          	mv	a1,a4
ffffffe000202678:	00078513          	mv	a0,a5
ffffffe00020267c:	88dff0ef          	jal	ffffffe000201f08 <strtol>
ffffffe000202680:	00050793          	mv	a5,a0
ffffffe000202684:	0007879b          	sext.w	a5,a5
ffffffe000202688:	f8f42423          	sw	a5,-120(s0)
                fmt--;
ffffffe00020268c:	f5043783          	ld	a5,-176(s0)
ffffffe000202690:	fff78793          	addi	a5,a5,-1
ffffffe000202694:	f4f43823          	sd	a5,-176(s0)
ffffffe000202698:	62c0006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
ffffffe00020269c:	f5043783          	ld	a5,-176(s0)
ffffffe0002026a0:	0007c783          	lbu	a5,0(a5)
ffffffe0002026a4:	00078713          	mv	a4,a5
ffffffe0002026a8:	02e00793          	li	a5,46
ffffffe0002026ac:	06f71863          	bne	a4,a5,ffffffe00020271c <vprintfmt+0x218>
                fmt++;
ffffffe0002026b0:	f5043783          	ld	a5,-176(s0)
ffffffe0002026b4:	00178793          	addi	a5,a5,1
ffffffe0002026b8:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
ffffffe0002026bc:	f5043783          	ld	a5,-176(s0)
ffffffe0002026c0:	0007c783          	lbu	a5,0(a5)
ffffffe0002026c4:	00078713          	mv	a4,a5
ffffffe0002026c8:	02a00793          	li	a5,42
ffffffe0002026cc:	00f71e63          	bne	a4,a5,ffffffe0002026e8 <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
ffffffe0002026d0:	f4843783          	ld	a5,-184(s0)
ffffffe0002026d4:	00878713          	addi	a4,a5,8
ffffffe0002026d8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002026dc:	0007a783          	lw	a5,0(a5)
ffffffe0002026e0:	f8f42623          	sw	a5,-116(s0)
ffffffe0002026e4:	5e00006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
ffffffe0002026e8:	f5043783          	ld	a5,-176(s0)
ffffffe0002026ec:	f5040713          	addi	a4,s0,-176
ffffffe0002026f0:	00a00613          	li	a2,10
ffffffe0002026f4:	00070593          	mv	a1,a4
ffffffe0002026f8:	00078513          	mv	a0,a5
ffffffe0002026fc:	80dff0ef          	jal	ffffffe000201f08 <strtol>
ffffffe000202700:	00050793          	mv	a5,a0
ffffffe000202704:	0007879b          	sext.w	a5,a5
ffffffe000202708:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
ffffffe00020270c:	f5043783          	ld	a5,-176(s0)
ffffffe000202710:	fff78793          	addi	a5,a5,-1
ffffffe000202714:	f4f43823          	sd	a5,-176(s0)
ffffffe000202718:	5ac0006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe00020271c:	f5043783          	ld	a5,-176(s0)
ffffffe000202720:	0007c783          	lbu	a5,0(a5)
ffffffe000202724:	00078713          	mv	a4,a5
ffffffe000202728:	07800793          	li	a5,120
ffffffe00020272c:	02f70663          	beq	a4,a5,ffffffe000202758 <vprintfmt+0x254>
ffffffe000202730:	f5043783          	ld	a5,-176(s0)
ffffffe000202734:	0007c783          	lbu	a5,0(a5)
ffffffe000202738:	00078713          	mv	a4,a5
ffffffe00020273c:	05800793          	li	a5,88
ffffffe000202740:	00f70c63          	beq	a4,a5,ffffffe000202758 <vprintfmt+0x254>
ffffffe000202744:	f5043783          	ld	a5,-176(s0)
ffffffe000202748:	0007c783          	lbu	a5,0(a5)
ffffffe00020274c:	00078713          	mv	a4,a5
ffffffe000202750:	07000793          	li	a5,112
ffffffe000202754:	30f71263          	bne	a4,a5,ffffffe000202a58 <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
ffffffe000202758:	f5043783          	ld	a5,-176(s0)
ffffffe00020275c:	0007c783          	lbu	a5,0(a5)
ffffffe000202760:	00078713          	mv	a4,a5
ffffffe000202764:	07000793          	li	a5,112
ffffffe000202768:	00f70663          	beq	a4,a5,ffffffe000202774 <vprintfmt+0x270>
ffffffe00020276c:	f8144783          	lbu	a5,-127(s0)
ffffffe000202770:	00078663          	beqz	a5,ffffffe00020277c <vprintfmt+0x278>
ffffffe000202774:	00100793          	li	a5,1
ffffffe000202778:	0080006f          	j	ffffffe000202780 <vprintfmt+0x27c>
ffffffe00020277c:	00000793          	li	a5,0
ffffffe000202780:	faf403a3          	sb	a5,-89(s0)
ffffffe000202784:	fa744783          	lbu	a5,-89(s0)
ffffffe000202788:	0017f793          	andi	a5,a5,1
ffffffe00020278c:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
ffffffe000202790:	fa744783          	lbu	a5,-89(s0)
ffffffe000202794:	0ff7f793          	zext.b	a5,a5
ffffffe000202798:	00078c63          	beqz	a5,ffffffe0002027b0 <vprintfmt+0x2ac>
ffffffe00020279c:	f4843783          	ld	a5,-184(s0)
ffffffe0002027a0:	00878713          	addi	a4,a5,8
ffffffe0002027a4:	f4e43423          	sd	a4,-184(s0)
ffffffe0002027a8:	0007b783          	ld	a5,0(a5)
ffffffe0002027ac:	01c0006f          	j	ffffffe0002027c8 <vprintfmt+0x2c4>
ffffffe0002027b0:	f4843783          	ld	a5,-184(s0)
ffffffe0002027b4:	00878713          	addi	a4,a5,8
ffffffe0002027b8:	f4e43423          	sd	a4,-184(s0)
ffffffe0002027bc:	0007a783          	lw	a5,0(a5)
ffffffe0002027c0:	02079793          	slli	a5,a5,0x20
ffffffe0002027c4:	0207d793          	srli	a5,a5,0x20
ffffffe0002027c8:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
ffffffe0002027cc:	f8c42783          	lw	a5,-116(s0)
ffffffe0002027d0:	02079463          	bnez	a5,ffffffe0002027f8 <vprintfmt+0x2f4>
ffffffe0002027d4:	fe043783          	ld	a5,-32(s0)
ffffffe0002027d8:	02079063          	bnez	a5,ffffffe0002027f8 <vprintfmt+0x2f4>
ffffffe0002027dc:	f5043783          	ld	a5,-176(s0)
ffffffe0002027e0:	0007c783          	lbu	a5,0(a5)
ffffffe0002027e4:	00078713          	mv	a4,a5
ffffffe0002027e8:	07000793          	li	a5,112
ffffffe0002027ec:	00f70663          	beq	a4,a5,ffffffe0002027f8 <vprintfmt+0x2f4>
                    flags.in_format = false;
ffffffe0002027f0:	f8040023          	sb	zero,-128(s0)
ffffffe0002027f4:	4d00006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
ffffffe0002027f8:	f5043783          	ld	a5,-176(s0)
ffffffe0002027fc:	0007c783          	lbu	a5,0(a5)
ffffffe000202800:	00078713          	mv	a4,a5
ffffffe000202804:	07000793          	li	a5,112
ffffffe000202808:	00f70a63          	beq	a4,a5,ffffffe00020281c <vprintfmt+0x318>
ffffffe00020280c:	f8244783          	lbu	a5,-126(s0)
ffffffe000202810:	00078a63          	beqz	a5,ffffffe000202824 <vprintfmt+0x320>
ffffffe000202814:	fe043783          	ld	a5,-32(s0)
ffffffe000202818:	00078663          	beqz	a5,ffffffe000202824 <vprintfmt+0x320>
ffffffe00020281c:	00100793          	li	a5,1
ffffffe000202820:	0080006f          	j	ffffffe000202828 <vprintfmt+0x324>
ffffffe000202824:	00000793          	li	a5,0
ffffffe000202828:	faf40323          	sb	a5,-90(s0)
ffffffe00020282c:	fa644783          	lbu	a5,-90(s0)
ffffffe000202830:	0017f793          	andi	a5,a5,1
ffffffe000202834:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
ffffffe000202838:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
ffffffe00020283c:	f5043783          	ld	a5,-176(s0)
ffffffe000202840:	0007c783          	lbu	a5,0(a5)
ffffffe000202844:	00078713          	mv	a4,a5
ffffffe000202848:	05800793          	li	a5,88
ffffffe00020284c:	00f71863          	bne	a4,a5,ffffffe00020285c <vprintfmt+0x358>
ffffffe000202850:	00001797          	auipc	a5,0x1
ffffffe000202854:	9b078793          	addi	a5,a5,-1616 # ffffffe000203200 <upperxdigits.1>
ffffffe000202858:	00c0006f          	j	ffffffe000202864 <vprintfmt+0x360>
ffffffe00020285c:	00001797          	auipc	a5,0x1
ffffffe000202860:	9bc78793          	addi	a5,a5,-1604 # ffffffe000203218 <lowerxdigits.0>
ffffffe000202864:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
ffffffe000202868:	fe043783          	ld	a5,-32(s0)
ffffffe00020286c:	00f7f793          	andi	a5,a5,15
ffffffe000202870:	f9843703          	ld	a4,-104(s0)
ffffffe000202874:	00f70733          	add	a4,a4,a5
ffffffe000202878:	fdc42783          	lw	a5,-36(s0)
ffffffe00020287c:	0017869b          	addiw	a3,a5,1
ffffffe000202880:	fcd42e23          	sw	a3,-36(s0)
ffffffe000202884:	00074703          	lbu	a4,0(a4)
ffffffe000202888:	ff078793          	addi	a5,a5,-16
ffffffe00020288c:	008787b3          	add	a5,a5,s0
ffffffe000202890:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
ffffffe000202894:	fe043783          	ld	a5,-32(s0)
ffffffe000202898:	0047d793          	srli	a5,a5,0x4
ffffffe00020289c:	fef43023          	sd	a5,-32(s0)
                } while (num);
ffffffe0002028a0:	fe043783          	ld	a5,-32(s0)
ffffffe0002028a4:	fc0792e3          	bnez	a5,ffffffe000202868 <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
ffffffe0002028a8:	f8c42783          	lw	a5,-116(s0)
ffffffe0002028ac:	00078713          	mv	a4,a5
ffffffe0002028b0:	fff00793          	li	a5,-1
ffffffe0002028b4:	02f71663          	bne	a4,a5,ffffffe0002028e0 <vprintfmt+0x3dc>
ffffffe0002028b8:	f8344783          	lbu	a5,-125(s0)
ffffffe0002028bc:	02078263          	beqz	a5,ffffffe0002028e0 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
ffffffe0002028c0:	f8842703          	lw	a4,-120(s0)
ffffffe0002028c4:	fa644783          	lbu	a5,-90(s0)
ffffffe0002028c8:	0007879b          	sext.w	a5,a5
ffffffe0002028cc:	0017979b          	slliw	a5,a5,0x1
ffffffe0002028d0:	0007879b          	sext.w	a5,a5
ffffffe0002028d4:	40f707bb          	subw	a5,a4,a5
ffffffe0002028d8:	0007879b          	sext.w	a5,a5
ffffffe0002028dc:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe0002028e0:	f8842703          	lw	a4,-120(s0)
ffffffe0002028e4:	fa644783          	lbu	a5,-90(s0)
ffffffe0002028e8:	0007879b          	sext.w	a5,a5
ffffffe0002028ec:	0017979b          	slliw	a5,a5,0x1
ffffffe0002028f0:	0007879b          	sext.w	a5,a5
ffffffe0002028f4:	40f707bb          	subw	a5,a4,a5
ffffffe0002028f8:	0007871b          	sext.w	a4,a5
ffffffe0002028fc:	fdc42783          	lw	a5,-36(s0)
ffffffe000202900:	f8f42a23          	sw	a5,-108(s0)
ffffffe000202904:	f8c42783          	lw	a5,-116(s0)
ffffffe000202908:	f8f42823          	sw	a5,-112(s0)
ffffffe00020290c:	f9442783          	lw	a5,-108(s0)
ffffffe000202910:	00078593          	mv	a1,a5
ffffffe000202914:	f9042783          	lw	a5,-112(s0)
ffffffe000202918:	00078613          	mv	a2,a5
ffffffe00020291c:	0006069b          	sext.w	a3,a2
ffffffe000202920:	0005879b          	sext.w	a5,a1
ffffffe000202924:	00f6d463          	bge	a3,a5,ffffffe00020292c <vprintfmt+0x428>
ffffffe000202928:	00058613          	mv	a2,a1
ffffffe00020292c:	0006079b          	sext.w	a5,a2
ffffffe000202930:	40f707bb          	subw	a5,a4,a5
ffffffe000202934:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202938:	0280006f          	j	ffffffe000202960 <vprintfmt+0x45c>
                    putch(' ');
ffffffe00020293c:	f5843783          	ld	a5,-168(s0)
ffffffe000202940:	02000513          	li	a0,32
ffffffe000202944:	000780e7          	jalr	a5
                    ++written;
ffffffe000202948:	fec42783          	lw	a5,-20(s0)
ffffffe00020294c:	0017879b          	addiw	a5,a5,1
ffffffe000202950:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
ffffffe000202954:	fd842783          	lw	a5,-40(s0)
ffffffe000202958:	fff7879b          	addiw	a5,a5,-1
ffffffe00020295c:	fcf42c23          	sw	a5,-40(s0)
ffffffe000202960:	fd842783          	lw	a5,-40(s0)
ffffffe000202964:	0007879b          	sext.w	a5,a5
ffffffe000202968:	fcf04ae3          	bgtz	a5,ffffffe00020293c <vprintfmt+0x438>
                }

                if (prefix) {
ffffffe00020296c:	fa644783          	lbu	a5,-90(s0)
ffffffe000202970:	0ff7f793          	zext.b	a5,a5
ffffffe000202974:	04078463          	beqz	a5,ffffffe0002029bc <vprintfmt+0x4b8>
                    putch('0');
ffffffe000202978:	f5843783          	ld	a5,-168(s0)
ffffffe00020297c:	03000513          	li	a0,48
ffffffe000202980:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
ffffffe000202984:	f5043783          	ld	a5,-176(s0)
ffffffe000202988:	0007c783          	lbu	a5,0(a5)
ffffffe00020298c:	00078713          	mv	a4,a5
ffffffe000202990:	05800793          	li	a5,88
ffffffe000202994:	00f71663          	bne	a4,a5,ffffffe0002029a0 <vprintfmt+0x49c>
ffffffe000202998:	05800793          	li	a5,88
ffffffe00020299c:	0080006f          	j	ffffffe0002029a4 <vprintfmt+0x4a0>
ffffffe0002029a0:	07800793          	li	a5,120
ffffffe0002029a4:	f5843703          	ld	a4,-168(s0)
ffffffe0002029a8:	00078513          	mv	a0,a5
ffffffe0002029ac:	000700e7          	jalr	a4
                    written += 2;
ffffffe0002029b0:	fec42783          	lw	a5,-20(s0)
ffffffe0002029b4:	0027879b          	addiw	a5,a5,2
ffffffe0002029b8:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe0002029bc:	fdc42783          	lw	a5,-36(s0)
ffffffe0002029c0:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002029c4:	0280006f          	j	ffffffe0002029ec <vprintfmt+0x4e8>
                    putch('0');
ffffffe0002029c8:	f5843783          	ld	a5,-168(s0)
ffffffe0002029cc:	03000513          	li	a0,48
ffffffe0002029d0:	000780e7          	jalr	a5
                    ++written;
ffffffe0002029d4:	fec42783          	lw	a5,-20(s0)
ffffffe0002029d8:	0017879b          	addiw	a5,a5,1
ffffffe0002029dc:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
ffffffe0002029e0:	fd442783          	lw	a5,-44(s0)
ffffffe0002029e4:	0017879b          	addiw	a5,a5,1
ffffffe0002029e8:	fcf42a23          	sw	a5,-44(s0)
ffffffe0002029ec:	f8c42703          	lw	a4,-116(s0)
ffffffe0002029f0:	fd442783          	lw	a5,-44(s0)
ffffffe0002029f4:	0007879b          	sext.w	a5,a5
ffffffe0002029f8:	fce7c8e3          	blt	a5,a4,ffffffe0002029c8 <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe0002029fc:	fdc42783          	lw	a5,-36(s0)
ffffffe000202a00:	fff7879b          	addiw	a5,a5,-1
ffffffe000202a04:	fcf42823          	sw	a5,-48(s0)
ffffffe000202a08:	03c0006f          	j	ffffffe000202a44 <vprintfmt+0x540>
                    putch(buf[i]);
ffffffe000202a0c:	fd042783          	lw	a5,-48(s0)
ffffffe000202a10:	ff078793          	addi	a5,a5,-16
ffffffe000202a14:	008787b3          	add	a5,a5,s0
ffffffe000202a18:	f807c783          	lbu	a5,-128(a5)
ffffffe000202a1c:	0007871b          	sext.w	a4,a5
ffffffe000202a20:	f5843783          	ld	a5,-168(s0)
ffffffe000202a24:	00070513          	mv	a0,a4
ffffffe000202a28:	000780e7          	jalr	a5
                    ++written;
ffffffe000202a2c:	fec42783          	lw	a5,-20(s0)
ffffffe000202a30:	0017879b          	addiw	a5,a5,1
ffffffe000202a34:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
ffffffe000202a38:	fd042783          	lw	a5,-48(s0)
ffffffe000202a3c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202a40:	fcf42823          	sw	a5,-48(s0)
ffffffe000202a44:	fd042783          	lw	a5,-48(s0)
ffffffe000202a48:	0007879b          	sext.w	a5,a5
ffffffe000202a4c:	fc07d0e3          	bgez	a5,ffffffe000202a0c <vprintfmt+0x508>
                }

                flags.in_format = false;
ffffffe000202a50:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
ffffffe000202a54:	2700006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202a58:	f5043783          	ld	a5,-176(s0)
ffffffe000202a5c:	0007c783          	lbu	a5,0(a5)
ffffffe000202a60:	00078713          	mv	a4,a5
ffffffe000202a64:	06400793          	li	a5,100
ffffffe000202a68:	02f70663          	beq	a4,a5,ffffffe000202a94 <vprintfmt+0x590>
ffffffe000202a6c:	f5043783          	ld	a5,-176(s0)
ffffffe000202a70:	0007c783          	lbu	a5,0(a5)
ffffffe000202a74:	00078713          	mv	a4,a5
ffffffe000202a78:	06900793          	li	a5,105
ffffffe000202a7c:	00f70c63          	beq	a4,a5,ffffffe000202a94 <vprintfmt+0x590>
ffffffe000202a80:	f5043783          	ld	a5,-176(s0)
ffffffe000202a84:	0007c783          	lbu	a5,0(a5)
ffffffe000202a88:	00078713          	mv	a4,a5
ffffffe000202a8c:	07500793          	li	a5,117
ffffffe000202a90:	08f71063          	bne	a4,a5,ffffffe000202b10 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
ffffffe000202a94:	f8144783          	lbu	a5,-127(s0)
ffffffe000202a98:	00078c63          	beqz	a5,ffffffe000202ab0 <vprintfmt+0x5ac>
ffffffe000202a9c:	f4843783          	ld	a5,-184(s0)
ffffffe000202aa0:	00878713          	addi	a4,a5,8
ffffffe000202aa4:	f4e43423          	sd	a4,-184(s0)
ffffffe000202aa8:	0007b783          	ld	a5,0(a5)
ffffffe000202aac:	0140006f          	j	ffffffe000202ac0 <vprintfmt+0x5bc>
ffffffe000202ab0:	f4843783          	ld	a5,-184(s0)
ffffffe000202ab4:	00878713          	addi	a4,a5,8
ffffffe000202ab8:	f4e43423          	sd	a4,-184(s0)
ffffffe000202abc:	0007a783          	lw	a5,0(a5)
ffffffe000202ac0:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
ffffffe000202ac4:	fa843583          	ld	a1,-88(s0)
ffffffe000202ac8:	f5043783          	ld	a5,-176(s0)
ffffffe000202acc:	0007c783          	lbu	a5,0(a5)
ffffffe000202ad0:	0007871b          	sext.w	a4,a5
ffffffe000202ad4:	07500793          	li	a5,117
ffffffe000202ad8:	40f707b3          	sub	a5,a4,a5
ffffffe000202adc:	00f037b3          	snez	a5,a5
ffffffe000202ae0:	0ff7f793          	zext.b	a5,a5
ffffffe000202ae4:	f8040713          	addi	a4,s0,-128
ffffffe000202ae8:	00070693          	mv	a3,a4
ffffffe000202aec:	00078613          	mv	a2,a5
ffffffe000202af0:	f5843503          	ld	a0,-168(s0)
ffffffe000202af4:	f08ff0ef          	jal	ffffffe0002021fc <print_dec_int>
ffffffe000202af8:	00050793          	mv	a5,a0
ffffffe000202afc:	fec42703          	lw	a4,-20(s0)
ffffffe000202b00:	00f707bb          	addw	a5,a4,a5
ffffffe000202b04:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202b08:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
ffffffe000202b0c:	1b80006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
ffffffe000202b10:	f5043783          	ld	a5,-176(s0)
ffffffe000202b14:	0007c783          	lbu	a5,0(a5)
ffffffe000202b18:	00078713          	mv	a4,a5
ffffffe000202b1c:	06e00793          	li	a5,110
ffffffe000202b20:	04f71c63          	bne	a4,a5,ffffffe000202b78 <vprintfmt+0x674>
                if (flags.longflag) {
ffffffe000202b24:	f8144783          	lbu	a5,-127(s0)
ffffffe000202b28:	02078463          	beqz	a5,ffffffe000202b50 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
ffffffe000202b2c:	f4843783          	ld	a5,-184(s0)
ffffffe000202b30:	00878713          	addi	a4,a5,8
ffffffe000202b34:	f4e43423          	sd	a4,-184(s0)
ffffffe000202b38:	0007b783          	ld	a5,0(a5)
ffffffe000202b3c:	faf43823          	sd	a5,-80(s0)
                    *n = written;
ffffffe000202b40:	fec42703          	lw	a4,-20(s0)
ffffffe000202b44:	fb043783          	ld	a5,-80(s0)
ffffffe000202b48:	00e7b023          	sd	a4,0(a5)
ffffffe000202b4c:	0240006f          	j	ffffffe000202b70 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
ffffffe000202b50:	f4843783          	ld	a5,-184(s0)
ffffffe000202b54:	00878713          	addi	a4,a5,8
ffffffe000202b58:	f4e43423          	sd	a4,-184(s0)
ffffffe000202b5c:	0007b783          	ld	a5,0(a5)
ffffffe000202b60:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
ffffffe000202b64:	fb843783          	ld	a5,-72(s0)
ffffffe000202b68:	fec42703          	lw	a4,-20(s0)
ffffffe000202b6c:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
ffffffe000202b70:	f8040023          	sb	zero,-128(s0)
ffffffe000202b74:	1500006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
ffffffe000202b78:	f5043783          	ld	a5,-176(s0)
ffffffe000202b7c:	0007c783          	lbu	a5,0(a5)
ffffffe000202b80:	00078713          	mv	a4,a5
ffffffe000202b84:	07300793          	li	a5,115
ffffffe000202b88:	02f71e63          	bne	a4,a5,ffffffe000202bc4 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
ffffffe000202b8c:	f4843783          	ld	a5,-184(s0)
ffffffe000202b90:	00878713          	addi	a4,a5,8
ffffffe000202b94:	f4e43423          	sd	a4,-184(s0)
ffffffe000202b98:	0007b783          	ld	a5,0(a5)
ffffffe000202b9c:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
ffffffe000202ba0:	fc043583          	ld	a1,-64(s0)
ffffffe000202ba4:	f5843503          	ld	a0,-168(s0)
ffffffe000202ba8:	dccff0ef          	jal	ffffffe000202174 <puts_wo_nl>
ffffffe000202bac:	00050793          	mv	a5,a0
ffffffe000202bb0:	fec42703          	lw	a4,-20(s0)
ffffffe000202bb4:	00f707bb          	addw	a5,a4,a5
ffffffe000202bb8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202bbc:	f8040023          	sb	zero,-128(s0)
ffffffe000202bc0:	1040006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
ffffffe000202bc4:	f5043783          	ld	a5,-176(s0)
ffffffe000202bc8:	0007c783          	lbu	a5,0(a5)
ffffffe000202bcc:	00078713          	mv	a4,a5
ffffffe000202bd0:	06300793          	li	a5,99
ffffffe000202bd4:	02f71e63          	bne	a4,a5,ffffffe000202c10 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
ffffffe000202bd8:	f4843783          	ld	a5,-184(s0)
ffffffe000202bdc:	00878713          	addi	a4,a5,8
ffffffe000202be0:	f4e43423          	sd	a4,-184(s0)
ffffffe000202be4:	0007a783          	lw	a5,0(a5)
ffffffe000202be8:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
ffffffe000202bec:	fcc42703          	lw	a4,-52(s0)
ffffffe000202bf0:	f5843783          	ld	a5,-168(s0)
ffffffe000202bf4:	00070513          	mv	a0,a4
ffffffe000202bf8:	000780e7          	jalr	a5
                ++written;
ffffffe000202bfc:	fec42783          	lw	a5,-20(s0)
ffffffe000202c00:	0017879b          	addiw	a5,a5,1
ffffffe000202c04:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202c08:	f8040023          	sb	zero,-128(s0)
ffffffe000202c0c:	0b80006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
ffffffe000202c10:	f5043783          	ld	a5,-176(s0)
ffffffe000202c14:	0007c783          	lbu	a5,0(a5)
ffffffe000202c18:	00078713          	mv	a4,a5
ffffffe000202c1c:	02500793          	li	a5,37
ffffffe000202c20:	02f71263          	bne	a4,a5,ffffffe000202c44 <vprintfmt+0x740>
                putch('%');
ffffffe000202c24:	f5843783          	ld	a5,-168(s0)
ffffffe000202c28:	02500513          	li	a0,37
ffffffe000202c2c:	000780e7          	jalr	a5
                ++written;
ffffffe000202c30:	fec42783          	lw	a5,-20(s0)
ffffffe000202c34:	0017879b          	addiw	a5,a5,1
ffffffe000202c38:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202c3c:	f8040023          	sb	zero,-128(s0)
ffffffe000202c40:	0840006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
ffffffe000202c44:	f5043783          	ld	a5,-176(s0)
ffffffe000202c48:	0007c783          	lbu	a5,0(a5)
ffffffe000202c4c:	0007871b          	sext.w	a4,a5
ffffffe000202c50:	f5843783          	ld	a5,-168(s0)
ffffffe000202c54:	00070513          	mv	a0,a4
ffffffe000202c58:	000780e7          	jalr	a5
                ++written;
ffffffe000202c5c:	fec42783          	lw	a5,-20(s0)
ffffffe000202c60:	0017879b          	addiw	a5,a5,1
ffffffe000202c64:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
ffffffe000202c68:	f8040023          	sb	zero,-128(s0)
ffffffe000202c6c:	0580006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
ffffffe000202c70:	f5043783          	ld	a5,-176(s0)
ffffffe000202c74:	0007c783          	lbu	a5,0(a5)
ffffffe000202c78:	00078713          	mv	a4,a5
ffffffe000202c7c:	02500793          	li	a5,37
ffffffe000202c80:	02f71063          	bne	a4,a5,ffffffe000202ca0 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
ffffffe000202c84:	f8043023          	sd	zero,-128(s0)
ffffffe000202c88:	f8043423          	sd	zero,-120(s0)
ffffffe000202c8c:	00100793          	li	a5,1
ffffffe000202c90:	f8f40023          	sb	a5,-128(s0)
ffffffe000202c94:	fff00793          	li	a5,-1
ffffffe000202c98:	f8f42623          	sw	a5,-116(s0)
ffffffe000202c9c:	0280006f          	j	ffffffe000202cc4 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
ffffffe000202ca0:	f5043783          	ld	a5,-176(s0)
ffffffe000202ca4:	0007c783          	lbu	a5,0(a5)
ffffffe000202ca8:	0007871b          	sext.w	a4,a5
ffffffe000202cac:	f5843783          	ld	a5,-168(s0)
ffffffe000202cb0:	00070513          	mv	a0,a4
ffffffe000202cb4:	000780e7          	jalr	a5
            ++written;
ffffffe000202cb8:	fec42783          	lw	a5,-20(s0)
ffffffe000202cbc:	0017879b          	addiw	a5,a5,1
ffffffe000202cc0:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
ffffffe000202cc4:	f5043783          	ld	a5,-176(s0)
ffffffe000202cc8:	00178793          	addi	a5,a5,1
ffffffe000202ccc:	f4f43823          	sd	a5,-176(s0)
ffffffe000202cd0:	f5043783          	ld	a5,-176(s0)
ffffffe000202cd4:	0007c783          	lbu	a5,0(a5)
ffffffe000202cd8:	84079ce3          	bnez	a5,ffffffe000202530 <vprintfmt+0x2c>
        }
    }

    return written;
ffffffe000202cdc:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202ce0:	00078513          	mv	a0,a5
ffffffe000202ce4:	0b813083          	ld	ra,184(sp)
ffffffe000202ce8:	0b013403          	ld	s0,176(sp)
ffffffe000202cec:	0c010113          	addi	sp,sp,192
ffffffe000202cf0:	00008067          	ret

ffffffe000202cf4 <printk>:

int printk(const char* s, ...) {
ffffffe000202cf4:	f9010113          	addi	sp,sp,-112
ffffffe000202cf8:	02113423          	sd	ra,40(sp)
ffffffe000202cfc:	02813023          	sd	s0,32(sp)
ffffffe000202d00:	03010413          	addi	s0,sp,48
ffffffe000202d04:	fca43c23          	sd	a0,-40(s0)
ffffffe000202d08:	00b43423          	sd	a1,8(s0)
ffffffe000202d0c:	00c43823          	sd	a2,16(s0)
ffffffe000202d10:	00d43c23          	sd	a3,24(s0)
ffffffe000202d14:	02e43023          	sd	a4,32(s0)
ffffffe000202d18:	02f43423          	sd	a5,40(s0)
ffffffe000202d1c:	03043823          	sd	a6,48(s0)
ffffffe000202d20:	03143c23          	sd	a7,56(s0)
    int res = 0;
ffffffe000202d24:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
ffffffe000202d28:	04040793          	addi	a5,s0,64
ffffffe000202d2c:	fcf43823          	sd	a5,-48(s0)
ffffffe000202d30:	fd043783          	ld	a5,-48(s0)
ffffffe000202d34:	fc878793          	addi	a5,a5,-56
ffffffe000202d38:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
ffffffe000202d3c:	fe043783          	ld	a5,-32(s0)
ffffffe000202d40:	00078613          	mv	a2,a5
ffffffe000202d44:	fd843583          	ld	a1,-40(s0)
ffffffe000202d48:	fffff517          	auipc	a0,0xfffff
ffffffe000202d4c:	11850513          	addi	a0,a0,280 # ffffffe000201e60 <putc>
ffffffe000202d50:	fb4ff0ef          	jal	ffffffe000202504 <vprintfmt>
ffffffe000202d54:	00050793          	mv	a5,a0
ffffffe000202d58:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
ffffffe000202d5c:	fec42783          	lw	a5,-20(s0)
}
ffffffe000202d60:	00078513          	mv	a0,a5
ffffffe000202d64:	02813083          	ld	ra,40(sp)
ffffffe000202d68:	02013403          	ld	s0,32(sp)
ffffffe000202d6c:	07010113          	addi	sp,sp,112
ffffffe000202d70:	00008067          	ret

ffffffe000202d74 <srand>:
#include "stdint.h"
#include "stdlib.h"

static uint64_t seed;

void srand(unsigned s) {
ffffffe000202d74:	fe010113          	addi	sp,sp,-32
ffffffe000202d78:	00813c23          	sd	s0,24(sp)
ffffffe000202d7c:	02010413          	addi	s0,sp,32
ffffffe000202d80:	00050793          	mv	a5,a0
ffffffe000202d84:	fef42623          	sw	a5,-20(s0)
    seed = s - 1;
ffffffe000202d88:	fec42783          	lw	a5,-20(s0)
ffffffe000202d8c:	fff7879b          	addiw	a5,a5,-1
ffffffe000202d90:	0007879b          	sext.w	a5,a5
ffffffe000202d94:	02079713          	slli	a4,a5,0x20
ffffffe000202d98:	02075713          	srli	a4,a4,0x20
ffffffe000202d9c:	00005797          	auipc	a5,0x5
ffffffe000202da0:	27c78793          	addi	a5,a5,636 # ffffffe000208018 <seed>
ffffffe000202da4:	00e7b023          	sd	a4,0(a5)
}
ffffffe000202da8:	00000013          	nop
ffffffe000202dac:	01813403          	ld	s0,24(sp)
ffffffe000202db0:	02010113          	addi	sp,sp,32
ffffffe000202db4:	00008067          	ret

ffffffe000202db8 <rand>:

int rand(void) {
ffffffe000202db8:	ff010113          	addi	sp,sp,-16
ffffffe000202dbc:	00813423          	sd	s0,8(sp)
ffffffe000202dc0:	01010413          	addi	s0,sp,16
    seed = 6364136223846793005ULL * seed + 1;
ffffffe000202dc4:	00005797          	auipc	a5,0x5
ffffffe000202dc8:	25478793          	addi	a5,a5,596 # ffffffe000208018 <seed>
ffffffe000202dcc:	0007b703          	ld	a4,0(a5)
ffffffe000202dd0:	00000797          	auipc	a5,0x0
ffffffe000202dd4:	46078793          	addi	a5,a5,1120 # ffffffe000203230 <lowerxdigits.0+0x18>
ffffffe000202dd8:	0007b783          	ld	a5,0(a5)
ffffffe000202ddc:	02f707b3          	mul	a5,a4,a5
ffffffe000202de0:	00178713          	addi	a4,a5,1
ffffffe000202de4:	00005797          	auipc	a5,0x5
ffffffe000202de8:	23478793          	addi	a5,a5,564 # ffffffe000208018 <seed>
ffffffe000202dec:	00e7b023          	sd	a4,0(a5)
    return seed >> 33;
ffffffe000202df0:	00005797          	auipc	a5,0x5
ffffffe000202df4:	22878793          	addi	a5,a5,552 # ffffffe000208018 <seed>
ffffffe000202df8:	0007b783          	ld	a5,0(a5)
ffffffe000202dfc:	0217d793          	srli	a5,a5,0x21
ffffffe000202e00:	0007879b          	sext.w	a5,a5
}
ffffffe000202e04:	00078513          	mv	a0,a5
ffffffe000202e08:	00813403          	ld	s0,8(sp)
ffffffe000202e0c:	01010113          	addi	sp,sp,16
ffffffe000202e10:	00008067          	ret

ffffffe000202e14 <memset>:
#include "string.h"
#include "stdint.h"

void *memset(void *dest, int c, uint64_t n) {
ffffffe000202e14:	fc010113          	addi	sp,sp,-64
ffffffe000202e18:	02813c23          	sd	s0,56(sp)
ffffffe000202e1c:	04010413          	addi	s0,sp,64
ffffffe000202e20:	fca43c23          	sd	a0,-40(s0)
ffffffe000202e24:	00058793          	mv	a5,a1
ffffffe000202e28:	fcc43423          	sd	a2,-56(s0)
ffffffe000202e2c:	fcf42a23          	sw	a5,-44(s0)
    char *s = (char *)dest;
ffffffe000202e30:	fd843783          	ld	a5,-40(s0)
ffffffe000202e34:	fef43023          	sd	a5,-32(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202e38:	fe043423          	sd	zero,-24(s0)
ffffffe000202e3c:	0280006f          	j	ffffffe000202e64 <memset+0x50>
        s[i] = c;
ffffffe000202e40:	fe043703          	ld	a4,-32(s0)
ffffffe000202e44:	fe843783          	ld	a5,-24(s0)
ffffffe000202e48:	00f707b3          	add	a5,a4,a5
ffffffe000202e4c:	fd442703          	lw	a4,-44(s0)
ffffffe000202e50:	0ff77713          	zext.b	a4,a4
ffffffe000202e54:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202e58:	fe843783          	ld	a5,-24(s0)
ffffffe000202e5c:	00178793          	addi	a5,a5,1
ffffffe000202e60:	fef43423          	sd	a5,-24(s0)
ffffffe000202e64:	fe843703          	ld	a4,-24(s0)
ffffffe000202e68:	fc843783          	ld	a5,-56(s0)
ffffffe000202e6c:	fcf76ae3          	bltu	a4,a5,ffffffe000202e40 <memset+0x2c>
    }
    return dest;
ffffffe000202e70:	fd843783          	ld	a5,-40(s0)
}
ffffffe000202e74:	00078513          	mv	a0,a5
ffffffe000202e78:	03813403          	ld	s0,56(sp)
ffffffe000202e7c:	04010113          	addi	sp,sp,64
ffffffe000202e80:	00008067          	ret

ffffffe000202e84 <memcpy>:

void *memcpy(void *dest, void *src, uint64_t n) {
ffffffe000202e84:	fb010113          	addi	sp,sp,-80
ffffffe000202e88:	04813423          	sd	s0,72(sp)
ffffffe000202e8c:	05010413          	addi	s0,sp,80
ffffffe000202e90:	fca43423          	sd	a0,-56(s0)
ffffffe000202e94:	fcb43023          	sd	a1,-64(s0)
ffffffe000202e98:	fac43c23          	sd	a2,-72(s0)
    char *d = (char *)dest;
ffffffe000202e9c:	fc843783          	ld	a5,-56(s0)
ffffffe000202ea0:	fef43023          	sd	a5,-32(s0)
    char *s = (char *)src;
ffffffe000202ea4:	fc043783          	ld	a5,-64(s0)
ffffffe000202ea8:	fcf43c23          	sd	a5,-40(s0)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202eac:	fe043423          	sd	zero,-24(s0)
ffffffe000202eb0:	0300006f          	j	ffffffe000202ee0 <memcpy+0x5c>
        d[i] = s[i];
ffffffe000202eb4:	fd843703          	ld	a4,-40(s0)
ffffffe000202eb8:	fe843783          	ld	a5,-24(s0)
ffffffe000202ebc:	00f70733          	add	a4,a4,a5
ffffffe000202ec0:	fe043683          	ld	a3,-32(s0)
ffffffe000202ec4:	fe843783          	ld	a5,-24(s0)
ffffffe000202ec8:	00f687b3          	add	a5,a3,a5
ffffffe000202ecc:	00074703          	lbu	a4,0(a4)
ffffffe000202ed0:	00e78023          	sb	a4,0(a5)
    for (uint64_t i = 0; i < n; ++i) {
ffffffe000202ed4:	fe843783          	ld	a5,-24(s0)
ffffffe000202ed8:	00178793          	addi	a5,a5,1
ffffffe000202edc:	fef43423          	sd	a5,-24(s0)
ffffffe000202ee0:	fe843703          	ld	a4,-24(s0)
ffffffe000202ee4:	fb843783          	ld	a5,-72(s0)
ffffffe000202ee8:	fcf766e3          	bltu	a4,a5,ffffffe000202eb4 <memcpy+0x30>
    }
    return dest;
ffffffe000202eec:	fc843783          	ld	a5,-56(s0)
}
ffffffe000202ef0:	00078513          	mv	a0,a5
ffffffe000202ef4:	04813403          	ld	s0,72(sp)
ffffffe000202ef8:	05010113          	addi	sp,sp,80
ffffffe000202efc:	00008067          	ret
