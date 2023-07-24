.data
symbolPrompt: .asciiz "Enter the symbol you would like to play with (X or O): "
rowPrompt: .asciiz "Enter the row you wish to play on (0 - 2): "
colPrompt: .asciiz "Enter the column you wish to play on (0 - 2): "
TTTArray: .word 0 : 9
playerSymbol: .byte ' '
computerSymbol: .byte ' '
emptySpace: .byte '-'
spacer: .asciiz " | "
newLine: .asciiz "\n"
boardLine: .asciiz "\n----------------"
errorMessage: .asciiz "That spot is not open! Try again.\n"
welcomeMessage: .asciiz "Welcome to Tic Tac Toe. The human player will pick their symbol, then be allowed to play first.\n"
gameTieMessage: .asciiz "The game has resulted in a tie! Here is the final board:\n"
playerWonStr: .asciiz "Player "
playerWonStr2: .asciiz " has won the game!"
thankYou: .asciiz "\nThank you for playing our Tic Tac Toe game."

.text
main:

	li $v0, 4  
	la $a0, welcomeMessage #give player welcome
	syscall 

	jal promptMessage #jal to prompt
	
	jal drawBoard #jal to draw, then human play, then computer play
	jal humanPlayer
	jal computerPlayer
	
	jal drawBoard #jal to draw, then human play, then computer play
	jal humanPlayer
	jal computerPlayer
	
	jal drawBoard #jal to draw, then human play, then computer play
	jal humanPlayer
	jal computerPlayer
	
	jal drawBoard #jal to draw, then human play, then computer play
	jal humanPlayer
	jal computerPlayer
	
	jal drawBoard #jal to draw, then human play, then computer play
	jal humanPlayer
	jal gameTie #by this point a move has been done 9 times. if still no winner, the game is tied.

##################################################
##################################################################################################
#################################################	
promptMessage:
	li $v0, 4
	la $a0, symbolPrompt #ask player for symbol
	syscall
	
	li $v0, 12
	syscall
	sb $v0, playerSymbol #store player symbol into label
	
	li $v0, 4
	la $a0, newLine #newline
	syscall
	
	lb $t1, playerSymbol
	li $t3, 'X'
	beq $t1, $t3, computerSymbolO #if playersymbol == 'X', goto computerSymbolO
	j computerSymbolX	#else, gotoComputerSymbolX
computerSymbolO:
	li $t1, 'O'
	sb $t1, computerSymbol #store computer symbol as 'O'
	jr $ra	
computerSymbolX:
	li $t1, 'X'
	sb $t1, computerSymbol #store computer symbol as 'X'
	jr $ra
#################################################
##################################################################################################
#################################################
drawBoard:
	addi $sp, $sp, -20 #make room on stack for 5 registers
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	la $s0, TTTArray
	li $s1, 0 # for array offset
	li $s3, 0 # for iterating 1-9
	li $v0, 4
	la $a0, newLine
	syscall
	
	j drawBoardLoop
drawBoardLoop: 
	lw $t0, 0($s0) # load values from each index
	
	li $v0, 4
	la $a0, spacer
	syscall
	# print the appropriate symbol
	beq $t0, 0, printEmptySpace 
	beq $t0, 1, printPlayerSymbol
	beq $t0, 2, printComputerSymbol
printEmptySpace:
	li $v0, 11
	lb $a0, emptySpace # print blank space + pipe
	syscall
	j next
printPlayerSymbol:
	li $v0, 11
	lb $a0, playerSymbol # print player symbol
	syscall
	j next
printComputerSymbol:
	li $v0, 11
	lb $a0, computerSymbol # print computer symbol
	syscall
	j next
next:
	addi $s3,$s3,1 #increment loop counter
	add $s1,$zero,4 # add integer offset
	add $s0, $s0, $s1 # update current index of grid
	bge $s3, 9, drawBoardComplete # after 1-9 are placed in the array, end loop
	beq $s3, 3, printNewLine # go to newline if working with the rightmost spaces
	beq $s3, 6, printNewLine  
	j drawBoardLoop # continue looping if still in 1-9
