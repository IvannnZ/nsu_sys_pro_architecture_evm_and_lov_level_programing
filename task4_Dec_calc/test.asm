j main
.macro syscall %n
	li a7, %n
	ecall
.end_macro

.macro read
	syscall 12
.end_macro

.macro print
	syscall 11
.end_macro

.macro exit
	syscall 93
.end_macro


.macro push %r
	addi sp, sp, -4
	sw %r, 0(sp)
.end_macro

.macro pop %r
	lw %r, 0(sp)
	addi sp, sp, 4
.end_macro

.macro push2 %r1, %r2
	addi sp, sp, -8
	sw %r1, 0(sp)
	sw %r2, 4(sp)
.end_macro

.macro pop2 %r1, %r2
	lw %r1, 0(sp)
	lw %r2, 4(sp)
	addi sp, sp, 8
.end_macro

.macro push_3 %r1, %r2, %r3
	addi sp, sp, -12
	sw %r1, 0(sp)
	sw %r2, 4(sp)
	sw %r3, 8(sp)
.end_macro

.macro pop_3 %r1, %r2, %r3
	lw %r1, 0(sp)
	lw %r2, 4(sp)
	lw %r3, 8(sp)
	addi sp, sp, 12
.end_macro




division_10:#a2 вход, a0, целая часть, a1, остаток

	srli a1, a2, 1
	srli a0, a1, 1
	add a0, a0, a1 #q = (n >> 1) + (n >> 2)
	
	srli a1, a0, 4
	add a0, a0, a1 #q = q + (q >> 4)
	
	srli a1, a0, 8
	add a0, a0, a1 #q = q + (q >> 8)
	
	srli a1, a0, 16
	add a0, a0, a1 #q = q + (q >> 16)
	
	
	srli a0, a0, 3
	
	slli a1, a0, 2
	add  a1, a1, a0
	slli a1, a1, 1
	sub a1, a2, a1 #r = n - (((q << 2) + q) << 1)
	
	slti a2, a1, 9
	xori a2, a2, 1
	add a0, a0, a2#q = q + (r > 9)
		
ret
	
	
	
some_old_ptr:
	srli a0, a0, 1
	srli a1, a0, 2
	add a0, a0, a1
	  
	  srli a1, a0, 4
	add a0, a0, a1
	
	srli a1, a0, 8
	add a0, a0, a1
	
	srli a1, a0, 16
	add a0, a0, a1
	
	srli a0, a0, 3
	
	srli a1, a0, 2
	add a1, a1, a0
	slli a1, a1, 1
	
	sub a1, a2, a1
	
	slti a2, a1, 10 # вот тут может быть ошибка
	
	add a0, a0, a2

ret

pow_10: # a0 -- вывод,  a1 -- ввод 
	slli a1, a1, 1
	mv a0, a1 
	slli a1, a1, 2
	add a0, a1, a0
	
	ret


main:
	
	read
	mv a1, a0
	li a0, ' '
	print
	print
	call pow_10
	mv a2, a0
	call division_10
	print
exit
