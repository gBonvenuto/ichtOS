#include "std.h"
typedef unsigned char uint8_t;
typedef unsigned int uint32_t;
typedef uint32_t size_t;

// NOTE: São ponteiros definidos no kernel.ld, a convenção é usar char[] por
// indicar um endereço brutos no linker. Mas é a mesma coisa que char*
extern uint8_t __bss[], __bss_end[], __stack_top[];

// NOTE: Parece que essa função está só preenchendo um buffer com algum
// caracter
void *memset(void *buf, char c, size_t n) {
  uint8_t *p = (uint8_t *)buf;
  while (n--) {
    *p++ = c;
  }
  return buf;
}

void kernel_main(void) {
  // Embora alguns bootloaders reconheçam a seção .bss e a preencham com zero
  // automaticamente, é uma boa prática nós mesmos limparmos ela.
  memset(__bss, 0, (size_t)__bss_end - (size_t)__bss);

  printf("\n"
            "  _      _     _    ___  ____     _____  \n"
            " (_) ___| |__ | |_ / _ \\/ ___|   /     \\/\n"
            " | |/ __| '_ \\| __| | | \\___ \\   \\_____/\\\n"
            " | | (__| | | | |_| |_| |___) |          \n"
            " |_|\\___|_| |_|\\__|\\___/|____/           \n"
            "\n");

  printf("\n"
            "-------------\n"
            "Versão %s\n"
            "-------------\n"
            "\n", VERSION /*versão definida no MakeFile*/);

  for (;;) {
    __asm__ __volatile__("wfi"); // Esperar por interrupts
  }
  // um loop infinito
}

__attribute__((section(".text.boot"))) __attribute__((naked)) void boot(void) {
  __asm__ __volatile__("mv sp, %[stack_top]\n"
                       "j kernel_main\n"
                       :
                       : [stack_top] "r"(__stack_top));
}
