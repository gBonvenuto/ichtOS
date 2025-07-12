const kernel = @import("kernel.zig");
const std = @import("std.zig");
const zstd = @import("std");
const PROCS_MAX = 8;
const KERNEL_STACK_SIZE = 8192;
const PROC_UNUSED = false;
const PROC_RUNNABLE = true;

pub noinline fn switch_context(prev_sp: usize, next_sp: usize) callconv(.{ .riscv32_ilp32 = .{} }) noreturn {
    if (prev_sp < 0x80000000 or prev_sp > 0x81000000) {
        kernel.PANIC("prev_sp corrompido!", .{}, @src());
    }
    if (next_sp < 0x80000000 or next_sp > 0x81000000) {
        kernel.PANIC("next_sp corrompido!", .{}, @src());
    }
    asm volatile (
        \\ addi sp, sp, -13*4
        \\ sw ra, 0 * 4(sp)
        \\ sw s0, 1 * 4(sp)
        \\ sw s1, 2 * 4(sp)
        \\ sw s2, 3 * 4(sp)
        \\ sw s3, 4 * 4(sp)
        \\ sw s4, 5 * 4(sp)
        \\ sw s5, 6 * 4(sp)
        \\ sw s6, 7 * 4(sp)
        \\ sw s7, 8 * 4(sp)
        \\ sw s8, 9 * 4(sp)
        \\ sw s9, 10 * 4(sp)
        \\ sw s10, 11 * 4(sp)
        \\ sw s11, 12 * 4(sp)
        \\ 
        \\ sw sp, (%[prev_sp])
        \\ lw sp, (%[next_sp])
        \\
        \\ lw ra, 0 * 4(sp)
        \\ lw s0, 1 * 4(sp)
        \\ lw s1, 2 * 4(sp)
        \\ lw s2, 3 * 4(sp)
        \\ lw s3, 4 * 4(sp)
        \\ lw s4, 5 * 4(sp)
        \\ lw s5, 6 * 4(sp)
        \\ lw s6, 7 * 4(sp)
        \\ lw s7, 8 * 4(sp)
        \\ lw s8, 9 * 4(sp)
        \\ lw s9, 10 * 4(sp)
        \\ lw s10, 11 * 4(sp)
        \\ lw s11, 12 * 4(sp)
        \\
        \\ addi sp, sp, 13*4
        \\ ret
        :
        : [prev_sp] "r" (prev_sp),
          [next_sp] "r" (next_sp),
    );
    unreachable;
}

pub const Process = struct {
    pid: usize,
    state: bool,
    sp: [*]volatile u8,
    stack: [KERNEL_STACK_SIZE]u8 align(@alignOf(usize)),
};

var procs: [PROCS_MAX]Process = .{Process{
    .pid = undefined,
    .state = PROC_UNUSED,
    .sp = undefined,
    .stack = [_]u8{0} ** KERNEL_STACK_SIZE,
}} ** PROCS_MAX;

pub fn create(pc: usize) *Process {
    std.print("criando processo com pc = {x}\n", .{pc});
    var proc: ?*Process = null;

    var pid: usize = 0;

    for (0..procs.len) |i| {
        if (procs[i].state == PROC_UNUSED) {
            std.print("encontramos um slot para o processo em i={d}\n", .{i});
            std.print("proc = {*}\n", .{&(procs[i])});
            proc = @constCast(&(procs[i]));
            pid = i;
            break;
        }
    }
    std.print("O pid para o processo {x} é {d}\n", .{ pc, pid });

    if (proc == null) {
        kernel.PANIC("Não há mais slots livres de memória", .{}, @src());
    }

    var sp: [*]usize = undefined;

    {
        const a: [*]u8 = @ptrCast(&proc.?.stack);
        std.print("sp = {*}\n", .{a});
        const stack_top = a + (proc.?.stack.len);
        std.print("sp = {*}\n", .{stack_top});
        std.print("sp = {*}\n", .{&stack_top});
        const b: [*]usize = @ptrCast(@alignCast(stack_top));
        std.print("sp = {*}\n", .{b});
        sp = @alignCast(@ptrCast(stack_top));
        std.print("sp = {*}\n", .{sp});
    }

    std.print("sp = {*}\n", .{sp});

    var i: usize = 12;
    while (i > 0) : (i -= 1) {
        sp -= 1;
        const ptr: *usize = @ptrCast(sp);
        ptr.* = i;
    }
    sp -= 1;
    const ptr: *u32 = @ptrCast(sp);
    ptr.* = pc;

    proc.?.pid = pid;
    proc.?.state = PROC_RUNNABLE;
    proc.?.sp = @ptrCast(sp);
    std.print("sp = {*}, proc.sp = {*}\n", .{ sp, proc.?.sp });

    const stack_u32: []u32 = @ptrCast(@alignCast(&(proc.?.stack)));
    std.print("stack: {x}\n", .{stack_u32[stack_u32.len - 13 ..]});
    std.print("processo: {*}\n", .{&proc.?});
    std.print("processo: {*}\n", .{&(procs[pid])});

    for (procs) |value| {
        std.print("{any}\n", .{value.state});
    }

    return proc.?;
}
