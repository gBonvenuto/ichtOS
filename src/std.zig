const sbi = @import("sbi.zig");
const std = @import("std");

pub inline fn assert(ok: bool) void {
    if (!ok) {
        unreachable;
    }
}

// TODO: Implementar isso aqui de verdade
pub fn PANIC(fmt: anytype) void {
    _ = fmt;
}

pub fn memset(buf: [*]u8, c: u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        print("setando o endereço {*}\n", .{&(buf[i])});
        buf[i] = c;
    }
    return buf;
}

pub fn memcpy(dst: []u8, src: []const u8) void {
    @memcpy(dst, src);
}

pub fn strncpy(dst: [*]u8, src: [*:0]const u8) [*:0]u8 {
    var i: usize = 0;
    while (src[i] != 0) : (i += 1) {
        dst[i] = src[i];
        i += 1;
    }
    dst[i] = 0;
    return @ptrCast(dst);
}

pub fn strcmp(s1: [:0]const u8, s2: [:0]const u8) i32 {
    const size = undefined;

    if (s1.len < s2.len) {
        size = s1.len;
    } else {
        size = s2.len;
    }

    for (0..size) |i| {
        const diff: i32 = s1[i] - s2[i];
        if (diff != 0) {
            return diff;
        }
    }
    return 0;
}

// TODO: ver como implementar o print do Zig (para isso preciso criar um writer)
pub fn print(comptime fmt: [:0]const u8, args: anytype) void {
    var string_final: [10000:0]u8 = undefined;

    _ = std.fmt.bufPrintZ(&string_final, fmt, args) catch null; // Vamos ignorar esse erro por enquanto

    for (string_final) |value| {
        if (value == 0) {
            break;
        }
        sbi.putchar(value);
    }
}

pub fn delay() void  {
    for (0..30000000) |_| {
        asm volatile ("nop");
    }
    for (0..30000000) |_| {
        asm volatile ("nop");
    }
    for (0..30000000) |_| {
        asm volatile ("nop");
    }
    for (0..30000000) |_| {
        asm volatile ("nop");
    }
}

test "Teste do std.print" {
    print(
        \\ Testando o Printf:
        \\ Inteiros: 
        \\ - Meu input: -10, -1, 1000, 123456789
        \\ - Printf: {d}, {d}, {d}, {d}
        \\ Hex:
        \\ - Meu input: -0x1, 0xabcdef9
        \\ - Printf: {x}, {x}
        \\ String:
        \\ - Meu input: , "Hello world!\n", "Hello World"
        \\ Printf: {s}, {s}, {s}
    , .{ -10, -1, 1000, 123456789, -0x1, 0xabcdef9, "", "Hello world!\n", "Hello World" });
}


