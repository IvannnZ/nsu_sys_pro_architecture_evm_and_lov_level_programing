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


# а в чём отличие между b and j
main:
	li t0, '\n'
for:
	read
	beq a0, t0, end_for
	print
	addi a0, a0, 1
	print
	j for
end_for:
	exit
