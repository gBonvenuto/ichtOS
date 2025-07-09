const sbiret = struct {
    err: i32,
    val: i32,
};

pub inline fn sbi_call(
    arg0: i32,
    arg1: i32,
    arg2: i32,
    arg3: i32,
    arg4: i32,
    arg5: i32,
    fid: i32,
    eid: i32,
) sbiret {
    const a0: i32 = undefined;
    // Não vamos lidar com isso agora, Zig só consegue fazer um único output,
    // e sinceramente não quero pensar muito sobre alternativas
    const a1: i32 = 0;

    _ = asm volatile(
        \\ecall
        : [a0] "={a0}" (-> i32),
        : [arg0] "{a0}" (arg0),
          [arg1] "{a1}" (arg1),
          [arg2] "{a2}" (arg2),
          [arg3] "{a3}" (arg3),
          [arg4] "{a4}" (arg4),
          [arg5] "{a5}" (arg5),
          [fid] "{a6}" (fid),
          [eid] "{a7}" (eid),
    );

    return sbiret{
        .err = a0,
        .val = a1,
    };
}

pub fn putchar(ch: u8) void{
    _ = sbi_call(ch, 0, 0, 0, 0, 0, 0, 1);
}
