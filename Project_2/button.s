	.text
	.equ	DISP,		0xFF200020
	.equ	BUTT,		0xFF200050
	.global _start
_start:
	movia	r2,	DISP		# Address of 7 seg display
	movia 	r3,	HEX_DISP_F;
	movia	r4,	HEX_DISP_R; 
	movia	r9,	BUTT; 
	movia	r10, wait_time; 
	ldwio	r7, 0(r3);
	movi	r6,	0;

Forward:
	beq 	r7,	r0,	RESET_Forward;
	ldwio	r11, (r9);
	bne		r11, r0, SHIFT_R;
	ldwio	r7, 0(r3);
	add		r7,	r6,	r7;
	stwio	r7,	(r2);
	slli	r6,	r7,	8;
	ldw		r5, (r10);
	addi	r3,	r3, 4;
	call 	wait_F;
	br		Forward;

Reverse:
	beq		r7,	r0,	RESET_Reverse;	
	ldwio	r11, (r9);
	bne		r11, r0, SHIFT_L;
	ldwio	r7,	0(r4);
	add		r7,	r6,	r7;
	stwio	r7,	(r2);
	srli	r6,	r7,	8;
	ldw		r5,	(r10);
	addi	r4,	r4,	4;
	call 	wait_R;
	br 		Reverse;
	
RESET_Forward:
	movia 	r3,	HEX_DISP_F;
	ldwio	r7, 0(r3);
	br		Forward;

RESET_Reverse:
	movia	r4,	HEX_DISP_R;
	ldwio	r7, 0(r4);
	br		Reverse;

wait_F:
	subi	r5,	r5,	1;
	bne		r5,	r0,	wait_F;
	br 		Forward;

wait_R:
	subi	r5,	r5,	1;
	bne		r5,	r0,	wait_R;
	br 		Reverse;

SHIFT_R:
	movia 	r3,	HEX_DISP_F;
	srli	r6,	r6,	8;
	ldw		r5,	(r10);
	br		wait_R;

SHIFT_L:
	movia	r4,	HEX_DISP_R;
	slli	r6,	r6,	8;
	ldw		r5,	(r10);
	br		wait_F;
	.data 
HEX_DISP_F:
	.word	0x79,	0x49,	0x49,	0x49,	0x00,	0x00,	0x00,	0x00
HEX_DISP_R:
	.word	0x4F000000,	0x49000000,	0x49000000,	0x49000000,	0x00000000,	0x00000000,	0x00000000,	0x00000000
wait_time:
	.word	10000000;
	.end
