.data
# variáveis de encontraPadrao
# _vetDados ($s0)	.space 4
# _posDados ($s1)	.space 4 (stack)
# _vetPadrao ($s2)	.space 4
# _posPadrao ($s3)	.space 4 (stack)
# _tamPadrao ($s4)	.space 4

# variáveis de carregaVetor
# _enderecoVetor ($a1)	.space 4
tamanhoVetor:		.space 4
posicao:		.space 4
valor:			.space 4

# variáveis de main
tamVetorDados:		.space 4
tamVetorPadrao:		.space 4
contabilizaPadrao:	.space 4
posicaoDados:		.space 4

# variáveis globais
vetorDados:		.space 200
vetorPadrao:		.space 20

# literais de string
dadosPrompt:		.asciiz "\n[vetorDados]"
padraoPrompt:		.asciiz "\n[vetorPadrao]"
vetorPrompt:		.asciiz "\n -> Informe o tamanho do vetor: "
numeroPrompt:		.asciiz "\t-> Informe um número a ser inserido: "
contabOut:		.asciiz "\n[contabilizaPadrao] = "

.text
# void main() {
main:		# printf("%s", dadosPrompt);
		la $a0, dadosPrompt
		li $v0, 4
		syscall

		# tamVetorDados = carregaVetor(vetorDados);
		la $a1, vetorDados
		jal carregaVetor
		sw $v1, tamVetorDados

		# printf("%s", padraoPrompt);
		la $a0, padraoPrompt
		li $v0, 4
		syscall

		# tamVetorPadrao = carregaVetor(vetorPadrao);
		la $a1, vetorPadrao
		jal carregaVetor
		sw $v1, tamVetorPadrao

		# contabilizaPadrao = 0;
		li $t0, 0
		sw $t0, contabilizaPadrao

		# posicaoDados = 0;
		li $t0, 0
		sw $t0, posicaoDados

whileLEQ: 	# tmp = posicaoDados + tamVetorPadrao;
		lw $t0, posicaoDados
		lw $t1, tamVetorPadrao
		add $t0, $t0, $t1
		lw $t1, tamVetorDados

		# while (tmp <= tamVetorDados) {
		bgt $t0, $t1, exitWhileLEQ

		# tmp = encontraPadrao(vetorDados, posicaoDados, vetorPadrao, 0, tamVetorPadrao);
		la $s0, vetorDados
		lw $s1, posicaoDados
		la $s2, vetorPadrao
		li $s3, 0
		lw $s4, tamVetorPadrao
		jal encontraPadrao

		# contabilizaPadrao += tmp;
		lw $t0, contabilizaPadrao
		add $t0, $t0, $v1
		sw $t0, contabilizaPadrao

		# posicaoDados += 1;
		lw $t0, posicaoDados
		addi $t0, $t0, 1
		sw $t0, posicaoDados

		j whileLEQ # };

exitWhileLEQ:	# printf("%s", contabOut);
		la $a0, contabOut
		li $v0, 4
		syscall

		# printf("%d", contabilizaPadrao);
		lw $a0, contabilizaPadrao
		li $v0, 1
		syscall

		j exitMain # }

# int carregaVetor(int *_enderecoVetor) {
carregaVetor:	# printf("%s", vetorPrompt);
		la $a0, vetorPrompt
		li $v0, 4
		syscall

		# scanf("%d", &tamanhoVetor);
		li $v0, 5
		syscall
		sw $v0, tamanhoVetor

		# posicao = 0;
		li $t0, 0
		sw $t0, posicao

whileLT:	# while (posicao < tamanhoVetor) {
		lw $t0, posicao
		lw $t1, tamanhoVetor
		bge $t0, $t1, exitWhileLT

		# printf("%s", numeroPrompt);
		la $a0, numeroPrompt
		li $v0, 4
		syscall

		# scanf("%d", &valor);
		li $v0, 5
		syscall
		sw $v0, valor

		# tmp = _enderecoVetor[posicao];
		li $t4, 4
		lw $t0, posicao
		mul $t0, $t0, $t4
		add $t0, $t0, $a1

		# *tmp = valor;
		lw $t1, valor
		sw $t1, 0($t0)

		# posicao += 1;
		lw $t0, posicao
		addi $t0, $t0, 1
		sw $t0, posicao

		j whileLT # };

exitWhileLT:	# return tamanhoVetor;
		lw $v1, tamanhoVetor
		jr $ra # }

# int encontraPadrao(int *_vetDados, int _posDados, int *_vetPadrao, int _posPadrao, int _tamPadrao) {
encontraPadrao:	addi $sp, $sp, -12
		sw $s3, 8($sp)
		sw $s1, 4($sp)
		sw $ra, 0($sp)

		# tmp0 = _vetDados[_posDados];
		li $t4, 4
		move $t0, $s1
		mul $t0, $t0, $t4
		add $t0, $t0, $s0
		lw $t0, 0($t0)

		# tmp1 = _vetPadrao[_posPadrao];
		move $t1, $s3
		mul $t1, $t1, $t4
		add $t1, $t1, $s2
		lw $t1, 0($t1)

		# if (*tmp0 != *tmp1) return 0;
		beq $t0, $t1, elseEQ
		li $v1, 0
		j exitEP

elseEQ:		# tmp = _tamPadrao - 1;
		move $t0, $s4
		addi $t0, $t0, -1

		# else if (_posPadrao == tmp;) return 1;
		bne $s3, $t0, elseNEQ
		li $v1, 1
		j exitEP

elseNEQ:	# _posDados += 1;
		addi $s1, $s1, 1

		# _posPadrao += 1;
		addi $s3, $s3, 1

		# else return encontraPadrao(_vetDados, _posDados, _vetPadrao, _posPadrao, _tamPadrao);
		jal encontraPadrao

exitEP:		lw $s3, 8($sp)
		lw $s1, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		jr $ra # }

exitMain:	# exit();
		li $v0, 10
		syscall