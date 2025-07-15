#include "process.h"

// NOTE: FUNCIONAMENTO
// cada processo e é representado pelo strcut process.
// Cada processo possui um pid, um state (RUNNABLE ou UNUSED), um stack pointer
// que aponta para o stack do próprio processo, um stack próprio e uma
// page_table, e cada processo possui a sua própria. A tradução do endereço
// de memória virtual para o endereço de memória real é feito pelo próprio
// processador riscv32.

struct process procs[PROCS_MAX] = {(struct process){
    .pid = 0,
    .state = PROC_UNUSED,
    .sp = 0,
    .page_table = NULL,
    .stack = {0},
}};

// ---- Funcionamento ----
// Para criarmos um processo, primeiro precisamos descorbrir um espaço livre
// na nossa array de processos `procs`, isso vai determinar o pid do nosso
// processo e o ponteiro para ele na array de processos.
// Em seguida preenchemos o stack com os valores dos callee saved registers
// (s0-s11) que inicialmente são zero, e depois no topo do stack guardamos o 
// ndereço do retorno (que no caso é o início da função da qual criamos o pro
// esso).
// TODO: escrever sobre a page table
//
// E por fim retornamos o ponteiro para esse processo (que está armazenado na
// nossa array de processos
// -----------------------
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

struct process *current_proc = (struct process *)NULL;
struct process *idle_proc = (struct process *)NULL;

// ---- Funcionamento ----
// Não há ordem de prioridade para a troca dos processos, pegamos o processo
// atual e seguimos pela array de processos a partir dele até encontrarmos um
// processo que pode ser rodado. Dessa forma é garantido que não há starvation
// nem deadlock (pelo menos não por parte do yield) pois todos os processos são
// executados uma vez que o processo precedente abre mão do controle
// -----------------------
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

  // NOTE: entender o que está acontecendo aqui
  __asm__ __volatile__(
      "sfence.vma\n"
      "csrw satp, %[satp]\n"
      "sfence.vma\n"
      "csrw sscratch, %[sscratch]\n" // Isso aqui é para o handler de interrupções
                                     // TODO: entender o porque dele
      :
      : [satp] "r"(SATP_SV32 | ((uint32_t)next->page_table / PAGE_SIZE)),
        [sscratch] "r"((uint32_t)&next->stack[sizeof(next->stack)]));

  switch_context(&prev->sp, &next->sp);
}
