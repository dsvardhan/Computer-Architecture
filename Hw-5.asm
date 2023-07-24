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

#Moving to new line
    la $a0, newline
    li $v0, 4
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
sort:
#a0=address of table
#a1=sizeof table
move $a0,$s2
move $a1,$s3
subi $sp,$sp, 20      # make room on stack for 5 registers
         sw $ra, 16($sp)        
         sw $s3,12($sp)         
         sw $s2, 8($sp)         
         sw $s1, 4($sp)         
         sw $s0, 0($sp)         
        
        move $s0, $zero         # i = 0
outLoop: slt  $t0, $s0, $s3      # $t0 = 1 if $s0<$s3 (i<n)
         beq  $t0, $zero, outExit  # go to outExit if $s0>=$s3 (i>=n)
         subi $s1, $s0, 1       # j = i – 1
inLoop: slti $t0, $s1, 0        # $t0 = 1 if $s1 < 0 (j < 0)
         bne  $t0, $zero, inExit  # go to inExit if $s1>=0 (j>=0)
         sll  $t1, $s1, 2        # $t1 = j * 4
         add  $t2, $s2, $t1      # $t2 = v + (j * 4)
         lw   $t3, 0($t2)        # $t3 = v[j]
         lw   $t4, 4($t2)        # $t4 = v[j + 1]
         slt  $t0, $t4, $t3      # $t0 =1 if $t4<$t3
         beq  $t0, $zero, inExit  # go to exit2 if $t4 ? $t3
         move $a0, $s2           # 1st param of swap is v (old $a0)
         move $a1, $s1           # 2nd param of swap is j
         jal  swap               # call swap procedure
         subi $s1, $s1, 1       # j –= 1
         j    inLoop            # jump to test of inner loop
inExit:   addi $s0, $s0, 1        # i += 1
         j    outLoop           # jump to test of outer loop

        
outExit: lw $s0, 0($sp)  # restore  from stack
         lw $s1, 4($sp)        
         lw $s2, 8($sp)         
         lw $s3,12($sp)         
         lw $ra,16($sp)         
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


