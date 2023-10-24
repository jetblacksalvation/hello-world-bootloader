CC = nasm
BOOTLDR = boot
IMG = myimage.img

build:
	$(CC) $(BOOTLDR).asm -o $(BOOTLDR).bin -f bin
	$(CC) $(BOOTLDR)2.asm -o $(BOOTLDR)2.bin -f bin
	#cat $(BOOTLDR).bin $(BOOTLDR)2.bin > combined.bin
	dd if=/dev/zero of=$(IMG) bs=512 count=2880  # Create a 1.44 MB floppy disk image
	dd if=$(BOOTLDR).bin of=$(IMG) conv=notrunc  # Copy boot sector to the first sector
	dd if=$(BOOTLDR)2.bin of=$(IMG) seek=1 conv=notrunc  # Copy second bootloader to the second sector

run:
	sudo qemu-system-x86_64 -drive format=raw,file=$(IMG)

clean:
	rm -rf $(BOOTLDR).bin $(BOOTLDR)2.bin combined.bin $(IMG)
