.data
NUM:.word 0:8
size:.word 9
SUM:.word 0

.text
la $t0,NUM #loading from memory
la $t1,size
lw $t1,0($t1)
li $t2,1

#Loop for storing in array
loop: sw $t2,0($t0) #storing the value at base address
beq $t2,$t1,e1 #checking if(i==9) el;
addi $t2,$t2,1#updating index
addi $t0,$t0,4#updating base address 
j loop

e1:
la $t0,NUM #reading in address from memory once again
lw $t3,SUM
li $t7,1

Loop:lw $t5,0($t0)#Reading in the value from address
add $t3,$t3,$t5#adding that value to sum 
beq $t7,$t1,exit#if(i==9)exit;
addi $t7,$t7,1#updating index
addi $t0,$t0,4#updating address
j Loop

exit:sw $t3,SUM#storing sum in memory
