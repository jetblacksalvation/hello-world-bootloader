run:
	nasm  boot.asm -o boot.bin -f bin
	sudo dd if=boot.bin bs=512 of=boot.img
	qemu-system-x86_64 boot.img