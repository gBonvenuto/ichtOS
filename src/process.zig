const kernel = @import("kernel.zig");
const std = @import("std.zig");
const zstd = @import("std");
const PROCS_MAX = 8;
const KERNEL_STACK_SIZE = 8192;
const PROC_UNUSED = false;
const PROC_RUNNABLE = true;

pub extern fn switch_context(prev_sp: usize, next_sp: usize) usize;

pub const Process = struct {
    pid: usize,
    state: bool,
    sp: usize,
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
        const stack_top = a + (proc.?.stack.len);
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
    proc.?.sp = @intFromPtr(sp);
    std.print("sp = {*}, proc.sp = {x}\n", .{ sp, proc.?.sp });

    const stack_u32: []u32 = @ptrCast(@alignCast(&(proc.?.stack)));
    std.print("stack: {x}\n", .{stack_u32[stack_u32.len - 13 ..]});
    std.print("processo: {*}\n", .{&proc.?});
    std.print("processo: {*}\n", .{&(procs[pid])});

    for (procs) |value| {
        std.print("{any}\n", .{value.state});
    }

    return proc.?;
}
