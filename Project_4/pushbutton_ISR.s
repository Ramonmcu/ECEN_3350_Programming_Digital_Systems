.include "address_map_nios2.s"
	.include "globals.s"
	.extern	PATTERN					# externally defined variables
	.extern COUNT
	.global	PUSHBUTTON_ISR
PUSHBUTTON_ISR:
	subi	sp, sp, 56				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r10, 4(sp)
	stw		r11, 8(sp)
	stw		r12, 12(sp)
	stw		r13, 16(sp)
	stw		r14, 20(sp)
	stw		r15, 24(sp)
	stw		r16, 28(sp)
	stw		r17, 32(sp)
	stw		r18, 36(sp)
	stw		r19, 40(sp)
	stw		r20, 44(sp)
	stw		r21, 48(sp)
	stw		r22, 52(sp)


	movia	r10, KEY_BASE			# base address of pushbutton KEY parallel port
	movia	r21, TIMER_BASE
	movia	r16, COUNT
	ldwio	r11, 0xC(r10)			# read edge capture register
	stwio	r11, 0xC(r10)			# clear the interrupt	  

	movi	r14, 7
	movi	r15, 1

CHECK_KEY0:
	andi	r13, r11, 0b0001		# check KEY0
	beq		r13, zero, CHECK_KEY1

	ldw		r17, 0(r16)
	beq		r17, r14, END_PUSHBUTTON_ISR # max speed has been reached 

	ldw		r18, 0(r16) 
	addi	r18, r18, 1 
	stw		r18, 0(r16) # increment counter for speed refrence 

	addi	r21, r21, 4
	movi	r19, 8
	sthio	r19, 0(r21)  # stops interval timer

	addi	r21, r21, 4
	ldw		r20, 0(r21)
	mov		r19, r20     # gets lower half of timer val

	addi 	r21, r21, 4
	ldw		r20, 0(r21)
	slli	r20, r20, 16  # gets upper half of timer val 
	add		r19, r19,r20  # entire val of timer
	 	

	movi	r22, 0x0065
	slli	r22, r22,8
	addi	r22, r22, 0xB9
	slli	r22, r22, 8
	addi	r22, r22, 0xAA # moves 6,666,666 int r22

	sub		r19, r19, r22 # decrements timer for faster speed
	
	subi 	r21, r21, 4 
	sthio	r19, 0(r21)	# stores lower half of timer val 

	addi	r21, r21, 4
	srli	r19, r19, 16
	sthio	r19, 0(r21)	# stores upper half of timer val 
	
	subi 	r21, r21, 8
	movi	r19, 7
	sthio	r19, 0(r21)	# renables interval timer 	
	
	br	END_PUSHBUTTON_ISR
	
CHECK_KEY1:
	andi	r13, r11, 0b0010		# check KEY0
	beq		r13, zero, CHECK_KEY1

	ldw		r17, 0(r16)
	beq		r17, r15, END_PUSHBUTTON_ISR

	ldw		r18, 0(r16)
	subi	r18, r18, 1
	stw		r18, 0(r16)

	addi	r21, r21, 4
	movi	r19, 8
	sthio	r19, 0(r21)

	addi	r21, r21, 4
	ldw		r20, 0(r21)
	mov		r19, r20

	addi 	r21, r21, 4
	ldw		r20, 0(r21)
	slli	r20, r20, 16
	add		r19, r19,r20
	 	
	movi	r22, 0x007A
	slli	r22, r22,8
	addi	r22, r22, 0x12
	slli	r22, r22, 8
	addi	r22, r22, 0x00

	add		r19, r19, r22
	
	subi 	r21, r21, 4 
	sthio	r19, 0(r21)

	addi	r21, r21, 4
	srli	r19, r19, 16
	sthio	r19, 0(r21)	
	
	subi 	r21, r21, 8
	movi	r19, 7
	sthio	r19, 0(r21)		
	
	br	END_PUSHBUTTON_ISR
	
END_PUSHBUTTON_ISR:
	ldw		ra,  0(sp)				# Restore all used register to previous
	ldw		r10, 4(sp)
	ldw		r11, 8(sp)
	ldw		r12, 12(sp)
	ldw		r13, 16(sp)
	ldw		r14, 20(sp)
	ldw		r15, 24(sp)
	ldw		r16, 28(sp)
	ldw		r17, 32(sp)
	ldw		r18, 36(sp)
	ldw		r19, 40(sp)
	ldw		r20, 44(sp)
	ldw		r21, 48(sp)
	ldw		r22, 52(sp)
	addi	sp,  sp, 56

	ret
	.end	

