const zstd = @import("std");
pub const std = @import("std.zig");
pub const sbi = @import("sbi.zig");
const builtin = zstd.builtin;

extern  var  __stack_top:           [*]u8;
extern  var  __bss:                 [*]u8;
extern  var  __bss_end:             [*]u8;
extern  var  __debug_info_start:    [*]u8;
extern  var  __debug_info_end:      [*]u8;
extern  var  __debug_abbrev_start:  [*]u8;
extern  var  __debug_abbrev_end:    [*]u8;
extern  var  __debug_str_start:     [*]u8;
extern  var  __debug_str_end:       [*]u8;
extern  var  __debug_line_start:    [*]u8;
extern  var  __debug_line_end:      [*]u8;
extern  var  __debug_ranges_start:  [*]u8;
extern  var  __debug_ranges_end:    [*]u8;

// TODO: tentar integrar com o @panic() do Zig no futuro
pub inline fn PANIC(message: []const u8, args: anytype, src: zstd.builtin.SourceLocation) noreturn {
    std.print(
        \\
        \\--------------
        \\PANIC: {s}:{s} ({d}:{d})
        \\
    , .{src.file, src.fn_name, src.line, src.column});
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
    std.print(
        \\ 
        \\  _      _     _    ___  ____   ___  
        \\ (_) ___| |__ | |_ / _ \/ ___| /   \/
        \\ | |/ __| '_ \| __| | | \___ \ \___/\
        \\ | | (__| | | | |_| |_| |___) |          
        \\ |_|\___|_| |_|\__|\___/|____/           
        \\
    , .{});

    PANIC("teste", .{}, @src());

    // while (true) {}
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
