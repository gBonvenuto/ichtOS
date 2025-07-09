const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .os_tag = .freestanding,
            .cpu_arch = .riscv32,
        },
    });
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseFast
    });

    // Primeiro compilamos o kernel
    const kernel = b.addExecutable(.{
        .name = "kernel",
        .root_source_file = b.path("src/kernel.zig"),
        .target = target,
        .optimize = optimize,
    });

    kernel.setLinkerScript(b.path("kernel.ld"));
    kernel.entry = .{ .symbol_name = "boot" };
    b.installArtifact(kernel);

    const qemu_cmd = b.addSystemCommand(&.{
        "qemu-system-riscv32",            "-machine",
        "virt",                           "-bios",
        "default",                        "-nographic",
        "-serial",                        "mon:stdio",
        "--no-reboot",                    "-kernel",
        b.getInstallPath(.bin, "kernel"),
    });
    const run_step = b.step("run", "Compila e Boota o QEMU");
    run_step.dependOn(&qemu_cmd.step);

    const asm_cmd = b.addSystemCommand(&.{
        "zsh",
        "-c",
        try std.fmt.allocPrint(b.allocator, "llvm-objdump -d --disassembler-color=on {s} | less -r", .{b.getInstallPath(.bin, "kernel")}),
    });
    const asm_step = b.step("asm", "Revela o assembly do kernel (para debugging)");
    asm_step.dependOn(&asm_cmd.step);

    const mem_cmd = b.addSystemCommand(&.{
        "zsh",
        "-c",
        try std.fmt.allocPrint(b.allocator, "llvm-nm -n {s} | less -r", .{b.getInstallPath(.bin, "kernel")}),
    });
    const mem_step = b.step("mem", "Revela a memória do kernel (para debugging)");
    mem_step.dependOn(&mem_cmd.step);
}
