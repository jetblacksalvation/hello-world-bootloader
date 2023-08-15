run:
	nasm  boot.asm -o boot.bin -f bin
	qemu-system-x86_64 boot.bin