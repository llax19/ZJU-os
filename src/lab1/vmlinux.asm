
../../vmlinux:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_skernel>:
    .extern start_kernel
    .section .text.init
    .globl _start
_start:
    # set sp with the top of boot_stack
    la sp, boot_stack_top 
    80200000:	00003117          	auipc	sp,0x3
    80200004:	01013103          	ld	sp,16(sp) # 80203010 <_GLOBAL_OFFSET_TABLE_+0x8>

    # set stvec
    la a0, _traps
    80200008:	00003517          	auipc	a0,0x3
    8020000c:	01053503          	ld	a0,16(a0) # 80203018 <_GLOBAL_OFFSET_TABLE_+0x10>
    csrrw x0, stvec, a0
    80200010:	10551073          	csrw	stvec,a0

    # set sie[stie]=1
    addi a0, x0, 32
    80200014:	02000513          	li	a0,32
    csrrs x0, sie, a0
    80200018:	10452073          	csrs	sie,a0

    # set the first timer interrupt
    rdtime a1
    8020001c:	c01025f3          	rdtime	a1
    li a7, 0x54494d45
    80200020:	544958b7          	lui	a7,0x54495
    80200024:	d458889b          	addiw	a7,a7,-699 # 54494d45 <regbytes+0x54494d3d>
    mv a6, x0
    80200028:	00000813          	li	a6,0
    mv a0, a1
    8020002c:	00058513          	mv	a0,a1
    mv a1, x0
    80200030:	00000593          	li	a1,0
    mv a2, x0
    80200034:	00000613          	li	a2,0
    mv a3, x0
    80200038:	00000693          	li	a3,0
    mv a4, x0
    8020003c:	00000713          	li	a4,0
    mv a5, x0
    80200040:	00000793          	li	a5,0
    ecall
    80200044:	00000073          	ecall

    # set sstatus[SIE]=1
    csrrsi x0, sstatus, 2
    80200048:	10016073          	csrsi	sstatus,2
    

    call start_kernel
    8020004c:	4c4000ef          	jal	80200510 <start_kernel>

0000000080200050 <_traps>:
    .globl _traps
    .equ regbytes, 8
_traps:
    # save 32 registers and sepc to stack
    # csrrw x0, sscratch, sp
    addi sp, sp, -33 * regbytes
    80200050:	ef810113          	addi	sp,sp,-264
    sd x0, 0*regbytes(sp)
    80200054:	00013023          	sd	zero,0(sp)
    sd x1, 1*regbytes(sp)
    80200058:	00113423          	sd	ra,8(sp)
    sd x3, 3*regbytes(sp)
    8020005c:	00313c23          	sd	gp,24(sp)
    sd x4, 4*regbytes(sp)
    80200060:	02413023          	sd	tp,32(sp)
    sd x5, 5*regbytes(sp)
    80200064:	02513423          	sd	t0,40(sp)
    sd x6, 6*regbytes(sp)
    80200068:	02613823          	sd	t1,48(sp)
    sd x7, 7*regbytes(sp)
    8020006c:	02713c23          	sd	t2,56(sp)
    sd x8, 8*regbytes(sp)
    80200070:	04813023          	sd	s0,64(sp)
    sd x9, 9*regbytes(sp)
    80200074:	04913423          	sd	s1,72(sp)
    sd x10, 10*regbytes(sp)
    80200078:	04a13823          	sd	a0,80(sp)
    sd x11, 11*regbytes(sp)
    8020007c:	04b13c23          	sd	a1,88(sp)
    sd x12, 12*regbytes(sp)
    80200080:	06c13023          	sd	a2,96(sp)
    sd x13, 13*regbytes(sp)
    80200084:	06d13423          	sd	a3,104(sp)
    sd x14, 14*regbytes(sp)
    80200088:	06e13823          	sd	a4,112(sp)
    sd x15, 15*regbytes(sp)
    8020008c:	06f13c23          	sd	a5,120(sp)
    sd x16, 16*regbytes(sp)
    80200090:	09013023          	sd	a6,128(sp)
    sd x17, 17*regbytes(sp)
    80200094:	09113423          	sd	a7,136(sp)
    sd x18, 18*regbytes(sp)
    80200098:	09213823          	sd	s2,144(sp)
    sd x19, 19*regbytes(sp)
    8020009c:	09313c23          	sd	s3,152(sp)
    sd x20, 20*regbytes(sp)
    802000a0:	0b413023          	sd	s4,160(sp)
    sd x21, 21*regbytes(sp)
    802000a4:	0b513423          	sd	s5,168(sp)
    sd x22, 22*regbytes(sp)
    802000a8:	0b613823          	sd	s6,176(sp)
    sd x23, 23*regbytes(sp)
    802000ac:	0b713c23          	sd	s7,184(sp)
    sd x24, 24*regbytes(sp)
    802000b0:	0d813023          	sd	s8,192(sp)
    sd x25, 25*regbytes(sp)
    802000b4:	0d913423          	sd	s9,200(sp)
    sd x26, 26*regbytes(sp)
    802000b8:	0da13823          	sd	s10,208(sp)
    sd x27, 27*regbytes(sp)
    802000bc:	0db13c23          	sd	s11,216(sp)
    sd x28, 28*regbytes(sp)
    802000c0:	0fc13023          	sd	t3,224(sp)
    sd x29, 29*regbytes(sp)
    802000c4:	0fd13423          	sd	t4,232(sp)
    sd x30, 30*regbytes(sp)
    802000c8:	0fe13823          	sd	t5,240(sp)
    sd x31, 31*regbytes(sp)
    802000cc:	0ff13c23          	sd	t6,248(sp)
    csrrs a0, sepc, x0
    802000d0:	14102573          	csrr	a0,sepc
    sd a0, 32*regbytes(sp)
    802000d4:	10a13023          	sd	a0,256(sp)
    sd sp, 2*regbytes(sp)
    802000d8:	00213823          	sd	sp,16(sp)

    # call trap_handler
    csrrw a0, scause, x0
    802000dc:	14201573          	csrrw	a0,scause,zero
    csrrw a1, sepc, x0
    802000e0:	141015f3          	csrrw	a1,sepc,zero
    call trap_handler
    802000e4:	374000ef          	jal	80200458 <trap_handler>
    
    # restore sepc and 32 registers (x2(sp) should be restore last) from stack
    ld a0, 32*regbytes(sp)
    802000e8:	10013503          	ld	a0,256(sp)
    csrrw x0, sepc, a0
    802000ec:	14151073          	csrw	sepc,a0
    ld x1, 1*regbytes(sp)
    802000f0:	00813083          	ld	ra,8(sp)
    ld x3, 3*regbytes(sp)
    802000f4:	01813183          	ld	gp,24(sp)
    ld x4, 4*regbytes(sp)
    802000f8:	02013203          	ld	tp,32(sp)
    ld x5, 5*regbytes(sp)
    802000fc:	02813283          	ld	t0,40(sp)
    ld x6, 6*regbytes(sp)
    80200100:	03013303          	ld	t1,48(sp)
    ld x7, 7*regbytes(sp)
    80200104:	03813383          	ld	t2,56(sp)
    ld x8, 8*regbytes(sp)
    80200108:	04013403          	ld	s0,64(sp)
    ld x9, 9*regbytes(sp)
    8020010c:	04813483          	ld	s1,72(sp)
    ld x10, 10*regbytes(sp)
    80200110:	05013503          	ld	a0,80(sp)
    ld x11, 11*regbytes(sp)
    80200114:	05813583          	ld	a1,88(sp)
    ld x12, 12*regbytes(sp)
    80200118:	06013603          	ld	a2,96(sp)
    ld x13, 13*regbytes(sp)
    8020011c:	06813683          	ld	a3,104(sp)
    ld x14, 14*regbytes(sp)
    80200120:	07013703          	ld	a4,112(sp)
    ld x15, 15*regbytes(sp)
    80200124:	07813783          	ld	a5,120(sp)
    ld x16, 16*regbytes(sp)
    80200128:	08013803          	ld	a6,128(sp)
    ld x17, 17*regbytes(sp)
    8020012c:	08813883          	ld	a7,136(sp)
    ld x18, 18*regbytes(sp)
    80200130:	09013903          	ld	s2,144(sp)
    ld x19, 19*regbytes(sp)
    80200134:	09813983          	ld	s3,152(sp)
    ld x20, 20*regbytes(sp)
    80200138:	0a013a03          	ld	s4,160(sp)
    ld x21, 21*regbytes(sp)
    8020013c:	0a813a83          	ld	s5,168(sp)
    ld x22, 22*regbytes(sp)
    80200140:	0b013b03          	ld	s6,176(sp)
    ld x23, 23*regbytes(sp)
    80200144:	0b813b83          	ld	s7,184(sp)
    ld x24, 24*regbytes(sp)
    80200148:	0c013c03          	ld	s8,192(sp)
    ld x25, 25*regbytes(sp)
    8020014c:	0c813c83          	ld	s9,200(sp)
    ld x26, 26*regbytes(sp)
    80200150:	0d013d03          	ld	s10,208(sp)
    ld x27, 27*regbytes(sp)
    80200154:	0d813d83          	ld	s11,216(sp)
    ld x28, 28*regbytes(sp)
    80200158:	0e013e03          	ld	t3,224(sp)
    ld x29, 29*regbytes(sp)
    8020015c:	0e813e83          	ld	t4,232(sp)
    ld x30, 30*regbytes(sp)
    80200160:	0f013f03          	ld	t5,240(sp)
    ld x31, 31*regbytes(sp)
    80200164:	0f813f83          	ld	t6,248(sp)
    ld x2, 2*regbytes(sp)
    80200168:	01013103          	ld	sp,16(sp)
    addi sp, sp, 33 * regbytes
    8020016c:	10810113          	addi	sp,sp,264
    # return from trap
    sret
    80200170:	10200073          	sret

0000000080200174 <get_cycles>:
#include "sbi.h"

// QEMU 中时钟的频率是 10MHz，也就是 1 秒钟相当于 10000000 个时钟周期
uint64_t TIMECLOCK = 10000000;

uint64_t get_cycles() {
    80200174:	fe010113          	addi	sp,sp,-32
    80200178:	00813c23          	sd	s0,24(sp)
    8020017c:	02010413          	addi	s0,sp,32
    uint64_t cycles;
    asm volatile("rdtime %0" : "=r"(cycles));
    80200180:	c01027f3          	rdtime	a5
    80200184:	fef43423          	sd	a5,-24(s0)
    return cycles;
    80200188:	fe843783          	ld	a5,-24(s0)
}
    8020018c:	00078513          	mv	a0,a5
    80200190:	01813403          	ld	s0,24(sp)
    80200194:	02010113          	addi	sp,sp,32
    80200198:	00008067          	ret

000000008020019c <clock_set_next_event>:

