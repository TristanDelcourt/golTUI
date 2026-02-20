const grid = @import("grid.zig");
const term = @import("terminal.zig");

pub fn draw(g: grid.Grid, writer: anytype) !void {
    try term.clear(writer);
    for (0..g.h) |y| {
        for (0..g.w) |x| {
            if (g.cells[y * g.w + x]) {
                try writer.writeAll("\u{2588}");
            } else {
                try writer.writeAll(" ");
            }
        }

        try writer.writeAll("\r\n");
    }

    try writer.flush();
}
