pub extern var __stack_top: [*]u8;

export fn kernel_main() void{
    while (true) {}
}

export fn boot() callconv(.naked) void{
    asm volatile (
        \\ mv sp, %[stack_top]
        \\ j kernel_main
        : 
        : [stack_top] "r"(__stack_top));
}
