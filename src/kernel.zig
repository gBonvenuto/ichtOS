const zstd = @import("std");
pub const std = @import("std.zig");
pub const sbi = @import("sbi.zig");
const exceptions = @import("exceptions.zig");
const builtin = zstd.builtin;

// NOTE: nota sobre Zig, por algum motivo, quando eu fazia __stack_top: [*]u8
// ele simplesmente ignorava que eu queria um [*]u8 e transformava em um u8.
// Por isso eu precisava usar "&" direto, então, pra deixar mais claro, vou
// declará-los como u8 direto.
// Eu fazia da outra forma porque em C seria: extern uint8_t *__stack_top.
extern var __stack_top: u8;
extern var __bss: u8;
extern var __bss_end: u8;
extern var __free_ram: u8;
extern var __free_ram_end: u8;

// Isso foi uma tentativa de fazer um stack trace, talvez eu revise isso no
// futuro, vou manter esse código aqui pra eu me lembrar depois
extern var __debug_info_start: u8;
extern var __debug_info_end: u8;
extern var __debug_abbrev_start: u8;
extern var __debug_abbrev_end: u8;
extern var __debug_str_start: u8;
extern var __debug_str_end: u8;
extern var __debug_line_start: u8;
extern var __debug_line_end: u8;
extern var __debug_ranges_start: u8;
extern var __debug_ranges_end: u8;

const PAGE_SIZE = 4096;
var next_paddr: *[*]u8 = undefined;

extern fn kernel_entry() void;

// TODO: tentar integrar com o @panic() do Zig no futuro
pub inline fn PANIC(message: []const u8, args: anytype, src: zstd.builtin.SourceLocation) noreturn {
    std.print(
        \\
        \\--------------
        \\PANIC: {s}:{s} ({d}:{d})
        \\
    , .{ src.file, src.fn_name, src.line, src.column });
    std.print(message ++
        \\
        \\--------------
        \\ 
    , args);

    sbi.putchar('\n');
    while (true) {}
}

export fn kernel_main() void {
    _ = exceptions.WRITE_CSR("stvec", kernel_entry);

    const bss: [*]u8 = @ptrCast(&__bss);
    _ = std.memset(bss, 0, @intFromPtr(&__bss_end) - @intFromPtr(&__bss));
    std.print("bss feito\n", .{});
    std.print("bss = {*}, bss_end = {*}, bss_end - bss = {x}\n", .{bss, &__bss_end, @intFromPtr(&__bss_end) - @intFromPtr(&__bss)});
    PANIC("", .{}, @src());

    next_paddr = @alignCast(@ptrCast(&__free_ram));


    std.print(
        \\ 
        \\  _      _     _    ___  ____   ___  
        \\ (_) ___| |__ | |_ / _ \/ ___| /   \/
        \\ | |/ __| '_ \| __| | | \___ \ \___/\
        \\ | | (__| | | | |_| |_| |___) |          
        \\ |_|\___|_| |_|\__|\___/|____/           
        \\
    , .{});

    const paddr0 = alloc_pages(2);
    const paddr1 = alloc_pages(1);
    std.print("paddr0={*}\n", .{paddr0});
    std.print("paddr1={*}\n", .{paddr1});

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
    const scause: usize = @bitCast(exceptions.READ_CSR("scause"));
    const stval: usize = @bitCast(exceptions.READ_CSR("stval"));
    const user_pc: usize = @bitCast(exceptions.READ_CSR("sepc"));

    PANIC("Trap inesperada: scause={X}, stval={X}, sepc={X}\n{any}", .{ scause, stval, user_pc, frame }, @src());
}

pub fn alloc_pages(n: usize) [*]u8 {
    const paddr: [*]u8 = @ptrCast(next_paddr);

    const np = @intFromPtr(next_paddr) + (n * PAGE_SIZE);
    next_paddr = @ptrFromInt(np);

    if (@intFromPtr(&next_paddr) > @intFromPtr(&__free_ram_end)) {
        PANIC("out of memory", .{}, @src());
    }

    return std.memset(paddr, 0, n*PAGE_SIZE);
}

test "PANIC" {
    PANIC("teste", .{}, @src());
}

test "testes da std" {
    zstd.testing.refAllDecls(@This());
}

// test "Teste de alocação de Páginas" {
//     const paddr0 = alloc_pages(2);
//     const paddr1 = alloc_pages(1);
//     std.print("paddr0={*}\n", .{paddr0});
//     std.print("paddr1={*}\n", .{paddr1});
// }
