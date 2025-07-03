#include "std.h"
#include "sbi.h"

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

        while (val/ordem_grandeza> 1) {
          ordem_grandeza *= 10;
        }

        while (ordem_grandeza > 0) {
          sbi_putchar('0' + ((val / ordem_grandeza )%10));
          ordem_grandeza/=10;
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
