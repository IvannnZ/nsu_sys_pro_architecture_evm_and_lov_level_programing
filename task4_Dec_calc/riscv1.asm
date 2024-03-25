# посмотри вызов границы рекурсии
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

.macro exit %ecode
	li a0, %ecode
	syscall 93
.end_macro

.macro error %str
.data
str: .asciz %str
.text
	la a0, str
	syscall 4 # PrintString
	exit 1
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

.macro push3 %r1, %r2, %r3
	addi sp, sp, -12
	sw %r1, 0(sp)
	sw %r2, 4(sp)
	sw %r3, 8(sp)
.end_macro

.macro pop3 %r1, %r2, %r3
	lw %r1, 0(sp)
	lw %r2, 4(sp)
	lw %r3, 8(sp)
	addi sp, sp, 12
.end_macro

.macro push4 %r1, %r2, %r3, %r4
	addi sp, sp, -16
	sw %r1, 0(sp)
	sw %r2, 4(sp)
	sw %r3, 8(sp)
	sw %r4, 12(sp)
.end_macro

.macro pop4 %r1, %r2, %r3, %r4
	lw %r1, 0(sp)
	lw %r2, 4(sp)
	lw %r3, 8(sp)
	lw %r4, 12(sp)	
	addi sp, sp, 16
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
	
	slti  a2, a1, 10
	xori a2, a2, 1
	beq a2, zero, end_division_10
	add a0, a0, a2 #q = q + (r > 9)
	
	mv a1, zero	
	end_division_10:
ret

pow_10: # a0 -- вывод,  a1 -- ввод 
	slli a1, a1, 1
	mv a0, a1 
	slli a1, a1, 2
	add a0, a1, a0
	
	ret

len_in_bit:#a1 - вход, a0 - выход
	li a0, 1
	li t0, 1
rec_for_len_in_bit:
	ble a1, t0, end_len_in_bit
	sll t1, t0, a0
	add t0, t0, t1
	slli a0, a0, 1
	j rec_for_len_in_bit
end_len_in_bit:
ret

# t0  t1
# 12  34
# 56  78	
# t2  t3
# 


multyply_hiden:# эта функция скрытая, и не важная для пользователя, a0 -- выход,  а1-а2 -- входы (множители) a3 - длина
	li t0, 1
	beq a3, t0, extreem_case
	
	push4 ra, s0, s1, s2
	# ra, s0, s1, s2, a3
	srli a3, a3, 1
	push a3
	srl t0, a1, a3
	sll t1, t0, a3
	sub t1, a1, t1 
	
	srl t2, a2, a3
	sll t3, t2, a3
	sub t3, a2, t3 
	
	push4 t0, t1, t2, t3
	
	mv a1, t0 # Шаг 1: a * c
	mv a2, t2
	call multyply_hiden
	mv s0, a0
	
	pop4 t0, t1, t2, t3
	pop a3
	push a3
	push4 t0, t1, t2, t3
	
	mv a1, t1 # Шаг 2: b * d
	mv a2, t3
	call multyply_hiden
	mv s1, a0
	
	pop4 t0, t1, t2, t3
	pop a3
	push a3
	
	add a1, t0, t1 # Шаг 3: (a + b) * (c + d)
	add a2, t2, t3
	call multyply_hiden
	mv s2, a0
	
	sub s2, s2, s1
	sub s2, s2, s0
	
	pop a3
	
	sll s0, s0, a3
	sll s0, s0, a3
	
	sll s2, s2, a3
	
	add a0, s0, s1
	add a0, a0, s2
	
	pop4 ra, s0, s1, s2
	
ret
extreem_case:
	or a0, a1, a2
	li t0, 2
	bge a0, t0, call_rec_one_more
	and a0, a1, a2
	ret
	call_rec_one_more:
		addi a3, a3, 1
		push ra
		call multyply_hiden
		pop ra
		ret

multyply: # a0 -- выход,  а1-а2 -- входы
	push ra
	push2 a1, a2
	mv s2, a2
	
	call len_in_bit
	mv s3, a0
	mv a1, s2
	call len_in_bit
	ble a0, s3, rec_multyply
	mv s3, a0
rec_multyply:
	mv a3, s3
	pop2 a1, a2
	
	call multyply_hiden
	
	
	pop ra
ret

simple_multyply: # ввод a1, a2, вывод:a0
push ra




pop ra
ret


print_decimal: # ввод в a1, вывода нет, пишет в консоль сразу
	push ra
	mv t0 zero
	mv t3 zero
	start_remake:
		beq a1, zero, start_print
		addi t3, t3, 1
		slli t0, t0, 8
		
		push2 t0, t3
		mv a2, a1
		call division_10
		
		mv t1, a1
		mv a1, a0
		
		pop2 t0, t3
		
		addi t1, t1, 48
		add t0, t0, t1
		j start_remake 
	start_print:
		beq t3, zero, end_print
		addi t3, t3, -1
		andi a0, t0, 0xff
		print
		srli t0, t0, 8
		j start_print
	end_print:
		pop ra
		ret	
		

read_decimal: #нет входа извне, вывод в a0
	mv t0 zero
	push ra
	start_scan:
		read
		li t1, ' ' # тут пробел
		beq t1, a0, end_scan
		li t1, 0
		bge t1, a0, error_read_decimal
		li t1, 10
		bge t1, a0, error_read_decimal
		
		
		mv a1, t0
		push a0
		call pow_10
		mv t0, a0
		pop a0
		addi a0, a0, -48
		add t0, t0, a0
		j start_scan
	end_scan:
		mv a0 t0
		pop ra
		ret
		
	error_read_decimal:
		error "\n num should be betwen 0..9"

.globl main
main:
	call read_decimal
	mv s1 a0
	call read_decimal
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
	li t4 '*'
	beq a0, t4, multyplyy
	li t4 'l'
	beq a0, t4, lenn

	
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
lenn:
	mv a1, s1
	call len_in_bit
	mv t3, a0
	j end
multyplyy:
	mv a1, s1
	mv a2, s2
	call multyply
	mv t3, a0
	j end
end:		
	mv a1, t3
	li a0, ' '
	print
	call print_decimal
	li a0, '\n'
	print
	j main
	exit
