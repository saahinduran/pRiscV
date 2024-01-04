riscv-none-embed-gcc.exe -c -nostdlib uart_tx_test.s -march=rv32i -o uart_tx_test.o
@echo off
if %errorlevel% equ 0 (
    echo Compilation successful
) else (
    echo Compilation failed with error code: %errorlevel%
)
@echo on

riscv-none-embed-gcc.exe -Tlinker.ld -nostdlib -o uart_tx_test.elf uart_tx_test.o -Wl,-Map=uart_tx_test.map -march=rv32i

@echo off
if %errorlevel% equ 0 (
    echo Linking successful
) else (
    echo Linking failed with error code: %errorlevel%
)
@echo on
riscv-none-embed-objdump.exe -h -S  uart_tx_test.elf  > "uart_tx_test.elf.list"



riscv-none-embed-objcopy.exe -O binary  uart_tx_test.elf  "uart_tx_test.bin"



python.exe .\final_output.py .\uart_tx_test.bin fpga.txt
python.exe .\byteoutput.py .\uart_tx_test.bin fpgaByte.txt

