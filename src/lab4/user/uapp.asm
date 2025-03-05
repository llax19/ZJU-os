
uapp:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100e8 <_start>:
   100e8:	0380006f          	j	10120 <main>

00000000000100ec <getpid>:
   100ec:	fe010113          	addi	sp,sp,-32
   100f0:	00813c23          	sd	s0,24(sp)
   100f4:	02010413          	addi	s0,sp,32
   100f8:	fe843783          	ld	a5,-24(s0)
   100fc:	0ac00893          	li	a7,172
   10100:	00000073          	ecall
   10104:	00050793          	mv	a5,a0
   10108:	fef43423          	sd	a5,-24(s0)
   1010c:	fe843783          	ld	a5,-24(s0)
   10110:	00078513          	mv	a0,a5
   10114:	01813403          	ld	s0,24(sp)
   10118:	02010113          	addi	sp,sp,32
   1011c:	00008067          	ret

0000000000010120 <main>:
   10120:	fe010113          	addi	sp,sp,-32
   10124:	00113c23          	sd	ra,24(sp)
   10128:	00813823          	sd	s0,16(sp)
   1012c:	02010413          	addi	s0,sp,32
   10130:	fbdff0ef          	jal	100ec <getpid>
   10134:	00050593          	mv	a1,a0
   10138:	00010613          	mv	a2,sp
   1013c:	00002797          	auipc	a5,0x2
   10140:	ec478793          	addi	a5,a5,-316 # 12000 <counter>
   10144:	0007a783          	lw	a5,0(a5)
   10148:	0017879b          	addiw	a5,a5,1
   1014c:	0007871b          	sext.w	a4,a5
   10150:	00002797          	auipc	a5,0x2
   10154:	eb078793          	addi	a5,a5,-336 # 12000 <counter>
   10158:	00e7a023          	sw	a4,0(a5)
   1015c:	00002797          	auipc	a5,0x2
   10160:	ea478793          	addi	a5,a5,-348 # 12000 <counter>
   10164:	0007a783          	lw	a5,0(a5)
   10168:	00078693          	mv	a3,a5
   1016c:	00001517          	auipc	a0,0x1
   10170:	fec50513          	addi	a0,a0,-20 # 11158 <printf+0x100>
   10174:	6e5000ef          	jal	11058 <printf>
   10178:	fe042623          	sw	zero,-20(s0)
   1017c:	0100006f          	j	1018c <main+0x6c>
   10180:	fec42783          	lw	a5,-20(s0)
   10184:	0017879b          	addiw	a5,a5,1
   10188:	fef42623          	sw	a5,-20(s0)
   1018c:	fec42783          	lw	a5,-20(s0)
   10190:	0007871b          	sext.w	a4,a5
   10194:	500007b7          	lui	a5,0x50000
   10198:	ffe78793          	addi	a5,a5,-2 # 4ffffffe <__global_pointer$+0x4ffed7fe>
   1019c:	fee7f2e3          	bgeu	a5,a4,10180 <main+0x60>
   101a0:	f91ff06f          	j	10130 <main+0x10>

00000000000101a4 <putc>:
   101a4:	fe010113          	addi	sp,sp,-32
   101a8:	00813c23          	sd	s0,24(sp)
   101ac:	02010413          	addi	s0,sp,32
   101b0:	00050793          	mv	a5,a0
   101b4:	fef42623          	sw	a5,-20(s0)
   101b8:	00002797          	auipc	a5,0x2
   101bc:	e4c78793          	addi	a5,a5,-436 # 12004 <tail>
   101c0:	0007a783          	lw	a5,0(a5)
   101c4:	0017871b          	addiw	a4,a5,1
   101c8:	0007069b          	sext.w	a3,a4
   101cc:	00002717          	auipc	a4,0x2
   101d0:	e3870713          	addi	a4,a4,-456 # 12004 <tail>
   101d4:	00d72023          	sw	a3,0(a4)
   101d8:	fec42703          	lw	a4,-20(s0)
   101dc:	0ff77713          	zext.b	a4,a4
   101e0:	00002697          	auipc	a3,0x2
   101e4:	e2868693          	addi	a3,a3,-472 # 12008 <buffer>
   101e8:	00f687b3          	add	a5,a3,a5
   101ec:	00e78023          	sb	a4,0(a5)
   101f0:	fec42783          	lw	a5,-20(s0)
   101f4:	0ff7f793          	zext.b	a5,a5
   101f8:	0007879b          	sext.w	a5,a5
   101fc:	00078513          	mv	a0,a5
   10200:	01813403          	ld	s0,24(sp)
   10204:	02010113          	addi	sp,sp,32
   10208:	00008067          	ret

000000000001020c <isspace>:
   1020c:	fe010113          	addi	sp,sp,-32
   10210:	00813c23          	sd	s0,24(sp)
   10214:	02010413          	addi	s0,sp,32
   10218:	00050793          	mv	a5,a0
   1021c:	fef42623          	sw	a5,-20(s0)
   10220:	fec42783          	lw	a5,-20(s0)
   10224:	0007871b          	sext.w	a4,a5
   10228:	02000793          	li	a5,32
   1022c:	02f70263          	beq	a4,a5,10250 <isspace+0x44>
   10230:	fec42783          	lw	a5,-20(s0)
   10234:	0007871b          	sext.w	a4,a5
   10238:	00800793          	li	a5,8
   1023c:	00e7de63          	bge	a5,a4,10258 <isspace+0x4c>
   10240:	fec42783          	lw	a5,-20(s0)
   10244:	0007871b          	sext.w	a4,a5
   10248:	00d00793          	li	a5,13
   1024c:	00e7c663          	blt	a5,a4,10258 <isspace+0x4c>
   10250:	00100793          	li	a5,1
   10254:	0080006f          	j	1025c <isspace+0x50>
   10258:	00000793          	li	a5,0
   1025c:	00078513          	mv	a0,a5
   10260:	01813403          	ld	s0,24(sp)
   10264:	02010113          	addi	sp,sp,32
   10268:	00008067          	ret

