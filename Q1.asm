.data
Xprompt: .asciiz "Enter the Value of X: "
Yprompt: .asciiz "Enter the Value of Y: "
Fprint:.asciiz "F="
newline: .byte '\n'

.text
.globl main

main:

#Prompt for X 
la $a0,Xprompt
li $v0,4
syscall

#Storing X in $t0
 li $v0, 5
 syscall
 add $t0,$v0,0
 
 #Moving to new line
 la $a0, newline
 li $v0, 4
 syscall
    
#Prompt for Y 
la $a0,Yprompt
li $v0,4
syscall

#Storing Y in $t1
li $v0, 5
syscall
add $t1,$v0,0

#F=X+Y
add $t2,$t1,$t0

#Moving to new line
 la $a0, newline
 li $v0, 4
 syscall
 
#Printing out F
 la $a0, Fprint
 li $v0, 4
 syscall
 
 add $a0,$t2,0
 li $v0, 1
 syscall
 
 # Exit program
    li $v0, 10
    syscall

