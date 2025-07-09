const sbi = @import("sbi.zig");

pub fn memset(buf: [*]u8, c: u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        buf[i] = c;
    }
    return buf;
}

pub fn memcpy(dst: [*]u8, src: [*]const u8, n: usize) [*]u8 {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        dst[i] = src[i];
    }
    return dst;
}

pub fn strncpy(dst: [*]u8, src: [*:0]const u8) [*:0]u8 {
    var i: usize = 0;
    while (src[i] != 0) : (i += 1) {
        dst[i] = src[i];
        i += 1;
    }
    dst[i] = 0;
    return @ptrCast(dst);
}

pub fn strcmp(s1: [:0]const u8, s2: [:0]const u8) i32 {

    const size = undefined;

    if (s1.len < s2.len) {
        size = s1.len;
    } else {
        size = s2.len;
    }

    for (0..size) |i| {
        const diff: i32 = s1[i] - s2[i];
        if (diff != 0) {
            return diff;
        }
    }
    return 0;
}

pub fn printf(str: [:0]const u8)void {
    for (str) |value| {
        sbi.putchar(value);
    }
}
