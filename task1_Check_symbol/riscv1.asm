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



main:
	read
	slti t1 a0 '0'
	bne zero, t1, end
	slti t1 a0 ':'
	beq zero, t1, end
	li a0, '1'
	print 

end:
	exit


