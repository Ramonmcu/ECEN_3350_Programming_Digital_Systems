.include "address_map_nios2.s"
	.text						# executable code follows
	.global _start
_start:
	movia 	sp, SDRAM_END - 3	# stack starts from largest memory address

	movia	r16, TIMER_BASE		# interval timer base address
	movia	r12, 30000000		# 1/(100 MHz) x (30 x 10^6) = 300 msec
	sthio	r12, 8(r16)			
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)		# store time in interval timer

	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)

	movia	r15, KEY_BASE		# pushbutton key base address
	movi	r7, 0b11			# set interrupt mask bits
	stwio	r7, 8(r15)			# interrupt mask register is (base + 8)

	movia	r7, 0x00000001		# get interrupt mask bit for interval timer
	movia	r8, 0x00000002		# get interrupt mask bit for pushbuttons
	or		r7, r7, r8
	wrctl	ienable, r7			# enable interrupts for the given mask bits
	movi	r7, 1
	wrctl	status, r7			# turn on Nios II interrupt processing

IDLE:
	br 		IDLE				# main program simply idles

	.data

	.global	PATTERN
PATTERN:
	.word	0x76, 0x79, 0x38, 0x38, 0x3F, 0x00, 0x7F, 0x3E, 0x71, 0x71, 0x6D, 0x00, 0x00, 0x00			# pattern to show on the HEX displays
	.global	PSTART
PSTART:
	.word 	0x00
	.global INDEX
INDEX:
	.word	0x000004D4
	.global COUNT
COUNT:
	.word	0x04

	.end
