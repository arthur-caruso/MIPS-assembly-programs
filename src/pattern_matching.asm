# The following MIPS assembly code mimics the behavior of
# this C language high-level code below:

################################################################################
# include <stdio.h>
# include <stdlib.h>
#
# int vetorDados[50];
# int vetorPadrao[5];
# char* dadosPrompt		= "\n[vetorDados]";
# char* padraoPrompt	= "\n[vetorPadrao]";
# char* vetorPrompt		= "\n-> Informe o tamanho do vetor: ";
# char* numeroPrompt	= "\t-> Informe um número a ser inserido: ";
# char* contabOut		= "\n[contabilizaPadrao] = ";
#
# void main() {
# 	printf("%s", dadosPrompt);
# 	tamVetorDados = carregaVetor(vetorDados);
#
# 	printf("%s", padraoPrompt);
# 	tamVetorPadrao = carregaVetor(vetorPadrao);
#
# 	contabilizaPadrao = 0;
# 	posicaoDados = 0;
#
# 	while (posicaoDados + tamVetorPadrao <= tamVetorDados) {
# 		contabilizaPadrao += encontraPadrao(vetorDados, posicaoDados, vetorPadrao, 0, tamVetorPadrao);
# 		posicaoDados += 1;
# 	};
#
# 	printf("%s", contabOut);
# 	printf("%d", contabilizaPadrao);
# }
#
# int carregaVetor(int *_enderecoVetor) {
# 	printf("%s", vetorPrompt);
# 	scanf("%d", &tamanhoVetor);
#
# 	posicao = 0;
# 	while (posicao < tamanhoVetor) {
# 		printf("%s", numeroPrompt);
# 		scanf("%d", &valor);
#
# 		_enderecoVetor[posicao] = valor;
# 		posicao += 1;
#	};
#
# 	return tamanhoVetor;
# }
#
# int encontraPadrao(int *_vetDados, int _posDados, int *_vetPadrao, int _posPadrao, int _tamPadrao) {
# 	if (_vetDados[_posDados] != _vetPadrao[_posPadrao])
#		return 0;
#
# 	else if (_posPadrao == _tamPadrao - 1;)
#		return 1;
#
# 	else
#		return encontraPadrao(_vetDados, _posDados++, _vetPadrao, _posPadrao++, _tamPadrao);
# }
################################################################################

.data
# variáveis de encontraPadrao
# _vetDados		($s0)		.space 4
# _posDados		($s1)		.space 4 (stack)
# _vetPadrao	($s2)		.space 4
# _posPadrao	($s3)		.space 4 (stack)
# _tamPadrao	($s4)		.space 4

# variáveis de carregaVetor
# _enderecoVetor ($a1)	.space 4
tamanhoVetor:			.space 4
posicao:				.space 4
valor:					.space 4

# variáveis de main
tamVetorDados:		.space 4
tamVetorPadrao:		.space 4
contabilizaPadrao:	.space 4
posicaoDados:		.space 4

# variáveis globais
vetorDados:		.space 200
vetorPadrao:	.space 20

# literais de string
dadosPrompt:	.asciiz "\n[vetorDados]"
padraoPrompt:	.asciiz "\n[vetorPadrao]"
vetorPrompt:	.asciiz "\n-> Informe o tamanho do vetor: "
numeroPrompt:	.asciiz "\t-> Informe um número a ser inserido: "
contabOut:		.asciiz "\n[contabilizaPadrao] = "

.text
.globl main
main:
	la $a0, dadosPrompt
	li $v0, 4
	syscall

	la $a1, vetorDados
	jal carregaVetor
	sw $v1, tamVetorDados

	la $a0, padraoPrompt
	li $v0, 4
	syscall

	la $a1, vetorPadrao
	jal carregaVetor
	sw $v1, tamVetorPadrao

	li $t0, 0
	sw $t0, contabilizaPadrao

	li $t0, 0
	sw $t0, posicaoDados

whileLEQ: 	
	lw $t0, posicaoDados
	lw $t1, tamVetorPadrao
	add $t0, $t0, $t1
	lw $t1, tamVetorDados

	bgt $t0, $t1, exitWhileLEQ

	la $s0, vetorDados
	lw $s1, posicaoDados
	la $s2, vetorPadrao
	li $s3, 0
	lw $s4, tamVetorPadrao

	jal encontraPadrao

	lw $t0, contabilizaPadrao
	add $t0, $t0, $v1
	sw $t0, contabilizaPadrao

	lw $t0, posicaoDados
	addi $t0, $t0, 1
	sw $t0, posicaoDados

	j whileLEQ

exitWhileLEQ:
	la $a0, contabOut
	li $v0, 4
	syscall

	lw $a0, contabilizaPadrao
	li $v0, 1
	syscall

	j exitMain

carregaVetor:
	la $a0, vetorPrompt
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	sw $v0, tamanhoVetor

	li $t0, 0
	sw $t0, posicao

whileLT:
	lw $t0, posicao
	lw $t1, tamanhoVetor
	bge $t0, $t1, exitWhileLT

	la $a0, numeroPrompt
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	sw $v0, valor

	li $t4, 4
	lw $t0, posicao
	mul $t0, $t0, $t4
	add $t0, $t0, $a1

	lw $t1, valor
	sw $t1, 0($t0)


	lw $t0, posicao
	addi $t0, $t0, 1
	sw $t0, posicao

	j whileLT

exitWhileLT:
	lw $v1, tamanhoVetor
	jr $ra

encontraPadrao:
	addi $sp, $sp, -12
	sw $s3, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)

	li $t4, 4

	move $t0, $s1
	mul $t0, $t0, $t4
	add $t0, $t0, $s0
	lw $t0, 0($t0)

	move $t1, $s3
	mul $t1, $t1, $t4
	add $t1, $t1, $s2
	lw $t1, 0($t1)

	beq $t0, $t1, elseEQ
	li $v1, 0
	j exitEP

elseEQ:
	move $t0, $s4
	addi $t0, $t0, -1

	bne $s3, $t0, elseNEQ
	li $v1, 1
	j exitEP

elseNEQ:
	addi $s1, $s1, 1
	addi $s3, $s3, 1
	jal encontraPadrao

exitEP:
	lw $s3, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12

	jr $ra

exitMain:
	li $v0, 10
	syscall
