### WELCOME TO WORLD'S MOST PRIMITIVE RISC-V CPU CORE ###

TODO List:
Leave this core as is. Just implement a new one :)

With the new peripherals, UART and LED, ram implementation is gone. Almost everything is register and LUT based now. 
I suppose I should remove peripherals from ram, implement a sistem bus and assign addresses to peripheral registers. Let us put that aside and leave this most primitive Risc-V core as is. 

LED Blink Results ()
https://imgur.com/xsmCRtg

UART Test Results (I could not add a delay in assembly code :), so it prints all the characters immediately.):
![image](https://github.com/saahinduran/pRiscV/assets/68019897/550a83a7-d090-4c4c-a7b5-d420f649a9dc)

In both UART and LED blink core is clocked from FPGA's oscillator which is 27 MHZ.
