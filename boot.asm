[bits 16]    ; use 16 bits
[org 0x7c00] ; sets the start address
jmp init
; use fdisk to repair MBR partition
; fdisk /dev/sda 
; g
; n p 
; t 1
; 1 
; w

init: 

  mov     ax, 0
  mov     ss, ax
  mov     sp, ax
  mov     ds, ax
  mov     es, ax

  mov si, msg  
  mov ah, 0x0e
print_char:
  mov al, [esi]
  cmp al, 0 ; compares AL to zero
  je done  
  inc esi
  int 0x10  ; print to screen using function 0xe of interrupt 0x10
  jmp print_char ; repeat with next byte
done:
  mov dl,0
  mov ah, 02h
  int 13
  cmp ah, 0
  jnz no
  yes:
  mov si, msg2
  jmp print_char
  no:
  mov si, msg3
  jmp print_char


msg: db "Hello Bootloader! ", 0 ; we need to explicitely put the zero byte here
msg2: db "successful read", 0 
msg3: db "not",0
times 510-($-$$) db 0           ; fill the output file with zeroes until 510 bytes are full
dw 0xaa55                       ; magic number that tells the BIOS this is bootable