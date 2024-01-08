#include <stdint.h>
#include <stddef.h>
#define UART_CTRL_REG_ADDR        0x100
#define UART_STS_REG_ADDR         0x104
#define UART_TX_DATA_REG_ADDR     0x108

void __attribute__((section(".init"),naked)) _start(void) {

    asm volatile("la sp, _end_stack");
}
int main()
{
  const char *msg = "Hello from pRiscV";
  // Enable TX
	*(uint32_t *) UART_CTRL_REG_ADDR = 1;
	

  do
  {
    *(uint32_t *) UART_TX_DATA_REG_ADDR = *msg;
    while ( (*(uint32_t *)UART_STS_REG_ADDR & (0x1 << 1) )>> 1);
    msg++;

    
  } while ( *(char *)msg != NULL);
  
  
  

  while(1);

  
}
