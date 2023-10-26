CC = clang
NASM = nasm
BOOTLDR = boot
KERNEL = kernel
IMG = myimage.img


build:
	$(NASM) $(BOOTLDR).asm -o $(BOOTLDR).bin -f bin
	$(NASM) $(BOOTLDR)2.asm -o $(BOOTLDR)2.bin -f bin
# Compile the C source file to an object file
	clang -c kernel/kernel.c -o kernel/kernel.o -m32 -ffreestanding -nostdlib -O2 -Wall -Wextra -g 

# Link the object file using the linker script
	clang -m32 -ffreestanding -nostdlib -T kernel/kernel.ld kernel.o -o kernel.bin 

	cat $(BOOTLDR).bin $(BOOTLDR)2.bin $(KERNEL).bin > combined.bin
	dd if=/dev/zero of=$(IMG) bs=512 count=2880  # Create a 1.44 MB floppy disk image
	dd if=$(BOOTLDR).bin of=$(IMG) conv=notrunc  # Copy boot sector to the first sector
	dd if=$(BOOTLDR)2.bin of=$(IMG) seek=1 conv=notrunc  # Copy second bootloader to the second sector
	dd if=$(KERNEL).bin of=$(IMG) seek=10 conv=notrunc  # Copy kernel to the 10th sector (adjust as needed)

run:
	sudo qemu-system-x86_64 -drive format=raw,file=$(IMG)

clean:
	rm -rf $(BOOTLDR).bin $(BOOTLDR)2.bin $(KERNEL).bin $(C_OBJECTS) combined.bin $(IMG)
