const zstd = @import("std");
pub const std = @import("std.zig");
pub const sbi = @import("sbi.zig");
const exceptions = @import("exceptions.zig");
const builtin = zstd.builtin;

extern var __stack_top: [*]u8;
extern var __bss: [*]u8;
extern var __bss_end: [*]u8;
extern var __debug_info_start: [*]u8;
extern var __debug_info_end: [*]u8;
extern var __debug_abbrev_start: [*]u8;
extern var __debug_abbrev_end: [*]u8;
extern var __debug_str_start: [*]u8;
extern var __debug_str_end: [*]u8;
extern var __debug_line_start: [*]u8;
extern var __debug_line_end: [*]u8;
extern var __debug_ranges_start: [*]u8;
extern var __debug_ranges_end: [*]u8;

extern fn kernel_entry() void;

// TODO: tentar integrar com o @panic() do Zig no futuro
pub inline fn PANIC(message: []const u8, args: anytype, src: zstd.builtin.SourceLocation) noreturn {
    _ = src;
    std.print(
        \\
        \\--------------
        \\PANIC: {s}:{s} ({d}:{d})
        \\
    , .{ @src().file, @src().fn_name, @src().line, @src().column });
    std.print(message ++
        \\
        \\--------------
        \\ 
    , args);

    sbi.putchar('\n');
    while (true) {}
}

export fn kernel_main() void {
    _ = std.memset(__bss, 0, __bss_end - __bss);

    _ = exceptions.WRITE_CSR("stvec", kernel_entry);
    asm volatile ("unimp");

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

export fn handle_trap(frame: *exceptions.trap_frame) void {
    _ = frame;
    const scause: usize = @bitCast(exceptions.READ_CSR("scause"));
    const stval: usize = @bitCast(exceptions.READ_CSR("stval"));
    const user_pc: usize = @bitCast(exceptions.READ_CSR("sepc"));

    PANIC("Trap inesperada: scause={X}, stval={X}, sepc={X}", .{ scause, stval, user_pc }, @src());
}

test "PANIC" {
    PANIC("teste", .{}, @src());
}

test "testes da std" {
    zstd.testing.refAllDecls(@This());
}