000000000001026c <strtol>:
   1026c:	fb010113          	addi	sp,sp,-80
   10270:	04113423          	sd	ra,72(sp)
   10274:	04813023          	sd	s0,64(sp)
   10278:	05010413          	addi	s0,sp,80
   1027c:	fca43423          	sd	a0,-56(s0)
   10280:	fcb43023          	sd	a1,-64(s0)
   10284:	00060793          	mv	a5,a2
   10288:	faf42e23          	sw	a5,-68(s0)
   1028c:	fe043423          	sd	zero,-24(s0)
   10290:	fe0403a3          	sb	zero,-25(s0)
   10294:	fc843783          	ld	a5,-56(s0)
   10298:	fcf43c23          	sd	a5,-40(s0)
   1029c:	0100006f          	j	102ac <strtol+0x40>
   102a0:	fd843783          	ld	a5,-40(s0)
   102a4:	00178793          	addi	a5,a5,1
   102a8:	fcf43c23          	sd	a5,-40(s0)
   102ac:	fd843783          	ld	a5,-40(s0)
   102b0:	0007c783          	lbu	a5,0(a5)
   102b4:	0007879b          	sext.w	a5,a5
   102b8:	00078513          	mv	a0,a5
   102bc:	f51ff0ef          	jal	1020c <isspace>
   102c0:	00050793          	mv	a5,a0
   102c4:	fc079ee3          	bnez	a5,102a0 <strtol+0x34>
   102c8:	fd843783          	ld	a5,-40(s0)
   102cc:	0007c783          	lbu	a5,0(a5)
   102d0:	00078713          	mv	a4,a5
   102d4:	02d00793          	li	a5,45
   102d8:	00f71e63          	bne	a4,a5,102f4 <strtol+0x88>
   102dc:	00100793          	li	a5,1
   102e0:	fef403a3          	sb	a5,-25(s0)
   102e4:	fd843783          	ld	a5,-40(s0)
   102e8:	00178793          	addi	a5,a5,1
   102ec:	fcf43c23          	sd	a5,-40(s0)
   102f0:	0240006f          	j	10314 <strtol+0xa8>
   102f4:	fd843783          	ld	a5,-40(s0)
   102f8:	0007c783          	lbu	a5,0(a5)
   102fc:	00078713          	mv	a4,a5
   10300:	02b00793          	li	a5,43
   10304:	00f71863          	bne	a4,a5,10314 <strtol+0xa8>
   10308:	fd843783          	ld	a5,-40(s0)
   1030c:	00178793          	addi	a5,a5,1
   10310:	fcf43c23          	sd	a5,-40(s0)
   10314:	fbc42783          	lw	a5,-68(s0)
   10318:	0007879b          	sext.w	a5,a5
   1031c:	06079c63          	bnez	a5,10394 <strtol+0x128>
   10320:	fd843783          	ld	a5,-40(s0)
   10324:	0007c783          	lbu	a5,0(a5)
   10328:	00078713          	mv	a4,a5
   1032c:	03000793          	li	a5,48
   10330:	04f71e63          	bne	a4,a5,1038c <strtol+0x120>
   10334:	fd843783          	ld	a5,-40(s0)
   10338:	00178793          	addi	a5,a5,1
   1033c:	fcf43c23          	sd	a5,-40(s0)
   10340:	fd843783          	ld	a5,-40(s0)
   10344:	0007c783          	lbu	a5,0(a5)
   10348:	00078713          	mv	a4,a5
   1034c:	07800793          	li	a5,120
   10350:	00f70c63          	beq	a4,a5,10368 <strtol+0xfc>
   10354:	fd843783          	ld	a5,-40(s0)
   10358:	0007c783          	lbu	a5,0(a5)
   1035c:	00078713          	mv	a4,a5
   10360:	05800793          	li	a5,88
   10364:	00f71e63          	bne	a4,a5,10380 <strtol+0x114>
   10368:	01000793          	li	a5,16
   1036c:	faf42e23          	sw	a5,-68(s0)
   10370:	fd843783          	ld	a5,-40(s0)
   10374:	00178793          	addi	a5,a5,1
   10378:	fcf43c23          	sd	a5,-40(s0)
   1037c:	0180006f          	j	10394 <strtol+0x128>
   10380:	00800793          	li	a5,8
   10384:	faf42e23          	sw	a5,-68(s0)
   10388:	00c0006f          	j	10394 <strtol+0x128>
   1038c:	00a00793          	li	a5,10
   10390:	faf42e23          	sw	a5,-68(s0)
   10394:	fd843783          	ld	a5,-40(s0)
   10398:	0007c783          	lbu	a5,0(a5)
   1039c:	00078713          	mv	a4,a5
   103a0:	02f00793          	li	a5,47
   103a4:	02e7f863          	bgeu	a5,a4,103d4 <strtol+0x168>
   103a8:	fd843783          	ld	a5,-40(s0)
   103ac:	0007c783          	lbu	a5,0(a5)
   103b0:	00078713          	mv	a4,a5
   103b4:	03900793          	li	a5,57
   103b8:	00e7ee63          	bltu	a5,a4,103d4 <strtol+0x168>
   103bc:	fd843783          	ld	a5,-40(s0)
   103c0:	0007c783          	lbu	a5,0(a5)
   103c4:	0007879b          	sext.w	a5,a5
   103c8:	fd07879b          	addiw	a5,a5,-48
   103cc:	fcf42a23          	sw	a5,-44(s0)
   103d0:	0800006f          	j	10450 <strtol+0x1e4>
   103d4:	fd843783          	ld	a5,-40(s0)
   103d8:	0007c783          	lbu	a5,0(a5)
   103dc:	00078713          	mv	a4,a5
   103e0:	06000793          	li	a5,96
   103e4:	02e7f863          	bgeu	a5,a4,10414 <strtol+0x1a8>
   103e8:	fd843783          	ld	a5,-40(s0)
   103ec:	0007c783          	lbu	a5,0(a5)
   103f0:	00078713          	mv	a4,a5
   103f4:	07a00793          	li	a5,122
   103f8:	00e7ee63          	bltu	a5,a4,10414 <strtol+0x1a8>
   103fc:	fd843783          	ld	a5,-40(s0)
   10400:	0007c783          	lbu	a5,0(a5)
   10404:	0007879b          	sext.w	a5,a5
   10408:	fa97879b          	addiw	a5,a5,-87
   1040c:	fcf42a23          	sw	a5,-44(s0)
   10410:	0400006f          	j	10450 <strtol+0x1e4>
   10414:	fd843783          	ld	a5,-40(s0)
   10418:	0007c783          	lbu	a5,0(a5)
   1041c:	00078713          	mv	a4,a5
   10420:	04000793          	li	a5,64
   10424:	06e7f863          	bgeu	a5,a4,10494 <strtol+0x228>
   10428:	fd843783          	ld	a5,-40(s0)
   1042c:	0007c783          	lbu	a5,0(a5)
   10430:	00078713          	mv	a4,a5
   10434:	05a00793          	li	a5,90
   10438:	04e7ee63          	bltu	a5,a4,10494 <strtol+0x228>
   1043c:	fd843783          	ld	a5,-40(s0)
   10440:	0007c783          	lbu	a5,0(a5)
   10444:	0007879b          	sext.w	a5,a5
   10448:	fc97879b          	addiw	a5,a5,-55
   1044c:	fcf42a23          	sw	a5,-44(s0)
   10450:	fd442783          	lw	a5,-44(s0)
   10454:	00078713          	mv	a4,a5
   10458:	fbc42783          	lw	a5,-68(s0)
   1045c:	0007071b          	sext.w	a4,a4
   10460:	0007879b          	sext.w	a5,a5
   10464:	02f75663          	bge	a4,a5,10490 <strtol+0x224>
   10468:	fbc42703          	lw	a4,-68(s0)
   1046c:	fe843783          	ld	a5,-24(s0)
   10470:	02f70733          	mul	a4,a4,a5
   10474:	fd442783          	lw	a5,-44(s0)
   10478:	00f707b3          	add	a5,a4,a5
   1047c:	fef43423          	sd	a5,-24(s0)
   10480:	fd843783          	ld	a5,-40(s0)
   10484:	00178793          	addi	a5,a5,1
   10488:	fcf43c23          	sd	a5,-40(s0)
   1048c:	f09ff06f          	j	10394 <strtol+0x128>
   10490:	00000013          	nop
   10494:	fc043783          	ld	a5,-64(s0)
   10498:	00078863          	beqz	a5,104a8 <strtol+0x23c>
   1049c:	fc043783          	ld	a5,-64(s0)
   104a0:	fd843703          	ld	a4,-40(s0)
   104a4:	00e7b023          	sd	a4,0(a5)
   104a8:	fe744783          	lbu	a5,-25(s0)
   104ac:	0ff7f793          	zext.b	a5,a5
   104b0:	00078863          	beqz	a5,104c0 <strtol+0x254>
   104b4:	fe843783          	ld	a5,-24(s0)
   104b8:	40f007b3          	neg	a5,a5
   104bc:	0080006f          	j	104c4 <strtol+0x258>
   104c0:	fe843783          	ld	a5,-24(s0)
   104c4:	00078513          	mv	a0,a5
   104c8:	04813083          	ld	ra,72(sp)
   104cc:	04013403          	ld	s0,64(sp)
   104d0:	05010113          	addi	sp,sp,80
   104d4:	00008067          	ret