void clock_set_next_event() {
    8020019c:	fe010113          	addi	sp,sp,-32
    802001a0:	00113c23          	sd	ra,24(sp)
    802001a4:	00813823          	sd	s0,16(sp)
    802001a8:	02010413          	addi	s0,sp,32
    // 下一次时钟中断的时间点
    uint64_t next = get_cycles() + TIMECLOCK;
    802001ac:	fc9ff0ef          	jal	80200174 <get_cycles>
    802001b0:	00050713          	mv	a4,a0
    802001b4:	00003797          	auipc	a5,0x3
    802001b8:	e4c78793          	addi	a5,a5,-436 # 80203000 <TIMECLOCK>
    802001bc:	0007b783          	ld	a5,0(a5)
    802001c0:	00f707b3          	add	a5,a4,a5
    802001c4:	fef43423          	sd	a5,-24(s0)

    // 使用 sbi_set_timer 来完成对下一次时钟中断的设置
    sbi_set_timer(next);
    802001c8:	fe843503          	ld	a0,-24(s0)
    802001cc:	200000ef          	jal	802003cc <sbi_set_timer>
    802001d0:	00000013          	nop
    802001d4:	01813083          	ld	ra,24(sp)
    802001d8:	01013403          	ld	s0,16(sp)
    802001dc:	02010113          	addi	sp,sp,32
    802001e0:	00008067          	ret

00000000802001e4 <sbi_ecall>:
#include "stdint.h"
#include "sbi.h"

struct sbiret sbi_ecall(uint64_t eid, uint64_t fid,
                        uint64_t arg0, uint64_t arg1, uint64_t arg2,
                        uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    802001e4:	f9010113          	addi	sp,sp,-112
    802001e8:	06813423          	sd	s0,104(sp)
    802001ec:	07010413          	addi	s0,sp,112
    802001f0:	fca43423          	sd	a0,-56(s0)
    802001f4:	fcb43023          	sd	a1,-64(s0)
    802001f8:	fac43c23          	sd	a2,-72(s0)
    802001fc:	fad43823          	sd	a3,-80(s0)
    80200200:	fae43423          	sd	a4,-88(s0)
    80200204:	faf43023          	sd	a5,-96(s0)
    80200208:	f9043c23          	sd	a6,-104(s0)
    8020020c:	f9143823          	sd	a7,-112(s0)
    struct sbiret ret;
    asm volatile(
    80200210:	fc843783          	ld	a5,-56(s0)
    80200214:	fc043703          	ld	a4,-64(s0)
    80200218:	fb843683          	ld	a3,-72(s0)
    8020021c:	fb043603          	ld	a2,-80(s0)
    80200220:	fa843583          	ld	a1,-88(s0)
    80200224:	fa043503          	ld	a0,-96(s0)
    80200228:	f9843803          	ld	a6,-104(s0)
    8020022c:	f9043883          	ld	a7,-112(s0)
    80200230:	00078893          	mv	a7,a5
    80200234:	00070813          	mv	a6,a4
    80200238:	00068513          	mv	a0,a3
    8020023c:	00060593          	mv	a1,a2
    80200240:	00058613          	mv	a2,a1
    80200244:	00050693          	mv	a3,a0
    80200248:	00080713          	mv	a4,a6
    8020024c:	00088793          	mv	a5,a7
    80200250:	00000073          	ecall
    80200254:	00050713          	mv	a4,a0
    80200258:	00058793          	mv	a5,a1
    8020025c:	fce43823          	sd	a4,-48(s0)
    80200260:	fcf43c23          	sd	a5,-40(s0)
        "mv %[value], a1"
        : [error] "=r" (ret.error), [value] "=r" (ret.value)
        : [eid]"r"(eid), [fid]"r"(fid), [arg0]"r"(arg0), [arg1]"r"(arg1), [arg2]"r"(arg2), [arg3]"r"(arg3), [arg4]"r"(arg4), [arg5]"r"(arg5)
        : "memory"
    );
    return ret;
    80200264:	fd043783          	ld	a5,-48(s0)
    80200268:	fef43023          	sd	a5,-32(s0)
    8020026c:	fd843783          	ld	a5,-40(s0)
    80200270:	fef43423          	sd	a5,-24(s0)
    80200274:	fe043703          	ld	a4,-32(s0)
    80200278:	fe843783          	ld	a5,-24(s0)
    8020027c:	00070313          	mv	t1,a4
    80200280:	00078393          	mv	t2,a5
    80200284:	00030713          	mv	a4,t1
    80200288:	00038793          	mv	a5,t2
}
    8020028c:	00070513          	mv	a0,a4
    80200290:	00078593          	mv	a1,a5
    80200294:	06813403          	ld	s0,104(sp)
    80200298:	07010113          	addi	sp,sp,112
    8020029c:	00008067          	ret

00000000802002a0 <sbi_debug_console_write_byte>:

struct sbiret sbi_debug_console_write_byte(uint8_t byte) {
    802002a0:	fc010113          	addi	sp,sp,-64
    802002a4:	02113c23          	sd	ra,56(sp)
    802002a8:	02813823          	sd	s0,48(sp)
    802002ac:	03213423          	sd	s2,40(sp)
    802002b0:	03313023          	sd	s3,32(sp)
    802002b4:	04010413          	addi	s0,sp,64
    802002b8:	00050793          	mv	a5,a0
    802002bc:	fcf407a3          	sb	a5,-49(s0)
    return sbi_ecall(0x4442434E, 0x2, byte, 0, 0, 0, 0, 0);;
    802002c0:	fcf44603          	lbu	a2,-49(s0)
    802002c4:	00000893          	li	a7,0
    802002c8:	00000813          	li	a6,0
    802002cc:	00000793          	li	a5,0
    802002d0:	00000713          	li	a4,0
    802002d4:	00000693          	li	a3,0
    802002d8:	00200593          	li	a1,2
    802002dc:	44424537          	lui	a0,0x44424
    802002e0:	34e50513          	addi	a0,a0,846 # 4442434e <regbytes+0x44424346>
    802002e4:	f01ff0ef          	jal	802001e4 <sbi_ecall>
    802002e8:	00050713          	mv	a4,a0
    802002ec:	00058793          	mv	a5,a1
    802002f0:	fce43823          	sd	a4,-48(s0)
    802002f4:	fcf43c23          	sd	a5,-40(s0)
    802002f8:	fd043703          	ld	a4,-48(s0)
    802002fc:	fd843783          	ld	a5,-40(s0)
    80200300:	00070913          	mv	s2,a4
    80200304:	00078993          	mv	s3,a5
    80200308:	00090713          	mv	a4,s2
    8020030c:	00098793          	mv	a5,s3
}
    80200310:	00070513          	mv	a0,a4
    80200314:	00078593          	mv	a1,a5
    80200318:	03813083          	ld	ra,56(sp)
    8020031c:	03013403          	ld	s0,48(sp)
    80200320:	02813903          	ld	s2,40(sp)
    80200324:	02013983          	ld	s3,32(sp)
    80200328:	04010113          	addi	sp,sp,64
    8020032c:	00008067          	ret

0000000080200330 <sbi_system_reset>:

struct sbiret sbi_system_reset(uint32_t reset_type, uint32_t reset_reason) {
    80200330:	fc010113          	addi	sp,sp,-64
    80200334:	02113c23          	sd	ra,56(sp)
    80200338:	02813823          	sd	s0,48(sp)
    8020033c:	03213423          	sd	s2,40(sp)
    80200340:	03313023          	sd	s3,32(sp)
    80200344:	04010413          	addi	s0,sp,64
    80200348:	00050793          	mv	a5,a0
    8020034c:	00058713          	mv	a4,a1
    80200350:	fcf42623          	sw	a5,-52(s0)
    80200354:	00070793          	mv	a5,a4
    80200358:	fcf42423          	sw	a5,-56(s0)
    return sbi_ecall(0x53525354, 0x0, reset_type, reset_reason, 0, 0, 0, 0);;
    8020035c:	fcc46603          	lwu	a2,-52(s0)
    80200360:	fc846683          	lwu	a3,-56(s0)
    80200364:	00000893          	li	a7,0
    80200368:	00000813          	li	a6,0
    8020036c:	00000793          	li	a5,0
    80200370:	00000713          	li	a4,0
    80200374:	00000593          	li	a1,0
    80200378:	53525537          	lui	a0,0x53525
    8020037c:	35450513          	addi	a0,a0,852 # 53525354 <regbytes+0x5352534c>
    80200380:	e65ff0ef          	jal	802001e4 <sbi_ecall>
    80200384:	00050713          	mv	a4,a0
    80200388:	00058793          	mv	a5,a1
    8020038c:	fce43823          	sd	a4,-48(s0)
    80200390:	fcf43c23          	sd	a5,-40(s0)
    80200394:	fd043703          	ld	a4,-48(s0)
    80200398:	fd843783          	ld	a5,-40(s0)
    8020039c:	00070913          	mv	s2,a4
    802003a0:	00078993          	mv	s3,a5
    802003a4:	00090713          	mv	a4,s2
    802003a8:	00098793          	mv	a5,s3
}
    802003ac:	00070513          	mv	a0,a4
    802003b0:	00078593          	mv	a1,a5
    802003b4:	03813083          	ld	ra,56(sp)
    802003b8:	03013403          	ld	s0,48(sp)
    802003bc:	02813903          	ld	s2,40(sp)
    802003c0:	02013983          	ld	s3,32(sp)
    802003c4:	04010113          	addi	sp,sp,64
    802003c8:	00008067          	ret

00000000802003cc <sbi_set_timer>:

struct sbiret sbi_set_timer(uint64_t stime_value) {
    802003cc:	fc010113          	addi	sp,sp,-64
    802003d0:	02113c23          	sd	ra,56(sp)
    802003d4:	02813823          	sd	s0,48(sp)
    802003d8:	03213423          	sd	s2,40(sp)
    802003dc:	03313023          	sd	s3,32(sp)
    802003e0:	04010413          	addi	s0,sp,64
    802003e4:	fca43423          	sd	a0,-56(s0)
    return sbi_ecall(0x54494d45, 0x0, stime_value, 0, 0, 0, 0, 0);
    802003e8:	00000893          	li	a7,0
    802003ec:	00000813          	li	a6,0
    802003f0:	00000793          	li	a5,0
    802003f4:	00000713          	li	a4,0
    802003f8:	00000693          	li	a3,0
    802003fc:	fc843603          	ld	a2,-56(s0)
    80200400:	00000593          	li	a1,0
    80200404:	54495537          	lui	a0,0x54495
    80200408:	d4550513          	addi	a0,a0,-699 # 54494d45 <regbytes+0x54494d3d>
    8020040c:	dd9ff0ef          	jal	802001e4 <sbi_ecall>
    80200410:	00050713          	mv	a4,a0
    80200414:	00058793          	mv	a5,a1
    80200418:	fce43823          	sd	a4,-48(s0)
    8020041c:	fcf43c23          	sd	a5,-40(s0)
    80200420:	fd043703          	ld	a4,-48(s0)
    80200424:	fd843783          	ld	a5,-40(s0)
    80200428:	00070913          	mv	s2,a4
    8020042c:	00078993          	mv	s3,a5
    80200430:	00090713          	mv	a4,s2
    80200434:	00098793          	mv	a5,s3
    80200438:	00070513          	mv	a0,a4
    8020043c:	00078593          	mv	a1,a5
    80200440:	03813083          	ld	ra,56(sp)
    80200444:	03013403          	ld	s0,48(sp)
    80200448:	02813903          	ld	s2,40(sp)
    8020044c:	02013983          	ld	s3,32(sp)
    80200450:	04010113          	addi	sp,sp,64
    80200454:	00008067          	ret

0000000080200458 <trap_handler>:
#include "stdint.h"
#include "printk.h"
#include "clock.h"
#include "defs.h"

void trap_handler(uint64_t scause, uint64_t sepc) {
    80200458:	fb010113          	addi	sp,sp,-80
    8020045c:	04113423          	sd	ra,72(sp)
    80200460:	04813023          	sd	s0,64(sp)
    80200464:	05010413          	addi	s0,sp,80
    80200468:	faa43c23          	sd	a0,-72(s0)
    8020046c:	fab43823          	sd	a1,-80(s0)
    uint64_t flag = scause >> 63;
    80200470:	fb843783          	ld	a5,-72(s0)
    80200474:	03f7d793          	srli	a5,a5,0x3f
    80200478:	fef43423          	sd	a5,-24(s0)
    uint64_t cause = scause & 0x7FFFFFFFFFFFFFFF;
    8020047c:	fb843703          	ld	a4,-72(s0)
    80200480:	fff00793          	li	a5,-1
    80200484:	0017d793          	srli	a5,a5,0x1
    80200488:	00f777b3          	and	a5,a4,a5
    8020048c:	fef43023          	sd	a5,-32(s0)

    if(flag) {//interrupt
    80200490:	fe843783          	ld	a5,-24(s0)
    80200494:	04078c63          	beqz	a5,802004ec <trap_handler+0x94>
        if(cause == 5) {
    80200498:	fe043703          	ld	a4,-32(s0)
    8020049c:	00500793          	li	a5,5
    802004a0:	02f71c63          	bne	a4,a5,802004d8 <trap_handler+0x80>
            uint64_t ret = csr_read(sstatus);
    802004a4:	100027f3          	csrr	a5,sstatus
    802004a8:	fcf43c23          	sd	a5,-40(s0)
    802004ac:	fd843783          	ld	a5,-40(s0)
    802004b0:	fcf43823          	sd	a5,-48(s0)
            csr_write(sscratch, ret);
    802004b4:	fd043783          	ld	a5,-48(s0)
    802004b8:	fcf43423          	sd	a5,-56(s0)
    802004bc:	fc843783          	ld	a5,-56(s0)
    802004c0:	14079073          	csrw	sscratch,a5
            printk("[S] Supervisor Mode Timer Interrupt\n");
    802004c4:	00002517          	auipc	a0,0x2
    802004c8:	b3c50513          	addi	a0,a0,-1220 # 80202000 <_srodata>
    802004cc:	76d000ef          	jal	80201438 <printk>
            clock_set_next_event();
    802004d0:	ccdff0ef          	jal	8020019c <clock_set_next_event>
        }
    }
    else {
        printk("[S] Exception: %d\n", cause);
    }
    802004d4:	0280006f          	j	802004fc <trap_handler+0xa4>
            printk("[S] Interrupt: %d\n", cause);
    802004d8:	fe043583          	ld	a1,-32(s0)
    802004dc:	00002517          	auipc	a0,0x2
    802004e0:	b4c50513          	addi	a0,a0,-1204 # 80202028 <_srodata+0x28>
    802004e4:	755000ef          	jal	80201438 <printk>
    802004e8:	0140006f          	j	802004fc <trap_handler+0xa4>
        printk("[S] Exception: %d\n", cause);
    802004ec:	fe043583          	ld	a1,-32(s0)
    802004f0:	00002517          	auipc	a0,0x2
    802004f4:	b5050513          	addi	a0,a0,-1200 # 80202040 <_srodata+0x40>
    802004f8:	741000ef          	jal	80201438 <printk>
    802004fc:	00000013          	nop
    80200500:	04813083          	ld	ra,72(sp)
    80200504:	04013403          	ld	s0,64(sp)
    80200508:	05010113          	addi	sp,sp,80
    8020050c:	00008067          	ret

0000000080200510 <start_kernel>:
#include "printk.h"

extern void test();

int start_kernel() {
    80200510:	ff010113          	addi	sp,sp,-16
    80200514:	00113423          	sd	ra,8(sp)
    80200518:	00813023          	sd	s0,0(sp)
    8020051c:	01010413          	addi	s0,sp,16
    printk("2024");
    80200520:	00002517          	auipc	a0,0x2
    80200524:	b3850513          	addi	a0,a0,-1224 # 80202058 <_srodata+0x58>
    80200528:	711000ef          	jal	80201438 <printk>
    printk(" ZJU Operating System\n");
    8020052c:	00002517          	auipc	a0,0x2
    80200530:	b3450513          	addi	a0,a0,-1228 # 80202060 <_srodata+0x60>
    80200534:	705000ef          	jal	80201438 <printk>

    test();
    80200538:	01c000ef          	jal	80200554 <test>
    return 0;
    8020053c:	00000793          	li	a5,0
}
    80200540:	00078513          	mv	a0,a5
    80200544:	00813083          	ld	ra,8(sp)
    80200548:	00013403          	ld	s0,0(sp)
    8020054c:	01010113          	addi	sp,sp,16
    80200550:	00008067          	ret

0000000080200554 <test>:
#include "printk.h"

void test() {
    80200554:	fe010113          	addi	sp,sp,-32
    80200558:	00113c23          	sd	ra,24(sp)
    8020055c:	00813823          	sd	s0,16(sp)
    80200560:	02010413          	addi	s0,sp,32
    int i = 0;
    80200564:	fe042623          	sw	zero,-20(s0)
    while (1) {
        if ((++i) % 100000000 == 0) {
    80200568:	fec42783          	lw	a5,-20(s0)
    8020056c:	0017879b          	addiw	a5,a5,1
    80200570:	fef42623          	sw	a5,-20(s0)
    80200574:	fec42783          	lw	a5,-20(s0)
    80200578:	00078713          	mv	a4,a5
    8020057c:	05f5e7b7          	lui	a5,0x5f5e
    80200580:	1007879b          	addiw	a5,a5,256 # 5f5e100 <regbytes+0x5f5e0f8>
    80200584:	02f767bb          	remw	a5,a4,a5
    80200588:	0007879b          	sext.w	a5,a5
    8020058c:	fc079ee3          	bnez	a5,80200568 <test+0x14>
            printk("kernel is running!\n");
    80200590:	00002517          	auipc	a0,0x2
    80200594:	ae850513          	addi	a0,a0,-1304 # 80202078 <_srodata+0x78>
    80200598:	6a1000ef          	jal	80201438 <printk>
            i = 0;
    8020059c:	fe042623          	sw	zero,-20(s0)
        if ((++i) % 100000000 == 0) {
    802005a0:	fc9ff06f          	j	80200568 <test+0x14>

00000000802005a4 <putc>:
// credit: 45gfg9 <45gfg9@45gfg9.net>

#include "printk.h"
#include "sbi.h"

int putc(int c) {
    802005a4:	fe010113          	addi	sp,sp,-32
    802005a8:	00113c23          	sd	ra,24(sp)
    802005ac:	00813823          	sd	s0,16(sp)
    802005b0:	02010413          	addi	s0,sp,32
    802005b4:	00050793          	mv	a5,a0
    802005b8:	fef42623          	sw	a5,-20(s0)
    sbi_debug_console_write_byte(c);
    802005bc:	fec42783          	lw	a5,-20(s0)
    802005c0:	0ff7f793          	zext.b	a5,a5
    802005c4:	00078513          	mv	a0,a5
    802005c8:	cd9ff0ef          	jal	802002a0 <sbi_debug_console_write_byte>
    return (char)c;
    802005cc:	fec42783          	lw	a5,-20(s0)
    802005d0:	0ff7f793          	zext.b	a5,a5
    802005d4:	0007879b          	sext.w	a5,a5
}
    802005d8:	00078513          	mv	a0,a5
    802005dc:	01813083          	ld	ra,24(sp)
    802005e0:	01013403          	ld	s0,16(sp)
    802005e4:	02010113          	addi	sp,sp,32
    802005e8:	00008067          	ret

00000000802005ec <isspace>:
    bool sign;
    int width;
    int prec;
};

int isspace(int c) {
    802005ec:	fe010113          	addi	sp,sp,-32
    802005f0:	00813c23          	sd	s0,24(sp)
    802005f4:	02010413          	addi	s0,sp,32
    802005f8:	00050793          	mv	a5,a0
    802005fc:	fef42623          	sw	a5,-20(s0)
    return c == ' ' || (c >= '\t' && c <= '\r');
    80200600:	fec42783          	lw	a5,-20(s0)
    80200604:	0007871b          	sext.w	a4,a5
    80200608:	02000793          	li	a5,32
    8020060c:	02f70263          	beq	a4,a5,80200630 <isspace+0x44>
    80200610:	fec42783          	lw	a5,-20(s0)
    80200614:	0007871b          	sext.w	a4,a5
    80200618:	00800793          	li	a5,8
    8020061c:	00e7de63          	bge	a5,a4,80200638 <isspace+0x4c>
    80200620:	fec42783          	lw	a5,-20(s0)
    80200624:	0007871b          	sext.w	a4,a5
    80200628:	00d00793          	li	a5,13
    8020062c:	00e7c663          	blt	a5,a4,80200638 <isspace+0x4c>
    80200630:	00100793          	li	a5,1
    80200634:	0080006f          	j	8020063c <isspace+0x50>
    80200638:	00000793          	li	a5,0
}
    8020063c:	00078513          	mv	a0,a5
    80200640:	01813403          	ld	s0,24(sp)
    80200644:	02010113          	addi	sp,sp,32
    80200648:	00008067          	ret

000000008020064c <strtol>:

long strtol(const char *restrict nptr, char **restrict endptr, int base) {
    8020064c:	fb010113          	addi	sp,sp,-80
    80200650:	04113423          	sd	ra,72(sp)
    80200654:	04813023          	sd	s0,64(sp)
    80200658:	05010413          	addi	s0,sp,80
    8020065c:	fca43423          	sd	a0,-56(s0)
    80200660:	fcb43023          	sd	a1,-64(s0)
    80200664:	00060793          	mv	a5,a2
    80200668:	faf42e23          	sw	a5,-68(s0)
    long ret = 0;
    8020066c:	fe043423          	sd	zero,-24(s0)
    bool neg = false;
    80200670:	fe0403a3          	sb	zero,-25(s0)
    const char *p = nptr;
    80200674:	fc843783          	ld	a5,-56(s0)
    80200678:	fcf43c23          	sd	a5,-40(s0)

    while (isspace(*p)) {
    8020067c:	0100006f          	j	8020068c <strtol+0x40>
        p++;
    80200680:	fd843783          	ld	a5,-40(s0)
    80200684:	00178793          	addi	a5,a5,1
    80200688:	fcf43c23          	sd	a5,-40(s0)
    while (isspace(*p)) {
    8020068c:	fd843783          	ld	a5,-40(s0)
    80200690:	0007c783          	lbu	a5,0(a5)
    80200694:	0007879b          	sext.w	a5,a5
    80200698:	00078513          	mv	a0,a5
    8020069c:	f51ff0ef          	jal	802005ec <isspace>
    802006a0:	00050793          	mv	a5,a0
    802006a4:	fc079ee3          	bnez	a5,80200680 <strtol+0x34>
    }

    if (*p == '-') {
    802006a8:	fd843783          	ld	a5,-40(s0)
    802006ac:	0007c783          	lbu	a5,0(a5)
    802006b0:	00078713          	mv	a4,a5
    802006b4:	02d00793          	li	a5,45
    802006b8:	00f71e63          	bne	a4,a5,802006d4 <strtol+0x88>
        neg = true;
    802006bc:	00100793          	li	a5,1
    802006c0:	fef403a3          	sb	a5,-25(s0)
        p++;
    802006c4:	fd843783          	ld	a5,-40(s0)
    802006c8:	00178793          	addi	a5,a5,1
    802006cc:	fcf43c23          	sd	a5,-40(s0)
    802006d0:	0240006f          	j	802006f4 <strtol+0xa8>
    } else if (*p == '+') {
    802006d4:	fd843783          	ld	a5,-40(s0)
    802006d8:	0007c783          	lbu	a5,0(a5)
    802006dc:	00078713          	mv	a4,a5
    802006e0:	02b00793          	li	a5,43
    802006e4:	00f71863          	bne	a4,a5,802006f4 <strtol+0xa8>
        p++;
    802006e8:	fd843783          	ld	a5,-40(s0)
    802006ec:	00178793          	addi	a5,a5,1
    802006f0:	fcf43c23          	sd	a5,-40(s0)
    }

    if (base == 0) {
    802006f4:	fbc42783          	lw	a5,-68(s0)
    802006f8:	0007879b          	sext.w	a5,a5
    802006fc:	06079c63          	bnez	a5,80200774 <strtol+0x128>
        if (*p == '0') {
    80200700:	fd843783          	ld	a5,-40(s0)
    80200704:	0007c783          	lbu	a5,0(a5)
    80200708:	00078713          	mv	a4,a5
    8020070c:	03000793          	li	a5,48
    80200710:	04f71e63          	bne	a4,a5,8020076c <strtol+0x120>
            p++;
    80200714:	fd843783          	ld	a5,-40(s0)
    80200718:	00178793          	addi	a5,a5,1
    8020071c:	fcf43c23          	sd	a5,-40(s0)
            if (*p == 'x' || *p == 'X') {
    80200720:	fd843783          	ld	a5,-40(s0)
    80200724:	0007c783          	lbu	a5,0(a5)
    80200728:	00078713          	mv	a4,a5
    8020072c:	07800793          	li	a5,120
    80200730:	00f70c63          	beq	a4,a5,80200748 <strtol+0xfc>
    80200734:	fd843783          	ld	a5,-40(s0)
    80200738:	0007c783          	lbu	a5,0(a5)
    8020073c:	00078713          	mv	a4,a5
    80200740:	05800793          	li	a5,88
    80200744:	00f71e63          	bne	a4,a5,80200760 <strtol+0x114>
                base = 16;
    80200748:	01000793          	li	a5,16
    8020074c:	faf42e23          	sw	a5,-68(s0)
                p++;
    80200750:	fd843783          	ld	a5,-40(s0)
    80200754:	00178793          	addi	a5,a5,1
    80200758:	fcf43c23          	sd	a5,-40(s0)
    8020075c:	0180006f          	j	80200774 <strtol+0x128>
            } else {
                base = 8;
    80200760:	00800793          	li	a5,8
    80200764:	faf42e23          	sw	a5,-68(s0)
    80200768:	00c0006f          	j	80200774 <strtol+0x128>
            }
        } else {
            base = 10;
    8020076c:	00a00793          	li	a5,10
    80200770:	faf42e23          	sw	a5,-68(s0)
        }
    }

    while (1) {
        int digit;
        if (*p >= '0' && *p <= '9') {
    80200774:	fd843783          	ld	a5,-40(s0)
    80200778:	0007c783          	lbu	a5,0(a5)
    8020077c:	00078713          	mv	a4,a5
    80200780:	02f00793          	li	a5,47
    80200784:	02e7f863          	bgeu	a5,a4,802007b4 <strtol+0x168>
    80200788:	fd843783          	ld	a5,-40(s0)
    8020078c:	0007c783          	lbu	a5,0(a5)
    80200790:	00078713          	mv	a4,a5
    80200794:	03900793          	li	a5,57
    80200798:	00e7ee63          	bltu	a5,a4,802007b4 <strtol+0x168>
            digit = *p - '0';
    8020079c:	fd843783          	ld	a5,-40(s0)
    802007a0:	0007c783          	lbu	a5,0(a5)
    802007a4:	0007879b          	sext.w	a5,a5
    802007a8:	fd07879b          	addiw	a5,a5,-48
    802007ac:	fcf42a23          	sw	a5,-44(s0)
    802007b0:	0800006f          	j	80200830 <strtol+0x1e4>
        } else if (*p >= 'a' && *p <= 'z') {
    802007b4:	fd843783          	ld	a5,-40(s0)
    802007b8:	0007c783          	lbu	a5,0(a5)
    802007bc:	00078713          	mv	a4,a5
    802007c0:	06000793          	li	a5,96
    802007c4:	02e7f863          	bgeu	a5,a4,802007f4 <strtol+0x1a8>
    802007c8:	fd843783          	ld	a5,-40(s0)
    802007cc:	0007c783          	lbu	a5,0(a5)
    802007d0:	00078713          	mv	a4,a5
    802007d4:	07a00793          	li	a5,122
    802007d8:	00e7ee63          	bltu	a5,a4,802007f4 <strtol+0x1a8>
            digit = *p - ('a' - 10);
    802007dc:	fd843783          	ld	a5,-40(s0)
    802007e0:	0007c783          	lbu	a5,0(a5)
    802007e4:	0007879b          	sext.w	a5,a5
    802007e8:	fa97879b          	addiw	a5,a5,-87
    802007ec:	fcf42a23          	sw	a5,-44(s0)
    802007f0:	0400006f          	j	80200830 <strtol+0x1e4>
        } else if (*p >= 'A' && *p <= 'Z') {
    802007f4:	fd843783          	ld	a5,-40(s0)
    802007f8:	0007c783          	lbu	a5,0(a5)
    802007fc:	00078713          	mv	a4,a5
    80200800:	04000793          	li	a5,64
    80200804:	06e7f863          	bgeu	a5,a4,80200874 <strtol+0x228>
    80200808:	fd843783          	ld	a5,-40(s0)
    8020080c:	0007c783          	lbu	a5,0(a5)
    80200810:	00078713          	mv	a4,a5
    80200814:	05a00793          	li	a5,90
    80200818:	04e7ee63          	bltu	a5,a4,80200874 <strtol+0x228>
            digit = *p - ('A' - 10);
    8020081c:	fd843783          	ld	a5,-40(s0)
    80200820:	0007c783          	lbu	a5,0(a5)
    80200824:	0007879b          	sext.w	a5,a5
    80200828:	fc97879b          	addiw	a5,a5,-55
    8020082c:	fcf42a23          	sw	a5,-44(s0)
        } else {
            break;
        }

        if (digit >= base) {
    80200830:	fd442783          	lw	a5,-44(s0)
    80200834:	00078713          	mv	a4,a5
    80200838:	fbc42783          	lw	a5,-68(s0)
    8020083c:	0007071b          	sext.w	a4,a4
    80200840:	0007879b          	sext.w	a5,a5
    80200844:	02f75663          	bge	a4,a5,80200870 <strtol+0x224>
            break;
        }

        ret = ret * base + digit;
    80200848:	fbc42703          	lw	a4,-68(s0)
    8020084c:	fe843783          	ld	a5,-24(s0)
    80200850:	02f70733          	mul	a4,a4,a5
    80200854:	fd442783          	lw	a5,-44(s0)
    80200858:	00f707b3          	add	a5,a4,a5
    8020085c:	fef43423          	sd	a5,-24(s0)
        p++;
    80200860:	fd843783          	ld	a5,-40(s0)
    80200864:	00178793          	addi	a5,a5,1
    80200868:	fcf43c23          	sd	a5,-40(s0)
    while (1) {
    8020086c:	f09ff06f          	j	80200774 <strtol+0x128>
            break;
    80200870:	00000013          	nop
    }

    if (endptr) {
    80200874:	fc043783          	ld	a5,-64(s0)
    80200878:	00078863          	beqz	a5,80200888 <strtol+0x23c>
        *endptr = (char *)p;
    8020087c:	fc043783          	ld	a5,-64(s0)
    80200880:	fd843703          	ld	a4,-40(s0)
    80200884:	00e7b023          	sd	a4,0(a5)
    }

    return neg ? -ret : ret;
    80200888:	fe744783          	lbu	a5,-25(s0)
    8020088c:	0ff7f793          	zext.b	a5,a5
    80200890:	00078863          	beqz	a5,802008a0 <strtol+0x254>
    80200894:	fe843783          	ld	a5,-24(s0)
    80200898:	40f007b3          	neg	a5,a5
    8020089c:	0080006f          	j	802008a4 <strtol+0x258>
    802008a0:	fe843783          	ld	a5,-24(s0)
}
    802008a4:	00078513          	mv	a0,a5
    802008a8:	04813083          	ld	ra,72(sp)
    802008ac:	04013403          	ld	s0,64(sp)
    802008b0:	05010113          	addi	sp,sp,80
    802008b4:	00008067          	ret

00000000802008b8 <puts_wo_nl>:

// puts without newline
static int puts_wo_nl(int (*putch)(int), const char *s) {
    802008b8:	fd010113          	addi	sp,sp,-48
    802008bc:	02113423          	sd	ra,40(sp)
    802008c0:	02813023          	sd	s0,32(sp)
    802008c4:	03010413          	addi	s0,sp,48
    802008c8:	fca43c23          	sd	a0,-40(s0)
    802008cc:	fcb43823          	sd	a1,-48(s0)
    if (!s) {
    802008d0:	fd043783          	ld	a5,-48(s0)
    802008d4:	00079863          	bnez	a5,802008e4 <puts_wo_nl+0x2c>
        s = "(null)";
    802008d8:	00001797          	auipc	a5,0x1
    802008dc:	7b878793          	addi	a5,a5,1976 # 80202090 <_srodata+0x90>
    802008e0:	fcf43823          	sd	a5,-48(s0)
    }
    const char *p = s;
    802008e4:	fd043783          	ld	a5,-48(s0)
    802008e8:	fef43423          	sd	a5,-24(s0)
    while (*p) {
    802008ec:	0240006f          	j	80200910 <puts_wo_nl+0x58>
        putch(*p++);
    802008f0:	fe843783          	ld	a5,-24(s0)
    802008f4:	00178713          	addi	a4,a5,1
    802008f8:	fee43423          	sd	a4,-24(s0)
    802008fc:	0007c783          	lbu	a5,0(a5)
    80200900:	0007871b          	sext.w	a4,a5
    80200904:	fd843783          	ld	a5,-40(s0)
    80200908:	00070513          	mv	a0,a4
    8020090c:	000780e7          	jalr	a5
    while (*p) {
    80200910:	fe843783          	ld	a5,-24(s0)
    80200914:	0007c783          	lbu	a5,0(a5)
    80200918:	fc079ce3          	bnez	a5,802008f0 <puts_wo_nl+0x38>
    }
    return p - s;
    8020091c:	fe843703          	ld	a4,-24(s0)
    80200920:	fd043783          	ld	a5,-48(s0)
    80200924:	40f707b3          	sub	a5,a4,a5
    80200928:	0007879b          	sext.w	a5,a5
}
    8020092c:	00078513          	mv	a0,a5
    80200930:	02813083          	ld	ra,40(sp)
    80200934:	02013403          	ld	s0,32(sp)
    80200938:	03010113          	addi	sp,sp,48
    8020093c:	00008067          	ret

0000000080200940 <print_dec_int>:

static int print_dec_int(int (*putch)(int), unsigned long num, bool is_signed, struct fmt_flags *flags) {
    80200940:	f9010113          	addi	sp,sp,-112
    80200944:	06113423          	sd	ra,104(sp)
    80200948:	06813023          	sd	s0,96(sp)
    8020094c:	07010413          	addi	s0,sp,112
    80200950:	faa43423          	sd	a0,-88(s0)
    80200954:	fab43023          	sd	a1,-96(s0)
    80200958:	00060793          	mv	a5,a2
    8020095c:	f8d43823          	sd	a3,-112(s0)
    80200960:	f8f40fa3          	sb	a5,-97(s0)
    if (is_signed && num == 0x8000000000000000UL) {
    80200964:	f9f44783          	lbu	a5,-97(s0)
    80200968:	0ff7f793          	zext.b	a5,a5
    8020096c:	02078663          	beqz	a5,80200998 <print_dec_int+0x58>
    80200970:	fa043703          	ld	a4,-96(s0)
    80200974:	fff00793          	li	a5,-1
    80200978:	03f79793          	slli	a5,a5,0x3f
    8020097c:	00f71e63          	bne	a4,a5,80200998 <print_dec_int+0x58>
        // special case for 0x8000000000000000
        return puts_wo_nl(putch, "-9223372036854775808");
    80200980:	00001597          	auipc	a1,0x1
    80200984:	71858593          	addi	a1,a1,1816 # 80202098 <_srodata+0x98>
    80200988:	fa843503          	ld	a0,-88(s0)
    8020098c:	f2dff0ef          	jal	802008b8 <puts_wo_nl>
    80200990:	00050793          	mv	a5,a0
    80200994:	2a00006f          	j	80200c34 <print_dec_int+0x2f4>
    }

    if (flags->prec == 0 && num == 0) {
    80200998:	f9043783          	ld	a5,-112(s0)
    8020099c:	00c7a783          	lw	a5,12(a5)
    802009a0:	00079a63          	bnez	a5,802009b4 <print_dec_int+0x74>
    802009a4:	fa043783          	ld	a5,-96(s0)
    802009a8:	00079663          	bnez	a5,802009b4 <print_dec_int+0x74>
        return 0;
    802009ac:	00000793          	li	a5,0
    802009b0:	2840006f          	j	80200c34 <print_dec_int+0x2f4>
    }

    bool neg = false;
    802009b4:	fe0407a3          	sb	zero,-17(s0)

    if (is_signed && (long)num < 0) {
    802009b8:	f9f44783          	lbu	a5,-97(s0)
    802009bc:	0ff7f793          	zext.b	a5,a5
    802009c0:	02078063          	beqz	a5,802009e0 <print_dec_int+0xa0>
    802009c4:	fa043783          	ld	a5,-96(s0)
    802009c8:	0007dc63          	bgez	a5,802009e0 <print_dec_int+0xa0>
        neg = true;
    802009cc:	00100793          	li	a5,1
    802009d0:	fef407a3          	sb	a5,-17(s0)
        num = -num;
    802009d4:	fa043783          	ld	a5,-96(s0)
    802009d8:	40f007b3          	neg	a5,a5
    802009dc:	faf43023          	sd	a5,-96(s0)
    }

    char buf[20];
    int decdigits = 0;
    802009e0:	fe042423          	sw	zero,-24(s0)

    bool has_sign_char = is_signed && (neg || flags->sign || flags->spaceflag);
    802009e4:	f9f44783          	lbu	a5,-97(s0)
    802009e8:	0ff7f793          	zext.b	a5,a5
    802009ec:	02078863          	beqz	a5,80200a1c <print_dec_int+0xdc>
    802009f0:	fef44783          	lbu	a5,-17(s0)
    802009f4:	0ff7f793          	zext.b	a5,a5
    802009f8:	00079e63          	bnez	a5,80200a14 <print_dec_int+0xd4>
    802009fc:	f9043783          	ld	a5,-112(s0)
    80200a00:	0057c783          	lbu	a5,5(a5)
    80200a04:	00079863          	bnez	a5,80200a14 <print_dec_int+0xd4>
    80200a08:	f9043783          	ld	a5,-112(s0)
    80200a0c:	0047c783          	lbu	a5,4(a5)
    80200a10:	00078663          	beqz	a5,80200a1c <print_dec_int+0xdc>
    80200a14:	00100793          	li	a5,1
    80200a18:	0080006f          	j	80200a20 <print_dec_int+0xe0>
    80200a1c:	00000793          	li	a5,0
    80200a20:	fcf40ba3          	sb	a5,-41(s0)
    80200a24:	fd744783          	lbu	a5,-41(s0)
    80200a28:	0017f793          	andi	a5,a5,1
    80200a2c:	fcf40ba3          	sb	a5,-41(s0)

    do {
        buf[decdigits++] = num % 10 + '0';
    80200a30:	fa043703          	ld	a4,-96(s0)
    80200a34:	00a00793          	li	a5,10
    80200a38:	02f777b3          	remu	a5,a4,a5
    80200a3c:	0ff7f713          	zext.b	a4,a5
    80200a40:	fe842783          	lw	a5,-24(s0)
    80200a44:	0017869b          	addiw	a3,a5,1
    80200a48:	fed42423          	sw	a3,-24(s0)
    80200a4c:	0307071b          	addiw	a4,a4,48
    80200a50:	0ff77713          	zext.b	a4,a4
    80200a54:	ff078793          	addi	a5,a5,-16
    80200a58:	008787b3          	add	a5,a5,s0
    80200a5c:	fce78423          	sb	a4,-56(a5)
        num /= 10;
    80200a60:	fa043703          	ld	a4,-96(s0)
    80200a64:	00a00793          	li	a5,10
    80200a68:	02f757b3          	divu	a5,a4,a5
    80200a6c:	faf43023          	sd	a5,-96(s0)
    } while (num);
    80200a70:	fa043783          	ld	a5,-96(s0)
    80200a74:	fa079ee3          	bnez	a5,80200a30 <print_dec_int+0xf0>

    if (flags->prec == -1 && flags->zeroflag) {
    80200a78:	f9043783          	ld	a5,-112(s0)
    80200a7c:	00c7a783          	lw	a5,12(a5)
    80200a80:	00078713          	mv	a4,a5
    80200a84:	fff00793          	li	a5,-1
    80200a88:	02f71063          	bne	a4,a5,80200aa8 <print_dec_int+0x168>
    80200a8c:	f9043783          	ld	a5,-112(s0)
    80200a90:	0037c783          	lbu	a5,3(a5)
    80200a94:	00078a63          	beqz	a5,80200aa8 <print_dec_int+0x168>
        flags->prec = flags->width;
    80200a98:	f9043783          	ld	a5,-112(s0)
    80200a9c:	0087a703          	lw	a4,8(a5)
    80200aa0:	f9043783          	ld	a5,-112(s0)
    80200aa4:	00e7a623          	sw	a4,12(a5)
    }

    int written = 0;
    80200aa8:	fe042223          	sw	zero,-28(s0)

    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80200aac:	f9043783          	ld	a5,-112(s0)
    80200ab0:	0087a703          	lw	a4,8(a5)
    80200ab4:	fe842783          	lw	a5,-24(s0)
    80200ab8:	fcf42823          	sw	a5,-48(s0)
    80200abc:	f9043783          	ld	a5,-112(s0)
    80200ac0:	00c7a783          	lw	a5,12(a5)
    80200ac4:	fcf42623          	sw	a5,-52(s0)
    80200ac8:	fd042783          	lw	a5,-48(s0)
    80200acc:	00078593          	mv	a1,a5
    80200ad0:	fcc42783          	lw	a5,-52(s0)
    80200ad4:	00078613          	mv	a2,a5
    80200ad8:	0006069b          	sext.w	a3,a2
    80200adc:	0005879b          	sext.w	a5,a1
    80200ae0:	00f6d463          	bge	a3,a5,80200ae8 <print_dec_int+0x1a8>
    80200ae4:	00058613          	mv	a2,a1
    80200ae8:	0006079b          	sext.w	a5,a2
    80200aec:	40f707bb          	subw	a5,a4,a5
    80200af0:	0007871b          	sext.w	a4,a5
    80200af4:	fd744783          	lbu	a5,-41(s0)
    80200af8:	0007879b          	sext.w	a5,a5
    80200afc:	40f707bb          	subw	a5,a4,a5
    80200b00:	fef42023          	sw	a5,-32(s0)
    80200b04:	0280006f          	j	80200b2c <print_dec_int+0x1ec>
        putch(' ');
    80200b08:	fa843783          	ld	a5,-88(s0)
    80200b0c:	02000513          	li	a0,32
    80200b10:	000780e7          	jalr	a5
        ++written;
    80200b14:	fe442783          	lw	a5,-28(s0)
    80200b18:	0017879b          	addiw	a5,a5,1
    80200b1c:	fef42223          	sw	a5,-28(s0)
    for (int i = flags->width - __MAX(decdigits, flags->prec) - has_sign_char; i > 0; i--) {
    80200b20:	fe042783          	lw	a5,-32(s0)
    80200b24:	fff7879b          	addiw	a5,a5,-1
    80200b28:	fef42023          	sw	a5,-32(s0)
    80200b2c:	fe042783          	lw	a5,-32(s0)
    80200b30:	0007879b          	sext.w	a5,a5
    80200b34:	fcf04ae3          	bgtz	a5,80200b08 <print_dec_int+0x1c8>
    }

    if (has_sign_char) {
    80200b38:	fd744783          	lbu	a5,-41(s0)
    80200b3c:	0ff7f793          	zext.b	a5,a5
    80200b40:	04078463          	beqz	a5,80200b88 <print_dec_int+0x248>
        putch(neg ? '-' : flags->sign ? '+' : ' ');
    80200b44:	fef44783          	lbu	a5,-17(s0)
    80200b48:	0ff7f793          	zext.b	a5,a5
    80200b4c:	00078663          	beqz	a5,80200b58 <print_dec_int+0x218>
    80200b50:	02d00793          	li	a5,45
    80200b54:	01c0006f          	j	80200b70 <print_dec_int+0x230>
    80200b58:	f9043783          	ld	a5,-112(s0)
    80200b5c:	0057c783          	lbu	a5,5(a5)
    80200b60:	00078663          	beqz	a5,80200b6c <print_dec_int+0x22c>
    80200b64:	02b00793          	li	a5,43
    80200b68:	0080006f          	j	80200b70 <print_dec_int+0x230>
    80200b6c:	02000793          	li	a5,32
    80200b70:	fa843703          	ld	a4,-88(s0)
    80200b74:	00078513          	mv	a0,a5
    80200b78:	000700e7          	jalr	a4
        ++written;
    80200b7c:	fe442783          	lw	a5,-28(s0)
    80200b80:	0017879b          	addiw	a5,a5,1
    80200b84:	fef42223          	sw	a5,-28(s0)
    }

    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80200b88:	fe842783          	lw	a5,-24(s0)
    80200b8c:	fcf42e23          	sw	a5,-36(s0)
    80200b90:	0280006f          	j	80200bb8 <print_dec_int+0x278>
        putch('0');
    80200b94:	fa843783          	ld	a5,-88(s0)
    80200b98:	03000513          	li	a0,48
    80200b9c:	000780e7          	jalr	a5
        ++written;
    80200ba0:	fe442783          	lw	a5,-28(s0)
    80200ba4:	0017879b          	addiw	a5,a5,1
    80200ba8:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits; i < flags->prec - has_sign_char; i++) {
    80200bac:	fdc42783          	lw	a5,-36(s0)
    80200bb0:	0017879b          	addiw	a5,a5,1
    80200bb4:	fcf42e23          	sw	a5,-36(s0)
    80200bb8:	f9043783          	ld	a5,-112(s0)
    80200bbc:	00c7a703          	lw	a4,12(a5)
    80200bc0:	fd744783          	lbu	a5,-41(s0)
    80200bc4:	0007879b          	sext.w	a5,a5
    80200bc8:	40f707bb          	subw	a5,a4,a5
    80200bcc:	0007871b          	sext.w	a4,a5
    80200bd0:	fdc42783          	lw	a5,-36(s0)
    80200bd4:	0007879b          	sext.w	a5,a5
    80200bd8:	fae7cee3          	blt	a5,a4,80200b94 <print_dec_int+0x254>
    }

    for (int i = decdigits - 1; i >= 0; i--) {
    80200bdc:	fe842783          	lw	a5,-24(s0)
    80200be0:	fff7879b          	addiw	a5,a5,-1
    80200be4:	fcf42c23          	sw	a5,-40(s0)
    80200be8:	03c0006f          	j	80200c24 <print_dec_int+0x2e4>
        putch(buf[i]);
    80200bec:	fd842783          	lw	a5,-40(s0)
    80200bf0:	ff078793          	addi	a5,a5,-16
    80200bf4:	008787b3          	add	a5,a5,s0
    80200bf8:	fc87c783          	lbu	a5,-56(a5)
    80200bfc:	0007871b          	sext.w	a4,a5
    80200c00:	fa843783          	ld	a5,-88(s0)
    80200c04:	00070513          	mv	a0,a4
    80200c08:	000780e7          	jalr	a5
        ++written;
    80200c0c:	fe442783          	lw	a5,-28(s0)
    80200c10:	0017879b          	addiw	a5,a5,1
    80200c14:	fef42223          	sw	a5,-28(s0)
    for (int i = decdigits - 1; i >= 0; i--) {
    80200c18:	fd842783          	lw	a5,-40(s0)
    80200c1c:	fff7879b          	addiw	a5,a5,-1
    80200c20:	fcf42c23          	sw	a5,-40(s0)
    80200c24:	fd842783          	lw	a5,-40(s0)
    80200c28:	0007879b          	sext.w	a5,a5
    80200c2c:	fc07d0e3          	bgez	a5,80200bec <print_dec_int+0x2ac>
    }

    return written;
    80200c30:	fe442783          	lw	a5,-28(s0)
}
    80200c34:	00078513          	mv	a0,a5
    80200c38:	06813083          	ld	ra,104(sp)
    80200c3c:	06013403          	ld	s0,96(sp)
    80200c40:	07010113          	addi	sp,sp,112
    80200c44:	00008067          	ret

0000000080200c48 <vprintfmt>:

int vprintfmt(int (*putch)(int), const char *fmt, va_list vl) {
    80200c48:	f4010113          	addi	sp,sp,-192
    80200c4c:	0a113c23          	sd	ra,184(sp)
    80200c50:	0a813823          	sd	s0,176(sp)
    80200c54:	0c010413          	addi	s0,sp,192
    80200c58:	f4a43c23          	sd	a0,-168(s0)
    80200c5c:	f4b43823          	sd	a1,-176(s0)
    80200c60:	f4c43423          	sd	a2,-184(s0)
    static const char lowerxdigits[] = "0123456789abcdef";
    static const char upperxdigits[] = "0123456789ABCDEF";

    struct fmt_flags flags = {};
    80200c64:	f8043023          	sd	zero,-128(s0)
    80200c68:	f8043423          	sd	zero,-120(s0)

    int written = 0;
    80200c6c:	fe042623          	sw	zero,-20(s0)

    for (; *fmt; fmt++) {
    80200c70:	7a40006f          	j	80201414 <vprintfmt+0x7cc>
        if (flags.in_format) {
    80200c74:	f8044783          	lbu	a5,-128(s0)
    80200c78:	72078e63          	beqz	a5,802013b4 <vprintfmt+0x76c>
            if (*fmt == '#') {
    80200c7c:	f5043783          	ld	a5,-176(s0)
    80200c80:	0007c783          	lbu	a5,0(a5)
    80200c84:	00078713          	mv	a4,a5
    80200c88:	02300793          	li	a5,35
    80200c8c:	00f71863          	bne	a4,a5,80200c9c <vprintfmt+0x54>
                flags.sharpflag = true;
    80200c90:	00100793          	li	a5,1
    80200c94:	f8f40123          	sb	a5,-126(s0)
    80200c98:	7700006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == '0') {
    80200c9c:	f5043783          	ld	a5,-176(s0)
    80200ca0:	0007c783          	lbu	a5,0(a5)
    80200ca4:	00078713          	mv	a4,a5
    80200ca8:	03000793          	li	a5,48
    80200cac:	00f71863          	bne	a4,a5,80200cbc <vprintfmt+0x74>
                flags.zeroflag = true;
    80200cb0:	00100793          	li	a5,1
    80200cb4:	f8f401a3          	sb	a5,-125(s0)
    80200cb8:	7500006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == 'l' || *fmt == 'z' || *fmt == 't' || *fmt == 'j') {
    80200cbc:	f5043783          	ld	a5,-176(s0)
    80200cc0:	0007c783          	lbu	a5,0(a5)
    80200cc4:	00078713          	mv	a4,a5
    80200cc8:	06c00793          	li	a5,108
    80200ccc:	04f70063          	beq	a4,a5,80200d0c <vprintfmt+0xc4>
    80200cd0:	f5043783          	ld	a5,-176(s0)
    80200cd4:	0007c783          	lbu	a5,0(a5)
    80200cd8:	00078713          	mv	a4,a5
    80200cdc:	07a00793          	li	a5,122
    80200ce0:	02f70663          	beq	a4,a5,80200d0c <vprintfmt+0xc4>
    80200ce4:	f5043783          	ld	a5,-176(s0)
    80200ce8:	0007c783          	lbu	a5,0(a5)
    80200cec:	00078713          	mv	a4,a5
    80200cf0:	07400793          	li	a5,116
    80200cf4:	00f70c63          	beq	a4,a5,80200d0c <vprintfmt+0xc4>
    80200cf8:	f5043783          	ld	a5,-176(s0)
    80200cfc:	0007c783          	lbu	a5,0(a5)
    80200d00:	00078713          	mv	a4,a5
    80200d04:	06a00793          	li	a5,106
    80200d08:	00f71863          	bne	a4,a5,80200d18 <vprintfmt+0xd0>
                // l: long, z: size_t, t: ptrdiff_t, j: intmax_t
                flags.longflag = true;
    80200d0c:	00100793          	li	a5,1
    80200d10:	f8f400a3          	sb	a5,-127(s0)
    80200d14:	6f40006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == '+') {
    80200d18:	f5043783          	ld	a5,-176(s0)
    80200d1c:	0007c783          	lbu	a5,0(a5)
    80200d20:	00078713          	mv	a4,a5
    80200d24:	02b00793          	li	a5,43
    80200d28:	00f71863          	bne	a4,a5,80200d38 <vprintfmt+0xf0>
                flags.sign = true;
    80200d2c:	00100793          	li	a5,1
    80200d30:	f8f402a3          	sb	a5,-123(s0)
    80200d34:	6d40006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == ' ') {
    80200d38:	f5043783          	ld	a5,-176(s0)
    80200d3c:	0007c783          	lbu	a5,0(a5)
    80200d40:	00078713          	mv	a4,a5
    80200d44:	02000793          	li	a5,32
    80200d48:	00f71863          	bne	a4,a5,80200d58 <vprintfmt+0x110>
                flags.spaceflag = true;
    80200d4c:	00100793          	li	a5,1
    80200d50:	f8f40223          	sb	a5,-124(s0)
    80200d54:	6b40006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == '*') {
    80200d58:	f5043783          	ld	a5,-176(s0)
    80200d5c:	0007c783          	lbu	a5,0(a5)
    80200d60:	00078713          	mv	a4,a5
    80200d64:	02a00793          	li	a5,42
    80200d68:	00f71e63          	bne	a4,a5,80200d84 <vprintfmt+0x13c>
                flags.width = va_arg(vl, int);
    80200d6c:	f4843783          	ld	a5,-184(s0)
    80200d70:	00878713          	addi	a4,a5,8
    80200d74:	f4e43423          	sd	a4,-184(s0)
    80200d78:	0007a783          	lw	a5,0(a5)
    80200d7c:	f8f42423          	sw	a5,-120(s0)
    80200d80:	6880006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt >= '1' && *fmt <= '9') {
    80200d84:	f5043783          	ld	a5,-176(s0)
    80200d88:	0007c783          	lbu	a5,0(a5)
    80200d8c:	00078713          	mv	a4,a5
    80200d90:	03000793          	li	a5,48
    80200d94:	04e7f663          	bgeu	a5,a4,80200de0 <vprintfmt+0x198>
    80200d98:	f5043783          	ld	a5,-176(s0)
    80200d9c:	0007c783          	lbu	a5,0(a5)
    80200da0:	00078713          	mv	a4,a5
    80200da4:	03900793          	li	a5,57
    80200da8:	02e7ec63          	bltu	a5,a4,80200de0 <vprintfmt+0x198>
                flags.width = strtol(fmt, (char **)&fmt, 10);
    80200dac:	f5043783          	ld	a5,-176(s0)
    80200db0:	f5040713          	addi	a4,s0,-176
    80200db4:	00a00613          	li	a2,10
    80200db8:	00070593          	mv	a1,a4
    80200dbc:	00078513          	mv	a0,a5
    80200dc0:	88dff0ef          	jal	8020064c <strtol>
    80200dc4:	00050793          	mv	a5,a0
    80200dc8:	0007879b          	sext.w	a5,a5
    80200dcc:	f8f42423          	sw	a5,-120(s0)
                fmt--;
    80200dd0:	f5043783          	ld	a5,-176(s0)
    80200dd4:	fff78793          	addi	a5,a5,-1
    80200dd8:	f4f43823          	sd	a5,-176(s0)
    80200ddc:	62c0006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == '.') {
    80200de0:	f5043783          	ld	a5,-176(s0)
    80200de4:	0007c783          	lbu	a5,0(a5)
    80200de8:	00078713          	mv	a4,a5
    80200dec:	02e00793          	li	a5,46
    80200df0:	06f71863          	bne	a4,a5,80200e60 <vprintfmt+0x218>
                fmt++;
    80200df4:	f5043783          	ld	a5,-176(s0)
    80200df8:	00178793          	addi	a5,a5,1
    80200dfc:	f4f43823          	sd	a5,-176(s0)
                if (*fmt == '*') {
    80200e00:	f5043783          	ld	a5,-176(s0)
    80200e04:	0007c783          	lbu	a5,0(a5)
    80200e08:	00078713          	mv	a4,a5
    80200e0c:	02a00793          	li	a5,42
    80200e10:	00f71e63          	bne	a4,a5,80200e2c <vprintfmt+0x1e4>
                    flags.prec = va_arg(vl, int);
    80200e14:	f4843783          	ld	a5,-184(s0)
    80200e18:	00878713          	addi	a4,a5,8
    80200e1c:	f4e43423          	sd	a4,-184(s0)
    80200e20:	0007a783          	lw	a5,0(a5)
    80200e24:	f8f42623          	sw	a5,-116(s0)
    80200e28:	5e00006f          	j	80201408 <vprintfmt+0x7c0>
                } else {
                    flags.prec = strtol(fmt, (char **)&fmt, 10);
    80200e2c:	f5043783          	ld	a5,-176(s0)
    80200e30:	f5040713          	addi	a4,s0,-176
    80200e34:	00a00613          	li	a2,10
    80200e38:	00070593          	mv	a1,a4
    80200e3c:	00078513          	mv	a0,a5
    80200e40:	80dff0ef          	jal	8020064c <strtol>
    80200e44:	00050793          	mv	a5,a0
    80200e48:	0007879b          	sext.w	a5,a5
    80200e4c:	f8f42623          	sw	a5,-116(s0)
                    fmt--;
    80200e50:	f5043783          	ld	a5,-176(s0)
    80200e54:	fff78793          	addi	a5,a5,-1
    80200e58:	f4f43823          	sd	a5,-176(s0)
    80200e5c:	5ac0006f          	j	80201408 <vprintfmt+0x7c0>
                }
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80200e60:	f5043783          	ld	a5,-176(s0)
    80200e64:	0007c783          	lbu	a5,0(a5)
    80200e68:	00078713          	mv	a4,a5
    80200e6c:	07800793          	li	a5,120
    80200e70:	02f70663          	beq	a4,a5,80200e9c <vprintfmt+0x254>
    80200e74:	f5043783          	ld	a5,-176(s0)
    80200e78:	0007c783          	lbu	a5,0(a5)
    80200e7c:	00078713          	mv	a4,a5
    80200e80:	05800793          	li	a5,88
    80200e84:	00f70c63          	beq	a4,a5,80200e9c <vprintfmt+0x254>
    80200e88:	f5043783          	ld	a5,-176(s0)
    80200e8c:	0007c783          	lbu	a5,0(a5)
    80200e90:	00078713          	mv	a4,a5
    80200e94:	07000793          	li	a5,112
    80200e98:	30f71263          	bne	a4,a5,8020119c <vprintfmt+0x554>
                bool is_long = *fmt == 'p' || flags.longflag;
    80200e9c:	f5043783          	ld	a5,-176(s0)
    80200ea0:	0007c783          	lbu	a5,0(a5)
    80200ea4:	00078713          	mv	a4,a5
    80200ea8:	07000793          	li	a5,112
    80200eac:	00f70663          	beq	a4,a5,80200eb8 <vprintfmt+0x270>
    80200eb0:	f8144783          	lbu	a5,-127(s0)
    80200eb4:	00078663          	beqz	a5,80200ec0 <vprintfmt+0x278>
    80200eb8:	00100793          	li	a5,1
    80200ebc:	0080006f          	j	80200ec4 <vprintfmt+0x27c>
    80200ec0:	00000793          	li	a5,0
    80200ec4:	faf403a3          	sb	a5,-89(s0)
    80200ec8:	fa744783          	lbu	a5,-89(s0)
    80200ecc:	0017f793          	andi	a5,a5,1
    80200ed0:	faf403a3          	sb	a5,-89(s0)

                unsigned long num = is_long ? va_arg(vl, unsigned long) : va_arg(vl, unsigned int);
    80200ed4:	fa744783          	lbu	a5,-89(s0)
    80200ed8:	0ff7f793          	zext.b	a5,a5
    80200edc:	00078c63          	beqz	a5,80200ef4 <vprintfmt+0x2ac>
    80200ee0:	f4843783          	ld	a5,-184(s0)
    80200ee4:	00878713          	addi	a4,a5,8
    80200ee8:	f4e43423          	sd	a4,-184(s0)
    80200eec:	0007b783          	ld	a5,0(a5)
    80200ef0:	01c0006f          	j	80200f0c <vprintfmt+0x2c4>
    80200ef4:	f4843783          	ld	a5,-184(s0)
    80200ef8:	00878713          	addi	a4,a5,8
    80200efc:	f4e43423          	sd	a4,-184(s0)
    80200f00:	0007a783          	lw	a5,0(a5)
    80200f04:	02079793          	slli	a5,a5,0x20
    80200f08:	0207d793          	srli	a5,a5,0x20
    80200f0c:	fef43023          	sd	a5,-32(s0)

                if (flags.prec == 0 && num == 0 && *fmt != 'p') {
    80200f10:	f8c42783          	lw	a5,-116(s0)
    80200f14:	02079463          	bnez	a5,80200f3c <vprintfmt+0x2f4>
    80200f18:	fe043783          	ld	a5,-32(s0)
    80200f1c:	02079063          	bnez	a5,80200f3c <vprintfmt+0x2f4>
    80200f20:	f5043783          	ld	a5,-176(s0)
    80200f24:	0007c783          	lbu	a5,0(a5)
    80200f28:	00078713          	mv	a4,a5
    80200f2c:	07000793          	li	a5,112
    80200f30:	00f70663          	beq	a4,a5,80200f3c <vprintfmt+0x2f4>
                    flags.in_format = false;
    80200f34:	f8040023          	sb	zero,-128(s0)
    80200f38:	4d00006f          	j	80201408 <vprintfmt+0x7c0>
                    continue;
                }

                // 0x prefix for pointers, or, if # flag is set and non-zero
                bool prefix = *fmt == 'p' || (flags.sharpflag && num != 0);
    80200f3c:	f5043783          	ld	a5,-176(s0)
    80200f40:	0007c783          	lbu	a5,0(a5)
    80200f44:	00078713          	mv	a4,a5
    80200f48:	07000793          	li	a5,112
    80200f4c:	00f70a63          	beq	a4,a5,80200f60 <vprintfmt+0x318>
    80200f50:	f8244783          	lbu	a5,-126(s0)
    80200f54:	00078a63          	beqz	a5,80200f68 <vprintfmt+0x320>
    80200f58:	fe043783          	ld	a5,-32(s0)
    80200f5c:	00078663          	beqz	a5,80200f68 <vprintfmt+0x320>
    80200f60:	00100793          	li	a5,1
    80200f64:	0080006f          	j	80200f6c <vprintfmt+0x324>
    80200f68:	00000793          	li	a5,0
    80200f6c:	faf40323          	sb	a5,-90(s0)
    80200f70:	fa644783          	lbu	a5,-90(s0)
    80200f74:	0017f793          	andi	a5,a5,1
    80200f78:	faf40323          	sb	a5,-90(s0)

                int hexdigits = 0;
    80200f7c:	fc042e23          	sw	zero,-36(s0)
                const char *xdigits = *fmt == 'X' ? upperxdigits : lowerxdigits;
    80200f80:	f5043783          	ld	a5,-176(s0)
    80200f84:	0007c783          	lbu	a5,0(a5)
    80200f88:	00078713          	mv	a4,a5
    80200f8c:	05800793          	li	a5,88
    80200f90:	00f71863          	bne	a4,a5,80200fa0 <vprintfmt+0x358>
    80200f94:	00001797          	auipc	a5,0x1
    80200f98:	11c78793          	addi	a5,a5,284 # 802020b0 <upperxdigits.1>
    80200f9c:	00c0006f          	j	80200fa8 <vprintfmt+0x360>
    80200fa0:	00001797          	auipc	a5,0x1
    80200fa4:	12878793          	addi	a5,a5,296 # 802020c8 <lowerxdigits.0>
    80200fa8:	f8f43c23          	sd	a5,-104(s0)
                char buf[2 * sizeof(unsigned long)];

                do {
                    buf[hexdigits++] = xdigits[num & 0xf];
    80200fac:	fe043783          	ld	a5,-32(s0)
    80200fb0:	00f7f793          	andi	a5,a5,15
    80200fb4:	f9843703          	ld	a4,-104(s0)
    80200fb8:	00f70733          	add	a4,a4,a5
    80200fbc:	fdc42783          	lw	a5,-36(s0)
    80200fc0:	0017869b          	addiw	a3,a5,1
    80200fc4:	fcd42e23          	sw	a3,-36(s0)
    80200fc8:	00074703          	lbu	a4,0(a4)
    80200fcc:	ff078793          	addi	a5,a5,-16
    80200fd0:	008787b3          	add	a5,a5,s0
    80200fd4:	f8e78023          	sb	a4,-128(a5)
                    num >>= 4;
    80200fd8:	fe043783          	ld	a5,-32(s0)
    80200fdc:	0047d793          	srli	a5,a5,0x4
    80200fe0:	fef43023          	sd	a5,-32(s0)
                } while (num);
    80200fe4:	fe043783          	ld	a5,-32(s0)
    80200fe8:	fc0792e3          	bnez	a5,80200fac <vprintfmt+0x364>

                if (flags.prec == -1 && flags.zeroflag) {
    80200fec:	f8c42783          	lw	a5,-116(s0)
    80200ff0:	00078713          	mv	a4,a5
    80200ff4:	fff00793          	li	a5,-1
    80200ff8:	02f71663          	bne	a4,a5,80201024 <vprintfmt+0x3dc>
    80200ffc:	f8344783          	lbu	a5,-125(s0)
    80201000:	02078263          	beqz	a5,80201024 <vprintfmt+0x3dc>
                    flags.prec = flags.width - 2 * prefix;
    80201004:	f8842703          	lw	a4,-120(s0)
    80201008:	fa644783          	lbu	a5,-90(s0)
    8020100c:	0007879b          	sext.w	a5,a5
    80201010:	0017979b          	slliw	a5,a5,0x1
    80201014:	0007879b          	sext.w	a5,a5
    80201018:	40f707bb          	subw	a5,a4,a5
    8020101c:	0007879b          	sext.w	a5,a5
    80201020:	f8f42623          	sw	a5,-116(s0)
                }

                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201024:	f8842703          	lw	a4,-120(s0)
    80201028:	fa644783          	lbu	a5,-90(s0)
    8020102c:	0007879b          	sext.w	a5,a5
    80201030:	0017979b          	slliw	a5,a5,0x1
    80201034:	0007879b          	sext.w	a5,a5
    80201038:	40f707bb          	subw	a5,a4,a5
    8020103c:	0007871b          	sext.w	a4,a5
    80201040:	fdc42783          	lw	a5,-36(s0)
    80201044:	f8f42a23          	sw	a5,-108(s0)
    80201048:	f8c42783          	lw	a5,-116(s0)
    8020104c:	f8f42823          	sw	a5,-112(s0)
    80201050:	f9442783          	lw	a5,-108(s0)
    80201054:	00078593          	mv	a1,a5
    80201058:	f9042783          	lw	a5,-112(s0)
    8020105c:	00078613          	mv	a2,a5
    80201060:	0006069b          	sext.w	a3,a2
    80201064:	0005879b          	sext.w	a5,a1
    80201068:	00f6d463          	bge	a3,a5,80201070 <vprintfmt+0x428>
    8020106c:	00058613          	mv	a2,a1
    80201070:	0006079b          	sext.w	a5,a2
    80201074:	40f707bb          	subw	a5,a4,a5
    80201078:	fcf42c23          	sw	a5,-40(s0)
    8020107c:	0280006f          	j	802010a4 <vprintfmt+0x45c>
                    putch(' ');
    80201080:	f5843783          	ld	a5,-168(s0)
    80201084:	02000513          	li	a0,32
    80201088:	000780e7          	jalr	a5
                    ++written;
    8020108c:	fec42783          	lw	a5,-20(s0)
    80201090:	0017879b          	addiw	a5,a5,1
    80201094:	fef42623          	sw	a5,-20(s0)
                for (int i = flags.width - 2 * prefix - __MAX(hexdigits, flags.prec); i > 0; i--) {
    80201098:	fd842783          	lw	a5,-40(s0)
    8020109c:	fff7879b          	addiw	a5,a5,-1
    802010a0:	fcf42c23          	sw	a5,-40(s0)
    802010a4:	fd842783          	lw	a5,-40(s0)
    802010a8:	0007879b          	sext.w	a5,a5
    802010ac:	fcf04ae3          	bgtz	a5,80201080 <vprintfmt+0x438>
                }

                if (prefix) {
    802010b0:	fa644783          	lbu	a5,-90(s0)
    802010b4:	0ff7f793          	zext.b	a5,a5
    802010b8:	04078463          	beqz	a5,80201100 <vprintfmt+0x4b8>
                    putch('0');
    802010bc:	f5843783          	ld	a5,-168(s0)
    802010c0:	03000513          	li	a0,48
    802010c4:	000780e7          	jalr	a5
                    putch(*fmt == 'X' ? 'X' : 'x');
    802010c8:	f5043783          	ld	a5,-176(s0)
    802010cc:	0007c783          	lbu	a5,0(a5)
    802010d0:	00078713          	mv	a4,a5
    802010d4:	05800793          	li	a5,88
    802010d8:	00f71663          	bne	a4,a5,802010e4 <vprintfmt+0x49c>
    802010dc:	05800793          	li	a5,88
    802010e0:	0080006f          	j	802010e8 <vprintfmt+0x4a0>
    802010e4:	07800793          	li	a5,120
    802010e8:	f5843703          	ld	a4,-168(s0)
    802010ec:	00078513          	mv	a0,a5
    802010f0:	000700e7          	jalr	a4
                    written += 2;
    802010f4:	fec42783          	lw	a5,-20(s0)
    802010f8:	0027879b          	addiw	a5,a5,2
    802010fc:	fef42623          	sw	a5,-20(s0)
                }

                for (int i = hexdigits; i < flags.prec; i++) {
    80201100:	fdc42783          	lw	a5,-36(s0)
    80201104:	fcf42a23          	sw	a5,-44(s0)
    80201108:	0280006f          	j	80201130 <vprintfmt+0x4e8>
                    putch('0');
    8020110c:	f5843783          	ld	a5,-168(s0)
    80201110:	03000513          	li	a0,48
    80201114:	000780e7          	jalr	a5
                    ++written;
    80201118:	fec42783          	lw	a5,-20(s0)
    8020111c:	0017879b          	addiw	a5,a5,1
    80201120:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits; i < flags.prec; i++) {
    80201124:	fd442783          	lw	a5,-44(s0)
    80201128:	0017879b          	addiw	a5,a5,1
    8020112c:	fcf42a23          	sw	a5,-44(s0)
    80201130:	f8c42703          	lw	a4,-116(s0)
    80201134:	fd442783          	lw	a5,-44(s0)
    80201138:	0007879b          	sext.w	a5,a5
    8020113c:	fce7c8e3          	blt	a5,a4,8020110c <vprintfmt+0x4c4>
                }

                for (int i = hexdigits - 1; i >= 0; i--) {
    80201140:	fdc42783          	lw	a5,-36(s0)
    80201144:	fff7879b          	addiw	a5,a5,-1
    80201148:	fcf42823          	sw	a5,-48(s0)
    8020114c:	03c0006f          	j	80201188 <vprintfmt+0x540>
                    putch(buf[i]);
    80201150:	fd042783          	lw	a5,-48(s0)
    80201154:	ff078793          	addi	a5,a5,-16
    80201158:	008787b3          	add	a5,a5,s0
    8020115c:	f807c783          	lbu	a5,-128(a5)
    80201160:	0007871b          	sext.w	a4,a5
    80201164:	f5843783          	ld	a5,-168(s0)
    80201168:	00070513          	mv	a0,a4
    8020116c:	000780e7          	jalr	a5
                    ++written;
    80201170:	fec42783          	lw	a5,-20(s0)
    80201174:	0017879b          	addiw	a5,a5,1
    80201178:	fef42623          	sw	a5,-20(s0)
                for (int i = hexdigits - 1; i >= 0; i--) {
    8020117c:	fd042783          	lw	a5,-48(s0)
    80201180:	fff7879b          	addiw	a5,a5,-1
    80201184:	fcf42823          	sw	a5,-48(s0)
    80201188:	fd042783          	lw	a5,-48(s0)
    8020118c:	0007879b          	sext.w	a5,a5
    80201190:	fc07d0e3          	bgez	a5,80201150 <vprintfmt+0x508>
                }

                flags.in_format = false;
    80201194:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'x' || *fmt == 'X' || *fmt == 'p') {
    80201198:	2700006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    8020119c:	f5043783          	ld	a5,-176(s0)
    802011a0:	0007c783          	lbu	a5,0(a5)
    802011a4:	00078713          	mv	a4,a5
    802011a8:	06400793          	li	a5,100
    802011ac:	02f70663          	beq	a4,a5,802011d8 <vprintfmt+0x590>
    802011b0:	f5043783          	ld	a5,-176(s0)
    802011b4:	0007c783          	lbu	a5,0(a5)
    802011b8:	00078713          	mv	a4,a5
    802011bc:	06900793          	li	a5,105
    802011c0:	00f70c63          	beq	a4,a5,802011d8 <vprintfmt+0x590>
    802011c4:	f5043783          	ld	a5,-176(s0)
    802011c8:	0007c783          	lbu	a5,0(a5)
    802011cc:	00078713          	mv	a4,a5
    802011d0:	07500793          	li	a5,117
    802011d4:	08f71063          	bne	a4,a5,80201254 <vprintfmt+0x60c>
                long num = flags.longflag ? va_arg(vl, long) : va_arg(vl, int);
    802011d8:	f8144783          	lbu	a5,-127(s0)
    802011dc:	00078c63          	beqz	a5,802011f4 <vprintfmt+0x5ac>
    802011e0:	f4843783          	ld	a5,-184(s0)
    802011e4:	00878713          	addi	a4,a5,8
    802011e8:	f4e43423          	sd	a4,-184(s0)
    802011ec:	0007b783          	ld	a5,0(a5)
    802011f0:	0140006f          	j	80201204 <vprintfmt+0x5bc>
    802011f4:	f4843783          	ld	a5,-184(s0)
    802011f8:	00878713          	addi	a4,a5,8
    802011fc:	f4e43423          	sd	a4,-184(s0)
    80201200:	0007a783          	lw	a5,0(a5)
    80201204:	faf43423          	sd	a5,-88(s0)

                written += print_dec_int(putch, num, *fmt != 'u', &flags);
    80201208:	fa843583          	ld	a1,-88(s0)
    8020120c:	f5043783          	ld	a5,-176(s0)
    80201210:	0007c783          	lbu	a5,0(a5)
    80201214:	0007871b          	sext.w	a4,a5
    80201218:	07500793          	li	a5,117
    8020121c:	40f707b3          	sub	a5,a4,a5
    80201220:	00f037b3          	snez	a5,a5
    80201224:	0ff7f793          	zext.b	a5,a5
    80201228:	f8040713          	addi	a4,s0,-128
    8020122c:	00070693          	mv	a3,a4
    80201230:	00078613          	mv	a2,a5
    80201234:	f5843503          	ld	a0,-168(s0)
    80201238:	f08ff0ef          	jal	80200940 <print_dec_int>
    8020123c:	00050793          	mv	a5,a0
    80201240:	fec42703          	lw	a4,-20(s0)
    80201244:	00f707bb          	addw	a5,a4,a5
    80201248:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    8020124c:	f8040023          	sb	zero,-128(s0)
            } else if (*fmt == 'd' || *fmt == 'i' || *fmt == 'u') {
    80201250:	1b80006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == 'n') {
    80201254:	f5043783          	ld	a5,-176(s0)
    80201258:	0007c783          	lbu	a5,0(a5)
    8020125c:	00078713          	mv	a4,a5
    80201260:	06e00793          	li	a5,110
    80201264:	04f71c63          	bne	a4,a5,802012bc <vprintfmt+0x674>
                if (flags.longflag) {
    80201268:	f8144783          	lbu	a5,-127(s0)
    8020126c:	02078463          	beqz	a5,80201294 <vprintfmt+0x64c>
                    long *n = va_arg(vl, long *);
    80201270:	f4843783          	ld	a5,-184(s0)
    80201274:	00878713          	addi	a4,a5,8
    80201278:	f4e43423          	sd	a4,-184(s0)
    8020127c:	0007b783          	ld	a5,0(a5)
    80201280:	faf43823          	sd	a5,-80(s0)
                    *n = written;
    80201284:	fec42703          	lw	a4,-20(s0)
    80201288:	fb043783          	ld	a5,-80(s0)
    8020128c:	00e7b023          	sd	a4,0(a5)
    80201290:	0240006f          	j	802012b4 <vprintfmt+0x66c>
                } else {
                    int *n = va_arg(vl, int *);
    80201294:	f4843783          	ld	a5,-184(s0)
    80201298:	00878713          	addi	a4,a5,8
    8020129c:	f4e43423          	sd	a4,-184(s0)
    802012a0:	0007b783          	ld	a5,0(a5)
    802012a4:	faf43c23          	sd	a5,-72(s0)
                    *n = written;
    802012a8:	fb843783          	ld	a5,-72(s0)
    802012ac:	fec42703          	lw	a4,-20(s0)
    802012b0:	00e7a023          	sw	a4,0(a5)
                }
                flags.in_format = false;
    802012b4:	f8040023          	sb	zero,-128(s0)
    802012b8:	1500006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == 's') {
    802012bc:	f5043783          	ld	a5,-176(s0)
    802012c0:	0007c783          	lbu	a5,0(a5)
    802012c4:	00078713          	mv	a4,a5
    802012c8:	07300793          	li	a5,115
    802012cc:	02f71e63          	bne	a4,a5,80201308 <vprintfmt+0x6c0>
                const char *s = va_arg(vl, const char *);
    802012d0:	f4843783          	ld	a5,-184(s0)
    802012d4:	00878713          	addi	a4,a5,8
    802012d8:	f4e43423          	sd	a4,-184(s0)
    802012dc:	0007b783          	ld	a5,0(a5)
    802012e0:	fcf43023          	sd	a5,-64(s0)
                written += puts_wo_nl(putch, s);
    802012e4:	fc043583          	ld	a1,-64(s0)
    802012e8:	f5843503          	ld	a0,-168(s0)
    802012ec:	dccff0ef          	jal	802008b8 <puts_wo_nl>
    802012f0:	00050793          	mv	a5,a0
    802012f4:	fec42703          	lw	a4,-20(s0)
    802012f8:	00f707bb          	addw	a5,a4,a5
    802012fc:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201300:	f8040023          	sb	zero,-128(s0)
    80201304:	1040006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == 'c') {
    80201308:	f5043783          	ld	a5,-176(s0)
    8020130c:	0007c783          	lbu	a5,0(a5)
    80201310:	00078713          	mv	a4,a5
    80201314:	06300793          	li	a5,99
    80201318:	02f71e63          	bne	a4,a5,80201354 <vprintfmt+0x70c>
                int ch = va_arg(vl, int);
    8020131c:	f4843783          	ld	a5,-184(s0)
    80201320:	00878713          	addi	a4,a5,8
    80201324:	f4e43423          	sd	a4,-184(s0)
    80201328:	0007a783          	lw	a5,0(a5)
    8020132c:	fcf42623          	sw	a5,-52(s0)
                putch(ch);
    80201330:	fcc42703          	lw	a4,-52(s0)
    80201334:	f5843783          	ld	a5,-168(s0)
    80201338:	00070513          	mv	a0,a4
    8020133c:	000780e7          	jalr	a5
                ++written;
    80201340:	fec42783          	lw	a5,-20(s0)
    80201344:	0017879b          	addiw	a5,a5,1
    80201348:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    8020134c:	f8040023          	sb	zero,-128(s0)
    80201350:	0b80006f          	j	80201408 <vprintfmt+0x7c0>
            } else if (*fmt == '%') {
    80201354:	f5043783          	ld	a5,-176(s0)
    80201358:	0007c783          	lbu	a5,0(a5)
    8020135c:	00078713          	mv	a4,a5
    80201360:	02500793          	li	a5,37
    80201364:	02f71263          	bne	a4,a5,80201388 <vprintfmt+0x740>
                putch('%');
    80201368:	f5843783          	ld	a5,-168(s0)
    8020136c:	02500513          	li	a0,37
    80201370:	000780e7          	jalr	a5
                ++written;
    80201374:	fec42783          	lw	a5,-20(s0)
    80201378:	0017879b          	addiw	a5,a5,1
    8020137c:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    80201380:	f8040023          	sb	zero,-128(s0)
    80201384:	0840006f          	j	80201408 <vprintfmt+0x7c0>
            } else {
                putch(*fmt);
    80201388:	f5043783          	ld	a5,-176(s0)
    8020138c:	0007c783          	lbu	a5,0(a5)
    80201390:	0007871b          	sext.w	a4,a5
    80201394:	f5843783          	ld	a5,-168(s0)
    80201398:	00070513          	mv	a0,a4
    8020139c:	000780e7          	jalr	a5
                ++written;
    802013a0:	fec42783          	lw	a5,-20(s0)
    802013a4:	0017879b          	addiw	a5,a5,1
    802013a8:	fef42623          	sw	a5,-20(s0)
                flags.in_format = false;
    802013ac:	f8040023          	sb	zero,-128(s0)
    802013b0:	0580006f          	j	80201408 <vprintfmt+0x7c0>
            }
        } else if (*fmt == '%') {
    802013b4:	f5043783          	ld	a5,-176(s0)
    802013b8:	0007c783          	lbu	a5,0(a5)
    802013bc:	00078713          	mv	a4,a5
    802013c0:	02500793          	li	a5,37
    802013c4:	02f71063          	bne	a4,a5,802013e4 <vprintfmt+0x79c>
            flags = (struct fmt_flags) {.in_format = true, .prec = -1};
    802013c8:	f8043023          	sd	zero,-128(s0)
    802013cc:	f8043423          	sd	zero,-120(s0)
    802013d0:	00100793          	li	a5,1
    802013d4:	f8f40023          	sb	a5,-128(s0)
    802013d8:	fff00793          	li	a5,-1
    802013dc:	f8f42623          	sw	a5,-116(s0)
    802013e0:	0280006f          	j	80201408 <vprintfmt+0x7c0>
        } else {
            putch(*fmt);
    802013e4:	f5043783          	ld	a5,-176(s0)
    802013e8:	0007c783          	lbu	a5,0(a5)
    802013ec:	0007871b          	sext.w	a4,a5
    802013f0:	f5843783          	ld	a5,-168(s0)
    802013f4:	00070513          	mv	a0,a4
    802013f8:	000780e7          	jalr	a5
            ++written;
    802013fc:	fec42783          	lw	a5,-20(s0)
    80201400:	0017879b          	addiw	a5,a5,1
    80201404:	fef42623          	sw	a5,-20(s0)
    for (; *fmt; fmt++) {
    80201408:	f5043783          	ld	a5,-176(s0)
    8020140c:	00178793          	addi	a5,a5,1
    80201410:	f4f43823          	sd	a5,-176(s0)
    80201414:	f5043783          	ld	a5,-176(s0)
    80201418:	0007c783          	lbu	a5,0(a5)
    8020141c:	84079ce3          	bnez	a5,80200c74 <vprintfmt+0x2c>
        }
    }

    return written;
    80201420:	fec42783          	lw	a5,-20(s0)
}
    80201424:	00078513          	mv	a0,a5
    80201428:	0b813083          	ld	ra,184(sp)
    8020142c:	0b013403          	ld	s0,176(sp)
    80201430:	0c010113          	addi	sp,sp,192
    80201434:	00008067          	ret

0000000080201438 <printk>:

int printk(const char* s, ...) {
    80201438:	f9010113          	addi	sp,sp,-112
    8020143c:	02113423          	sd	ra,40(sp)
    80201440:	02813023          	sd	s0,32(sp)
    80201444:	03010413          	addi	s0,sp,48
    80201448:	fca43c23          	sd	a0,-40(s0)
    8020144c:	00b43423          	sd	a1,8(s0)
    80201450:	00c43823          	sd	a2,16(s0)
    80201454:	00d43c23          	sd	a3,24(s0)
    80201458:	02e43023          	sd	a4,32(s0)
    8020145c:	02f43423          	sd	a5,40(s0)
    80201460:	03043823          	sd	a6,48(s0)
    80201464:	03143c23          	sd	a7,56(s0)
    int res = 0;
    80201468:	fe042623          	sw	zero,-20(s0)
    va_list vl;
    va_start(vl, s);
    8020146c:	04040793          	addi	a5,s0,64
    80201470:	fcf43823          	sd	a5,-48(s0)
    80201474:	fd043783          	ld	a5,-48(s0)
    80201478:	fc878793          	addi	a5,a5,-56
    8020147c:	fef43023          	sd	a5,-32(s0)
    res = vprintfmt(putc, s, vl);
    80201480:	fe043783          	ld	a5,-32(s0)
    80201484:	00078613          	mv	a2,a5
    80201488:	fd843583          	ld	a1,-40(s0)
    8020148c:	fffff517          	auipc	a0,0xfffff
    80201490:	11850513          	addi	a0,a0,280 # 802005a4 <putc>
    80201494:	fb4ff0ef          	jal	80200c48 <vprintfmt>
    80201498:	00050793          	mv	a5,a0
    8020149c:	fef42623          	sw	a5,-20(s0)
    va_end(vl);
    return res;
    802014a0:	fec42783          	lw	a5,-20(s0)
}
    802014a4:	00078513          	mv	a0,a5
    802014a8:	02813083          	ld	ra,40(sp)
    802014ac:	02013403          	ld	s0,32(sp)
    802014b0:	07010113          	addi	sp,sp,112
    802014b4:	00008067          	ret
