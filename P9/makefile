build:
	gcc -m32 -c main.c
	nasm -f elf p9.asm
	gcc -m32 p9.o main.o -no-pie -z noexecstack -o practica9.exe

run:
	./practica9.exe

clean:
	rm -f *.o practica9.exemake