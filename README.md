[![CI](https://github.com/allyourcodebase/win-iconv/actions/workflows/ci.yaml/badge.svg)](https://github.com/allyourcodebase/win-iconv/actions)

# win-iconv

This is [win-iconv](https://github.com/win-iconv/win-iconv), packaged for [Zig](https://ziglang.org/).

## Installation

First, update your `build.zig.zon`:

```
# Initialize a `zig build` project if you haven't already
zig init
zig fetch --save git+https://github.com/allyourcodebase/win-iconv.git
```

You can then import `win-iconv` in your `build.zig` with:

```zig
const win_iconv_dependency = b.dependency("win_iconv", .{
    .target = target,
    .optimize = optimize,
});
your_exe.linkLibrary(win_iconv_dependency.artifact("iconv"));
```
