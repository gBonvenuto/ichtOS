#/bin/bash

set -xue # -x exibe cada comando antes de executar
         # -u gera erro ao usar variáveis não definidas
         # -e encerra o script se algum comando der erro# QEMU file path
         
# QEMU file path
QEMU=qemu-system-riscv32

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot
