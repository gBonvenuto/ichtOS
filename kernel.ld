ENTRY(boot)

SECTIONS {
    . = 0x80200000;

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
    __stack_top = .; /* NOTE: Pesquisar o que acontece com o resto da memória 
                        porque parece que depois que a gente reserva 128kb para 
                        o stack, a gente fica com um monte de memória vazia */
}