printNewLine:
	li $v0, 4
	la $a0, spacer
	syscall
	
	li $v0, 4
	la $a0, boardLine #print board line
	syscall
	
	li $v0, 4
	la $a0, newLine # print blank line
	syscall
	j drawBoardLoop
drawBoardComplete:
	li $v0, 4
	la $a0, spacer
	syscall
	
	li $v0, 4
	la $a0, newLine # print newline
	syscall
	syscall
	
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
 	
	jr $ra
#################################################
##################################################################################################
#################################################
humanPlayer:
	addi $sp, $sp, -20 #make room on stack for 5 registers
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	j humanMove
humanMove:
	la $s0, TTTArray #load our TTT array into $s0
	
	li $v0, 4
	la $a0, rowPrompt #prompt user for row
	syscall
	
	li $v0, 5
	syscall 
	move $t9, $v0
	
	li $v0, 4
	la $a0, colPrompt #prompt user for col
	syscall
	
	li $v0, 5
	syscall
	move $t8, $v0
	
	mul $t7, $t9, 3 #(row*rowSize)
	add $t7, $t7, $t8 #(row*rowSize + col). t7 is the index of where to play
	#addi $t7, $t7, 1 #incrememnt to account for indexes 1-9
	j playerCheckIfOpen
correctHumanMove:
	li $t1, 1
	sw $t1, ($s0) #store player numerical identity into that address location
	jal checkWins
	
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
 	jr $ra # return to calling routine
playerCheckIfOpen:
	sll $t7, $t7, 2 #make index proper to address
	add $s0, $s0, $t7 #s0 = TTTArray[index]
	lw $t3, ($s0) #load the value into t3
	bne $t3, $zero, playerErrorMessage #if t3 == 0, we have an empty space and can put move. if not, show error message.
	j correctHumanMove
playerErrorMessage: 
	li $v0, 4
	la $a0, errorMessage
	syscall
	j humanMove
#################################################
##################################################################################################
#################################################
computerPlayer:
	addi $sp, $sp, -20 # make room on stack for 5 registers
	sw $ra, 16($sp) # back up registers to stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	j computerMove
computerMove:
	la $s0, TTTArray
	
	li $a1, 8
	li $v0, 42
	syscall
	move $t7, $a0
	j computerCheckIfOpen
correctComputerMove:
	li $t1, 2
	sw $t1, ($s0) #store player numerical identity into that address location
	jal checkWins
	
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
 	jr $ra # return to calling routine
computerCheckIfOpen:
	sll $t7, $t7, 2 #make index proper to address
	add $s0, $s0, $t7 #s0 = TTTArray[index]
	lw $t3, ($s0) #load the value into t3
	bne $t3, $zero, computerMove#if t3 == 0, we have an empty space and can put move. if not, retry computer move.
	j correctComputerMove
#################################################
##################################################################################################
#################################################
checkWins:
	addi $sp, $sp, -20 # make room on stack for 5 registers
	sw $ra, 16($sp) # back up registers to stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	jal winRows
	jal winCols
	jal winDiag
	
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
	jr $ra
winRows:
	addi $sp, $sp, -20 # make room on stack for 5 registers
	sw $ra, 16($sp) # back up registers to stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	la $s0, TTTArray # load array address
	j rOneCh
rOneCh:	
	lw $t0, 0($s0)
	beq $t0, $zero, rTwoCh
	lw $t1, 4($s0)
	beq $t1, $zero, rTwoCh
	lw $t2, 8($s0)
	beq $t2, $zero, rTwoCh
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, rWin # move to win, $t2 will have the number of which won
	j rTwoCh	
rTwoCh:	
	lw $t0, 12($s0)
	beq $t0, $zero, rThrCh
	lw $t1, 16($s0)
	beq $t1, $zero, rThrCh
	lw $t2, 20($s0)
	beq $t2, $zero, rThrCh
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, rWin # move to win, $t2 will have the number of which won
	j rThrCh
