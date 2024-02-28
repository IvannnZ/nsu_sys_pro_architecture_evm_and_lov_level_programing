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

.macro from_16 %in %out
	slti t0 %in ':'
	beq zero t0 more_9
	addi %out, %in , -48
	beq zero zero end_macro
more_9:
	addi %out, %in, -55 
end_macro:	
.end_macro

.macro to_16 %in %out
	slti t0 %in 10
	beq zero t0 more_9
	addi %out, %in , 48
	beq zero zero end_macro
more_9:
	addi %out, %in, 55 
end_macro:
.end_macro

.macro summ %reg1 %reg2 %answ
	add %answ, %reg1, %reg2
	andi %answ, %answ, 0xF
.end_macro

.macro minus %reg1 %reg2 %answ
	sub %answ, %reg1, %reg2
	#andi %answ, %answ, 0xF #вроде при вычитании не нужно обрезать значение
.end_macro

.macro annd %reg1 %reg2 %answ
	and %answ, %reg1, %reg2
.end_macro

.macro orr %reg1 %reg2 %answ
	or %answ, %reg1, %reg2
.end_macro


main:
	read
	from_16 a0 t1
	read
	from_16 a0 t2
	read
	add t3, a0 zero
	li t4 '+'
	beq t3, t4, sum
	li t4 '-'
	beq t3, t4, minus
	li t4 '&'
	beq t3, t4, annd
	li t4 '|'
	beq t3, t4, orr
		
	
sum:
	summ t1 t2 t3
	beq zero zero end
	
minus:
	minus t1 t2 t3
	beq zero zero end
annd:
	annd t1 t2 t3
	beq zero zero end
orr:
	orr t1 t2 t3
	beq zero zero end
end:		
	to_16 t3 a0
	print
	exit	
	
	
	