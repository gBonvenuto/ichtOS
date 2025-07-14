ENTRY(boot)

SECTIONS {
    . = 0x80200000;
    __kernel_base = .;

    .text :{
        KEEP(*(.text.boot));
        *(.text .text.*);
    }

    .rodata : ALIGN(4) {
        /* *(.rodata .rodata.*); */
        *(.rodata)
        /*WARN: não funcionou, mas vou manter aqui por referência futura
         * caso eu queria tentar novamente*/
        /* NOTE: Agora que estamos usando Zig e enquanto não temos um filesystem,
         * vou guardar as informações de debugging na memória pra poder utilizar 
         * o stack trace, estou  me baseando neste post do Andrew Kelley
         * https://andrewkelley.me/post/zig-stack-traces-kernel-panic-bare-bones-os.html*/
        __debug_info_start = .;
        KEEP(*(.debug_info))
        __debug_info_end = .;
        __debug_abbrev_start = .;
        KEEP(*(.debug_abbrev))
        __debug_abbrev_end = .;
        __debug_str_start = .;
        KEEP(*(.debug_str))
        __debug_str_end = .;
        __debug_line_start = .;
        KEEP(*(.debug_line))
        __debug_line_end = .;
        __debug_ranges_start = .;
        KEEP(*(.debug_ranges))
        __debug_ranges_end = .;
        *(.rodata.*)
    }

    .data : ALIGN(4) {
        __global_pointer$ = . + 0x800;
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
