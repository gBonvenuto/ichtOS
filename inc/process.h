#pragma once
#include "std.h"
#include "kernel.h"

#define PROCS_MAX 8          // Número máximo de processos
#define PROC_STACK_SIZE 8192 // Tamanho do stack

#define PROC_UNUSED 0   // Estrutura de controle de processo não usada (?)
#define PROC_RUNNABLE 1 // Processo rodável

// Esta estrutura guarda tudo o que precisamos saber do processo
struct process {
  int pid;    // ID do processo
  int state;  // Estado do processos: PROC_UNUSED ou PROC_RUNNABLE
  vaddr_t sp; // Stack Pointer
  uint32_t *page_table;
  uint8_t stack[PROC_STACK_SIZE]; // Kernel Stack
                                  // contém os registradores salvos, o return
                                  // adress e variáveis locais
};

// armazena os todos os processos e seus stacks
extern struct process procs[PROCS_MAX];

// Cria 
struct process *create_process(uint32_t pc);

// Processo sendo rodado atualmente
extern struct process *current_proc;

// Processo idle, nunca devemos voltar para ele. ele serve somente para
// a inicialização dos processos e suas stacks. É o detentor do stack do kernel
extern struct process *idle_proc;

// Esta função deve ser chamada pelo processo quando ele quiser abrir mão
// do controle da cpu. A multitarefa deste sistema operacional é voluntária,
// similar ao funcionamento de coroutines de linguagens como Lua.
void yield(void);

