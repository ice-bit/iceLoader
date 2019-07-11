ASM = nasm
AFLAGS = -felf32 -o iceLoader
CC = i686-elf-gcc
CFLAGS = -nostdlib -ffreestanding -fno-exceptions -nostdlib -Wall -Wextra -Werror

all:
	make compile-asm
	make compile-c
	make run

compile-asm:
	$(ASM) iceLoader.asm $(AFLAGS)

compile-c:
	$(CC) $(CFLAGS) kernel.c iceLoader -T linker.ld -o kernel.bin

run:
	qemu-system-x86_64 -fda kernel.bin -curses

clean:
	rm -f kernel.bin iceLoader 
