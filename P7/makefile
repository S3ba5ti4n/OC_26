# Makefile Practica 7 (NASM i386 en Linux)
NASM = nasm
LD   = ld

build:
	$(NASM) -f elf32 p7.asm -o p7.o
	$(LD) -m elf_i386 p7.o -o p7

run:
	./p7

.PHONY: build run