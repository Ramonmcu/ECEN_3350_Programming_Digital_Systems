.text					
.global	sum_two	
sum_two:	

	add r2, r4, r5;	
	ret;

.global op_three
op_three:
	
	addi	sp, sp, -0x10;
	stw		ra, 12(sp);
	stw		fp, 8(sp);
	addi	fp, sp, 8;
	call 	op_two;
	stw 	r2, 4(fp);
	ldw 	r4, 4(fp);
	mov 	r5, r6;	
	call 	op_two;
	add 	sp, fp, r0;
	ldw		ra, 8(fp);
	ldw 	fp,	0(sp);
	addi 	sp, sp , 0x8;
	ret;

.global fibonnaci	
fibonnaci:
	
    movi	r8, 1;
	addi	sp, sp, -12;
    stw		ra,	8(sp);
    stw		fp, 4(sp);
    addi 	fp, sp, 4;
    
    beq		r4, r0, ZERO_CASE;
    
    subi 	r4, r4, 1;
    
    call fibonnaci;
	
    
    stw		r2, (sp); #	n-2
    add		r2,	r2, r8;	# n
    ldw	 	r8, (sp); # n-1
    
    br END; 
    
ZERO_CASE:
	
    stw		r8, (sp);
    movi 	r2, 0;
    
END:
	
	mov		sp, fp;
	ldw		ra, 4(sp);
	ldw		fp, 0(sp);
	addi	sp, sp, 8;
	ret;
	
