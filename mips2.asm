.data 
inPrompt1:.asciiz "How many numbers you are gonna enter:"
inPrompt2:.asciiz"Enter the numbers one by one:"
outPrompt:.asciiz"Numbers in ascending order:"
newline: .byte '\n'
array:.word 1:50


.text
.globl main
main:

#Prompt user for how many numbers
la $a0,inPrompt1
li $v0,4
syscall

#Storing array size in $s3
 li $v0, 5
 syscall
 addi $s3,$v0,0
 
 #Moving to new line
 la $a0, newline
 li $v0, 4
 syscall
 
#Prompt user to enter numbers
la $a0,inPrompt2
li $v0,4
syscall

#Read each number and store in array

la $s2,array #s1 has base address of array
li $t0,0 #index of array

in: 
 li $v0, 5
 syscall
 sw $v0,0($s2)
 addi $s2,$s2,4
 addi $t0,$t0,1
 bne $t0,$s3,in
 
 #Call the sort procedure
la $s2,array

jal sort
 
#Output the sorted numbers
la $a0,outPrompt
li $v0,4
syscall

#Loop to output
out:     
    lw $a0, 0($s2)
    li  $v0, 1   
    syscall
    #Moving to new line
    la $a0, newline
    li $v0, 4
    syscall
    addi $s2,$s2,4
    subi $s3,$s3,1
    bne $s3,0,out

# Exit program
    li $v0, 10
    syscall
    
#Sort Procedure
sort:    subi $sp,$sp, 20      # make room on stack for 5 registers
         sw $ra, 16($sp)        # save $ra on stack
         sw $s3,12($sp)         # save $s3 on stack
         sw $s2, 8($sp)         # save $s2 on stack
         sw $s1, 4($sp)         # save $s1 on stack
         sw $s0, 0($sp)         # save $s0 on stack
         
         move $s2, $a0           # save $a0 into $s2
         move $s3, $a1           # save $a1 into $s3
         move $s0, $zero         # i = 0
for1tst: slt  $t0, $s0, $s3      # $t0 = 0 if $s0 ? $s3 (i ? n)
         beq  $t0, $zero, exit1  # go to exit1 if $s0 ? $s3 (i ? n)
         subi $s1, $s0, 1       # j = i � 1
for2tst: slti $t0, $s1, 0        # $t0 = 1 if $s1 < 0 (j < 0)
         bne  $t0, $zero, exit2  # go to exit2 if $s1 < 0 (j < 0)
         sll  $t1, $s1, 2        # $t1 = j * 4
         add  $t2, $s2, $t1      # $t2 = v + (j * 4)
         lw   $t3, 0($t2)        # $t3 = v[j]
         lw   $t4, 4($t2)        # $t4 = v[j + 1]
         slt  $t0, $t4, $t3      # $t0 = 0 if $t4 ? $t3
         beq  $t0, $zero, exit2  # go to exit2 if $t4 ? $t3
         move $a0, $s2           # 1st param of swap is v (old $a0)
         move $a1, $s1           # 2nd param of swap is j
         jal  swap               # call swap procedure
         subi $s1, $s1, 1       # j �= 1
         j    for2tst            # jump to test of inner loop
exit2:   addi $s0, $s0, 1        # i += 1
         j    for1tst            # jump to test of outer loop

        
        
exit1: lw $s0, 0($sp)  # restore $s0 from stack
         lw $s1, 4($sp)         # restore $s1 from stack
         lw $s2, 8($sp)         # restore $s2 from stack
         lw $s3,12($sp)         # restore $s3 from stack
         lw $ra,16($sp)         # restore $ra from stack
         addi $sp,$sp, 20       # restore stack pointer
         jr $ra                 # return to calling routine

         
swap: sll $t1, $a1, 2   # $t1 = k * 4
      add $t1, $a0, $t1 # $t1 = v+(k*4)
                        #   (address of v[k])
      lw $t0, 0($t1)    # $t0 (temp) = v[k]
      lw $t2, 4($t1)    # $t2 = v[k+1]
      sw $t2, 0($t1)    # v[k] = $t2 (v[k+1])
      sw $t0, 4($t1)    # v[k+1] = $t0 (temp)
      jr $ra            # return to calling routine



