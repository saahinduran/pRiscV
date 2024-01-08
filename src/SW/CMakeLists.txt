cmake_minimum_required(VERSION 3.13.1)

include(riscv.cmake)

project(test C ASM)


# specify the C++ standard
set ( CMAKE_C_FLAGS "-g  -nostdlib -ffunction-sections  -march=rv32i")
set ( STACK_SIZE 0x40 )
set ( TARGET test )

# add the executable

add_executable(${TARGET}.elf main.c) 
SET(LINKER_SCRIPT linker.ld)

set_target_properties(${TARGET}.elf PROPERTIES LINK_DEPENDS "${LINKER_SCRIPT}")
target_include_directories(${TARGET}.elf PRIVATE ../include/ )

# Linker control
SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -nostdlib  -march=rv32i -Xlinker --defsym=__stack_size=${STACK_SIZE} -T ${LINKER_SCRIPT} -Wl,-Map=${TARGET}.map")

add_custom_command(TARGET ${TARGET}.elf POST_BUILD
        COMMAND ${CMAKE_OBJDUMP} -S -h ${TARGET}.elf > ${TARGET}.disasm
        COMMENT "Invoking: Disassemble")

# Post processing command to create a hex file 
add_custom_command(TARGET ${TARGET}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary  ${TARGET}.elf  ${TARGET}.bin
        COMMENT "Invoking: Hexdump")

# Pre-processing command to create disassembly for each source file
foreach (SRC_MODULE test startup dummy)
  add_custom_command(TARGET ${TARGET}.elf 
                     PRE_LINK
                     COMMAND ${CMAKE_OBJDUMP} -S CMakeFiles/${TARGET}.elf.dir/${SRC_MODULE}.c.obj > ${SRC_MODULE}.s
                     COMMENT "Invoking: Disassemble ( CMakeFiles/${TARGET}.elf.dir/${SRC_MODULE}.c.obj)")
endforeach()