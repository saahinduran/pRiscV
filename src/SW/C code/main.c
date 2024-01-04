#include <stdint.h>

#define UART_CTRL_REG_ADDR        0x100
#define UART_STS_REG_ADDR         0x104
#define UART_TX_DATA_REG_ADDR     0x108

void __attribute__((section(".init"),naked)) _start(void) {

    asm volatile("la sp, _end_stack");
    asm volatile("add x1,x0,x1");
}
int main()
{
  const uint8_t *msg = "Hello from pRiscV";
	*(uint32_t *) UART_CTRL_REG_ADDR = 1;
	// Enable TX
  /*
	
  *(uint32_t *) UART_TX_DATA_REG_ADDR = 'H';
  while( ( (*(uint32_t *)UART_STS_REG_ADDR) & 0x2) >> 1 );
  */

  *(uint32_t *) UART_TX_DATA_REG_ADDR = *msg;

  while(1);

  
}
