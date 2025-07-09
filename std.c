#include "std.h"
#include "kernel.h"
#include "sbi.h"

void *memset(void *buf, int8_t c, size_t n) {
  int8_t *buf8 = (int8_t *)buf;
  for (size_t i = 0; i < n; i++) {
    buf8[i] = c;
  }
  return buf;
}

void *memcpy(void *dst, const void *src, size_t n) {
  uint8_t *dst8 = (uint8_t *)dst;
  const uint8_t *src8 = (const uint8_t *)src;
  for (size_t i = 0; i < n; i++) {
    dst8[i] = src8[i];
  }
  return dst;
}

size_t strlen(const char *buf) {
  size_t i = 0;
  for (; buf[i] != '\0'; i++)
    ;
  return i;
}

char *strncpy(char *dst, const char *src, size_t dst_size) {

  for (size_t i = 0; i < dst_size; i++) {
    dst[i] = src[i];
    if (src[i] != '\0')
      break;
  }

  dst[dst_size] = '\0';

  return dst;
}

int strcmp(const char *s1, const char *s2) {
  for (size_t i = 0; s1[i] != s2[i] && s1[i] != '\0' && s2[i] != '\0'; i++) {
    int cmp = s1[i] - s2[i];
    if (cmp != 0)
      return cmp;
  }
  return 0;
}

void printf(const char *fmt, ...) {
  va_list vargs;
  va_start(vargs, fmt);

  while (*fmt) {
    if (*fmt == '%') {
      fmt++;
      switch (*fmt) {
      case '\0':
        goto end;
        break;
      case '%':
        sbi_putchar('%');
        break;

      case 's': { // Printa a string (terminada em \0)
        const char *s = va_arg(vargs, const char *);
        while (*s != '\0') {
          sbi_putchar(*s);
          s++;
        }
        break;
      }

      case 'd': {
        // NOTE: no livro é implementado de outra forma. Como o projeto é meu,
        // vou fazer a implementação inicial do meu jeito e depois quando for
        // mudar pra Zig eu vejo qual é o real problema dessa implementação
        // minha.
        int val = va_arg(vargs, int);

        if (val == 0) {
          sbi_putchar('0');
          break;
        }

        if (val < 0) {
          sbi_putchar('-');
          val = -val;
        }

        int ordem_grandeza = 1;

        while (val / ordem_grandeza > 1) {
          ordem_grandeza *= 10;
        }

        while (ordem_grandeza > 0) {
          sbi_putchar('0' + ((val / ordem_grandeza) % 10));
          ordem_grandeza /= 10;
        }
        break;
      }
      case 'x': {
        // NOTE: essa parte fiz igual do livro porque achei genial
        unsigned int val = va_arg(vargs, int);

        sbi_putchar('0');
        sbi_putchar('x');
        for (int i = 7; i >= 0; i--) {
          unsigned nibble = (val >> (i * 4)) & 0b1111;
          sbi_putchar("0123456789abcdef"[nibble]);
        }
        break;
      }
      }
    } else {
      sbi_putchar(*fmt);
    }
    fmt++;
  }

end:
  va_end(vargs);
}

extern uint8_t __free_ram[], __free_ram_end[];

// TODO: pesquisar como deixar isso mais sofisticado, o guide comentou sobre
// um buddy system
paddr_t alloc_pages(size_t n) {
  static paddr_t next_paddr = (paddr_t)__free_ram;
  paddr_t paddr = next_paddr;
  next_paddr += n * PAGE_SIZE;

  if (next_paddr > (paddr_t)__free_ram_end) {
    PANIC("Sem memória!");
  }

  memset((void *)paddr, 0,
         n * PAGE_SIZE); // TODO: verificar se isso é necessário
  return paddr;
}
