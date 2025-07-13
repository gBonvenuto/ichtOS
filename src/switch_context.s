.global switch_context
.text
// a0: recebe prev_sp: usize
// a1: recebe next_sp: usize
switch_context:
    addi sp, sp, -13*4
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

    
    mv a0, sp

    lw ra, 0 * 4(a1)
    lw s0, 1 * 4(a1)
    lw s1, 2 * 4(a1)
    lw s2, 3 * 4(a1)
    lw s3, 4 * 4(a1)
    lw s4, 5 * 4(a1)
    lw s5, 6 * 4(a1)
    lw s6, 7 * 4(a1)
    lw s7, 8 * 4(a1)
    lw s8, 9 * 4(a1)
    lw s9, 10 * 4(a1)
    lw s10, 11 * 4(a1)
    lw s11, 12 * 4(a1)
    
    addi a1, a1, 13*4
    mv sp, a1
    ret
