
uapp.elf:     file format elf64-littleriscv


Disassembly of section .text.init:

0000000000000000 <_start>:
   0:	0380006f          	j	38 <main>

Disassembly of section .text.getpid:

0000000000000004 <getpid>:
   4:	fe010113          	addi	sp,sp,-32
   8:	00813c23          	sd	s0,24(sp)
   c:	02010413          	addi	s0,sp,32
  10:	fe843783          	ld	a5,-24(s0)
  14:	0ac00893          	li	a7,172
  18:	00000073          	ecall
  1c:	00050793          	mv	a5,a0
  20:	fef43423          	sd	a5,-24(s0)
  24:	fe843783          	ld	a5,-24(s0)
  28:	00078513          	mv	a0,a5
  2c:	01813403          	ld	s0,24(sp)
  30:	02010113          	addi	sp,sp,32
  34:	00008067          	ret

Disassembly of section .text.main:

0000000000000038 <main>:
  38:	fe010113          	addi	sp,sp,-32
  3c:	00113c23          	sd	ra,24(sp)
  40:	00813823          	sd	s0,16(sp)
  44:	02010413          	addi	s0,sp,32
  48:	fbdff0ef          	jal	4 <getpid>
  4c:	00050593          	mv	a1,a0
  50:	00010613          	mv	a2,sp
  54:	00001797          	auipc	a5,0x1
  58:	21878793          	addi	a5,a5,536 # 126c <counter>
  5c:	0007a783          	lw	a5,0(a5)
  60:	0017879b          	addiw	a5,a5,1
  64:	0007871b          	sext.w	a4,a5
  68:	00001797          	auipc	a5,0x1
  6c:	20478793          	addi	a5,a5,516 # 126c <counter>
  70:	00e7a023          	sw	a4,0(a5)
  74:	00001797          	auipc	a5,0x1
  78:	1f878793          	addi	a5,a5,504 # 126c <counter>
  7c:	0007a783          	lw	a5,0(a5)
  80:	00078693          	mv	a3,a5
  84:	00001517          	auipc	a0,0x1
  88:	16450513          	addi	a0,a0,356 # 11e8 <printf+0x278>
  8c:	6e5000ef          	jal	f70 <printf>
  90:	fe042623          	sw	zero,-20(s0)
  94:	0100006f          	j	a4 <main+0x6c>
  98:	fec42783          	lw	a5,-20(s0)
  9c:	0017879b          	addiw	a5,a5,1
  a0:	fef42623          	sw	a5,-20(s0)
  a4:	fec42783          	lw	a5,-20(s0)
  a8:	0007871b          	sext.w	a4,a5
  ac:	500007b7          	lui	a5,0x50000
  b0:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <buffer+0x4fffed86>
  b4:	fee7f2e3          	bgeu	a5,a4,98 <main+0x60>
  b8:	f91ff06f          	j	48 <main+0x10>

Disassembly of section .text.putc:

00000000000000bc <putc>:
  bc:	fe010113          	addi	sp,sp,-32
  c0:	00813c23          	sd	s0,24(sp)
  c4:	02010413          	addi	s0,sp,32
  c8:	00050793          	mv	a5,a0
  cc:	fef42623          	sw	a5,-20(s0)
  d0:	00001797          	auipc	a5,0x1
  d4:	1a078793          	addi	a5,a5,416 # 1270 <tail>
  d8:	0007a783          	lw	a5,0(a5)
  dc:	0017871b          	addiw	a4,a5,1
  e0:	0007069b          	sext.w	a3,a4
  e4:	00001717          	auipc	a4,0x1
  e8:	18c70713          	addi	a4,a4,396 # 1270 <tail>
  ec:	00d72023          	sw	a3,0(a4)
  f0:	fec42703          	lw	a4,-20(s0)
  f4:	0ff77713          	zext.b	a4,a4
  f8:	00001697          	auipc	a3,0x1
  fc:	18068693          	addi	a3,a3,384 # 1278 <buffer>
 100:	00f687b3          	add	a5,a3,a5
 104:	00e78023          	sb	a4,0(a5)
 108:	fec42783          	lw	a5,-20(s0)
 10c:	0ff7f793          	zext.b	a5,a5
 110:	0007879b          	sext.w	a5,a5
 114:	00078513          	mv	a0,a5
 118:	01813403          	ld	s0,24(sp)
 11c:	02010113          	addi	sp,sp,32
 120:	00008067          	ret

Disassembly of section .text.isspace:

0000000000000124 <isspace>:
 124:	fe010113          	addi	sp,sp,-32
 128:	00813c23          	sd	s0,24(sp)
 12c:	02010413          	addi	s0,sp,32
 130:	00050793          	mv	a5,a0
 134:	fef42623          	sw	a5,-20(s0)
 138:	fec42783          	lw	a5,-20(s0)
 13c:	0007871b          	sext.w	a4,a5
 140:	02000793          	li	a5,32
 144:	02f70263          	beq	a4,a5,168 <isspace+0x44>
 148:	fec42783          	lw	a5,-20(s0)
 14c:	0007871b          	sext.w	a4,a5
 150:	00800793          	li	a5,8
 154:	00e7de63          	bge	a5,a4,170 <isspace+0x4c>
 158:	fec42783          	lw	a5,-20(s0)
 15c:	0007871b          	sext.w	a4,a5
 160:	00d00793          	li	a5,13
 164:	00e7c663          	blt	a5,a4,170 <isspace+0x4c>
 168:	00100793          	li	a5,1
 16c:	0080006f          	j	174 <isspace+0x50>
 170:	00000793          	li	a5,0
 174:	00078513          	mv	a0,a5
 178:	01813403          	ld	s0,24(sp)
 17c:	02010113          	addi	sp,sp,32
 180:	00008067          	ret

Disassembly of section .text.strtol:

0000000000000184 <strtol>:
 184:	fb010113          	addi	sp,sp,-80
 188:	04113423          	sd	ra,72(sp)
 18c:	04813023          	sd	s0,64(sp)
 190:	05010413          	addi	s0,sp,80
 194:	fca43423          	sd	a0,-56(s0)
 198:	fcb43023          	sd	a1,-64(s0)
 19c:	00060793          	mv	a5,a2
 1a0:	faf42e23          	sw	a5,-68(s0)
 1a4:	fe043423          	sd	zero,-24(s0)
 1a8:	fe0403a3          	sb	zero,-25(s0)
 1ac:	fc843783          	ld	a5,-56(s0)
 1b0:	fcf43c23          	sd	a5,-40(s0)
 1b4:	0100006f          	j	1c4 <strtol+0x40>
 1b8:	fd843783          	ld	a5,-40(s0)
 1bc:	00178793          	addi	a5,a5,1
 1c0:	fcf43c23          	sd	a5,-40(s0)
 1c4:	fd843783          	ld	a5,-40(s0)
 1c8:	0007c783          	lbu	a5,0(a5)
 1cc:	0007879b          	sext.w	a5,a5
 1d0:	00078513          	mv	a0,a5
 1d4:	f51ff0ef          	jal	124 <isspace>
 1d8:	00050793          	mv	a5,a0
 1dc:	fc079ee3          	bnez	a5,1b8 <strtol+0x34>
 1e0:	fd843783          	ld	a5,-40(s0)
 1e4:	0007c783          	lbu	a5,0(a5)
 1e8:	00078713          	mv	a4,a5
 1ec:	02d00793          	li	a5,45
 1f0:	00f71e63          	bne	a4,a5,20c <strtol+0x88>
 1f4:	00100793          	li	a5,1
 1f8:	fef403a3          	sb	a5,-25(s0)
 1fc:	fd843783          	ld	a5,-40(s0)
 200:	00178793          	addi	a5,a5,1
 204:	fcf43c23          	sd	a5,-40(s0)
 208:	0240006f          	j	22c <strtol+0xa8>
 20c:	fd843783          	ld	a5,-40(s0)
 210:	0007c783          	lbu	a5,0(a5)
 214:	00078713          	mv	a4,a5
 218:	02b00793          	li	a5,43
 21c:	00f71863          	bne	a4,a5,22c <strtol+0xa8>
 220:	fd843783          	ld	a5,-40(s0)
 224:	00178793          	addi	a5,a5,1
 228:	fcf43c23          	sd	a5,-40(s0)
 22c:	fbc42783          	lw	a5,-68(s0)
 230:	0007879b          	sext.w	a5,a5
 234:	06079c63          	bnez	a5,2ac <strtol+0x128>
 238:	fd843783          	ld	a5,-40(s0)
 23c:	0007c783          	lbu	a5,0(a5)
 240:	00078713          	mv	a4,a5
 244:	03000793          	li	a5,48
 248:	04f71e63          	bne	a4,a5,2a4 <strtol+0x120>
 24c:	fd843783          	ld	a5,-40(s0)
 250:	00178793          	addi	a5,a5,1
 254:	fcf43c23          	sd	a5,-40(s0)
 258:	fd843783          	ld	a5,-40(s0)
 25c:	0007c783          	lbu	a5,0(a5)
 260:	00078713          	mv	a4,a5
 264:	07800793          	li	a5,120
 268:	00f70c63          	beq	a4,a5,280 <strtol+0xfc>
 26c:	fd843783          	ld	a5,-40(s0)
 270:	0007c783          	lbu	a5,0(a5)
 274:	00078713          	mv	a4,a5
 278:	05800793          	li	a5,88
 27c:	00f71e63          	bne	a4,a5,298 <strtol+0x114>
 280:	01000793          	li	a5,16
 284:	faf42e23          	sw	a5,-68(s0)
 288:	fd843783          	ld	a5,-40(s0)
 28c:	00178793          	addi	a5,a5,1
 290:	fcf43c23          	sd	a5,-40(s0)
 294:	0180006f          	j	2ac <strtol+0x128>
 298:	00800793          	li	a5,8
 29c:	faf42e23          	sw	a5,-68(s0)
 2a0:	00c0006f          	j	2ac <strtol+0x128>
 2a4:	00a00793          	li	a5,10
 2a8:	faf42e23          	sw	a5,-68(s0)
 2ac:	fd843783          	ld	a5,-40(s0)
 2b0:	0007c783          	lbu	a5,0(a5)
 2b4:	00078713          	mv	a4,a5
 2b8:	02f00793          	li	a5,47
 2bc:	02e7f863          	bgeu	a5,a4,2ec <strtol+0x168>
 2c0:	fd843783          	ld	a5,-40(s0)
 2c4:	0007c783          	lbu	a5,0(a5)
 2c8:	00078713          	mv	a4,a5
 2cc:	03900793          	li	a5,57
 2d0:	00e7ee63          	bltu	a5,a4,2ec <strtol+0x168>
 2d4:	fd843783          	ld	a5,-40(s0)
 2d8:	0007c783          	lbu	a5,0(a5)
 2dc:	0007879b          	sext.w	a5,a5
 2e0:	fd07879b          	addiw	a5,a5,-48
 2e4:	fcf42a23          	sw	a5,-44(s0)
 2e8:	0800006f          	j	368 <strtol+0x1e4>
 2ec:	fd843783          	ld	a5,-40(s0)
 2f0:	0007c783          	lbu	a5,0(a5)
 2f4:	00078713          	mv	a4,a5
 2f8:	06000793          	li	a5,96
 2fc:	02e7f863          	bgeu	a5,a4,32c <strtol+0x1a8>
 300:	fd843783          	ld	a5,-40(s0)
 304:	0007c783          	lbu	a5,0(a5)
 308:	00078713          	mv	a4,a5
 30c:	07a00793          	li	a5,122
 310:	00e7ee63          	bltu	a5,a4,32c <strtol+0x1a8>
 314:	fd843783          	ld	a5,-40(s0)
 318:	0007c783          	lbu	a5,0(a5)
 31c:	0007879b          	sext.w	a5,a5
 320:	fa97879b          	addiw	a5,a5,-87
 324:	fcf42a23          	sw	a5,-44(s0)
 328:	0400006f          	j	368 <strtol+0x1e4>
 32c:	fd843783          	ld	a5,-40(s0)
 330:	0007c783          	lbu	a5,0(a5)
 334:	00078713          	mv	a4,a5
 338:	04000793          	li	a5,64
 33c:	06e7f863          	bgeu	a5,a4,3ac <strtol+0x228>
 340:	fd843783          	ld	a5,-40(s0)
 344:	0007c783          	lbu	a5,0(a5)
 348:	00078713          	mv	a4,a5
 34c:	05a00793          	li	a5,90
 350:	04e7ee63          	bltu	a5,a4,3ac <strtol+0x228>
 354:	fd843783          	ld	a5,-40(s0)
 358:	0007c783          	lbu	a5,0(a5)
 35c:	0007879b          	sext.w	a5,a5
 360:	fc97879b          	addiw	a5,a5,-55
 364:	fcf42a23          	sw	a5,-44(s0)
 368:	fd442783          	lw	a5,-44(s0)
 36c:	00078713          	mv	a4,a5
 370:	fbc42783          	lw	a5,-68(s0)
 374:	0007071b          	sext.w	a4,a4
 378:	0007879b          	sext.w	a5,a5
 37c:	02f75663          	bge	a4,a5,3a8 <strtol+0x224>
 380:	fbc42703          	lw	a4,-68(s0)
 384:	fe843783          	ld	a5,-24(s0)
 388:	02f70733          	mul	a4,a4,a5
 38c:	fd442783          	lw	a5,-44(s0)
 390:	00f707b3          	add	a5,a4,a5
 394:	fef43423          	sd	a5,-24(s0)
 398:	fd843783          	ld	a5,-40(s0)
 39c:	00178793          	addi	a5,a5,1
 3a0:	fcf43c23          	sd	a5,-40(s0)
 3a4:	f09ff06f          	j	2ac <strtol+0x128>
 3a8:	00000013          	nop
 3ac:	fc043783          	ld	a5,-64(s0)
 3b0:	00078863          	beqz	a5,3c0 <strtol+0x23c>
 3b4:	fc043783          	ld	a5,-64(s0)
 3b8:	fd843703          	ld	a4,-40(s0)
 3bc:	00e7b023          	sd	a4,0(a5)
 3c0:	fe744783          	lbu	a5,-25(s0)
 3c4:	0ff7f793          	zext.b	a5,a5
 3c8:	00078863          	beqz	a5,3d8 <strtol+0x254>
 3cc:	fe843783          	ld	a5,-24(s0)
 3d0:	40f007b3          	neg	a5,a5
 3d4:	0080006f          	j	3dc <strtol+0x258>
 3d8:	fe843783          	ld	a5,-24(s0)
 3dc:	00078513          	mv	a0,a5
 3e0:	04813083          	ld	ra,72(sp)
 3e4:	04013403          	ld	s0,64(sp)
 3e8:	05010113          	addi	sp,sp,80
 3ec:	00008067          	ret

Disassembly of section .text.puts_wo_nl:

00000000000003f0 <puts_wo_nl>:
 3f0:	fd010113          	addi	sp,sp,-48
 3f4:	02113423          	sd	ra,40(sp)
 3f8:	02813023          	sd	s0,32(sp)
 3fc:	03010413          	addi	s0,sp,48
 400:	fca43c23          	sd	a0,-40(s0)
 404:	fcb43823          	sd	a1,-48(s0)
 408:	fd043783          	ld	a5,-48(s0)
 40c:	00079863          	bnez	a5,41c <puts_wo_nl+0x2c>
 410:	00001797          	auipc	a5,0x1
 414:	e1078793          	addi	a5,a5,-496 # 1220 <printf+0x2b0>
 418:	fcf43823          	sd	a5,-48(s0)
 41c:	fd043783          	ld	a5,-48(s0)
 420:	fef43423          	sd	a5,-24(s0)
 424:	0240006f          	j	448 <puts_wo_nl+0x58>
 428:	fe843783          	ld	a5,-24(s0)
 42c:	00178713          	addi	a4,a5,1
 430:	fee43423          	sd	a4,-24(s0)
 434:	0007c783          	lbu	a5,0(a5)
 438:	0007871b          	sext.w	a4,a5
 43c:	fd843783          	ld	a5,-40(s0)
 440:	00070513          	mv	a0,a4
 444:	000780e7          	jalr	a5
 448:	fe843783          	ld	a5,-24(s0)
 44c:	0007c783          	lbu	a5,0(a5)
 450:	fc079ce3          	bnez	a5,428 <puts_wo_nl+0x38>
 454:	fe843703          	ld	a4,-24(s0)
 458:	fd043783          	ld	a5,-48(s0)
 45c:	40f707b3          	sub	a5,a4,a5
 460:	0007879b          	sext.w	a5,a5
 464:	00078513          	mv	a0,a5
 468:	02813083          	ld	ra,40(sp)
 46c:	02013403          	ld	s0,32(sp)
 470:	03010113          	addi	sp,sp,48
 474:	00008067          	ret

Disassembly of section .text.print_dec_int:

0000000000000478 <print_dec_int>:
 478:	f9010113          	addi	sp,sp,-112
 47c:	06113423          	sd	ra,104(sp)
 480:	06813023          	sd	s0,96(sp)
 484:	07010413          	addi	s0,sp,112
 488:	faa43423          	sd	a0,-88(s0)
 48c:	fab43023          	sd	a1,-96(s0)
 490:	00060793          	mv	a5,a2
 494:	f8d43823          	sd	a3,-112(s0)
 498:	f8f40fa3          	sb	a5,-97(s0)
 49c:	f9f44783          	lbu	a5,-97(s0)
 4a0:	0ff7f793          	zext.b	a5,a5
 4a4:	02078663          	beqz	a5,4d0 <print_dec_int+0x58>
 4a8:	fa043703          	ld	a4,-96(s0)
 4ac:	fff00793          	li	a5,-1
 4b0:	03f79793          	slli	a5,a5,0x3f
 4b4:	00f71e63          	bne	a4,a5,4d0 <print_dec_int+0x58>
 4b8:	00001597          	auipc	a1,0x1
 4bc:	d7058593          	addi	a1,a1,-656 # 1228 <printf+0x2b8>
 4c0:	fa843503          	ld	a0,-88(s0)
 4c4:	f2dff0ef          	jal	3f0 <puts_wo_nl>
 4c8:	00050793          	mv	a5,a0
 4cc:	2a00006f          	j	76c <print_dec_int+0x2f4>
 4d0:	f9043783          	ld	a5,-112(s0)
 4d4:	00c7a783          	lw	a5,12(a5)
 4d8:	00079a63          	bnez	a5,4ec <print_dec_int+0x74>
 4dc:	fa043783          	ld	a5,-96(s0)
 4e0:	00079663          	bnez	a5,4ec <print_dec_int+0x74>
 4e4:	00000793          	li	a5,0
 4e8:	2840006f          	j	76c <print_dec_int+0x2f4>
 4ec:	fe0407a3          	sb	zero,-17(s0)
 4f0:	f9f44783          	lbu	a5,-97(s0)
 4f4:	0ff7f793          	zext.b	a5,a5
 4f8:	02078063          	beqz	a5,518 <print_dec_int+0xa0>
 4fc:	fa043783          	ld	a5,-96(s0)
 500:	0007dc63          	bgez	a5,518 <print_dec_int+0xa0>
 504:	00100793          	li	a5,1
 508:	fef407a3          	sb	a5,-17(s0)
 50c:	fa043783          	ld	a5,-96(s0)
 510:	40f007b3          	neg	a5,a5
 514:	faf43023          	sd	a5,-96(s0)
 518:	fe042423          	sw	zero,-24(s0)
 51c:	f9f44783          	lbu	a5,-97(s0)
 520:	0ff7f793          	zext.b	a5,a5
 524:	02078863          	beqz	a5,554 <print_dec_int+0xdc>
 528:	fef44783          	lbu	a5,-17(s0)
 52c:	0ff7f793          	zext.b	a5,a5
 530:	00079e63          	bnez	a5,54c <print_dec_int+0xd4>
 534:	f9043783          	ld	a5,-112(s0)
 538:	0057c783          	lbu	a5,5(a5)
 53c:	00079863          	bnez	a5,54c <print_dec_int+0xd4>
 540:	f9043783          	ld	a5,-112(s0)
 544:	0047c783          	lbu	a5,4(a5)
 548:	00078663          	beqz	a5,554 <print_dec_int+0xdc>
 54c:	00100793          	li	a5,1
 550:	0080006f          	j	558 <print_dec_int+0xe0>
 554:	00000793          	li	a5,0
 558:	fcf40ba3          	sb	a5,-41(s0)
 55c:	fd744783          	lbu	a5,-41(s0)
 560:	0017f793          	andi	a5,a5,1
 564:	fcf40ba3          	sb	a5,-41(s0)
 568:	fa043703          	ld	a4,-96(s0)
 56c:	00a00793          	li	a5,10
 570:	02f777b3          	remu	a5,a4,a5
 574:	0ff7f713          	zext.b	a4,a5
 578:	fe842783          	lw	a5,-24(s0)
 57c:	0017869b          	addiw	a3,a5,1
 580:	fed42423          	sw	a3,-24(s0)
 584:	0307071b          	addiw	a4,a4,48
 588:	0ff77713          	zext.b	a4,a4
 58c:	ff078793          	addi	a5,a5,-16
 590:	008787b3          	add	a5,a5,s0
 594:	fce78423          	sb	a4,-56(a5)
 598:	fa043703          	ld	a4,-96(s0)
 59c:	00a00793          	li	a5,10
 5a0:	02f757b3          	divu	a5,a4,a5
 5a4:	faf43023          	sd	a5,-96(s0)
 5a8:	fa043783          	ld	a5,-96(s0)
 5ac:	fa079ee3          	bnez	a5,568 <print_dec_int+0xf0>
 5b0:	f9043783          	ld	a5,-112(s0)
 5b4:	00c7a783          	lw	a5,12(a5)
 5b8:	00078713          	mv	a4,a5
 5bc:	fff00793          	li	a5,-1
 5c0:	02f71063          	bne	a4,a5,5e0 <print_dec_int+0x168>
 5c4:	f9043783          	ld	a5,-112(s0)
 5c8:	0037c783          	lbu	a5,3(a5)
 5cc:	00078a63          	beqz	a5,5e0 <print_dec_int+0x168>
 5d0:	f9043783          	ld	a5,-112(s0)
 5d4:	0087a703          	lw	a4,8(a5)
 5d8:	f9043783          	ld	a5,-112(s0)
 5dc:	00e7a623          	sw	a4,12(a5)
 5e0:	fe042223          	sw	zero,-28(s0)
 5e4:	f9043783          	ld	a5,-112(s0)
 5e8:	0087a703          	lw	a4,8(a5)
 5ec:	fe842783          	lw	a5,-24(s0)
 5f0:	fcf42823          	sw	a5,-48(s0)
 5f4:	f9043783          	ld	a5,-112(s0)
 5f8:	00c7a783          	lw	a5,12(a5)
 5fc:	fcf42623          	sw	a5,-52(s0)
 600:	fd042783          	lw	a5,-48(s0)
 604:	00078593          	mv	a1,a5
 608:	fcc42783          	lw	a5,-52(s0)
 60c:	00078613          	mv	a2,a5
 610:	0006069b          	sext.w	a3,a2
 614:	0005879b          	sext.w	a5,a1
 618:	00f6d463          	bge	a3,a5,620 <print_dec_int+0x1a8>
 61c:	00058613          	mv	a2,a1
 620:	0006079b          	sext.w	a5,a2
 624:	40f707bb          	subw	a5,a4,a5
 628:	0007871b          	sext.w	a4,a5
 62c:	fd744783          	lbu	a5,-41(s0)
 630:	0007879b          	sext.w	a5,a5
 634:	40f707bb          	subw	a5,a4,a5
 638:	fef42023          	sw	a5,-32(s0)
 63c:	0280006f          	j	664 <print_dec_int+0x1ec>
 640:	fa843783          	ld	a5,-88(s0)
 644:	02000513          	li	a0,32
 648:	000780e7          	jalr	a5
 64c:	fe442783          	lw	a5,-28(s0)
 650:	0017879b          	addiw	a5,a5,1
 654:	fef42223          	sw	a5,-28(s0)
 658:	fe042783          	lw	a5,-32(s0)
 65c:	fff7879b          	addiw	a5,a5,-1
 660:	fef42023          	sw	a5,-32(s0)
 664:	fe042783          	lw	a5,-32(s0)
 668:	0007879b          	sext.w	a5,a5
 66c:	fcf04ae3          	bgtz	a5,640 <print_dec_int+0x1c8>
 670:	fd744783          	lbu	a5,-41(s0)
 674:	0ff7f793          	zext.b	a5,a5
 678:	04078463          	beqz	a5,6c0 <print_dec_int+0x248>
 67c:	fef44783          	lbu	a5,-17(s0)
 680:	0ff7f793          	zext.b	a5,a5
 684:	00078663          	beqz	a5,690 <print_dec_int+0x218>
 688:	02d00793          	li	a5,45
 68c:	01c0006f          	j	6a8 <print_dec_int+0x230>
 690:	f9043783          	ld	a5,-112(s0)
 694:	0057c783          	lbu	a5,5(a5)
 698:	00078663          	beqz	a5,6a4 <print_dec_int+0x22c>
 69c:	02b00793          	li	a5,43
 6a0:	0080006f          	j	6a8 <print_dec_int+0x230>
 6a4:	02000793          	li	a5,32
 6a8:	fa843703          	ld	a4,-88(s0)
 6ac:	00078513          	mv	a0,a5
 6b0:	000700e7          	jalr	a4
 6b4:	fe442783          	lw	a5,-28(s0)
 6b8:	0017879b          	addiw	a5,a5,1
 6bc:	fef42223          	sw	a5,-28(s0)
 6c0:	fe842783          	lw	a5,-24(s0)
 6c4:	fcf42e23          	sw	a5,-36(s0)
 6c8:	0280006f          	j	6f0 <print_dec_int+0x278>
 6cc:	fa843783          	ld	a5,-88(s0)
 6d0:	03000513          	li	a0,48
 6d4:	000780e7          	jalr	a5
 6d8:	fe442783          	lw	a5,-28(s0)
 6dc:	0017879b          	addiw	a5,a5,1
 6e0:	fef42223          	sw	a5,-28(s0)
 6e4:	fdc42783          	lw	a5,-36(s0)
 6e8:	0017879b          	addiw	a5,a5,1
 6ec:	fcf42e23          	sw	a5,-36(s0)
 6f0:	f9043783          	ld	a5,-112(s0)
 6f4:	00c7a703          	lw	a4,12(a5)
 6f8:	fd744783          	lbu	a5,-41(s0)
 6fc:	0007879b          	sext.w	a5,a5
 700:	40f707bb          	subw	a5,a4,a5
 704:	0007871b          	sext.w	a4,a5
 708:	fdc42783          	lw	a5,-36(s0)
 70c:	0007879b          	sext.w	a5,a5
 710:	fae7cee3          	blt	a5,a4,6cc <print_dec_int+0x254>
 714:	fe842783          	lw	a5,-24(s0)
 718:	fff7879b          	addiw	a5,a5,-1
 71c:	fcf42c23          	sw	a5,-40(s0)
 720:	03c0006f          	j	75c <print_dec_int+0x2e4>
 724:	fd842783          	lw	a5,-40(s0)
 728:	ff078793          	addi	a5,a5,-16
 72c:	008787b3          	add	a5,a5,s0
 730:	fc87c783          	lbu	a5,-56(a5)
 734:	0007871b          	sext.w	a4,a5
 738:	fa843783          	ld	a5,-88(s0)
 73c:	00070513          	mv	a0,a4
 740:	000780e7          	jalr	a5
 744:	fe442783          	lw	a5,-28(s0)
 748:	0017879b          	addiw	a5,a5,1
 74c:	fef42223          	sw	a5,-28(s0)
 750:	fd842783          	lw	a5,-40(s0)
 754:	fff7879b          	addiw	a5,a5,-1
 758:	fcf42c23          	sw	a5,-40(s0)
 75c:	fd842783          	lw	a5,-40(s0)
 760:	0007879b          	sext.w	a5,a5
 764:	fc07d0e3          	bgez	a5,724 <print_dec_int+0x2ac>
 768:	fe442783          	lw	a5,-28(s0)
 76c:	00078513          	mv	a0,a5
 770:	06813083          	ld	ra,104(sp)
 774:	06013403          	ld	s0,96(sp)
 778:	07010113          	addi	sp,sp,112
 77c:	00008067          	ret

