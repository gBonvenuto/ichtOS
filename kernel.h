#pragma once
#include "std.h"

#define PANIC(fmt, ...)                                                        \
  do {                                                                         \
    printf("PANIC: %s:%d: " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__);      \
    while (1) {                                                                \
    }                                                                          \
  } while (0)

extern void kernel_entry(void); // exceptions.s
extern void switch_context(paddr_t *prev_sp,
                           paddr_t *next_sp); // switch_context.s

struct trap_frame {
  uint32_t ra;
  uint32_t gp;
  uint32_t tp;
  uint32_t t0;
  uint32_t t1;
  uint32_t t2;
  uint32_t t3;
  uint32_t t4;
  uint32_t t5;
  uint32_t t6;
  uint32_t a0;
  uint32_t a1;
  uint32_t a2;
  uint32_t a3;
  uint32_t a4;
  uint32_t a5;
  uint32_t a6;
  uint32_t a7;
  uint32_t s0;
  uint32_t s1;
  uint32_t s2;
  uint32_t s3;
  uint32_t s4;
  uint32_t s5;
  uint32_t s6;
  uint32_t s7;
  uint32_t s8;
  uint32_t s9;
  uint32_t s10;
  uint32_t s11;
  uint32_t sp;
} __attribute__((packed));

#define READ_CSR(reg)                                                          \
  ({                                                                           \
    unsigned long __tmp;                                                       \
    __asm__ __volatile__("csrr %0, " #reg : "=r"(__tmp));                      \
    __tmp;                                                                     \
  })

#define WRITE_CSR(reg, value)                                                  \
  do {                                                                         \
    uint32_t __tmp = (value);                                                  \
    __asm__ __volatile__("csrw " #reg ", %0" ::"r"(__tmp));                    \
  } while (0)

// Espera um tempo aí
void delay(void);

void handle_trap(struct trap_frame *f);

#define PROCS_MAX 8          // Número máximo de processos
#define PROC_STACK_SIZE 8192 // Tamanho do stack

#define PROC_UNUSED 0   // Estrutura de controle de processo não usada (?)
#define PROC_RUNNABLE 1 // Processo rodável

struct process {
  int pid;    // ID do processo
  int state;  // Estado do processos: PROC_UNUSED ou PROC_RUNNABLE
  vaddr_t sp; // Stack Pointer
  uint32_t *page_table;
  uint8_t stack[PROC_STACK_SIZE]; // Kernel Stack
                                  // contém os registradores salvos, o return
                                  // adress e variáveis locais
};

extern struct process procs[PROCS_MAX];
struct process *create_process(uint32_t pc);

extern struct process *current_proc;
extern struct process *idle_proc;

void yield(void);

// Paging
#define SATP_SV32 (1u << 31)
#define PAGE_V    (1 << 0)   // "Valid" bit (entry is enabled)
#define PAGE_R    (1 << 1)   // Readable
#define PAGE_W    (1 << 2)   // Writable
#define PAGE_X    (1 << 3)   // Executable
#define PAGE_U    (1 << 4)   // User (accessible in user mode)

void map_page(uint32_t *table1, uint32_t vaddr_t, paddr_t paddr, uint32_t flags);
