.data
n1:.word 10
n2:.word 13
n3:.word 5
Result:.word 0

.text
#Have a dummy largest and then check for largest say 10 then compare with n1 if larger say n1 is large then n2 and 
#change if n2 is large and so on

lw $t1, n1  #loading data from labels to register
lw $t2, n2
lw $t3, n3

li $s0,0 #setting a dummy maximum

slt $t0,$s0,$t1 #comparing if(s0<t1) then t0=1 else t0=0 
bne $t0,1,L1 #if(t0==1)else execute L1
lw $s0,n1 #updating to new max

L1:slt $t0,$s0,$t2 #comparing new/old max with t2 and if(s0<t2) then t0=1 else t0=0 
bne $t0,1,L2 #checking if(t0==1)else execute L1
lw $s0,n2 #updating to new max

L2:slt $t0,$s0,$t3 #comparing new/old max with t3 and if(s0<t3) then t0=1 else t0=0
bne $t0,1,exit #checking if(t0==1)else execute exit
lw $s0,n3 #updating to new max

exit:sw $s0,Result #storing max searched in Result label
