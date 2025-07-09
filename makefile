OTIMIZACAO      ?= -O2
VERSION			:= 0.0.1
QEMU            := qemu-system-riscv32
CC              := clang
CFLAGS          := -std=c11 $(OTIMIZACAO) -g0 -Wall -Wextra \
                   --target=riscv32-unknown-elf \
                   -fno-stack-protector -ffreestanding -nostdlib\
				   -DVERSION='"$(VERSION)"'


LDFLAGS         := -Wl,-Tkernel.ld -Wl,-Map=build/kernel.map

SRCS            := exceptions.s switch_context.s kernel.c sbi.c std.c
# SRCS            := exceptions.s
OBJS            := $(SRCS:.c=.o)

all: build/kernel.elf

asm: build/kernel.elf
	llvm-objdump --disassembler-color=on -d build/kernel.elf | less -r

mem: build/kernel.elf
	llvm-nm -n build/kernel.elf | less -r
	
build/kernel.elf: $(SRCS)
	mkdir -p build
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

run: build/kernel.elf 
	$(QEMU) -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
	  -kernel build/kernel.elf

clean:
	rm -vrf kernel.elf kernel.map *.o build



.PHONY: all run clean
