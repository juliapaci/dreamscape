const std = @import("std");
const ren = @import("renderer.zig");

pub fn main() void {
    const window = ren.createWindow() catch |err| {
        std.log.err("window creation error: {s}", .{@errorName(err)});

        switch(err) {
            error.glfwWindowCreation,
            error.gladLoading => ren.c.glfwTerminate(),
            else => {}
        }

        return;
    };
    defer ren.c.glfwTerminate();

    var renderer = ren.Renderer.init() catch |err| {
        std.log.err("failed to initialise graphics stuff: {s}", .{@errorName(err)});
        return;
    };
    defer renderer.free();

    while (ren.c.glfwWindowShouldClose(window) == ren.c.GLFW_FALSE) {
        renderer.update();

        if (ren.c.glfwGetKey(window, ren.c.GLFW_KEY_ESCAPE) == ren.c.GLFW_PRESS)
            ren.c.glfwSetWindowShouldClose(window, ren.c.GLFW_TRUE);

        ren.c.glfwSwapBuffers(window);
        ren.c.glfwPollEvents();
    }
}
