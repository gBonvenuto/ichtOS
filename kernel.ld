ENTRY(boot)

SECTIONS {
    . = 0x80200000;
    __kernel_base = .;

    .text :{
        KEEP(*(.text.boot));
        *(.text .text.*);
    }

    .rodata : ALIGN(4) {
        *(.rodata .rodata.*);
    }

    .data : ALIGN(4) {
        *(.data .data.*);
    }

    .bss : ALIGN(4) {
        __bss = .;
        *(.bss .bss.* .sbss .sbss.*);
        __bss_end = .;
    }

    /* Stack do kernel*/
    . = ALIGN(4);
    . += 128 * 1024; /* 128KB */
    __stack_top = .;

    /* Memória livre*/
    . = ALIGN(4096); /* A gente alinha em 4096 pra ficar mais fácil de ler: 0x1000
                        e uma página de memória geralmente é 4KB*/
    __free_ram = .;
    . += 64 * 1024 * 1024; /* 64MiB */
    __free_ram_end = .; /* NOTE: Por que só 64Mib?*/ 
                        /* TODO: Alocar esse espaço de forma dinâmica ao 
                         * inicializar o computador, não em compile-time*/
}
