const std = @import("std");

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("win_iconv", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const linkage = b.option(std.builtin.LinkMode, "linkage", "Link mode") orelse .static;
    const strip = b.option(bool, "strip", "Omit debug information");
    const pic = b.option(bool, "pie", "Produce Position Independent Code");

    const exe = b.addExecutable(.{
        .name = "win_iconv",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .pic = pic,
            .link_libc = true,
        }),
    });
    b.installArtifact(exe);
    exe.root_module.addCSourceFile(.{ .file = upstream.path("win_iconv.c") });
    exe.root_module.addCMacro("MAKE_EXE", "1");
    exe.root_module.addCMacro("USE_LIBICONV_DLL", "1");

    const lib = b.addLibrary(.{
        .linkage = linkage,
        .name = "iconv",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .pic = pic,
            .link_libc = true,
        }),
    });
    lib.installHeader(upstream.path("iconv.h"), "iconv.h");
    lib.installHeader(upstream.path("localcharset.h"), "localcharset.h");
    lib.root_module.addCSourceFile(.{ .file = upstream.path("win_iconv.c") });
    switch (linkage) {
        .static => {},
        .dynamic => lib.root_module.addCMacro("MAKE_DLL", "1"),
    }
    lib.root_module.addCMacro("USE_LIBICONV_DLL", "1");
    b.installArtifact(lib);

    const win_iconv_test = b.addExecutable(.{
        .name = "win_iconv_test",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .strip = strip,
            .pic = pic,
            .link_libc = true,
        }),
    });
    win_iconv_test.root_module.addCSourceFile(.{ .file = upstream.path("win_iconv_test.c") });
    win_iconv_test.root_module.addCMacro("USE_LIBICONV_DLL", "1");

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&b.addRunArtifact(win_iconv_test).step);
}
