const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exec = b.addExecutable(.{
        .name = "dreamscape",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize
    });

    const zlm_module = b.addModule("zlm", .{
        .root_source_file = b.path("zlm/src/zlm.zig"),
        .target = target,
        .optimize = optimize
    });
    exec.root_module.addImport("zlm", zlm_module);

    exec.linkSystemLibrary("glfw");
    exec.linkSystemLibrary("GL");
    exec.addIncludePath(b.path("gl"));
    exec.linkLibC();
    exec.addCSourceFile(.{
        .file = b.path("gl/glad/glad.c")
    });

    b.installArtifact(exec);

    const run_exec = b.addRunArtifact(exec);
    const run_step = b.step("run", "run the app");
    run_step.dependOn(&run_exec.step);
}
