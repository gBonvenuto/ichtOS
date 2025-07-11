const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .os_tag = .freestanding,
            .cpu_arch = .riscv32,
            .abi = .gnuilp32,
            // .os_tag = .linux,
            // .cpu_arch = .x86_64,
            // .abi = .none,
        },
    });
    const optimize = b.standardOptimizeOption(.{ 
        .preferred_optimize_mode = .Debug
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
    kernel.addAssemblyFile(b.path("src/kernel_entry.s"));
    const install_kernel = b.addInstallArtifact(kernel, .{});
    b.getInstallStep().dependOn(&install_kernel.step);

    const qemu_cmd = b.addSystemCommand(&.{
        "qemu-system-riscv32",            "-machine",
        "virt",                           "-bios",
        "default",                        "-nographic",
        "-serial",                        "mon:stdio",
        "--no-reboot",                    "-kernel",
        b.getInstallPath(.bin, "kernel"),
    });
    qemu_cmd.step.dependOn(&install_kernel.step);
    const run_step = b.step("run", "Compila e Boota o QEMU");
    run_step.dependOn(&qemu_cmd.step);

    const asm_cmd = b.addSystemCommand(&.{
        "zsh",
        "-c",
        try std.fmt.allocPrint(b.allocator, "llvm-objdump -d --disassembler-color=on {s} | less -r", .{b.getInstallPath(.bin, "kernel")}),
    });
    asm_cmd.step.dependOn(&kernel.step);
    const asm_step = b.step("asm", "Revela o assembly do kernel (para debugging)");
    asm_step.dependOn(&asm_cmd.step);

    const mem_cmd = b.addSystemCommand(&.{
        "zsh",
        "-c",
        try std.fmt.allocPrint(b.allocator, "llvm-nm -n {s} | less -r", .{b.getInstallPath(.bin, "kernel")}),
    });
    mem_cmd.step.dependOn(&install_kernel.step);
    const mem_step = b.step("mem", "Revela a memória do kernel (para debugging)");
    mem_step.dependOn(&mem_cmd.step);

    // Testes
    const tests = b.addTest(.{
        .root_source_file = b.path("src/kernel.zig"),
        .target = target,
        .optimize = optimize,
    });
    tests.step.dependOn(&install_kernel.step);
    const test_step = b.step("test", "Roda os testes");
    test_step.dependOn(&tests.step);
}
