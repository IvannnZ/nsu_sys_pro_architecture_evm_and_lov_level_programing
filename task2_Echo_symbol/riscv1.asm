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
	print
	addi a0 a0 1
	print
	exit