Disassembly of section .text.vprintfmt:

0000000000000780 <vprintfmt>:
 780:	f4010113          	addi	sp,sp,-192
 784:	0a113c23          	sd	ra,184(sp)
 788:	0a813823          	sd	s0,176(sp)
 78c:	0c010413          	addi	s0,sp,192
 790:	f4a43c23          	sd	a0,-168(s0)
 794:	f4b43823          	sd	a1,-176(s0)
 798:	f4c43423          	sd	a2,-184(s0)
 79c:	f8043023          	sd	zero,-128(s0)
 7a0:	f8043423          	sd	zero,-120(s0)
 7a4:	fe042623          	sw	zero,-20(s0)
 7a8:	7a40006f          	j	f4c <vprintfmt+0x7cc>
 7ac:	f8044783          	lbu	a5,-128(s0)
 7b0:	72078e63          	beqz	a5,eec <vprintfmt+0x76c>
 7b4:	f5043783          	ld	a5,-176(s0)
 7b8:	0007c783          	lbu	a5,0(a5)
 7bc:	00078713          	mv	a4,a5
 7c0:	02300793          	li	a5,35
 7c4:	00f71863          	bne	a4,a5,7d4 <vprintfmt+0x54>
 7c8:	00100793          	li	a5,1
 7cc:	f8f40123          	sb	a5,-126(s0)
 7d0:	7700006f          	j	f40 <vprintfmt+0x7c0>
 7d4:	f5043783          	ld	a5,-176(s0)
 7d8:	0007c783          	lbu	a5,0(a5)
 7dc:	00078713          	mv	a4,a5
 7e0:	03000793          	li	a5,48
 7e4:	00f71863          	bne	a4,a5,7f4 <vprintfmt+0x74>
 7e8:	00100793          	li	a5,1
 7ec:	f8f401a3          	sb	a5,-125(s0)
 7f0:	7500006f          	j	f40 <vprintfmt+0x7c0>
 7f4:	f5043783          	ld	a5,-176(s0)
 7f8:	0007c783          	lbu	a5,0(a5)
 7fc:	00078713          	mv	a4,a5
 800:	06c00793          	li	a5,108
 804:	04f70063          	beq	a4,a5,844 <vprintfmt+0xc4>
 808:	f5043783          	ld	a5,-176(s0)
 80c:	0007c783          	lbu	a5,0(a5)
 810:	00078713          	mv	a4,a5
 814:	07a00793          	li	a5,122
 818:	02f70663          	beq	a4,a5,844 <vprintfmt+0xc4>
 81c:	f5043783          	ld	a5,-176(s0)
 820:	0007c783          	lbu	a5,0(a5)
 824:	00078713          	mv	a4,a5
 828:	07400793          	li	a5,116
 82c:	00f70c63          	beq	a4,a5,844 <vprintfmt+0xc4>
 830:	f5043783          	ld	a5,-176(s0)
 834:	0007c783          	lbu	a5,0(a5)
 838:	00078713          	mv	a4,a5
 83c:	06a00793          	li	a5,106
 840:	00f71863          	bne	a4,a5,850 <vprintfmt+0xd0>
 844:	00100793          	li	a5,1
 848:	f8f400a3          	sb	a5,-127(s0)
 84c:	6f40006f          	j	f40 <vprintfmt+0x7c0>
 850:	f5043783          	ld	a5,-176(s0)
 854:	0007c783          	lbu	a5,0(a5)
 858:	00078713          	mv	a4,a5
 85c:	02b00793          	li	a5,43
 860:	00f71863          	bne	a4,a5,870 <vprintfmt+0xf0>
 864:	00100793          	li	a5,1
 868:	f8f402a3          	sb	a5,-123(s0)
 86c:	6d40006f          	j	f40 <vprintfmt+0x7c0>
 870:	f5043783          	ld	a5,-176(s0)
 874:	0007c783          	lbu	a5,0(a5)
 878:	00078713          	mv	a4,a5
 87c:	02000793          	li	a5,32
 880:	00f71863          	bne	a4,a5,890 <vprintfmt+0x110>
 884:	00100793          	li	a5,1
 888:	f8f40223          	sb	a5,-124(s0)
 88c:	6b40006f          	j	f40 <vprintfmt+0x7c0>
 890:	f5043783          	ld	a5,-176(s0)
 894:	0007c783          	lbu	a5,0(a5)
 898:	00078713          	mv	a4,a5
 89c:	02a00793          	li	a5,42
 8a0:	00f71e63          	bne	a4,a5,8bc <vprintfmt+0x13c>
 8a4:	f4843783          	ld	a5,-184(s0)
 8a8:	00878713          	addi	a4,a5,8
 8ac:	f4e43423          	sd	a4,-184(s0)
 8b0:	0007a783          	lw	a5,0(a5)
 8b4:	f8f42423          	sw	a5,-120(s0)
 8b8:	6880006f          	j	f40 <vprintfmt+0x7c0>
 8bc:	f5043783          	ld	a5,-176(s0)
 8c0:	0007c783          	lbu	a5,0(a5)
 8c4:	00078713          	mv	a4,a5
 8c8:	03000793          	li	a5,48
 8cc:	04e7f663          	bgeu	a5,a4,918 <vprintfmt+0x198>
 8d0:	f5043783          	ld	a5,-176(s0)
 8d4:	0007c783          	lbu	a5,0(a5)
 8d8:	00078713          	mv	a4,a5
 8dc:	03900793          	li	a5,57
 8e0:	02e7ec63          	bltu	a5,a4,918 <vprintfmt+0x198>
 8e4:	f5043783          	ld	a5,-176(s0)
 8e8:	f5040713          	addi	a4,s0,-176
 8ec:	00a00613          	li	a2,10
 8f0:	00070593          	mv	a1,a4
 8f4:	00078513          	mv	a0,a5
 8f8:	88dff0ef          	jal	184 <strtol>
 8fc:	00050793          	mv	a5,a0
 900:	0007879b          	sext.w	a5,a5
 904:	f8f42423          	sw	a5,-120(s0)
 908:	f5043783          	ld	a5,-176(s0)
 90c:	fff78793          	addi	a5,a5,-1
 910:	f4f43823          	sd	a5,-176(s0)
 914:	62c0006f          	j	f40 <vprintfmt+0x7c0>
 918:	f5043783          	ld	a5,-176(s0)
 91c:	0007c783          	lbu	a5,0(a5)
 920:	00078713          	mv	a4,a5
 924:	02e00793          	li	a5,46
 928:	06f71863          	bne	a4,a5,998 <vprintfmt+0x218>
 92c:	f5043783          	ld	a5,-176(s0)
 930:	00178793          	addi	a5,a5,1
 934:	f4f43823          	sd	a5,-176(s0)
 938:	f5043783          	ld	a5,-176(s0)
 93c:	0007c783          	lbu	a5,0(a5)
 940:	00078713          	mv	a4,a5
 944:	02a00793          	li	a5,42
 948:	00f71e63          	bne	a4,a5,964 <vprintfmt+0x1e4>
 94c:	f4843783          	ld	a5,-184(s0)
 950:	00878713          	addi	a4,a5,8
 954:	f4e43423          	sd	a4,-184(s0)
 958:	0007a783          	lw	a5,0(a5)
 95c:	f8f42623          	sw	a5,-116(s0)
 960:	5e00006f          	j	f40 <vprintfmt+0x7c0>
 964:	f5043783          	ld	a5,-176(s0)
 968:	f5040713          	addi	a4,s0,-176
 96c:	00a00613          	li	a2,10
 970:	00070593          	mv	a1,a4
 974:	00078513          	mv	a0,a5
 978:	80dff0ef          	jal	184 <strtol>
 97c:	00050793          	mv	a5,a0
 980:	0007879b          	sext.w	a5,a5
 984:	f8f42623          	sw	a5,-116(s0)
 988:	f5043783          	ld	a5,-176(s0)
 98c:	fff78793          	addi	a5,a5,-1
 990:	f4f43823          	sd	a5,-176(s0)
 994:	5ac0006f          	j	f40 <vprintfmt+0x7c0>
 998:	f5043783          	ld	a5,-176(s0)
 99c:	0007c783          	lbu	a5,0(a5)
 9a0:	00078713          	mv	a4,a5
 9a4:	07800793          	li	a5,120
 9a8:	02f70663          	beq	a4,a5,9d4 <vprintfmt+0x254>
 9ac:	f5043783          	ld	a5,-176(s0)
 9b0:	0007c783          	lbu	a5,0(a5)
 9b4:	00078713          	mv	a4,a5
 9b8:	05800793          	li	a5,88
 9bc:	00f70c63          	beq	a4,a5,9d4 <vprintfmt+0x254>
 9c0:	f5043783          	ld	a5,-176(s0)
 9c4:	0007c783          	lbu	a5,0(a5)
 9c8:	00078713          	mv	a4,a5
 9cc:	07000793          	li	a5,112
 9d0:	30f71263          	bne	a4,a5,cd4 <vprintfmt+0x554>
 9d4:	f5043783          	ld	a5,-176(s0)
 9d8:	0007c783          	lbu	a5,0(a5)
 9dc:	00078713          	mv	a4,a5
 9e0:	07000793          	li	a5,112
 9e4:	00f70663          	beq	a4,a5,9f0 <vprintfmt+0x270>
 9e8:	f8144783          	lbu	a5,-127(s0)
 9ec:	00078663          	beqz	a5,9f8 <vprintfmt+0x278>
 9f0:	00100793          	li	a5,1
 9f4:	0080006f          	j	9fc <vprintfmt+0x27c>
 9f8:	00000793          	li	a5,0
 9fc:	faf403a3          	sb	a5,-89(s0)
 a00:	fa744783          	lbu	a5,-89(s0)
 a04:	0017f793          	andi	a5,a5,1
 a08:	faf403a3          	sb	a5,-89(s0)
 a0c:	fa744783          	lbu	a5,-89(s0)
 a10:	0ff7f793          	zext.b	a5,a5
 a14:	00078c63          	beqz	a5,a2c <vprintfmt+0x2ac>
 a18:	f4843783          	ld	a5,-184(s0)
 a1c:	00878713          	addi	a4,a5,8
 a20:	f4e43423          	sd	a4,-184(s0)
 a24:	0007b783          	ld	a5,0(a5)
 a28:	01c0006f          	j	a44 <vprintfmt+0x2c4>
 a2c:	f4843783          	ld	a5,-184(s0)
 a30:	00878713          	addi	a4,a5,8
 a34:	f4e43423          	sd	a4,-184(s0)
 a38:	0007a783          	lw	a5,0(a5)
 a3c:	02079793          	slli	a5,a5,0x20
 a40:	0207d793          	srli	a5,a5,0x20
 a44:	fef43023          	sd	a5,-32(s0)
 a48:	f8c42783          	lw	a5,-116(s0)
 a4c:	02079463          	bnez	a5,a74 <vprintfmt+0x2f4>
 a50:	fe043783          	ld	a5,-32(s0)
 a54:	02079063          	bnez	a5,a74 <vprintfmt+0x2f4>
 a58:	f5043783          	ld	a5,-176(s0)
 a5c:	0007c783          	lbu	a5,0(a5)
 a60:	00078713          	mv	a4,a5
 a64:	07000793          	li	a5,112
 a68:	00f70663          	beq	a4,a5,a74 <vprintfmt+0x2f4>
 a6c:	f8040023          	sb	zero,-128(s0)
 a70:	4d00006f          	j	f40 <vprintfmt+0x7c0>
 a74:	f5043783          	ld	a5,-176(s0)
 a78:	0007c783          	lbu	a5,0(a5)
 a7c:	00078713          	mv	a4,a5
 a80:	07000793          	li	a5,112
 a84:	00f70a63          	beq	a4,a5,a98 <vprintfmt+0x318>
 a88:	f8244783          	lbu	a5,-126(s0)
 a8c:	00078a63          	beqz	a5,aa0 <vprintfmt+0x320>
 a90:	fe043783          	ld	a5,-32(s0)
 a94:	00078663          	beqz	a5,aa0 <vprintfmt+0x320>
 a98:	00100793          	li	a5,1
 a9c:	0080006f          	j	aa4 <vprintfmt+0x324>
 aa0:	00000793          	li	a5,0
 aa4:	faf40323          	sb	a5,-90(s0)
 aa8:	fa644783          	lbu	a5,-90(s0)
 aac:	0017f793          	andi	a5,a5,1
 ab0:	faf40323          	sb	a5,-90(s0)
 ab4:	fc042e23          	sw	zero,-36(s0)
 ab8:	f5043783          	ld	a5,-176(s0)
 abc:	0007c783          	lbu	a5,0(a5)
 ac0:	00078713          	mv	a4,a5
 ac4:	05800793          	li	a5,88
 ac8:	00f71863          	bne	a4,a5,ad8 <vprintfmt+0x358>
 acc:	00000797          	auipc	a5,0x0
 ad0:	77478793          	addi	a5,a5,1908 # 1240 <upperxdigits.1>
 ad4:	00c0006f          	j	ae0 <vprintfmt+0x360>
 ad8:	00000797          	auipc	a5,0x0
 adc:	78078793          	addi	a5,a5,1920 # 1258 <lowerxdigits.0>
 ae0:	f8f43c23          	sd	a5,-104(s0)
 ae4:	fe043783          	ld	a5,-32(s0)
 ae8:	00f7f793          	andi	a5,a5,15
 aec:	f9843703          	ld	a4,-104(s0)
 af0:	00f70733          	add	a4,a4,a5
 af4:	fdc42783          	lw	a5,-36(s0)
 af8:	0017869b          	addiw	a3,a5,1
 afc:	fcd42e23          	sw	a3,-36(s0)
 b00:	00074703          	lbu	a4,0(a4)
 b04:	ff078793          	addi	a5,a5,-16
 b08:	008787b3          	add	a5,a5,s0
 b0c:	f8e78023          	sb	a4,-128(a5)
 b10:	fe043783          	ld	a5,-32(s0)
 b14:	0047d793          	srli	a5,a5,0x4
 b18:	fef43023          	sd	a5,-32(s0)
 b1c:	fe043783          	ld	a5,-32(s0)
 b20:	fc0792e3          	bnez	a5,ae4 <vprintfmt+0x364>
 b24:	f8c42783          	lw	a5,-116(s0)
 b28:	00078713          	mv	a4,a5
 b2c:	fff00793          	li	a5,-1
 b30:	02f71663          	bne	a4,a5,b5c <vprintfmt+0x3dc>
 b34:	f8344783          	lbu	a5,-125(s0)
 b38:	02078263          	beqz	a5,b5c <vprintfmt+0x3dc>
 b3c:	f8842703          	lw	a4,-120(s0)
 b40:	fa644783          	lbu	a5,-90(s0)
 b44:	0007879b          	sext.w	a5,a5
 b48:	0017979b          	slliw	a5,a5,0x1
 b4c:	0007879b          	sext.w	a5,a5
 b50:	40f707bb          	subw	a5,a4,a5
 b54:	0007879b          	sext.w	a5,a5
 b58:	f8f42623          	sw	a5,-116(s0)
 b5c:	f8842703          	lw	a4,-120(s0)
 b60:	fa644783          	lbu	a5,-90(s0)
 b64:	0007879b          	sext.w	a5,a5
 b68:	0017979b          	slliw	a5,a5,0x1
 b6c:	0007879b          	sext.w	a5,a5
 b70:	40f707bb          	subw	a5,a4,a5
 b74:	0007871b          	sext.w	a4,a5
 b78:	fdc42783          	lw	a5,-36(s0)
 b7c:	f8f42a23          	sw	a5,-108(s0)
 b80:	f8c42783          	lw	a5,-116(s0)
 b84:	f8f42823          	sw	a5,-112(s0)
 b88:	f9442783          	lw	a5,-108(s0)
 b8c:	00078593          	mv	a1,a5
 b90:	f9042783          	lw	a5,-112(s0)
 b94:	00078613          	mv	a2,a5
 b98:	0006069b          	sext.w	a3,a2
 b9c:	0005879b          	sext.w	a5,a1
 ba0:	00f6d463          	bge	a3,a5,ba8 <vprintfmt+0x428>
 ba4:	00058613          	mv	a2,a1
 ba8:	0006079b          	sext.w	a5,a2
 bac:	40f707bb          	subw	a5,a4,a5
 bb0:	fcf42c23          	sw	a5,-40(s0)
 bb4:	0280006f          	j	bdc <vprintfmt+0x45c>
 bb8:	f5843783          	ld	a5,-168(s0)
 bbc:	02000513          	li	a0,32
 bc0:	000780e7          	jalr	a5
 bc4:	fec42783          	lw	a5,-20(s0)
 bc8:	0017879b          	addiw	a5,a5,1
 bcc:	fef42623          	sw	a5,-20(s0)
 bd0:	fd842783          	lw	a5,-40(s0)
 bd4:	fff7879b          	addiw	a5,a5,-1
 bd8:	fcf42c23          	sw	a5,-40(s0)
 bdc:	fd842783          	lw	a5,-40(s0)
 be0:	0007879b          	sext.w	a5,a5
 be4:	fcf04ae3          	bgtz	a5,bb8 <vprintfmt+0x438>
 be8:	fa644783          	lbu	a5,-90(s0)
 bec:	0ff7f793          	zext.b	a5,a5
 bf0:	04078463          	beqz	a5,c38 <vprintfmt+0x4b8>
 bf4:	f5843783          	ld	a5,-168(s0)
 bf8:	03000513          	li	a0,48
 bfc:	000780e7          	jalr	a5
 c00:	f5043783          	ld	a5,-176(s0)
 c04:	0007c783          	lbu	a5,0(a5)
 c08:	00078713          	mv	a4,a5
 c0c:	05800793          	li	a5,88
 c10:	00f71663          	bne	a4,a5,c1c <vprintfmt+0x49c>
 c14:	05800793          	li	a5,88
 c18:	0080006f          	j	c20 <vprintfmt+0x4a0>
 c1c:	07800793          	li	a5,120
 c20:	f5843703          	ld	a4,-168(s0)
 c24:	00078513          	mv	a0,a5
 c28:	000700e7          	jalr	a4
 c2c:	fec42783          	lw	a5,-20(s0)
 c30:	0027879b          	addiw	a5,a5,2
 c34:	fef42623          	sw	a5,-20(s0)
 c38:	fdc42783          	lw	a5,-36(s0)
 c3c:	fcf42a23          	sw	a5,-44(s0)
 c40:	0280006f          	j	c68 <vprintfmt+0x4e8>
 c44:	f5843783          	ld	a5,-168(s0)
 c48:	03000513          	li	a0,48
 c4c:	000780e7          	jalr	a5
 c50:	fec42783          	lw	a5,-20(s0)
 c54:	0017879b          	addiw	a5,a5,1
 c58:	fef42623          	sw	a5,-20(s0)
 c5c:	fd442783          	lw	a5,-44(s0)
 c60:	0017879b          	addiw	a5,a5,1
 c64:	fcf42a23          	sw	a5,-44(s0)
 c68:	f8c42703          	lw	a4,-116(s0)
 c6c:	fd442783          	lw	a5,-44(s0)
 c70:	0007879b          	sext.w	a5,a5
 c74:	fce7c8e3          	blt	a5,a4,c44 <vprintfmt+0x4c4>
 c78:	fdc42783          	lw	a5,-36(s0)
 c7c:	fff7879b          	addiw	a5,a5,-1
 c80:	fcf42823          	sw	a5,-48(s0)
 c84:	03c0006f          	j	cc0 <vprintfmt+0x540>
 c88:	fd042783          	lw	a5,-48(s0)
 c8c:	ff078793          	addi	a5,a5,-16
 c90:	008787b3          	add	a5,a5,s0
 c94:	f807c783          	lbu	a5,-128(a5)
 c98:	0007871b          	sext.w	a4,a5
 c9c:	f5843783          	ld	a5,-168(s0)
 ca0:	00070513          	mv	a0,a4
 ca4:	000780e7          	jalr	a5
 ca8:	fec42783          	lw	a5,-20(s0)
 cac:	0017879b          	addiw	a5,a5,1
 cb0:	fef42623          	sw	a5,-20(s0)
 cb4:	fd042783          	lw	a5,-48(s0)
 cb8:	fff7879b          	addiw	a5,a5,-1
 cbc:	fcf42823          	sw	a5,-48(s0)
 cc0:	fd042783          	lw	a5,-48(s0)
 cc4:	0007879b          	sext.w	a5,a5
 cc8:	fc07d0e3          	bgez	a5,c88 <vprintfmt+0x508>
 ccc:	f8040023          	sb	zero,-128(s0)
 cd0:	2700006f          	j	f40 <vprintfmt+0x7c0>
 cd4:	f5043783          	ld	a5,-176(s0)
 cd8:	0007c783          	lbu	a5,0(a5)
 cdc:	00078713          	mv	a4,a5
 ce0:	06400793          	li	a5,100
 ce4:	02f70663          	beq	a4,a5,d10 <vprintfmt+0x590>
 ce8:	f5043783          	ld	a5,-176(s0)
 cec:	0007c783          	lbu	a5,0(a5)
 cf0:	00078713          	mv	a4,a5
 cf4:	06900793          	li	a5,105
 cf8:	00f70c63          	beq	a4,a5,d10 <vprintfmt+0x590>
 cfc:	f5043783          	ld	a5,-176(s0)
 d00:	0007c783          	lbu	a5,0(a5)
 d04:	00078713          	mv	a4,a5
 d08:	07500793          	li	a5,117
 d0c:	08f71063          	bne	a4,a5,d8c <vprintfmt+0x60c>
 d10:	f8144783          	lbu	a5,-127(s0)
 d14:	00078c63          	beqz	a5,d2c <vprintfmt+0x5ac>
 d18:	f4843783          	ld	a5,-184(s0)
 d1c:	00878713          	addi	a4,a5,8
 d20:	f4e43423          	sd	a4,-184(s0)
 d24:	0007b783          	ld	a5,0(a5)
 d28:	0140006f          	j	d3c <vprintfmt+0x5bc>
 d2c:	f4843783          	ld	a5,-184(s0)
 d30:	00878713          	addi	a4,a5,8
 d34:	f4e43423          	sd	a4,-184(s0)
 d38:	0007a783          	lw	a5,0(a5)
 d3c:	faf43423          	sd	a5,-88(s0)
 d40:	fa843583          	ld	a1,-88(s0)
 d44:	f5043783          	ld	a5,-176(s0)
 d48:	0007c783          	lbu	a5,0(a5)
 d4c:	0007871b          	sext.w	a4,a5
 d50:	07500793          	li	a5,117
 d54:	40f707b3          	sub	a5,a4,a5
 d58:	00f037b3          	snez	a5,a5
 d5c:	0ff7f793          	zext.b	a5,a5
 d60:	f8040713          	addi	a4,s0,-128
 d64:	00070693          	mv	a3,a4
 d68:	00078613          	mv	a2,a5
 d6c:	f5843503          	ld	a0,-168(s0)
 d70:	f08ff0ef          	jal	478 <print_dec_int>
 d74:	00050793          	mv	a5,a0
 d78:	fec42703          	lw	a4,-20(s0)
 d7c:	00f707bb          	addw	a5,a4,a5
 d80:	fef42623          	sw	a5,-20(s0)
 d84:	f8040023          	sb	zero,-128(s0)
 d88:	1b80006f          	j	f40 <vprintfmt+0x7c0>
 d8c:	f5043783          	ld	a5,-176(s0)
 d90:	0007c783          	lbu	a5,0(a5)
 d94:	00078713          	mv	a4,a5
 d98:	06e00793          	li	a5,110
 d9c:	04f71c63          	bne	a4,a5,df4 <vprintfmt+0x674>
 da0:	f8144783          	lbu	a5,-127(s0)
 da4:	02078463          	beqz	a5,dcc <vprintfmt+0x64c>
 da8:	f4843783          	ld	a5,-184(s0)
 dac:	00878713          	addi	a4,a5,8
 db0:	f4e43423          	sd	a4,-184(s0)
 db4:	0007b783          	ld	a5,0(a5)
 db8:	faf43823          	sd	a5,-80(s0)
 dbc:	fec42703          	lw	a4,-20(s0)
 dc0:	fb043783          	ld	a5,-80(s0)
 dc4:	00e7b023          	sd	a4,0(a5)
 dc8:	0240006f          	j	dec <vprintfmt+0x66c>
 dcc:	f4843783          	ld	a5,-184(s0)
 dd0:	00878713          	addi	a4,a5,8
 dd4:	f4e43423          	sd	a4,-184(s0)
 dd8:	0007b783          	ld	a5,0(a5)
 ddc:	faf43c23          	sd	a5,-72(s0)
 de0:	fb843783          	ld	a5,-72(s0)
 de4:	fec42703          	lw	a4,-20(s0)
 de8:	00e7a023          	sw	a4,0(a5)
 dec:	f8040023          	sb	zero,-128(s0)
 df0:	1500006f          	j	f40 <vprintfmt+0x7c0>
 df4:	f5043783          	ld	a5,-176(s0)
 df8:	0007c783          	lbu	a5,0(a5)
 dfc:	00078713          	mv	a4,a5
 e00:	07300793          	li	a5,115
 e04:	02f71e63          	bne	a4,a5,e40 <vprintfmt+0x6c0>
 e08:	f4843783          	ld	a5,-184(s0)
 e0c:	00878713          	addi	a4,a5,8
 e10:	f4e43423          	sd	a4,-184(s0)
 e14:	0007b783          	ld	a5,0(a5)
 e18:	fcf43023          	sd	a5,-64(s0)
 e1c:	fc043583          	ld	a1,-64(s0)
 e20:	f5843503          	ld	a0,-168(s0)
 e24:	dccff0ef          	jal	3f0 <puts_wo_nl>
 e28:	00050793          	mv	a5,a0
 e2c:	fec42703          	lw	a4,-20(s0)
 e30:	00f707bb          	addw	a5,a4,a5
 e34:	fef42623          	sw	a5,-20(s0)
 e38:	f8040023          	sb	zero,-128(s0)
 e3c:	1040006f          	j	f40 <vprintfmt+0x7c0>
 e40:	f5043783          	ld	a5,-176(s0)
 e44:	0007c783          	lbu	a5,0(a5)
 e48:	00078713          	mv	a4,a5
 e4c:	06300793          	li	a5,99
 e50:	02f71e63          	bne	a4,a5,e8c <vprintfmt+0x70c>
 e54:	f4843783          	ld	a5,-184(s0)
 e58:	00878713          	addi	a4,a5,8
 e5c:	f4e43423          	sd	a4,-184(s0)
 e60:	0007a783          	lw	a5,0(a5)
 e64:	fcf42623          	sw	a5,-52(s0)
 e68:	fcc42703          	lw	a4,-52(s0)
 e6c:	f5843783          	ld	a5,-168(s0)
 e70:	00070513          	mv	a0,a4
 e74:	000780e7          	jalr	a5
 e78:	fec42783          	lw	a5,-20(s0)
 e7c:	0017879b          	addiw	a5,a5,1
 e80:	fef42623          	sw	a5,-20(s0)
 e84:	f8040023          	sb	zero,-128(s0)
 e88:	0b80006f          	j	f40 <vprintfmt+0x7c0>
 e8c:	f5043783          	ld	a5,-176(s0)
 e90:	0007c783          	lbu	a5,0(a5)
 e94:	00078713          	mv	a4,a5
 e98:	02500793          	li	a5,37
 e9c:	02f71263          	bne	a4,a5,ec0 <vprintfmt+0x740>
 ea0:	f5843783          	ld	a5,-168(s0)
 ea4:	02500513          	li	a0,37
 ea8:	000780e7          	jalr	a5
 eac:	fec42783          	lw	a5,-20(s0)
 eb0:	0017879b          	addiw	a5,a5,1
 eb4:	fef42623          	sw	a5,-20(s0)
 eb8:	f8040023          	sb	zero,-128(s0)
 ebc:	0840006f          	j	f40 <vprintfmt+0x7c0>
 ec0:	f5043783          	ld	a5,-176(s0)
 ec4:	0007c783          	lbu	a5,0(a5)
 ec8:	0007871b          	sext.w	a4,a5
 ecc:	f5843783          	ld	a5,-168(s0)
 ed0:	00070513          	mv	a0,a4
 ed4:	000780e7          	jalr	a5
 ed8:	fec42783          	lw	a5,-20(s0)
 edc:	0017879b          	addiw	a5,a5,1
 ee0:	fef42623          	sw	a5,-20(s0)
 ee4:	f8040023          	sb	zero,-128(s0)
 ee8:	0580006f          	j	f40 <vprintfmt+0x7c0>
 eec:	f5043783          	ld	a5,-176(s0)
 ef0:	0007c783          	lbu	a5,0(a5)
 ef4:	00078713          	mv	a4,a5
 ef8:	02500793          	li	a5,37
 efc:	02f71063          	bne	a4,a5,f1c <vprintfmt+0x79c>
 f00:	f8043023          	sd	zero,-128(s0)
 f04:	f8043423          	sd	zero,-120(s0)
 f08:	00100793          	li	a5,1
 f0c:	f8f40023          	sb	a5,-128(s0)
 f10:	fff00793          	li	a5,-1
 f14:	f8f42623          	sw	a5,-116(s0)
 f18:	0280006f          	j	f40 <vprintfmt+0x7c0>
 f1c:	f5043783          	ld	a5,-176(s0)
 f20:	0007c783          	lbu	a5,0(a5)
 f24:	0007871b          	sext.w	a4,a5
 f28:	f5843783          	ld	a5,-168(s0)
 f2c:	00070513          	mv	a0,a4
 f30:	000780e7          	jalr	a5
 f34:	fec42783          	lw	a5,-20(s0)
 f38:	0017879b          	addiw	a5,a5,1
 f3c:	fef42623          	sw	a5,-20(s0)
 f40:	f5043783          	ld	a5,-176(s0)
 f44:	00178793          	addi	a5,a5,1
 f48:	f4f43823          	sd	a5,-176(s0)
 f4c:	f5043783          	ld	a5,-176(s0)
 f50:	0007c783          	lbu	a5,0(a5)
 f54:	84079ce3          	bnez	a5,7ac <vprintfmt+0x2c>
 f58:	fec42783          	lw	a5,-20(s0)
 f5c:	00078513          	mv	a0,a5
 f60:	0b813083          	ld	ra,184(sp)
 f64:	0b013403          	ld	s0,176(sp)
 f68:	0c010113          	addi	sp,sp,192
 f6c:	00008067          	ret