00000000000104d8 <puts_wo_nl>:
   104d8:	fd010113          	addi	sp,sp,-48
   104dc:	02113423          	sd	ra,40(sp)
   104e0:	02813023          	sd	s0,32(sp)
   104e4:	03010413          	addi	s0,sp,48
   104e8:	fca43c23          	sd	a0,-40(s0)
   104ec:	fcb43823          	sd	a1,-48(s0)
   104f0:	fd043783          	ld	a5,-48(s0)
   104f4:	00079863          	bnez	a5,10504 <puts_wo_nl+0x2c>
   104f8:	00001797          	auipc	a5,0x1
   104fc:	c9878793          	addi	a5,a5,-872 # 11190 <printf+0x138>
   10500:	fcf43823          	sd	a5,-48(s0)
   10504:	fd043783          	ld	a5,-48(s0)
   10508:	fef43423          	sd	a5,-24(s0)
   1050c:	0240006f          	j	10530 <puts_wo_nl+0x58>
   10510:	fe843783          	ld	a5,-24(s0)
   10514:	00178713          	addi	a4,a5,1
   10518:	fee43423          	sd	a4,-24(s0)
   1051c:	0007c783          	lbu	a5,0(a5)
   10520:	0007871b          	sext.w	a4,a5
   10524:	fd843783          	ld	a5,-40(s0)
   10528:	00070513          	mv	a0,a4
   1052c:	000780e7          	jalr	a5
   10530:	fe843783          	ld	a5,-24(s0)
   10534:	0007c783          	lbu	a5,0(a5)
   10538:	fc079ce3          	bnez	a5,10510 <puts_wo_nl+0x38>
   1053c:	fe843703          	ld	a4,-24(s0)
   10540:	fd043783          	ld	a5,-48(s0)
   10544:	40f707b3          	sub	a5,a4,a5
   10548:	0007879b          	sext.w	a5,a5
   1054c:	00078513          	mv	a0,a5
   10550:	02813083          	ld	ra,40(sp)
   10554:	02013403          	ld	s0,32(sp)
   10558:	03010113          	addi	sp,sp,48
   1055c:	00008067          	ret

0000000000010560 <print_dec_int>:
   10560:	f9010113          	addi	sp,sp,-112
   10564:	06113423          	sd	ra,104(sp)
   10568:	06813023          	sd	s0,96(sp)
   1056c:	07010413          	addi	s0,sp,112
   10570:	faa43423          	sd	a0,-88(s0)
   10574:	fab43023          	sd	a1,-96(s0)
   10578:	00060793          	mv	a5,a2
   1057c:	f8d43823          	sd	a3,-112(s0)
   10580:	f8f40fa3          	sb	a5,-97(s0)
   10584:	f9f44783          	lbu	a5,-97(s0)
   10588:	0ff7f793          	zext.b	a5,a5
   1058c:	02078663          	beqz	a5,105b8 <print_dec_int+0x58>
   10590:	fa043703          	ld	a4,-96(s0)
   10594:	fff00793          	li	a5,-1
   10598:	03f79793          	slli	a5,a5,0x3f
   1059c:	00f71e63          	bne	a4,a5,105b8 <print_dec_int+0x58>
   105a0:	00001597          	auipc	a1,0x1
   105a4:	bf858593          	addi	a1,a1,-1032 # 11198 <printf+0x140>
   105a8:	fa843503          	ld	a0,-88(s0)
   105ac:	f2dff0ef          	jal	104d8 <puts_wo_nl>
   105b0:	00050793          	mv	a5,a0
   105b4:	2a00006f          	j	10854 <print_dec_int+0x2f4>
   105b8:	f9043783          	ld	a5,-112(s0)
   105bc:	00c7a783          	lw	a5,12(a5)
   105c0:	00079a63          	bnez	a5,105d4 <print_dec_int+0x74>
   105c4:	fa043783          	ld	a5,-96(s0)
   105c8:	00079663          	bnez	a5,105d4 <print_dec_int+0x74>
   105cc:	00000793          	li	a5,0
   105d0:	2840006f          	j	10854 <print_dec_int+0x2f4>
   105d4:	fe0407a3          	sb	zero,-17(s0)
   105d8:	f9f44783          	lbu	a5,-97(s0)
   105dc:	0ff7f793          	zext.b	a5,a5
   105e0:	02078063          	beqz	a5,10600 <print_dec_int+0xa0>
   105e4:	fa043783          	ld	a5,-96(s0)
   105e8:	0007dc63          	bgez	a5,10600 <print_dec_int+0xa0>
   105ec:	00100793          	li	a5,1
   105f0:	fef407a3          	sb	a5,-17(s0)
   105f4:	fa043783          	ld	a5,-96(s0)
   105f8:	40f007b3          	neg	a5,a5
   105fc:	faf43023          	sd	a5,-96(s0)
   10600:	fe042423          	sw	zero,-24(s0)
   10604:	f9f44783          	lbu	a5,-97(s0)
   10608:	0ff7f793          	zext.b	a5,a5
   1060c:	02078863          	beqz	a5,1063c <print_dec_int+0xdc>
   10610:	fef44783          	lbu	a5,-17(s0)
   10614:	0ff7f793          	zext.b	a5,a5
   10618:	00079e63          	bnez	a5,10634 <print_dec_int+0xd4>
   1061c:	f9043783          	ld	a5,-112(s0)
   10620:	0057c783          	lbu	a5,5(a5)
   10624:	00079863          	bnez	a5,10634 <print_dec_int+0xd4>
   10628:	f9043783          	ld	a5,-112(s0)
   1062c:	0047c783          	lbu	a5,4(a5)
   10630:	00078663          	beqz	a5,1063c <print_dec_int+0xdc>
   10634:	00100793          	li	a5,1
   10638:	0080006f          	j	10640 <print_dec_int+0xe0>
   1063c:	00000793          	li	a5,0
   10640:	fcf40ba3          	sb	a5,-41(s0)
   10644:	fd744783          	lbu	a5,-41(s0)
   10648:	0017f793          	andi	a5,a5,1
   1064c:	fcf40ba3          	sb	a5,-41(s0)
   10650:	fa043703          	ld	a4,-96(s0)
   10654:	00a00793          	li	a5,10
   10658:	02f777b3          	remu	a5,a4,a5
   1065c:	0ff7f713          	zext.b	a4,a5
   10660:	fe842783          	lw	a5,-24(s0)
   10664:	0017869b          	addiw	a3,a5,1
   10668:	fed42423          	sw	a3,-24(s0)
   1066c:	0307071b          	addiw	a4,a4,48
   10670:	0ff77713          	zext.b	a4,a4
   10674:	ff078793          	addi	a5,a5,-16
   10678:	008787b3          	add	a5,a5,s0
   1067c:	fce78423          	sb	a4,-56(a5)
   10680:	fa043703          	ld	a4,-96(s0)
   10684:	00a00793          	li	a5,10
   10688:	02f757b3          	divu	a5,a4,a5
   1068c:	faf43023          	sd	a5,-96(s0)
   10690:	fa043783          	ld	a5,-96(s0)
   10694:	fa079ee3          	bnez	a5,10650 <print_dec_int+0xf0>
   10698:	f9043783          	ld	a5,-112(s0)
   1069c:	00c7a783          	lw	a5,12(a5)
   106a0:	00078713          	mv	a4,a5
   106a4:	fff00793          	li	a5,-1
   106a8:	02f71063          	bne	a4,a5,106c8 <print_dec_int+0x168>
   106ac:	f9043783          	ld	a5,-112(s0)
   106b0:	0037c783          	lbu	a5,3(a5)
   106b4:	00078a63          	beqz	a5,106c8 <print_dec_int+0x168>
   106b8:	f9043783          	ld	a5,-112(s0)
   106bc:	0087a703          	lw	a4,8(a5)
   106c0:	f9043783          	ld	a5,-112(s0)
   106c4:	00e7a623          	sw	a4,12(a5)
   106c8:	fe042223          	sw	zero,-28(s0)
   106cc:	f9043783          	ld	a5,-112(s0)
   106d0:	0087a703          	lw	a4,8(a5)
   106d4:	fe842783          	lw	a5,-24(s0)
   106d8:	fcf42823          	sw	a5,-48(s0)
   106dc:	f9043783          	ld	a5,-112(s0)
   106e0:	00c7a783          	lw	a5,12(a5)
   106e4:	fcf42623          	sw	a5,-52(s0)
   106e8:	fd042783          	lw	a5,-48(s0)
   106ec:	00078593          	mv	a1,a5
   106f0:	fcc42783          	lw	a5,-52(s0)
   106f4:	00078613          	mv	a2,a5
   106f8:	0006069b          	sext.w	a3,a2
   106fc:	0005879b          	sext.w	a5,a1
   10700:	00f6d463          	bge	a3,a5,10708 <print_dec_int+0x1a8>
   10704:	00058613          	mv	a2,a1
   10708:	0006079b          	sext.w	a5,a2
   1070c:	40f707bb          	subw	a5,a4,a5
   10710:	0007871b          	sext.w	a4,a5
   10714:	fd744783          	lbu	a5,-41(s0)
   10718:	0007879b          	sext.w	a5,a5
   1071c:	40f707bb          	subw	a5,a4,a5
   10720:	fef42023          	sw	a5,-32(s0)
   10724:	0280006f          	j	1074c <print_dec_int+0x1ec>
   10728:	fa843783          	ld	a5,-88(s0)
   1072c:	02000513          	li	a0,32
   10730:	000780e7          	jalr	a5
   10734:	fe442783          	lw	a5,-28(s0)
   10738:	0017879b          	addiw	a5,a5,1
   1073c:	fef42223          	sw	a5,-28(s0)
   10740:	fe042783          	lw	a5,-32(s0)
   10744:	fff7879b          	addiw	a5,a5,-1
   10748:	fef42023          	sw	a5,-32(s0)
   1074c:	fe042783          	lw	a5,-32(s0)
   10750:	0007879b          	sext.w	a5,a5
   10754:	fcf04ae3          	bgtz	a5,10728 <print_dec_int+0x1c8>
   10758:	fd744783          	lbu	a5,-41(s0)
   1075c:	0ff7f793          	zext.b	a5,a5
   10760:	04078463          	beqz	a5,107a8 <print_dec_int+0x248>
   10764:	fef44783          	lbu	a5,-17(s0)
   10768:	0ff7f793          	zext.b	a5,a5
   1076c:	00078663          	beqz	a5,10778 <print_dec_int+0x218>
   10770:	02d00793          	li	a5,45
   10774:	01c0006f          	j	10790 <print_dec_int+0x230>
   10778:	f9043783          	ld	a5,-112(s0)
   1077c:	0057c783          	lbu	a5,5(a5)
   10780:	00078663          	beqz	a5,1078c <print_dec_int+0x22c>
   10784:	02b00793          	li	a5,43
   10788:	0080006f          	j	10790 <print_dec_int+0x230>
   1078c:	02000793          	li	a5,32
   10790:	fa843703          	ld	a4,-88(s0)
   10794:	00078513          	mv	a0,a5
   10798:	000700e7          	jalr	a4
   1079c:	fe442783          	lw	a5,-28(s0)
   107a0:	0017879b          	addiw	a5,a5,1
   107a4:	fef42223          	sw	a5,-28(s0)
   107a8:	fe842783          	lw	a5,-24(s0)
   107ac:	fcf42e23          	sw	a5,-36(s0)
   107b0:	0280006f          	j	107d8 <print_dec_int+0x278>
   107b4:	fa843783          	ld	a5,-88(s0)
   107b8:	03000513          	li	a0,48
   107bc:	000780e7          	jalr	a5
   107c0:	fe442783          	lw	a5,-28(s0)
   107c4:	0017879b          	addiw	a5,a5,1
   107c8:	fef42223          	sw	a5,-28(s0)
   107cc:	fdc42783          	lw	a5,-36(s0)
   107d0:	0017879b          	addiw	a5,a5,1
   107d4:	fcf42e23          	sw	a5,-36(s0)
   107d8:	f9043783          	ld	a5,-112(s0)
   107dc:	00c7a703          	lw	a4,12(a5)
   107e0:	fd744783          	lbu	a5,-41(s0)
   107e4:	0007879b          	sext.w	a5,a5
   107e8:	40f707bb          	subw	a5,a4,a5
   107ec:	0007871b          	sext.w	a4,a5
   107f0:	fdc42783          	lw	a5,-36(s0)
   107f4:	0007879b          	sext.w	a5,a5
   107f8:	fae7cee3          	blt	a5,a4,107b4 <print_dec_int+0x254>
   107fc:	fe842783          	lw	a5,-24(s0)
   10800:	fff7879b          	addiw	a5,a5,-1
   10804:	fcf42c23          	sw	a5,-40(s0)
   10808:	03c0006f          	j	10844 <print_dec_int+0x2e4>
   1080c:	fd842783          	lw	a5,-40(s0)
   10810:	ff078793          	addi	a5,a5,-16
   10814:	008787b3          	add	a5,a5,s0
   10818:	fc87c783          	lbu	a5,-56(a5)
   1081c:	0007871b          	sext.w	a4,a5
   10820:	fa843783          	ld	a5,-88(s0)
   10824:	00070513          	mv	a0,a4
   10828:	000780e7          	jalr	a5
   1082c:	fe442783          	lw	a5,-28(s0)
   10830:	0017879b          	addiw	a5,a5,1
   10834:	fef42223          	sw	a5,-28(s0)
   10838:	fd842783          	lw	a5,-40(s0)
   1083c:	fff7879b          	addiw	a5,a5,-1
   10840:	fcf42c23          	sw	a5,-40(s0)
   10844:	fd842783          	lw	a5,-40(s0)
   10848:	0007879b          	sext.w	a5,a5
   1084c:	fc07d0e3          	bgez	a5,1080c <print_dec_int+0x2ac>
   10850:	fe442783          	lw	a5,-28(s0)
   10854:	00078513          	mv	a0,a5
   10858:	06813083          	ld	ra,104(sp)
   1085c:	06013403          	ld	s0,96(sp)
   10860:	07010113          	addi	sp,sp,112
   10864:	00008067          	ret