rThrCh:	
	lw $t0, 24($s0)
	beq $t0, $zero, rReturn
	lw $t1, 28($s0)
	beq $t1, $zero, rReturn
	lw $t2, 32($s0)
	beq $t2, $zero, rReturn
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, rWin # move to win, $t2 will have the number of which won
	j rReturn
rWin:	
	j finishGame
rReturn:
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
	jr $ra
winCols:
	addi $sp, $sp, -20 # make room on stack for 5 registers
	sw $ra, 16($sp) # back up registers to stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	la $s0, TTTArray # load array address
	j cOneCh
cOneCh:	
	lw $t0, 0($s0)
	beq $t0, $zero, cTwoCh
	lw $t1, 12($s0)
	beq $t1, $zero, cTwoCh
	lw $t2, 24($s0)
	beq $t2, $zero, cTwoCh
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, rWin # move to win, $t2 will have the number of which won
	j cTwoCh
	
cTwoCh:	
	lw $t0, 4($s0)
	beq $t0, $zero, cThrCh
	lw $t1, 16($s0)
	beq $t1, $zero, cThrCh
	lw $t2, 28($s0)
	beq $t2, $zero, cThrCh
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, rWin # move to win, $t2 will have the number of which won
	j cThrCh
	
cThrCh:	
	lw $t0, 8($s0)
	beq $t0, $zero, cReturn
	lw $t1, 20($s0)
	beq $t1, $zero, cReturn
	lw $t2, 32($s0)
	beq $t2, $zero, cReturn
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, cWin # move to win, $t2 will have the number of which won
	j cReturn

cWin:	# do something for win
	j finishGame
	
cReturn:	
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
	jr $ra
winDiag:
	addi $sp, $sp, -20 # make room on stack for 5 registers
	sw $ra, 16($sp) # back up registers to stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	la $s0, TTTArray # load array address
	j dOneCh
dOneCh:	
	lw $t0, 0($s0)
	beq $t0, $zero, dTwoCh
	lw $t1, 16($s0)
	beq $t1, $zero, dTwoCh
	lw $t2, 32($s0)
	beq $t2, $zero, dTwoCh
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, dWin # move to win, $t2 will have the number of which won
	j dTwoCh
	
dTwoCh:	lw $t0, 8($s0)
	beq $t0, $zero, dReturn
	lw $t1, 16($s0)
	beq $t1, $zero, dReturn
	lw $t2, 24($s0)
	beq $t2, $zero, dReturn
	seq $t0, $t0, $t1
	seq $t1, $t1, $t2
	and $t0, $t0, $t1
	bne $t0, $zero, dWin # move to win, $t2 will have the number of which won
	j dReturn
dWin:
	j finishGame
dReturn:	
	lw $s0, 0($sp) 
 	lw $s1, 4($sp)
 	lw $s2, 8($sp)
 	lw $s3, 12($sp)
 	lw $ra, 16($sp)
 	addi $sp, $sp, 20 # restore stack pointer
	jr $ra
#################################################
##################################################################################################
#################################################
gameTie:
	li $v0, 4
	la $a0, gameTieMessage
	syscall

	jal drawBoard
	
	li $v0, 4
	la $a0, thankYou
	syscall 
	
	li $v0, 10
	syscall
#################################################
##################################################################################################
#################################################
finishGame:
	jal drawBoard
	
	beq $t2, 1, playerWon
	beq $t2, 2, computerWon
playerWon:
	li $v0 4,
	la $a0, playerWonStr
	syscall
	
	li $v0, 11
	lb $a0, playerSymbol
	syscall
	
	li $v0, 4
	la $a0, playerWonStr2
	syscall
	
	li $v0, 4
	la $a0, thankYou
	syscall
	
	li $v0, 10
	syscall
computerWon:
	li $v0 4,
	la $a0, playerWonStr
	syscall
	
	li $v0, 11
	lb $a0, computerSymbol
	syscall

	li $v0, 4
	la $a0, playerWonStr2
	syscall
	
	li $v0, 4
	la $a0, thankYou
	syscall
	
	li $v0, 10
	syscall