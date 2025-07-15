#include "kernel.h"
#include "process.h"
#include "std.h"


void kernel_main(void) {
  // Embora alguns bootloaders reconheçam a seção .bss e a preencham com zero
  // automaticamente, é uma boa prática nós mesmos limparmos ela.
  memset(__bss, 0, (size_t)__bss_end - (size_t)__bss);

  printf("\n"
         "  _      _     _    ___  ____   ___  \n"
         " (_) ___| |__ | |_ / _ \\/ ___| /   \\/\n"
         " | |/ __| '_ \\| __| | | \\___ \\ \\___/\\\n"
         " | | (__| | | | |_| |_| |___) |          \n"
         " |_|\\___|_| |_|\\__|\\___/|____/           \n"
         "\n");

  if (VERSION[0] == '\0') {
    PANIC("Versão está vazia, defina-a no makefile");
  }

  printf("\n"
         "-------------\n"
         "Versão %s\n"
         "-------------\n"
         "\n",
         VERSION /*versão definida no MakeFile*/);

  // Adicionando parte que vai lidar com as exceções
  WRITE_CSR(stvec, (uint32_t)kernel_entry);
  // __asm__ __volatile__("unimp"); // Força uma exceção de instrução ilegal

  idle_proc = create_process((uint32_t)NULL);
  idle_proc->pid = 0;
  current_proc = idle_proc;
  yield(); // unreachable


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

void handle_trap(struct trap_frame *f) {
  uint32_t scause = READ_CSR(scause);
  uint32_t stval = READ_CSR(stval);
  uint32_t user_pc = READ_CSR(sepc);

  PANIC("unexpected trap scause %x, stval = %xk, sepc=%x", scause, stval,
        user_pc);
}

// TODO: Implementar uma forma de definir quantos milissegundos vai ser esse
// delay
void delay(void) {
  for (int i = 0; i < 30000000; i++) {
    __asm__ __volatile__("nop");
  }
  for (int i = 0; i < 30000000; i++) {
    __asm__ __volatile__("nop");
  }
  for (int i = 0; i < 30000000; i++) {
    __asm__ __volatile__("nop");
  }
  for (int i = 0; i < 30000000; i++) {
    __asm__ __volatile__("nop");
  }
  for (int i = 0; i < 30000000; i++) {
    __asm__ __volatile__("nop");
  }
  for (int i = 0; i < 30000000; i++) {
    __asm__ __volatile__("nop");
  }
}

void map_page(uint32_t *table1, vaddr_t vaddr, paddr_t paddr, uint32_t flags) {
  if (!is_aligned(vaddr, PAGE_SIZE)) {
    PANIC("vaddr %x não está alinhado", vaddr);
  }

  if (!is_aligned(paddr, PAGE_SIZE)) {
    PANIC("paddr %x não está alinhado", paddr);
  }

  uint32_t vpn1 = (vaddr >> 22) & 0x3ff; // 10 bits

  // Se não existir, criamos a page table de primeiro nível
  if ((table1[vpn1] & PAGE_V) == 0) {
    paddr_t pt_paddr = alloc_pages(1);
    table1[vpn1] = ((pt_paddr / PAGE_SIZE) << 10) |
                   PAGE_V; // WARNING: não sei oq tá acontecendo aqui
  }

  // Seta a entrada da tabela de segundo nível pra mapear pra página física
  uint32_t vpn0 = (vaddr >> 12) & 0x3ff; // 10 bits
  uint32_t *table0 =
      (uint32_t *)((table1[vpn1] >> 10) *
                   PAGE_SIZE); // WARNING: não sei oq tá acontecendo aqui tbm
  table0[vpn0] = ((paddr / PAGE_SIZE) << 10) | flags | PAGE_V;
}