0000000000010868 <vprintfmt>:
   10868:	f4010113          	addi	sp,sp,-192
   1086c:	0a113c23          	sd	ra,184(sp)
   10870:	0a813823          	sd	s0,176(sp)
   10874:	0c010413          	addi	s0,sp,192
   10878:	f4a43c23          	sd	a0,-168(s0)
   1087c:	f4b43823          	sd	a1,-176(s0)
   10880:	f4c43423          	sd	a2,-184(s0)
   10884:	f8043023          	sd	zero,-128(s0)
   10888:	f8043423          	sd	zero,-120(s0)
   1088c:	fe042623          	sw	zero,-20(s0)
   10890:	7a40006f          	j	11034 <vprintfmt+0x7cc>
   10894:	f8044783          	lbu	a5,-128(s0)
   10898:	72078e63          	beqz	a5,10fd4 <vprintfmt+0x76c>
   1089c:	f5043783          	ld	a5,-176(s0)
   108a0:	0007c783          	lbu	a5,0(a5)
   108a4:	00078713          	mv	a4,a5
   108a8:	02300793          	li	a5,35
   108ac:	00f71863          	bne	a4,a5,108bc <vprintfmt+0x54>
   108b0:	00100793          	li	a5,1
   108b4:	f8f40123          	sb	a5,-126(s0)
   108b8:	7700006f          	j	11028 <vprintfmt+0x7c0>
   108bc:	f5043783          	ld	a5,-176(s0)
   108c0:	0007c783          	lbu	a5,0(a5)
   108c4:	00078713          	mv	a4,a5
   108c8:	03000793          	li	a5,48
   108cc:	00f71863          	bne	a4,a5,108dc <vprintfmt+0x74>
   108d0:	00100793          	li	a5,1
   108d4:	f8f401a3          	sb	a5,-125(s0)
   108d8:	7500006f          	j	11028 <vprintfmt+0x7c0>
   108dc:	f5043783          	ld	a5,-176(s0)
   108e0:	0007c783          	lbu	a5,0(a5)
   108e4:	00078713          	mv	a4,a5
   108e8:	06c00793          	li	a5,108
   108ec:	04f70063          	beq	a4,a5,1092c <vprintfmt+0xc4>
   108f0:	f5043783          	ld	a5,-176(s0)
   108f4:	0007c783          	lbu	a5,0(a5)
   108f8:	00078713          	mv	a4,a5
   108fc:	07a00793          	li	a5,122
   10900:	02f70663          	beq	a4,a5,1092c <vprintfmt+0xc4>
   10904:	f5043783          	ld	a5,-176(s0)
   10908:	0007c783          	lbu	a5,0(a5)
   1090c:	00078713          	mv	a4,a5
   10910:	07400793          	li	a5,116
   10914:	00f70c63          	beq	a4,a5,1092c <vprintfmt+0xc4>
   10918:	f5043783          	ld	a5,-176(s0)
   1091c:	0007c783          	lbu	a5,0(a5)
   10920:	00078713          	mv	a4,a5
   10924:	06a00793          	li	a5,106
   10928:	00f71863          	bne	a4,a5,10938 <vprintfmt+0xd0>
   1092c:	00100793          	li	a5,1
   10930:	f8f400a3          	sb	a5,-127(s0)
   10934:	6f40006f          	j	11028 <vprintfmt+0x7c0>
   10938:	f5043783          	ld	a5,-176(s0)
   1093c:	0007c783          	lbu	a5,0(a5)
   10940:	00078713          	mv	a4,a5
   10944:	02b00793          	li	a5,43
   10948:	00f71863          	bne	a4,a5,10958 <vprintfmt+0xf0>
   1094c:	00100793          	li	a5,1
   10950:	f8f402a3          	sb	a5,-123(s0)
   10954:	6d40006f          	j	11028 <vprintfmt+0x7c0>
   10958:	f5043783          	ld	a5,-176(s0)
   1095c:	0007c783          	lbu	a5,0(a5)
   10960:	00078713          	mv	a4,a5
   10964:	02000793          	li	a5,32
   10968:	00f71863          	bne	a4,a5,10978 <vprintfmt+0x110>
   1096c:	00100793          	li	a5,1
   10970:	f8f40223          	sb	a5,-124(s0)
   10974:	6b40006f          	j	11028 <vprintfmt+0x7c0>
   10978:	f5043783          	ld	a5,-176(s0)
   1097c:	0007c783          	lbu	a5,0(a5)
   10980:	00078713          	mv	a4,a5
   10984:	02a00793          	li	a5,42
   10988:	00f71e63          	bne	a4,a5,109a4 <vprintfmt+0x13c>
   1098c:	f4843783          	ld	a5,-184(s0)
   10990:	00878713          	addi	a4,a5,8
   10994:	f4e43423          	sd	a4,-184(s0)
   10998:	0007a783          	lw	a5,0(a5)
   1099c:	f8f42423          	sw	a5,-120(s0)
   109a0:	6880006f          	j	11028 <vprintfmt+0x7c0>
   109a4:	f5043783          	ld	a5,-176(s0)
   109a8:	0007c783          	lbu	a5,0(a5)
   109ac:	00078713          	mv	a4,a5
   109b0:	03000793          	li	a5,48
   109b4:	04e7f663          	bgeu	a5,a4,10a00 <vprintfmt+0x198>
   109b8:	f5043783          	ld	a5,-176(s0)
   109bc:	0007c783          	lbu	a5,0(a5)
   109c0:	00078713          	mv	a4,a5
   109c4:	03900793          	li	a5,57
   109c8:	02e7ec63          	bltu	a5,a4,10a00 <vprintfmt+0x198>
   109cc:	f5043783          	ld	a5,-176(s0)
   109d0:	f5040713          	addi	a4,s0,-176
   109d4:	00a00613          	li	a2,10
   109d8:	00070593          	mv	a1,a4
   109dc:	00078513          	mv	a0,a5
   109e0:	88dff0ef          	jal	1026c <strtol>
   109e4:	00050793          	mv	a5,a0
   109e8:	0007879b          	sext.w	a5,a5
   109ec:	f8f42423          	sw	a5,-120(s0)
   109f0:	f5043783          	ld	a5,-176(s0)
   109f4:	fff78793          	addi	a5,a5,-1
   109f8:	f4f43823          	sd	a5,-176(s0)
   109fc:	62c0006f          	j	11028 <vprintfmt+0x7c0>
   10a00:	f5043783          	ld	a5,-176(s0)
   10a04:	0007c783          	lbu	a5,0(a5)
   10a08:	00078713          	mv	a4,a5
   10a0c:	02e00793          	li	a5,46
   10a10:	06f71863          	bne	a4,a5,10a80 <vprintfmt+0x218>
   10a14:	f5043783          	ld	a5,-176(s0)
   10a18:	00178793          	addi	a5,a5,1
   10a1c:	f4f43823          	sd	a5,-176(s0)
   10a20:	f5043783          	ld	a5,-176(s0)
   10a24:	0007c783          	lbu	a5,0(a5)
   10a28:	00078713          	mv	a4,a5
   10a2c:	02a00793          	li	a5,42
   10a30:	00f71e63          	bne	a4,a5,10a4c <vprintfmt+0x1e4>
   10a34:	f4843783          	ld	a5,-184(s0)
   10a38:	00878713          	addi	a4,a5,8
   10a3c:	f4e43423          	sd	a4,-184(s0)
   10a40:	0007a783          	lw	a5,0(a5)
   10a44:	f8f42623          	sw	a5,-116(s0)
   10a48:	5e00006f          	j	11028 <vprintfmt+0x7c0>
   10a4c:	f5043783          	ld	a5,-176(s0)
   10a50:	f5040713          	addi	a4,s0,-176
   10a54:	00a00613          	li	a2,10
   10a58:	00070593          	mv	a1,a4
   10a5c:	00078513          	mv	a0,a5
   10a60:	80dff0ef          	jal	1026c <strtol>
   10a64:	00050793          	mv	a5,a0
   10a68:	0007879b          	sext.w	a5,a5
   10a6c:	f8f42623          	sw	a5,-116(s0)
   10a70:	f5043783          	ld	a5,-176(s0)
   10a74:	fff78793          	addi	a5,a5,-1
   10a78:	f4f43823          	sd	a5,-176(s0)
   10a7c:	5ac0006f          	j	11028 <vprintfmt+0x7c0>
   10a80:	f5043783          	ld	a5,-176(s0)
   10a84:	0007c783          	lbu	a5,0(a5)
   10a88:	00078713          	mv	a4,a5
   10a8c:	07800793          	li	a5,120
   10a90:	02f70663          	beq	a4,a5,10abc <vprintfmt+0x254>
   10a94:	f5043783          	ld	a5,-176(s0)
   10a98:	0007c783          	lbu	a5,0(a5)
   10a9c:	00078713          	mv	a4,a5
   10aa0:	05800793          	li	a5,88
   10aa4:	00f70c63          	beq	a4,a5,10abc <vprintfmt+0x254>
   10aa8:	f5043783          	ld	a5,-176(s0)
   10aac:	0007c783          	lbu	a5,0(a5)
   10ab0:	00078713          	mv	a4,a5
   10ab4:	07000793          	li	a5,112
   10ab8:	30f71263          	bne	a4,a5,10dbc <vprintfmt+0x554>
   10abc:	f5043783          	ld	a5,-176(s0)
   10ac0:	0007c783          	lbu	a5,0(a5)
   10ac4:	00078713          	mv	a4,a5
   10ac8:	07000793          	li	a5,112
   10acc:	00f70663          	beq	a4,a5,10ad8 <vprintfmt+0x270>
   10ad0:	f8144783          	lbu	a5,-127(s0)
   10ad4:	00078663          	beqz	a5,10ae0 <vprintfmt+0x278>
   10ad8:	00100793          	li	a5,1
   10adc:	0080006f          	j	10ae4 <vprintfmt+0x27c>
   10ae0:	00000793          	li	a5,0
   10ae4:	faf403a3          	sb	a5,-89(s0)
   10ae8:	fa744783          	lbu	a5,-89(s0)
   10aec:	0017f793          	andi	a5,a5,1
   10af0:	faf403a3          	sb	a5,-89(s0)
   10af4:	fa744783          	lbu	a5,-89(s0)
   10af8:	0ff7f793          	zext.b	a5,a5
   10afc:	00078c63          	beqz	a5,10b14 <vprintfmt+0x2ac>
   10b00:	f4843783          	ld	a5,-184(s0)
   10b04:	00878713          	addi	a4,a5,8
   10b08:	f4e43423          	sd	a4,-184(s0)
   10b0c:	0007b783          	ld	a5,0(a5)
   10b10:	01c0006f          	j	10b2c <vprintfmt+0x2c4>
   10b14:	f4843783          	ld	a5,-184(s0)
   10b18:	00878713          	addi	a4,a5,8
   10b1c:	f4e43423          	sd	a4,-184(s0)
   10b20:	0007a783          	lw	a5,0(a5)
   10b24:	02079793          	slli	a5,a5,0x20
   10b28:	0207d793          	srli	a5,a5,0x20
   10b2c:	fef43023          	sd	a5,-32(s0)
   10b30:	f8c42783          	lw	a5,-116(s0)
   10b34:	02079463          	bnez	a5,10b5c <vprintfmt+0x2f4>
   10b38:	fe043783          	ld	a5,-32(s0)
   10b3c:	02079063          	bnez	a5,10b5c <vprintfmt+0x2f4>
   10b40:	f5043783          	ld	a5,-176(s0)
   10b44:	0007c783          	lbu	a5,0(a5)
   10b48:	00078713          	mv	a4,a5
   10b4c:	07000793          	li	a5,112
   10b50:	00f70663          	beq	a4,a5,10b5c <vprintfmt+0x2f4>
   10b54:	f8040023          	sb	zero,-128(s0)
   10b58:	4d00006f          	j	11028 <vprintfmt+0x7c0>
   10b5c:	f5043783          	ld	a5,-176(s0)
   10b60:	0007c783          	lbu	a5,0(a5)
   10b64:	00078713          	mv	a4,a5
   10b68:	07000793          	li	a5,112
   10b6c:	00f70a63          	beq	a4,a5,10b80 <vprintfmt+0x318>
   10b70:	f8244783          	lbu	a5,-126(s0)
   10b74:	00078a63          	beqz	a5,10b88 <vprintfmt+0x320>
   10b78:	fe043783          	ld	a5,-32(s0)
   10b7c:	00078663          	beqz	a5,10b88 <vprintfmt+0x320>
   10b80:	00100793          	li	a5,1
   10b84:	0080006f          	j	10b8c <vprintfmt+0x324>
   10b88:	00000793          	li	a5,0
   10b8c:	faf40323          	sb	a5,-90(s0)
   10b90:	fa644783          	lbu	a5,-90(s0)
   10b94:	0017f793          	andi	a5,a5,1
   10b98:	faf40323          	sb	a5,-90(s0)
   10b9c:	fc042e23          	sw	zero,-36(s0)
   10ba0:	f5043783          	ld	a5,-176(s0)
   10ba4:	0007c783          	lbu	a5,0(a5)
   10ba8:	00078713          	mv	a4,a5
   10bac:	05800793          	li	a5,88
   10bb0:	00f71863          	bne	a4,a5,10bc0 <vprintfmt+0x358>
   10bb4:	00000797          	auipc	a5,0x0
   10bb8:	5fc78793          	addi	a5,a5,1532 # 111b0 <upperxdigits.1>
   10bbc:	00c0006f          	j	10bc8 <vprintfmt+0x360>
   10bc0:	00000797          	auipc	a5,0x0
   10bc4:	60878793          	addi	a5,a5,1544 # 111c8 <lowerxdigits.0>
   10bc8:	f8f43c23          	sd	a5,-104(s0)
   10bcc:	fe043783          	ld	a5,-32(s0)
   10bd0:	00f7f793          	andi	a5,a5,15
   10bd4:	f9843703          	ld	a4,-104(s0)
   10bd8:	00f70733          	add	a4,a4,a5
   10bdc:	fdc42783          	lw	a5,-36(s0)
   10be0:	0017869b          	addiw	a3,a5,1
   10be4:	fcd42e23          	sw	a3,-36(s0)
   10be8:	00074703          	lbu	a4,0(a4)
   10bec:	ff078793          	addi	a5,a5,-16
   10bf0:	008787b3          	add	a5,a5,s0
   10bf4:	f8e78023          	sb	a4,-128(a5)
   10bf8:	fe043783          	ld	a5,-32(s0)
   10bfc:	0047d793          	srli	a5,a5,0x4
   10c00:	fef43023          	sd	a5,-32(s0)
   10c04:	fe043783          	ld	a5,-32(s0)
   10c08:	fc0792e3          	bnez	a5,10bcc <vprintfmt+0x364>
   10c0c:	f8c42783          	lw	a5,-116(s0)
   10c10:	00078713          	mv	a4,a5
   10c14:	fff00793          	li	a5,-1
   10c18:	02f71663          	bne	a4,a5,10c44 <vprintfmt+0x3dc>
   10c1c:	f8344783          	lbu	a5,-125(s0)
   10c20:	02078263          	beqz	a5,10c44 <vprintfmt+0x3dc>
   10c24:	f8842703          	lw	a4,-120(s0)
   10c28:	fa644783          	lbu	a5,-90(s0)
   10c2c:	0007879b          	sext.w	a5,a5
   10c30:	0017979b          	slliw	a5,a5,0x1
   10c34:	0007879b          	sext.w	a5,a5
   10c38:	40f707bb          	subw	a5,a4,a5
   10c3c:	0007879b          	sext.w	a5,a5
   10c40:	f8f42623          	sw	a5,-116(s0)
   10c44:	f8842703          	lw	a4,-120(s0)
   10c48:	fa644783          	lbu	a5,-90(s0)
   10c4c:	0007879b          	sext.w	a5,a5
   10c50:	0017979b          	slliw	a5,a5,0x1
   10c54:	0007879b          	sext.w	a5,a5
   10c58:	40f707bb          	subw	a5,a4,a5
   10c5c:	0007871b          	sext.w	a4,a5
   10c60:	fdc42783          	lw	a5,-36(s0)
   10c64:	f8f42a23          	sw	a5,-108(s0)
   10c68:	f8c42783          	lw	a5,-116(s0)
   10c6c:	f8f42823          	sw	a5,-112(s0)
   10c70:	f9442783          	lw	a5,-108(s0)
   10c74:	00078593          	mv	a1,a5
   10c78:	f9042783          	lw	a5,-112(s0)
   10c7c:	00078613          	mv	a2,a5
   10c80:	0006069b          	sext.w	a3,a2
   10c84:	0005879b          	sext.w	a5,a1
   10c88:	00f6d463          	bge	a3,a5,10c90 <vprintfmt+0x428>
   10c8c:	00058613          	mv	a2,a1
   10c90:	0006079b          	sext.w	a5,a2
   10c94:	40f707bb          	subw	a5,a4,a5
   10c98:	fcf42c23          	sw	a5,-40(s0)
   10c9c:	0280006f          	j	10cc4 <vprintfmt+0x45c>
   10ca0:	f5843783          	ld	a5,-168(s0)
   10ca4:	02000513          	li	a0,32
   10ca8:	000780e7          	jalr	a5
   10cac:	fec42783          	lw	a5,-20(s0)
   10cb0:	0017879b          	addiw	a5,a5,1
   10cb4:	fef42623          	sw	a5,-20(s0)
   10cb8:	fd842783          	lw	a5,-40(s0)
   10cbc:	fff7879b          	addiw	a5,a5,-1
   10cc0:	fcf42c23          	sw	a5,-40(s0)
   10cc4:	fd842783          	lw	a5,-40(s0)
   10cc8:	0007879b          	sext.w	a5,a5
   10ccc:	fcf04ae3          	bgtz	a5,10ca0 <vprintfmt+0x438>
   10cd0:	fa644783          	lbu	a5,-90(s0)
   10cd4:	0ff7f793          	zext.b	a5,a5
   10cd8:	04078463          	beqz	a5,10d20 <vprintfmt+0x4b8>
   10cdc:	f5843783          	ld	a5,-168(s0)
   10ce0:	03000513          	li	a0,48
   10ce4:	000780e7          	jalr	a5
   10ce8:	f5043783          	ld	a5,-176(s0)
   10cec:	0007c783          	lbu	a5,0(a5)
   10cf0:	00078713          	mv	a4,a5
   10cf4:	05800793          	li	a5,88
   10cf8:	00f71663          	bne	a4,a5,10d04 <vprintfmt+0x49c>
   10cfc:	05800793          	li	a5,88
   10d00:	0080006f          	j	10d08 <vprintfmt+0x4a0>
   10d04:	07800793          	li	a5,120
   10d08:	f5843703          	ld	a4,-168(s0)
   10d0c:	00078513          	mv	a0,a5
   10d10:	000700e7          	jalr	a4
   10d14:	fec42783          	lw	a5,-20(s0)
   10d18:	0027879b          	addiw	a5,a5,2
   10d1c:	fef42623          	sw	a5,-20(s0)
   10d20:	fdc42783          	lw	a5,-36(s0)
   10d24:	fcf42a23          	sw	a5,-44(s0)
   10d28:	0280006f          	j	10d50 <vprintfmt+0x4e8>
   10d2c:	f5843783          	ld	a5,-168(s0)
   10d30:	03000513          	li	a0,48
   10d34:	000780e7          	jalr	a5
   10d38:	fec42783          	lw	a5,-20(s0)
   10d3c:	0017879b          	addiw	a5,a5,1
   10d40:	fef42623          	sw	a5,-20(s0)
   10d44:	fd442783          	lw	a5,-44(s0)
   10d48:	0017879b          	addiw	a5,a5,1
   10d4c:	fcf42a23          	sw	a5,-44(s0)
   10d50:	f8c42703          	lw	a4,-116(s0)
   10d54:	fd442783          	lw	a5,-44(s0)
   10d58:	0007879b          	sext.w	a5,a5
   10d5c:	fce7c8e3          	blt	a5,a4,10d2c <vprintfmt+0x4c4>
   10d60:	fdc42783          	lw	a5,-36(s0)
   10d64:	fff7879b          	addiw	a5,a5,-1
   10d68:	fcf42823          	sw	a5,-48(s0)
   10d6c:	03c0006f          	j	10da8 <vprintfmt+0x540>
   10d70:	fd042783          	lw	a5,-48(s0)
   10d74:	ff078793          	addi	a5,a5,-16
   10d78:	008787b3          	add	a5,a5,s0
   10d7c:	f807c783          	lbu	a5,-128(a5)
   10d80:	0007871b          	sext.w	a4,a5
   10d84:	f5843783          	ld	a5,-168(s0)
   10d88:	00070513          	mv	a0,a4
   10d8c:	000780e7          	jalr	a5
   10d90:	fec42783          	lw	a5,-20(s0)
   10d94:	0017879b          	addiw	a5,a5,1
   10d98:	fef42623          	sw	a5,-20(s0)
   10d9c:	fd042783          	lw	a5,-48(s0)
   10da0:	fff7879b          	addiw	a5,a5,-1
   10da4:	fcf42823          	sw	a5,-48(s0)
   10da8:	fd042783          	lw	a5,-48(s0)
   10dac:	0007879b          	sext.w	a5,a5
   10db0:	fc07d0e3          	bgez	a5,10d70 <vprintfmt+0x508>
   10db4:	f8040023          	sb	zero,-128(s0)
   10db8:	2700006f          	j	11028 <vprintfmt+0x7c0>
   10dbc:	f5043783          	ld	a5,-176(s0)
   10dc0:	0007c783          	lbu	a5,0(a5)
   10dc4:	00078713          	mv	a4,a5
   10dc8:	06400793          	li	a5,100
   10dcc:	02f70663          	beq	a4,a5,10df8 <vprintfmt+0x590>
   10dd0:	f5043783          	ld	a5,-176(s0)
   10dd4:	0007c783          	lbu	a5,0(a5)
   10dd8:	00078713          	mv	a4,a5
   10ddc:	06900793          	li	a5,105
   10de0:	00f70c63          	beq	a4,a5,10df8 <vprintfmt+0x590>
   10de4:	f5043783          	ld	a5,-176(s0)
   10de8:	0007c783          	lbu	a5,0(a5)
   10dec:	00078713          	mv	a4,a5
   10df0:	07500793          	li	a5,117
   10df4:	08f71063          	bne	a4,a5,10e74 <vprintfmt+0x60c>
   10df8:	f8144783          	lbu	a5,-127(s0)
   10dfc:	00078c63          	beqz	a5,10e14 <vprintfmt+0x5ac>
   10e00:	f4843783          	ld	a5,-184(s0)
   10e04:	00878713          	addi	a4,a5,8
   10e08:	f4e43423          	sd	a4,-184(s0)
   10e0c:	0007b783          	ld	a5,0(a5)
   10e10:	0140006f          	j	10e24 <vprintfmt+0x5bc>
   10e14:	f4843783          	ld	a5,-184(s0)
   10e18:	00878713          	addi	a4,a5,8
   10e1c:	f4e43423          	sd	a4,-184(s0)
   10e20:	0007a783          	lw	a5,0(a5)
   10e24:	faf43423          	sd	a5,-88(s0)
   10e28:	fa843583          	ld	a1,-88(s0)
   10e2c:	f5043783          	ld	a5,-176(s0)
   10e30:	0007c783          	lbu	a5,0(a5)
   10e34:	0007871b          	sext.w	a4,a5
   10e38:	07500793          	li	a5,117
   10e3c:	40f707b3          	sub	a5,a4,a5
   10e40:	00f037b3          	snez	a5,a5
   10e44:	0ff7f793          	zext.b	a5,a5
   10e48:	f8040713          	addi	a4,s0,-128
   10e4c:	00070693          	mv	a3,a4
   10e50:	00078613          	mv	a2,a5
   10e54:	f5843503          	ld	a0,-168(s0)
   10e58:	f08ff0ef          	jal	10560 <print_dec_int>
   10e5c:	00050793          	mv	a5,a0
   10e60:	fec42703          	lw	a4,-20(s0)
   10e64:	00f707bb          	addw	a5,a4,a5
   10e68:	fef42623          	sw	a5,-20(s0)
   10e6c:	f8040023          	sb	zero,-128(s0)
   10e70:	1b80006f          	j	11028 <vprintfmt+0x7c0>
   10e74:	f5043783          	ld	a5,-176(s0)
   10e78:	0007c783          	lbu	a5,0(a5)
   10e7c:	00078713          	mv	a4,a5
   10e80:	06e00793          	li	a5,110
   10e84:	04f71c63          	bne	a4,a5,10edc <vprintfmt+0x674>
   10e88:	f8144783          	lbu	a5,-127(s0)
   10e8c:	02078463          	beqz	a5,10eb4 <vprintfmt+0x64c>
   10e90:	f4843783          	ld	a5,-184(s0)
   10e94:	00878713          	addi	a4,a5,8
   10e98:	f4e43423          	sd	a4,-184(s0)
   10e9c:	0007b783          	ld	a5,0(a5)
   10ea0:	faf43823          	sd	a5,-80(s0)
   10ea4:	fec42703          	lw	a4,-20(s0)
   10ea8:	fb043783          	ld	a5,-80(s0)
   10eac:	00e7b023          	sd	a4,0(a5)
   10eb0:	0240006f          	j	10ed4 <vprintfmt+0x66c>
   10eb4:	f4843783          	ld	a5,-184(s0)
   10eb8:	00878713          	addi	a4,a5,8
   10ebc:	f4e43423          	sd	a4,-184(s0)
   10ec0:	0007b783          	ld	a5,0(a5)
   10ec4:	faf43c23          	sd	a5,-72(s0)
   10ec8:	fb843783          	ld	a5,-72(s0)
   10ecc:	fec42703          	lw	a4,-20(s0)
   10ed0:	00e7a023          	sw	a4,0(a5)
   10ed4:	f8040023          	sb	zero,-128(s0)
   10ed8:	1500006f          	j	11028 <vprintfmt+0x7c0>
   10edc:	f5043783          	ld	a5,-176(s0)
   10ee0:	0007c783          	lbu	a5,0(a5)
   10ee4:	00078713          	mv	a4,a5
   10ee8:	07300793          	li	a5,115
   10eec:	02f71e63          	bne	a4,a5,10f28 <vprintfmt+0x6c0>
   10ef0:	f4843783          	ld	a5,-184(s0)
   10ef4:	00878713          	addi	a4,a5,8
   10ef8:	f4e43423          	sd	a4,-184(s0)
   10efc:	0007b783          	ld	a5,0(a5)
   10f00:	fcf43023          	sd	a5,-64(s0)
   10f04:	fc043583          	ld	a1,-64(s0)
   10f08:	f5843503          	ld	a0,-168(s0)
   10f0c:	dccff0ef          	jal	104d8 <puts_wo_nl>
   10f10:	00050793          	mv	a5,a0
   10f14:	fec42703          	lw	a4,-20(s0)
   10f18:	00f707bb          	addw	a5,a4,a5
   10f1c:	fef42623          	sw	a5,-20(s0)
   10f20:	f8040023          	sb	zero,-128(s0)
   10f24:	1040006f          	j	11028 <vprintfmt+0x7c0>
   10f28:	f5043783          	ld	a5,-176(s0)
   10f2c:	0007c783          	lbu	a5,0(a5)
   10f30:	00078713          	mv	a4,a5
   10f34:	06300793          	li	a5,99
   10f38:	02f71e63          	bne	a4,a5,10f74 <vprintfmt+0x70c>
   10f3c:	f4843783          	ld	a5,-184(s0)
   10f40:	00878713          	addi	a4,a5,8
   10f44:	f4e43423          	sd	a4,-184(s0)
   10f48:	0007a783          	lw	a5,0(a5)
   10f4c:	fcf42623          	sw	a5,-52(s0)
   10f50:	fcc42703          	lw	a4,-52(s0)
   10f54:	f5843783          	ld	a5,-168(s0)
   10f58:	00070513          	mv	a0,a4
   10f5c:	000780e7          	jalr	a5
   10f60:	fec42783          	lw	a5,-20(s0)
   10f64:	0017879b          	addiw	a5,a5,1
   10f68:	fef42623          	sw	a5,-20(s0)
   10f6c:	f8040023          	sb	zero,-128(s0)
   10f70:	0b80006f          	j	11028 <vprintfmt+0x7c0>
   10f74:	f5043783          	ld	a5,-176(s0)
   10f78:	0007c783          	lbu	a5,0(a5)
   10f7c:	00078713          	mv	a4,a5
   10f80:	02500793          	li	a5,37
   10f84:	02f71263          	bne	a4,a5,10fa8 <vprintfmt+0x740>
   10f88:	f5843783          	ld	a5,-168(s0)
   10f8c:	02500513          	li	a0,37
   10f90:	000780e7          	jalr	a5
   10f94:	fec42783          	lw	a5,-20(s0)
   10f98:	0017879b          	addiw	a5,a5,1
   10f9c:	fef42623          	sw	a5,-20(s0)
   10fa0:	f8040023          	sb	zero,-128(s0)
   10fa4:	0840006f          	j	11028 <vprintfmt+0x7c0>
   10fa8:	f5043783          	ld	a5,-176(s0)
   10fac:	0007c783          	lbu	a5,0(a5)
   10fb0:	0007871b          	sext.w	a4,a5
   10fb4:	f5843783          	ld	a5,-168(s0)
   10fb8:	00070513          	mv	a0,a4
   10fbc:	000780e7          	jalr	a5
   10fc0:	fec42783          	lw	a5,-20(s0)
   10fc4:	0017879b          	addiw	a5,a5,1
   10fc8:	fef42623          	sw	a5,-20(s0)
   10fcc:	f8040023          	sb	zero,-128(s0)
   10fd0:	0580006f          	j	11028 <vprintfmt+0x7c0>
   10fd4:	f5043783          	ld	a5,-176(s0)
   10fd8:	0007c783          	lbu	a5,0(a5)
   10fdc:	00078713          	mv	a4,a5
   10fe0:	02500793          	li	a5,37
   10fe4:	02f71063          	bne	a4,a5,11004 <vprintfmt+0x79c>
   10fe8:	f8043023          	sd	zero,-128(s0)
   10fec:	f8043423          	sd	zero,-120(s0)
   10ff0:	00100793          	li	a5,1
   10ff4:	f8f40023          	sb	a5,-128(s0)
   10ff8:	fff00793          	li	a5,-1
   10ffc:	f8f42623          	sw	a5,-116(s0)
   11000:	0280006f          	j	11028 <vprintfmt+0x7c0>
   11004:	f5043783          	ld	a5,-176(s0)
   11008:	0007c783          	lbu	a5,0(a5)
   1100c:	0007871b          	sext.w	a4,a5
   11010:	f5843783          	ld	a5,-168(s0)
   11014:	00070513          	mv	a0,a4
   11018:	000780e7          	jalr	a5
   1101c:	fec42783          	lw	a5,-20(s0)
   11020:	0017879b          	addiw	a5,a5,1
   11024:	fef42623          	sw	a5,-20(s0)
   11028:	f5043783          	ld	a5,-176(s0)
   1102c:	00178793          	addi	a5,a5,1
   11030:	f4f43823          	sd	a5,-176(s0)
   11034:	f5043783          	ld	a5,-176(s0)
   11038:	0007c783          	lbu	a5,0(a5)
   1103c:	84079ce3          	bnez	a5,10894 <vprintfmt+0x2c>
   11040:	fec42783          	lw	a5,-20(s0)
   11044:	00078513          	mv	a0,a5
   11048:	0b813083          	ld	ra,184(sp)
   1104c:	0b013403          	ld	s0,176(sp)
   11050:	0c010113          	addi	sp,sp,192
   11054:	00008067          	ret

