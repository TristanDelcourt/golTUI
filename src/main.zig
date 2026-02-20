const std = @import("std");
const term = @import("terminal.zig");
const grid = @import("grid.zig");
const renderer = @import("renderer.zig");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();
    const io = init.io;

    var stdout_buffer: [16344]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    const original = try term.enableRawMode();
    try term.hideCursor(stdout_writer);

    var g = try grid.Grid.init(arena, 100, 50);
    defer g.deinit(arena);

    var prng = std.Random.DefaultPrng.init(@as(u64, @intCast(Io.Clock.now(.real, io).nanoseconds)));
    const rng = prng.random();
    g.seed(rng);

    var stdin_buffer: [10]u8 = undefined;
    while (true) {
        _ = std.posix.read(std.posix.STDIN_FILENO, &stdin_buffer) catch {};
        if (stdin_buffer[0] == 'q') {
            break;
        }

        try renderer.draw(g, stdout_writer);
        g.step();
        try io.sleep(.fromMilliseconds(100), .awake);
    }

    try term.showCursor(stdout_writer);
    try term.disableRawMode(original);
    try stdout_writer.flush();
}
