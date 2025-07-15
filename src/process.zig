const kernel = @import("kernel.zig");
const std = @import("std.zig");
const zstd = @import("std");
const sbi = @import("sbi.zig");
const PROCS_MAX = 8;
const KERNEL_STACK_SIZE = 1024 * 20;
const PROC_UNUSED = false;
const PROC_RUNNABLE = true;

pub extern fn switch_context(prev_sp: *usize, next_sp: *usize) noreturn;

pub const Process = struct {
    pid: usize,
    state: bool,
    sp: usize,
    stack: [KERNEL_STACK_SIZE]u8 align(16),
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

    // Encontrar um slot livre para esse processo
    for (0..procs.len) |i| {
        if (procs[i].state == PROC_UNUSED) {
            std.print("encontramos um slot para o processo em i={d}\n", .{i});
            std.print("proc = {*}\n", .{&(procs[i])});
            proc = (&(procs[i]));
            pid = i;
            break;
        }
    }
    std.print("O pid para o processo {x} é {d}\n", .{ pc, pid });

    if (proc == null) {
        kernel.PANIC("Não há mais slots livres de memória", .{}, @src());
    }

    var sp: [*]usize = blk: {
        const stack_cast: [*]u8 = @ptrCast(&proc.?.stack); // Para apontarmos
        // pro topo precisamos
        // que ele seja um many-item
        // pointer
        const stack_top = stack_cast + (proc.?.stack.len);
        break :blk @alignCast(@ptrCast(stack_top));
    };
    std.print("sp = {*}\n", .{sp});

    var i: usize = 12;
    while (i > 0) : (i -= 1) {
        sp -= 1;
        const ptr: *usize = @ptrCast(sp);
        ptr.* = 0;
    }
    var ptr: *u32 = @ptrCast(sp);
    sp -= 1;
    ptr = @ptrCast(sp);
    ptr.* = pc;

    proc.?.pid = pid;
    proc.?.state = PROC_RUNNABLE;
    proc.?.sp = @intFromPtr(sp);
    std.print("sp = {*}, proc.sp = {x}\n", .{ sp, proc.?.sp });

    const stack_u32: []u32 = @ptrCast(@alignCast(&(proc.?.stack)));
    std.print("stack: {x}\n", .{stack_u32[stack_u32.len - 13 ..]});
    std.print("processo: {*}\n", .{proc.?});
    std.print("processo: {*}\n", .{&(procs[pid])});

    for (procs) |value| {
        std.print("{any}\n", .{value.state});
    }

    return proc.?;
}

var current_proc: *Process = undefined;
var idle_proc: *Process = undefined;

fn teste() void {
    std.print("estamos no teste\n", .{});
}

pub fn init() void {
    idle_proc = create(@intFromPtr(&teste));
    idle_proc.pid = 0;
    current_proc = idle_proc;
}

pub fn yield() void {
    // std.print("yielding\n", .{});
    var next = idle_proc;
    var i: usize = 0;
    while (i < PROCS_MAX) : (i += 1) {
        const idx = (current_proc.pid + i + 1) % PROCS_MAX;
        const proc = &(procs[idx]);
        {
            const idx_u8: u8 = @intCast(idx);
            sbi.putchar('0' + idx_u8);
            sbi.putchar('\n');
        }
        // std.print("proc.pid = {d}\n", .{proc.pid});
        if (proc.state == PROC_RUNNABLE and idx > 0) {
            std.print("proc id = {x}\n", .{proc.pid});
            next = @constCast(proc);
            break;
        }
    }

    // for (procs) |proc| {
    // std.print("proc: {any}\n", .{proc.state});
    // }

    // Se só tiver este único processo
    if (next == current_proc) {
        // std.print("next = {*}, current_proc = {*}\n", .{ next, current_proc });
        return;
    }

    // Mudamos de contexto
    const prev = current_proc;
    current_proc = next;
    // asm volatile (
    //     \\ addi sp, sp, -13*4 # o copilot falou pra eu tomar cuidado com o alinhamento
    //     \\ sw ra, 0 * 4(sp)
    //     \\ sw s0, 1 * 4(sp)
    //     \\ sw s1, 2 * 4(sp)
    //     \\ sw s2, 3 * 4(sp)
    //     \\ sw s3, 4 * 4(sp)
    //     \\ sw s4, 5 * 4(sp)
    //     \\ sw s5, 6 * 4(sp)
    //     \\ sw s6, 7 * 4(sp)
    //     \\ sw s7, 8 * 4(sp)
    //     \\ sw s8, 9 * 4(sp)
    //     \\ sw s9, 10 * 4(sp)
    //     \\ sw s10, 11 * 4(sp)
    //     \\ sw s11, 12 * 4(sp)
    //     \\ 
    //     \\ sw sp, (%[prev_sp])
    //     \\ lw sp, (%[next_sp])
    //     \\
    //     \\ lw ra, 0 * 4(sp)
    //     \\ lw s0, 1 * 4(sp)
    //     \\ lw s1, 2 * 4(sp)
    //     \\ lw s2, 3 * 4(sp)
    //     \\ lw s3, 4 * 4(sp)
    //     \\ lw s4, 5 * 4(sp)
    //     \\ lw s5, 6 * 4(sp)
    //     \\ lw s6, 7 * 4(sp)
    //     \\ lw s7, 8 * 4(sp)
    //     \\ lw s8, 9 * 4(sp)
    //     \\ lw s9, 10 * 4(sp)
    //     \\ lw s10, 11 * 4(sp)
    //     \\ lw s11, 12 * 4(sp)
    //     \\ 
    //     \\ addi sp, sp, 13*4
    //     \\ ret
    //     :
    //     : [prev_sp] "r" (&prev.sp),
    //       [next_sp] "r" (&next.sp),
    // );
    std.print("mudando o contexto\n", .{});
    switch_context(&prev.sp, &next.sp);
}
