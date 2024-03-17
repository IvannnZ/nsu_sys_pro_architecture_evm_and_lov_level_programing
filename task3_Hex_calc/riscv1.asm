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

print_16_num: # ввод в a1, вывода нет, пишет в консоль сразу
	mv t0 zero
	mv t3 zero
	#addi t3, t3, 1
	start_remake:
		beq a1, zero, start_print
		addi t3, t3, 1
		slli t0, t0, 8
		andi t1, a1, 0xf
		slti t2, t1, 10
		beq t2, zero, more__9
			addi t1, t1, 48
			add t0, t0, t1
			srli a1, a1, 4
			j start_remake 
		more__9:
			addi t0, t1, 55
			add t0, t0, t1
			srli a1, a1, 4
			j start_remake
	start_print:
		beq t3, zero, end_print
		addi t3, t3, -1
		andi a0, t0, 0xff
		print
		srli t0, t0, 8
		j start_print
	end_print:
		ret
		
		

scan_16_num: #нет входа извне, вывод в a0
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
	add t3, s1, s2
	j end
	
minus:
	sub t3, s1, s2
	j end
annd:
	and t3, s1, s2
	j end
orr:
	or t3, s1, s2 
	j end
end:		
	mv a1, t3
	call print_16_num
	exit	
	
	
	
