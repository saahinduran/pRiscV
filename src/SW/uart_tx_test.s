.global myFunction 
.text
.align 4

_start :
addi x3,x0,520
addi x4,x0,521
addi x5,x0,522 
addi x1,x0,49
addi x2,x0,1

addi x31,x0,2
sw x2,0(x3) 
sw x1,0(x4)
sw x0,0(x3)
CheckIsBusy:
lw x6,0(x5) 
bne x6,x2,CheckIsBusy
beq x6,x2,Transmit1Byte



Transmit1Byte:
addi x1,x1,1
sw x1,0(x4)
sw x2,0(x3)
sw x0,0(x3)
j CheckIsBusy

Loop:
beq x0,x0, Loop

