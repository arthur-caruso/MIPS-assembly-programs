# Autor: Arthur Francisco Caruso

# o código assembly mips32 a seguir imita o comportamento
# do código em alto nível da linguagem c a seguir:
#	void main() {
#		int value = 2, pow = 10;
#		value = potencia(value, pow);
#	}
#	int potencia(int value, int pow) {
#		if (pow == 0) return 1;
#		else return value * potencia(value, pow--);
#	}

.data
value: .word 3
pow: .word 4

.text
main:
	# guardar value em a1 (primeiro argumento)
	la $a1, value
	lw $a1, 0($a1)

	# guardar pow em a2 (segundo argumento)
	la $a2, pow
	lw $a2, 0($a2)

	# guardar value em t0 (estado temporário)
	la $t0, value
	lw $t0, 0($t0)

	# pular para subrotina potencia(value, pow)
	jal potencia

	# salvar resultado ($t0 -> value)
	la $t1, value
	sw $t0, 0($t1)

	# imprimir resultado (apenas para testes)
	move $a0, $t0
	li $v0, 1
	syscall

	# sair do programa
	li $v0, 10
	syscall

potencia:
	# ajustar stack pointer
	addi $sp, $sp, -8

	# salvar conteúdo do registrador ($a2)
	sw $a2, 4($sp)

	# salvar o endereço de retorno ($ra)
	sw $ra, 0($sp)

	# decrementar pow (pow--)
	addi $a2, $a2, -1

	# sair quando pow for zero ($a2 == 0 ? exit : potencia)
	beq $a2, $zero, exit

	# chamada recursiva
	jal potencia

	# $t0 <- value * potencia(value, pow - 1)
	mul $t0, $a1, $t0

exit:
	# restaurar registradores da pilha
	lw $a2, 4($sp)
	lw $ra, 0($sp)

	# reajustar stack pointer
	addi $sp, $sp, 8

	# retornar para endereço de retorno ($ra)
	jr $ra
