#/bin/bash

set -xue # -x exibe cada comando antes de executar
         # -u gera erro ao usar variáveis não definidas
         # -e encerra o script se algum comando der erro# QEMU file path
         
# QEMU file path
QEMU=qemu-system-riscv32

CC=clang
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fno-stack-protector -ffreestanding -nostdlib"

# Build the kernel
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map \
    -o kernel.elf \
    kernel.c sbi.c

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
  -kernel kernel.elf
