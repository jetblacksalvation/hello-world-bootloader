[bits 16]    ; use 16 bits
[org 0x7c00] ; sets the start address
mov bp,0x9000
mov sp,bp

init: 

  xor     ax, ax
  mov     ss, ax
  mov     sp, ax
  mov     ds, ax
  mov     es, ax

  mov si, msg;
  mov ah, 0x0e ; sets AH to 0xe (function teletype)
  call print_char
  jmp done
print_char:
  start:
  mov al, [esi]
  cmp al, 0 ; compares AL to zero
  jz end_start
  inc esi
  int 0x10  ; print to screen using function 0xe of interrupt 0x10
  jmp start ; repeat with next byte
  end_start:
  ret
done:
  hlt ; stop execution

msg: db "Hello Bootloader!", 0 ; we need to explicitely put the zero byte here

times 510-($-$$) db 0           ; fill the output file with zeroes until 510 bytes are full
dw 0xaa55                       ; magic number that tells the BIOS this is bootable