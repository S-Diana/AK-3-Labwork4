.global lab4
.syntax unified

// =================================== VAR DECLARING

#define X1 #-17
#define X2 #12
#define X3 #17
#define X4 #3
#define F #0xFFFFFFFF

// =================================== Lab4 consists of 2 parts

lab4:
	push {lr}
	bl part1
	bl part2
	pop {pc}

// =================================== PART 1

part1:
	push {lr}
	mov r0, X1
	mov r1, F
	mov r2, X2
	mov r3, #0
	mov r4, X3
	mov r5, #0
	mov r6, X4
	mov r7, #0
	
	// (x1 + x2 + x3) 
	adds r0, r2
	adc r1, r3
	adds r0, r4
	adc r1, r5

	// 2 * (x1 + x2 + x3)
	lsl r1, #1
	lsl r0, #1
	bvc shift_l
	add r1, #1
 	shift_l:

	// (x4 + 1)
	adds r6, #1
	adc r7, #0
	
	// (x4 + 1) / 4
	lsr r6, #1
	lsr r7, #1
	bvc shift_r1
	add r7, 0x80000000
	shift_r1:
	lsr r6, #1
	lsr r7, #1
	bvc shift_r2
	add r7, 0x80000000
	shift_r2:
	
	// 2 * (x1 + x2 + x3) - (x4 + 1)/4
	subs r0, r6
	sbc r1, r7
	lsl r5, #1
		
	bl res_corr
	pop {pc}

// =================================== RESULT CORRECTION

res_corr:
	push {lr}
	bvc s2
	lsr r0, #1
	lsr r1, #1
s2:
	cmp r1, #0
	bne s4
	orr r1, #0
	bne s4
	mov r0, #0b10000100
s4:
	add r1, #0b10000100
	add r5, r1, #0xc0000000
	beq s7
	eor r5, #0xc0000000
	beq s7
	lsr r0, #1
	lsr r1, #1
s7:
	bvs res_corr_end
	push {r0}
	push {r1}	
	pop {r1}
	pop {r0}

res_corr_end:
	pop {pc}
	
// =================================== PART 2

part2:
  push {lr}
  
  mov r1, 50
  mov r2, -10

first_block:
  //1. r0 = r1 + r2
  add r0, r1, r2
  bl second_block
  //2. r0 = r0 - 1
  sub r0, #1
  
  block_3:
  //3. r0 = r1 / r2
  udiv r0, r1, r2
  
  //4. N = 1
  bmi neg_6

  //5.  r0 = r1 + r2
  add r0, r1, r2  
  
  //7.  r1 = r1 + 5
  add r1, r1, #5
  
  bl cond_8

 
  neg_6:
 
  sub r0, r1, r2
 
  cond_8:  
  
  //8.  V = 1
  bvc block_3

  //9.  r0 = r1 & r2
  and r0, r1, r2
  
  pop {pc}
  
second_block:
  push {lr}
  
  block_10:
  //10. r1 = r1 ^ r2
  eor r1, r2
  
  bl third_block

  //11. Z = 0
  beq eq_cond

  //12. r0 = r1 + r2
  add r0, r1, r2
  
  eq_cond:
  //13. N = 1
  
  bpl block_10

  //14. r0 = r1 - 5
  sub r0, r1, #5
  
  //15. r0 = r1 + 78
  add r0, r1, #78
  
  pop {pc}
  
third_block:
  push {lr}
  
  //17. r0 = r1 * r2
  mul r0, r1, r2
  
  //18. r0 = r1 + 1
  add r0, r1, #1
  
  pop {pc}
