Addition to version1 (not in version1 branch, the one in main branch),

1- Memory controller is added. Memory accesses from 0x100 to 0x108 is redirected to UART peripherals.

2- UART implementation is changed. UART registers are implemented.

3- Active low reset is added.

4- A basic batch script is added for building. With the help of a python script, output program binary can be copied from "fpga.txt" file to instruction memory VHDL file.

5- Hello world assembly program is written.


LEDs are not implemented. I am planning to implement a GPIO peripheral. I also plan it to be programmable as input and output and write an example program for it.

Core is run on Sipeed Tang NANO 9k FPGA development board equipped with GOWIN 1NR-9 FPGA. Here is the output of the assembly program in src\SW\uart_tx_test.s
:
![image](https://github.com/saahinduran/pRiscV/assets/68019897/921c3725-e65b-42a4-be8a-9d801cf0db44)
