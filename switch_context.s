.text
.global switch_context

# Neste sistema operacional, o programa do usuário deve voltuntariamente
# abrir mão do controle. Então, quando ele faz isso chamando yield(), ele já
# guardou os registradores que queria guardar. Dessa forma, precisamos apenas
# guardar os callee saved registers.
# Precisamos guardá-los manualmente porque não sabemos quais registradores
# callee saved o outro contexto vai alterar, então não tem como deixarmos isso
# para o comiplador fazer

# a0: paddr_t *prev_sp
# a1: paddr_t *next_sp
switch_context:
    addi sp, sp, -13 * 4 # NOTE: quem é esse sp? É do kernel, do contexto 1 ou do contexto 2
    sw ra, 0 * 4(sp)
    sw s0, 1 * 4(sp)
    sw s1, 2 * 4(sp)
    sw s2, 3 * 4(sp)
    sw s3, 4 * 4(sp)
    sw s4, 5 * 4(sp)
    sw s5, 6 * 4(sp)
    sw s6, 7 * 4(sp)
    sw s7, 8 * 4(sp)
    sw s8, 9 * 4(sp)
    sw s9, 10 * 4(sp)
    sw s10, 11 * 4(sp)
    sw s11, 12 * 4(sp)

    # Agora trocamos o stack pointer

    sw sp, (a0) # Guardamos o stack pointer na variável prev_sp
    lw sp, (a1) # Agora vamos utilizar o next_sp como o stack pointer

    # E recuperamos os callee saved registers antes de mudar o contexto

    lw ra, 0 * 4(sp)
    lw s0, 1 * 4(sp)
    lw s1, 2 * 4(sp)
    lw s2, 3 * 4(sp)
    lw s3, 4 * 4(sp)
    lw s4, 5 * 4(sp)
    lw s5, 6 * 4(sp)
    lw s6, 7 * 4(sp)
    lw s7, 8 * 4(sp)
    lw s8, 9 * 4(sp)
    lw s9, 10 * 4(sp)
    lw s10, 11 * 4(sp)
    lw s11, 12 * 4(sp)

    addi sp, sp, 13 * 4 # liberamos o espaço no stack 
    ret
