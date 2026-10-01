p5: p5.o
	gcc -m32 -no-pie p5.o -o p5

p5.o: p5.asm
	nasm -f elf32 p5.asm -o p5.o

clean:
	rm -f p5.o p5
