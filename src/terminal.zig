const std = @import("std");

pub fn enableRawMode() !std.posix.termios {
    const state = try std.posix.tcgetattr(std.posix.STDIN_FILENO);
    var stateCpy = state;

    stateCpy.lflag.ECHO = false;
    stateCpy.lflag.ICANON = false;
    stateCpy.lflag.ISIG = false;
    stateCpy.lflag.IEXTEN = false;

    stateCpy.iflag.IXON = false;
    stateCpy.iflag.ICRNL = false;
    stateCpy.iflag.BRKINT = false;
    stateCpy.iflag.INPCK = false;
    stateCpy.iflag.ISTRIP = false;

    stateCpy.oflag.OPOST = false;

    stateCpy.cc[@intFromEnum(std.posix.V.MIN)] = 0;
    stateCpy.cc[@intFromEnum(std.posix.V.TIME)] = 0;

    try std.posix.tcsetattr(std.posix.STDIN_FILENO, .FLUSH, stateCpy);

    return state;
}

pub fn disableRawMode(original: std.posix.termios) !void {
    try std.posix.tcsetattr(std.posix.STDIN_FILENO, .FLUSH, original);
}

pub fn clear(writer: anytype) !void {
    try writer.writeAll("\x1B[2J\x1B[H");
}

pub fn hideCursor(writer: anytype) !void {
    try writer.writeAll("\x1B[?25l");
}

pub fn showCursor(writer: anytype) !void {
    try writer.writeAll("\x1B[?25h");
}
