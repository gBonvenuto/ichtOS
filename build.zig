const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{ .cpu_arch = .riscv32 },
    });
    const optimize = b.standardOptimizeOption(.{});

    // Primeiro compilamos o kernel
    const kernel = b.addObject(.{
        .name = "kernel",
        .root_source_file = b.path("src/kernel.zig"),
        .target = target,
        .optimize = optimize,
    });

    // E agora fazemos o link
    const linked = b.addSystemCommand(&.{
        "zig",                           "ld",
        "-T",                            "kernel.ld",
        kernel.step.,             "-o",
        b.path("kernel.elf").getPath(b),
    });
    linked.step.dependOn(&kernel.step);
    b.installFile("kernel.elf", "kernel");

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
}
