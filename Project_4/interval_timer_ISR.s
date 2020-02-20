	.include "address_map_nios2.s"
	.include "globals.s"
	.extern	PATTERN					# externally defined variables
	.extern PSTART
	.extern INDEX
	.global INTERVAL_TIMER_ISR

INTERVAL_TIMER_ISR:					
	subi	sp,  sp, 44				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r4, 4(sp)
	stw		r5, 8(sp)
	stw		r6, 12(sp)
	stw		r8, 16(sp)
	stw		r10, 20(sp)
	stw		r17, 24(sp)
	stw		r20, 28(sp)
	stw		r21, 32(sp)
	stw		r22, 36(sp)
	stw		r23, 40(sp)

	movia	r10, TIMER_BASE			# interval timer base address
	sthio	r0,  0(r10)				# clear the interrupt

	movia	r20, HEX3_HEX0_BASE		# HEX3_HEX0 base address
	movia	r21, PATTERN			# Pattern address base 
	movia 	r22, PSTART		 		# Address where previos display is stored 
	movia	r17, INDEX				# Address of letter to be added to display 

	ldw		r21, 0(r17)				
	ldw		r6, 0(r21)				# load char
	
	ldw		r23, 0(r22)				#load address of of stored display 

SHIFT_L:	
	movi	r5, 0x6D00
	slli	r5, r5, 16
	addi	r5, r5, 0x0000			# hex display for last update 
	add		r6,	r6,	r23				 
    stwio	r6, 0(r20)				# updates new display 
	slli	r6, r6, 8				
	beq		r6, r5, RESET			# Reset displays
	stw		r6, 0(r22)				# store new display	
	addi	r21, r21, 4				# address of next letter 
	stw		r21, 0(r17)				# store address 
	br END_INTERVAL_TIMER_ISR

RESET:
	movi	r6, 0x000004D4
	stw		r6, 0(r17)

END_INTERVAL_TIMER_ISR:
	ldw		ra, 0(sp)				# restore registers
	ldw		r4, 4(sp)
  	ldw		r5, 8(sp)
	ldw		r6, 12(sp)
	ldw		r8, 16(sp)
	ldw		r10, 20(sp)
	ldw		r17, 24(sp)
	ldw		r20, 28(sp)
	ldw		r21, 32(sp)
	ldw		r22, 36(sp)
	ldw		r23, 40(sp)
	addi	sp,  sp, 44				# release the reserved space on the stack

	ret
	.end
