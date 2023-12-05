const std = @import("std");

const stdout_file = std.io.getStdOut().writer();
var cw = std.io.countingWriter(stdout_file);
const stdout = cw.writer();

fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(buffer, '\n')) orelse return null;
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}

const Cubes = struct {
    red: u8,
    green: u8,
    blue: u8,

    fn is_impossible(self: @This()) bool {
        return self.red > 12 or self.green > 13 or self.blue > 14;
    }
};

const CubeKind = enum {
    Red,
    Green,
    Blue,
};

const cube_map = std.ComptimeStringMap(CubeKind, .{
    .{ "red", .Red },
    .{ "green", .Green },
    .{ "blue", .Blue },
});

fn get_cubes(subst: []const u8) !Cubes {
    var cubes = Cubes{ .red = 0, .green = 0, .blue = 0 };
    var iter = std.mem.splitAny(u8, subst, " ,");
    while (iter.next()) |item| {
        if (item.len == 0) continue;
        const n = try std.fmt.parseInt(u8, item, 10);
        switch (cube_map.get(iter.next().?).?) {
            .Red => cubes.red += n,
            .Green => cubes.green += n,
            .Blue => cubes.blue += n,
        }
    }
    return cubes;
}

fn process_line(line: []const u8) !u32 {
    var iter = std.mem.splitAny(u8, line, ":;");
    var game = std.mem.splitAny(u8, iter.first(), " ");
    if (!std.mem.eql(u8, game.first(), "Game")) {
        std.debug.panic("line doesn't start with \"Game\"", .{});
    }
    const game_id = try std.fmt.parseInt(u32, game.next().?, 10);
    while (iter.next()) |subset| {
        if ((try get_cubes(subset)).is_impossible()) {
            return 0;
        }
    }
    return game_id;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();
    var buffer: [256]u8 = undefined;
    var sum: u32 = 0;
    while (try nextLine(file.reader(), &buffer)) |line| {
        sum += try process_line(line);
    }
    try stdout.print("{d}\n", .{sum});
}
