const std = @import("std");

pub const Grid = struct {
    pub const Error = error{ OutOfBounds, InvalidSize, OutOfMemory };

    cells: []bool,
    next: []bool,
    w: usize,
    h: usize,

    pub fn init(alloc: std.mem.Allocator, width: usize, height: usize) Error!Grid {
        if (width == 0 or height == 0) {
            return error.InvalidSize;
        }

        return Grid{
            .cells = try alloc.alloc(bool, width * height),
            .next = try alloc.alloc(bool, width * height),
            .w = width,
            .h = height,
        };
    }

    pub fn deinit(self: *Grid, alloc: std.mem.Allocator) void {
        alloc.free(self.cells);
        alloc.free(self.next);
        self.cells = undefined;
        self.next = undefined;
    }

    fn coords(self: Grid, x: usize, y: usize) usize {
        return y * self.w + x;
    }

    pub fn getCell(self: Grid, x: usize, y: usize) Error!bool {
        if (x >= self.w or y >= self.h) {
            return error.OutOfBounds;
        }

        return self.cells[self.coords(x, y)];
    }

    pub fn setCell(self: *Grid, x: usize, y: usize, value: bool) Error!void {
        if (x >= self.w or y >= self.h) {
            return error.OutOfBounds;
        }

        self.cells[self.coords(x, y)] = value;
    }

    pub fn seed(self: *Grid, rand: std.Random) void {
        for (0..self.w * self.h) |i| {
            self.cells[i] = rand.boolean();
        }
    }

    const dx_offset = [8]i8{ -1, -1, -1, 0, 0, 1, 1, 1 };
    const dy_offset = [8]i8{ -1, 0, 1, -1, 1, -1, 0, 1 };

    pub fn step(self: *Grid) void {
        for (0..self.w) |x| {
            for (0..self.h) |y| {
                var neightbors: u8 = 0;

                for (dx_offset, dy_offset) |dx, dy| {
                    const new_x: isize = @mod(@as(isize, @intCast(x)) + @as(isize, @intCast(self.w)) + @as(isize, @intCast(dx)), @as(isize, @intCast(self.w)));
                    const new_y: isize = @mod(@as(isize, @intCast(y)) + @as(isize, @intCast(self.h)) + @as(isize, @intCast(dy)), @as(isize, @intCast(self.h)));
                    if (self.cells[self.coords(@as(usize, @intCast(new_x)), @as(usize, @intCast(new_y)))]) {
                        neightbors += 1;
                    }
                }

                if (neightbors < 2) {
                    self.next[self.coords(x, y)] = false;
                } else if (self.cells[self.coords(x, y)] and neightbors > 3) {
                    self.next[self.coords(x, y)] = false;
                } else if (!self.cells[self.coords(x, y)] and neightbors == 3) {
                    self.next[self.coords(x, y)] = true;
                } else {
                    self.next[self.coords(x, y)] = self.cells[self.coords(x, y)];
                }
            }
        }

        std.mem.swap([]bool, &self.cells, &self.next);
    }
};
