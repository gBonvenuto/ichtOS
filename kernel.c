#include "kernel.h"
#include "std.h"

// NOTE: São ponteiros definidos no kernel.ld, a convenção é usar char[] por
// indicar um endereço brutos no linker. Mas é a mesma coisa que char*
extern uint8_t __bss[], __bss_end[], __stack_top[];
extern uint8_t __kernel_base[], __free_ram[], __free_ram_end[];

// WARNING: apagar isso depois (é só pra testar a criação de processos)
struct process *proc_a;
struct process *proc_b;

void proc_a_entry(void) {
  while (true) {
    printf("A\n");
    yield();
    delay();
  }
}

void proc_b_entry(void) {
  while (true) {
    printf("B\n");
    yield();
    delay();
  }
}

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

  // NOTE: teste de alocação de memória
  {
    paddr_t paddr0 = alloc_pages(2);
    paddr_t paddr1 = alloc_pages(1);
    printf("alloc_pages test: paddr0=%x\n", paddr0);
    printf("alloc_pages test: paddr1=%x\n", paddr1);
  }

  idle_proc = create_process((uint32_t)NULL);
  idle_proc->pid = 0;
  current_proc = idle_proc;

  // NOTE: teste de criação de processos
  {
    proc_a = create_process((uint32_t)proc_a_entry);
    proc_b = create_process((uint32_t)proc_b_entry);
    yield();
    PANIC("voltamos pro idle process");
  }

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

struct process procs[PROCS_MAX] = {(struct process){
    .pid = 0,
    .state = PROC_UNUSED,
    .sp = 0,
    .stack = {0},
}};

struct process *create_process(uint32_t pc) {
  printf("create_process: pc=%x\n", pc);
  struct process *proc = (struct process *)NULL;
  size_t pid;
  for (pid = 0; pid < PROCS_MAX; pid++) {
    if (procs[pid].state == PROC_UNUSED) {
      proc = &procs[pid];
      break;
    }
  }

  if (proc == NULL) {
    PANIC("Não há mais slots livres");
  }

  uint32_t *sp = (uint32_t *)&proc->stack[PROC_STACK_SIZE];
  for (size_t i = 1; i < 13; i++) { // Preencher o s0 a s11 com zeros
    sp -= 1;
    *sp = 0;
  }
  sp -= 1;
  *sp = (uint32_t)pc; // Preenchendo o ra com o ponteiro da função

  // Por fim fazemos o map das kernel pages
  uint32_t *page_table = (uint32_t *)alloc_pages(1);
  for (paddr_t paddr = (paddr_t)__kernel_base; paddr < (paddr_t)__free_ram_end;
       paddr += PAGE_SIZE) {
    map_page(page_table, paddr, paddr, PAGE_R | PAGE_W | PAGE_X);
  }

  proc->pid = pid + 1;
  proc->state = PROC_RUNNABLE;
  proc->sp = (uint32_t)sp;
  proc->page_table = page_table;
  printf("Processo criado com pid=%x e sp=%x\n", proc->pid, proc->sp);
  return proc;
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

struct process *current_proc = (struct process *)NULL;
struct process *idle_proc = (struct process *)NULL;

void yield(void) {
  printf("yelding\n");
  struct process *next = idle_proc;
  for (size_t i = 0; i < PROCS_MAX; i++) {
    struct process *proc = &procs[(current_proc->pid + i) % PROCS_MAX];
    if (proc->state == PROC_RUNNABLE && proc->pid > 0) {
      next = proc;
      break;
    }
  }

  if (next == current_proc) {
    return;
  }

  struct process *prev = current_proc;
  current_proc = next;
  printf("switching context %d -> %d\n", prev->pid, next->pid);

    //NOTE: entender o que está acontecendo aqui
    __asm__ __volatile__(
        "sfence.vma\n"
        "csrw satp, %[satp]\n"
        "sfence.vma\n"
        "csrw sscratch, %[sscratch]\n"
        :
        : [satp] "r" (SATP_SV32 | ((uint32_t) next->page_table / PAGE_SIZE)),
          [sscratch] "r" ((uint32_t) &next->stack[sizeof(next->stack)])
    );

  switch_context(&prev->sp, &next->sp);
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
