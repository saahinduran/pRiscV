# Set cross compilation information
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR riscv)

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# GCC toolchain prefix
set(TOOLCHAIN_PREFIX "C:/GMD/toolchain/RISC-V_toolchain/bin/riscv-none-embed")

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc.exe)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++.exe)

# TODO this should be the assembler, but ${CMAKE_ASM_FLAGS} are
# actually gcc flags, therefore they won't work with as
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}-gcc.exe)

set(CMAKE_AR ${TOOLCHAIN_PREFIX}-ar.exe)
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}-objcopy.exe)
set(CMAKE_OBJDUMP ${TOOLCHAIN_PREFIX}-objdump.exe)

# TODO These are actually gcc flags. The assembler should be
# used and these flags replaced
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g -O0")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g -O0")


set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

set(CMAKE_EXPORT_COMPILE_COMMANDS true)