# The following MIPS assembly code mimics the behavior of
# this C language high-level code below:

################################################################################
#	void main() {
#		int base = 2, exp = 10;
#		int val = pow(base, exp);
#	}
#	int pow(int base, int exp) {
#		if (exp == 0) return 1;
#		else return base * pow(base, exp--);
#	}
################################################################################

.data
base:	.word 3
exp:	.word 4
val:	.space 4

.text
.globl main

main:
	lw $v1, base
	lw $a1, base
	lw $a2, exp

	jal pow
	sw $v1, val

	lw $a0, val
	li $v0, 1
	syscall

	li $v0, 10
	syscall

pow:
	addi $sp, $sp, -8
	sw $a2, 4($sp)
	sw $ra, 0($sp)

	addi $a2, $a2, -1
	beq $a2, $zero, exit

	jal pow
	mul $v1, $a1, $v1

exit:
	lw $a2, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8

	jr $ra
