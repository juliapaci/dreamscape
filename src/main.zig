const std = @import("std");

pub fn main() void {
    std.debug.print("Test {s}\n", .{"hi"});
}