Disassembly of section .text.printf:

0000000000000f70 <printf>:
     f70:	f8010113          	addi	sp,sp,-128
     f74:	02113c23          	sd	ra,56(sp)
     f78:	02813823          	sd	s0,48(sp)
     f7c:	04010413          	addi	s0,sp,64
     f80:	fca43423          	sd	a0,-56(s0)
     f84:	00b43423          	sd	a1,8(s0)
     f88:	00c43823          	sd	a2,16(s0)
     f8c:	00d43c23          	sd	a3,24(s0)
     f90:	02e43023          	sd	a4,32(s0)
     f94:	02f43423          	sd	a5,40(s0)
     f98:	03043823          	sd	a6,48(s0)
     f9c:	03143c23          	sd	a7,56(s0)
     fa0:	fe042623          	sw	zero,-20(s0)
     fa4:	04040793          	addi	a5,s0,64
     fa8:	fcf43023          	sd	a5,-64(s0)
     fac:	fc043783          	ld	a5,-64(s0)
     fb0:	fc878793          	addi	a5,a5,-56
     fb4:	fcf43823          	sd	a5,-48(s0)
     fb8:	fd043783          	ld	a5,-48(s0)
     fbc:	00078613          	mv	a2,a5
     fc0:	fc843583          	ld	a1,-56(s0)
     fc4:	fffff517          	auipc	a0,0xfffff
     fc8:	0f850513          	addi	a0,a0,248 # bc <putc>
     fcc:	fb4ff0ef          	jal	780 <vprintfmt>
     fd0:	00050793          	mv	a5,a0
     fd4:	fef42623          	sw	a5,-20(s0)
     fd8:	00100793          	li	a5,1
     fdc:	fef43023          	sd	a5,-32(s0)
     fe0:	00000797          	auipc	a5,0x0
     fe4:	29078793          	addi	a5,a5,656 # 1270 <tail>
     fe8:	0007a783          	lw	a5,0(a5)
     fec:	0017871b          	addiw	a4,a5,1
     ff0:	0007069b          	sext.w	a3,a4
     ff4:	00000717          	auipc	a4,0x0
     ff8:	27c70713          	addi	a4,a4,636 # 1270 <tail>
     ffc:	00d72023          	sw	a3,0(a4)
    1000:	00000717          	auipc	a4,0x0
    1004:	27870713          	addi	a4,a4,632 # 1278 <buffer>
    1008:	00f707b3          	add	a5,a4,a5
    100c:	00078023          	sb	zero,0(a5)
    1010:	00000797          	auipc	a5,0x0
    1014:	26078793          	addi	a5,a5,608 # 1270 <tail>
    1018:	0007a603          	lw	a2,0(a5)
    101c:	fe043703          	ld	a4,-32(s0)
    1020:	00000697          	auipc	a3,0x0
    1024:	25868693          	addi	a3,a3,600 # 1278 <buffer>
    1028:	fd843783          	ld	a5,-40(s0)
    102c:	04000893          	li	a7,64
    1030:	00070513          	mv	a0,a4
    1034:	00068593          	mv	a1,a3
    1038:	00060613          	mv	a2,a2
    103c:	00000073          	ecall
    1040:	00050793          	mv	a5,a0
    1044:	fcf43c23          	sd	a5,-40(s0)
    1048:	00000797          	auipc	a5,0x0
    104c:	22878793          	addi	a5,a5,552 # 1270 <tail>
    1050:	0007a023          	sw	zero,0(a5)
    1054:	fec42783          	lw	a5,-20(s0)
    1058:	00078513          	mv	a0,a5
    105c:	03813083          	ld	ra,56(sp)
    1060:	03013403          	ld	s0,48(sp)
    1064:	08010113          	addi	sp,sp,128
    1068:	00008067          	ret
