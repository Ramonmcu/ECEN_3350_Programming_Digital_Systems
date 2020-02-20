	.text
	.equ	LEDs,		0xFF200000
	.equ	SWITCHES,	0xFF200040
	.global _start
_start:
	movia	r2, LEDs		# Address of LEDs         
	movia	r3, SWITCHES	# Address of switches
	ldwio	r4, (r3)
	call 	ADDER

ADDER:
	srli	r5, r4, 5
	slli	r6, r4, 27
	srli	r7, r6, 27
	add		r8, r7, r5 

LOOP:
	stwio	r8, (r2)		# Display the state on LEDs
	ldwio	r4, (r3)		# Read the state of switches
	call 	ADDER
	br		LOOP

	.end
