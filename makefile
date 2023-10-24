CC = nasm
BOOTLDR = boot


build:
	$(CC)  $(BOOTLDR).asm -o $(BOOTLDR).bin -f bin
	$(CC)  $(BOOTLDR)2.asm -o $(BOOTLDR)2.bin -f bin
	cat $(BOOTLDR).bin $(BOOTLDR)2.bin > combined.bin

run:
	sudo qemu-system-x86_64 -drive format=raw,file=combined.bin
clean:
	rm -rf $(BOOTLDR).bin
