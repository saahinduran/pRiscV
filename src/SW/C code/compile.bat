riscv-none-embed-gcc.exe -c -g -nostdlib main.c -march=rv32i -o main.o
@echo off
if %errorlevel% equ 0 (
    echo Compilation successful
) else (
    echo Compilation failed with error code: %errorlevel%
)
@echo on

riscv-none-embed-gcc.exe -Tlinker.ld -nostdlib -o main.elf main.o -Wl,-Map=main.map -march=rv32i

@echo off
if %errorlevel% equ 0 (
    echo Linking successful
) else (
    echo Linking failed with error code: %errorlevel%
)
@echo on
riscv-none-embed-objdump.exe -h -S  main.elf  > "main.elf.list"



riscv-none-embed-objcopy.exe -O binary  main.elf  "main.bin"



python.exe .\final_output.py .\main.bin fpga.txt
python.exe .\byteoutput.py .\main.bin fpgaByte.txt

