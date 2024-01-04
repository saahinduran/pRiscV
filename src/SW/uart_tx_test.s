.global myFunction 
.global _start
.text
.align 2

.equ UART_CTRL_REG_ADDR,        0x100
.equ UART_STS_REG_ADDR,         0x104
.equ UART_TX_DATA_REG_ADDR,     0x108


_start :
nop
addi x5,x0,0xBB
sw   x5,0(x0)

addi x3,x0,UART_CTRL_REG_ADDR
addi x2,x0,1
sw x2,0(x3) 
addi x5,x0,UART_TX_DATA_REG_ADDR 
lw   x4,0(x0)
sw x4,0(x5)
beq x0,x0, .


/*    ROM TEST
addi x1,x0,0x200

lw   x4,0(x1)
lb   x5,0(x1)
lh   x6,0(x1)
beq x0,x0, .
*/


LoadRegAddresses:
/*
lui x1,0xfffff
lui x2,0xfffff
add x1,x2,x2

addi x3,x0,UART_CTRL_REG_ADDR
addi x4,x0,UART_STS_REG_ADDR
addi x5,x0,UART_TX_DATA_REG_ADDR 
addi x6,x0,10
sll  x7,x0,x6
enableTx:
addi x2,x0,1
sw x2,0(x3) 

addi x31,x0, 0x27c
lb x31,0(x31)
jal x16,sendData
jal x16,CheckIsBusy

addi x31,x0, 0x27d
lb x31,0(x31)
jal x16,sendData
jal x16,CheckIsBusy

addi x31,x0, 0x27e
lb x31,0(x31)
jal x16,sendData
jal x16,CheckIsBusy

addi x31,x0, 0x27f
lb x31,0(x31)
jal x16,sendData
jal x16,CheckIsBusy

/*
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
*/








/*
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


