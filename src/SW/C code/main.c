#include <stdint.h>

#define UART_CTRL_REG_ADDR        0x100
#define UART_STS_REG_ADDR         0x104
#define UART_TX_DATA_REG_ADDR     0x108

void __attribute__((section(".init"),naked)) _start(void) {

    asm volatile("la sp, _end_stack");
}
int main()
{
	const uint8_t *msg = "Hello world\n";
	
	// Enable TX
	*(uint32_t *) UART_CTRL_REG_ADDR = 1;
	while(*msg != 0)
	{
		uint32_t statusReg;
		*(uint32_t *) UART_TX_DATA_REG_ADDR = (uint32_t)msg;
		msg = msg +1;
	
		do
		{
			statusReg = *(uint32_t *)UART_STS_REG_ADDR;
			statusReg = (statusReg & 0x2) >> 1;
			asm volatile ("NOP");
		}while(statusReg);

    const int a = 1;
    int b;
    b = a +1;
	
	}
	
	while(1);
	return 0;
}
