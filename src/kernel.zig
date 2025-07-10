const zstd = @import("std");
pub const std = @import("std.zig");
pub const sbi = @import("sbi.zig");
pub extern var __stack_top: [*]u8;
pub extern var __bss: [*]u8;
pub extern var __bss_end: [*]u8;

pub fn main() void {}

export fn kernel_main() void {
    _ = std.memset(__bss, 0, __bss_end - __bss);
    std.print(
        \\ 
        \\  _      _     _    ___  ____   ___  
        \\ (_) ___| |__ | |_ / _ \/ ___| /   \/
        \\ | |/ __| '_ \| __| | | \___ \ \___/\
        \\ | | (__| | | | |_| |_| |___) |          
        \\ |_|\___|_| |_|\__|\___/|____/           
        \\
    , .{});

    while (true) {}
}

comptime {
    @setRuntimeSafety(false);
}

export fn boot() linksection(".text.boot") callconv(.naked) void {
    @setRuntimeSafety(false);
    asm volatile (
        \\ mv sp, %[stack_top]
        \\ j kernel_main
        :
        : [stack_top] "r" (&__stack_top),
          // NOTE: não sei pq tem que ser o "&" aqui, só sei que descobri isso
          // depois de 2h olhando pro assembly
    );
}

test "testes da std" {
    zstd.testing.refAllDecls(@This());
}

