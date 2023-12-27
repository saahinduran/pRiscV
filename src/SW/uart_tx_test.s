.global myFunction 
.global _start
.text
.align 2

.equ UART_CTRL_REG_ADDR,        0x100
.equ UART_STS_REG_ADDR,         0x104
.equ UART_TX_DATA_REG_ADDR,     0x108


_start :
/*
addi x1,x0,0x03
addi x2,x0,0x05
addi x3,x0,0x410
lui x5,0xABCDE
addi x5,x5,0xFF
sb x2,0(x1)
sh x3,0(x0)
sb x1,2(x0)
lw x4,0(x0)
sw x5,2(x2)
lb x1, 2(x2) # 
lh x2, 4(x2) # 
addi x2, x0 ,0x05
lbu x1,2(x2)
lb x1,2(x2)
lh x1,2(x2)
lhu x1,2(x2)
*/
addi x1,x0,0x204
addi x2,x0,0x205
addi x3,x0,0x208
lw   x4,0(x1)
lw   x5,0(x2)
lw   x6,0(x3)



/*
LoadRegAddresses:
addi x3,x0,UART_CTRL_REG_ADDR
addi x4,x0,UART_STS_REG_ADDR
addi x5,x0,UART_TX_DATA_REG_ADDR 

enableTx:
addi x2,x0,1
sw x2,0(x3) 

loadData:
addi x31,x0,72 # Load 'H'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,101 # Load 'e'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,108 # Load 'l'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,108 # Load 'l'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,111 # Load 'o'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,32 # Load 'space'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,119 # Load 'w'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,111 # Load 'o'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,114 # Load 'r'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,108 # Load 'l'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,100 # Load 'd'
jal x16,sendData
jal x16,CheckIsBusy
addi x31,x0,33 # Load '!'
jal x16,sendData
jal x16,CheckIsBusy










CheckIsBusy:
lw x1,0(x4)
and x1,x1,2
bne x1,x0,CheckIsBusy
jalr x0, x16, 0      # return

Loop:
beq x0,x0, Loop

sendData:
sw x31,0(x5)
jalr x0, x16, 0    # return

*/

#_start :
#LoadRegAddresses:
#addi x3,x0,UART_CTRL_REG_ADDR
#addi x4,x0,UART_STS_REG_ADDR
#addi x5,x0,UART_TX_DATA_REG_ADDR 
#
#enableTx:
#addi x2,x0,1
#sw x2,0(x3) 
#
#loadData:
#addi x31,x0,83 # Load 'S'
#sw x31,0(x5)
#
#CheckIsBusy:
#lw x1,0(x4)
#and x1,x1,2
#bne x1,x0,CheckIsBusy
#
#Loop:
#beq x0,x0, Loop


