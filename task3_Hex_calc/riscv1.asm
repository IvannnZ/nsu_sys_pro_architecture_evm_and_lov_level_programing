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

.macro to_16 %in %out
	slti t0 %in 10
	beq zero t0 more9
	addi %out, %in , 48
	beq zero zero end_macro
more9:
	addi %out, %in, 55 
end_macro:
.end_macro

.macro summ %reg1 %reg2 %answ
	add %answ, %reg1, %reg2
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

scan_16_num:
	mv t0 zero
	start_scan:
		li t1 ' ' # тут пробел
		read # не стал закидывать в стек, так как ничего не поменяет
		beq t1, a0, end_scan
		slli t0, t0, 4
		slti t1, a0, ':'
		beq zero t1 more_9
		addi a0, a0, -48
		add t0, t0, a0
		j start_scan
	more_9:
		addi a0, a0, -55
		add t0, t0, a0
		j start_scan
	end_scan:
		mv a0 t0
		ret
	
parse_from_16:


.globl main
main:
	call scan_16_num
	mv s1 a0
	call scan_16_num
	mv s2 a0
	read
	
	li t4 '+'
	beq a0, t4, sum
	li t4 '-'
	beq a0, t4, minus
	li t4 '&'
	beq a0, t4, annd
	li t4 '|'
	beq a0, t4, orr
		
	
sum:
	summ s1 s2 t3
	j end
	
minus:
	minus s1 s2 t3
	j end
annd:
	annd s1 s2 t3
	j end
orr:
	orr s1 s2 t3
	j end
end:		
	to_16 t3 a0
	print
	exit	
	
	
	