0000000000011058 <printf>:
   11058:	f8010113          	addi	sp,sp,-128
   1105c:	02113c23          	sd	ra,56(sp)
   11060:	02813823          	sd	s0,48(sp)
   11064:	04010413          	addi	s0,sp,64
   11068:	fca43423          	sd	a0,-56(s0)
   1106c:	00b43423          	sd	a1,8(s0)
   11070:	00c43823          	sd	a2,16(s0)
   11074:	00d43c23          	sd	a3,24(s0)
   11078:	02e43023          	sd	a4,32(s0)
   1107c:	02f43423          	sd	a5,40(s0)
   11080:	03043823          	sd	a6,48(s0)
   11084:	03143c23          	sd	a7,56(s0)
   11088:	fe042623          	sw	zero,-20(s0)
   1108c:	04040793          	addi	a5,s0,64
   11090:	fcf43023          	sd	a5,-64(s0)
   11094:	fc043783          	ld	a5,-64(s0)
   11098:	fc878793          	addi	a5,a5,-56
   1109c:	fcf43823          	sd	a5,-48(s0)
   110a0:	fd043783          	ld	a5,-48(s0)
   110a4:	00078613          	mv	a2,a5
   110a8:	fc843583          	ld	a1,-56(s0)
   110ac:	fffff517          	auipc	a0,0xfffff
   110b0:	0f850513          	addi	a0,a0,248 # 101a4 <putc>
   110b4:	fb4ff0ef          	jal	10868 <vprintfmt>
   110b8:	00050793          	mv	a5,a0
   110bc:	fef42623          	sw	a5,-20(s0)
   110c0:	00100793          	li	a5,1
   110c4:	fef43023          	sd	a5,-32(s0)
   110c8:	00001797          	auipc	a5,0x1
   110cc:	f3c78793          	addi	a5,a5,-196 # 12004 <tail>
   110d0:	0007a783          	lw	a5,0(a5)
   110d4:	0017871b          	addiw	a4,a5,1
   110d8:	0007069b          	sext.w	a3,a4
   110dc:	00001717          	auipc	a4,0x1
   110e0:	f2870713          	addi	a4,a4,-216 # 12004 <tail>
   110e4:	00d72023          	sw	a3,0(a4)
   110e8:	00001717          	auipc	a4,0x1
   110ec:	f2070713          	addi	a4,a4,-224 # 12008 <buffer>
   110f0:	00f707b3          	add	a5,a4,a5
   110f4:	00078023          	sb	zero,0(a5)
   110f8:	00001797          	auipc	a5,0x1
   110fc:	f0c78793          	addi	a5,a5,-244 # 12004 <tail>
   11100:	0007a603          	lw	a2,0(a5)
   11104:	fe043703          	ld	a4,-32(s0)
   11108:	00001697          	auipc	a3,0x1
   1110c:	f0068693          	addi	a3,a3,-256 # 12008 <buffer>
   11110:	fd843783          	ld	a5,-40(s0)
   11114:	04000893          	li	a7,64
   11118:	00070513          	mv	a0,a4
   1111c:	00068593          	mv	a1,a3
   11120:	00060613          	mv	a2,a2
   11124:	00000073          	ecall
   11128:	00050793          	mv	a5,a0
   1112c:	fcf43c23          	sd	a5,-40(s0)
   11130:	00001797          	auipc	a5,0x1
   11134:	ed478793          	addi	a5,a5,-300 # 12004 <tail>
   11138:	0007a023          	sw	zero,0(a5)
   1113c:	fec42783          	lw	a5,-20(s0)
   11140:	00078513          	mv	a0,a5
   11144:	03813083          	ld	ra,56(sp)
   11148:	03013403          	ld	s0,48(sp)
   1114c:	08010113          	addi	sp,sp,128
   11150:	00008067          	ret
