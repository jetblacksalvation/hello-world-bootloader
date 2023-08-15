CC = nasm
BOOTLDR = boot


build:
	$(CC)  $(BOOTLDR).asm -o $(BOOTLDR).bin -f bin

run:
	sudo qemu-system-x86_64 $(BOOTLDR).bin
clean:
	rm -rf $(BOOTLDR).bin