#ifndef STD_H

#define true 1
#define false 0
#define NULL ((void *)0)
#define PAGE_SIZE 4096

// Arredonda um valor para o multiplo mais perto de align
#define align_up(value, align) __builtin_align_up(value, align)

// Verifica se está alinhado (align precisa ser potência de 2)
#define is_aligned(value, align) __builtin_is_aligned(value, align)

// Verifica o offset de um membro do struct
#define offsetof(type, member) __builtin_offsetof(type, member)

#define va_list __builtin_va_list
#define va_start __builtin_va_start
#define va_end __builtin_va_end
#define va_arg __builtin_va_arg

typedef int bool;
typedef char int8_t;
typedef short int16_t;
typedef int int32_t;
typedef long long int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef uint32_t size_t;
typedef uint32_t paddr_t;
typedef uint32_t vaddr_t;

void *memset(void *buf, char c, size_t n);
void *memcpy(void *dst, const void *src, size_t n);
size_t strlen(const char *buf);
char *strncpy(char *dst, const char *src, size_t dst_size);
int strcmp(const char *s1, const char *s2);
void printf(const char *fmt, ...);

// Aloca n páginas (equivalente a PAGE_SIZE bytes (muita coisa))
paddr_t alloc_pages(size_t n);

#endif // !STD_H
