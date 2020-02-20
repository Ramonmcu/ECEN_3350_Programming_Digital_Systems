	.text
	.equ	DISP,		0xFF200020
	.global _start
_start:
	movia	r2,	DISP		# Address of 7 seg display
	movia 	r3,	HEX_DISP;  
	movia	r6,	Patterns; 
	movia	r10, wait_time;
	movi	r11, 13;
	ldw		r5, (r10);
	movia	r7,	counter;
	ldw		r8,	(r7);
	ldwio	r4, 0(r3);
  
wait:
	subi	r5,	r5,	1;
	bne		r5,	r0,	wait;

LOOP:
	beq		r4,	r0,	Pattern
	ldwio	r4, 0(r3);
	stwio	r4,	(r2);
	ldw		r5, (r10);
	addi	r3,	r3, 4;
	call wait;
	br		LOOP

Pattern:
	addi	r8,	r8,	1;
	bge		r8,	r11,RESET;
	ldwio	r9,	0(r6);
	stwio	r9,	(r2);
	ldw		r5, (r10);
	addi	r6,	r6,	4;
	call wait;

RESET:
	movia 	r3,	HEX_DISP;
	movia	r6,	Patterns; 
	subi	r8,	r8,	13;
	.data 
HEX_DISP:
	.word	0x00000076,0x00007679,0x767938,0x76793838,0x7938383F,0x38383F00,0x383F007F,0x3F007F3E,0x007F3E71,0x7F3E7171,0x3E71716D,0x071716D40,0x716D4040,0x6D404040,0x40404000,0x40400000,0x40000000,0x00000000;
Patterns:
	.word	0x49494949,0x36363636,0x49494949,0x36363636,0x49494949,0x36363636,0x7F7F7F7F,0x00000000,0x7F7F7F7F,0x00000000,0x7F7F7F7F,0x00000000;
wait_time:
	.word	10000000;
counter:
	.word	0;
	.end
