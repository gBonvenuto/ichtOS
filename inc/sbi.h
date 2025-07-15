#pragma once

struct sbiret {
  long error;
  long value;
};

// Função Wrapper para podermos invocar a SBI
struct sbiret sbi_call(long arg0, long arg1, long arg2, long arg3, long arg4,
                       long arg5, long fid /*function id*/,
                       long eid /*extension id*/);

// Coloca um caractere no Console pela SBI
void sbi_putchar(char c);
