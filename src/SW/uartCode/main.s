
CMakeFiles/main.elf.dir/main.c.obj:     file format elf32-littleriscv


Disassembly of section .init:

00000000 <_start>:
#define UART_STS_REG_ADDR         0x104
#define UART_TX_DATA_REG_ADDR     0x108

void __attribute__((section(".init"),naked)) _start(void) {

    asm volatile("la sp, _end_stack");
   0:	00000117          	auipc	sp,0x0
   4:	00010113          	mv	sp,sp
}
   8:	00000013          	nop

Disassembly of section .text.main:

00000000 <main>:
int main()
{
   0:	fe010113          	addi	sp,sp,-32 # ffffffe0 <.LASF0+0xfffffe82>
   4:	00812e23          	sw	s0,28(sp)
   8:	02010413          	addi	s0,sp,32
  const char *msg = "Hello from pRiscV";
   c:	000007b7          	lui	a5,0x0
  10:	00078793          	mv	a5,a5
  14:	fef42623          	sw	a5,-20(s0)
  // Enable TX
	*(uint32_t *) UART_CTRL_REG_ADDR = 1;
  18:	10000793          	li	a5,256
  1c:	00100713          	li	a4,1
  20:	00e7a023          	sw	a4,0(a5) # 0 <main>

00000024 <.L4>:
	

  do
  {
    *(uint32_t *) UART_TX_DATA_REG_ADDR = *msg;
  24:	fec42783          	lw	a5,-20(s0)
  28:	0007c703          	lbu	a4,0(a5)
  2c:	10800793          	li	a5,264
  30:	00e7a023          	sw	a4,0(a5)
    while ( (*(uint32_t *)UART_STS_REG_ADDR & (0x1 << 1) )>> 1);
  34:	00000013          	nop

00000038 <.L3>:
  38:	10400793          	li	a5,260
  3c:	0007a783          	lw	a5,0(a5)
  40:	0027f793          	andi	a5,a5,2
  44:	fe079ae3          	bnez	a5,38 <.L3>
    msg++;
  48:	fec42783          	lw	a5,-20(s0)
  4c:	00178793          	addi	a5,a5,1
  50:	fef42623          	sw	a5,-20(s0)

    
  } while ( *(char *)msg != NULL);
  54:	fec42783          	lw	a5,-20(s0)
  58:	0007c783          	lbu	a5,0(a5)
  5c:	fc0794e3          	bnez	a5,24 <.L4>

00000060 <.L5>:
  
  
  

  while(1);
  60:	0000006f          	j	60 <.L5>
