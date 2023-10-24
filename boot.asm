[bits 16]    ; use 16 bits
[org 0x7c00] ; sets the start address
jmp start


;sudo dd if=boot2.bin of=/dev/sdb seek=1
;sudo dd if=boot.bin of=/dev/sdb
start:
    mov     ax, 0
    mov     ss, ax
    mov     sp, ax
    mov     ds, ax
    mov     es, ax

    jmp main

; use fdisk to repair MBR partition
; fdisk /dev/sda 
; g
; n p 
; t 1
; 1 
; w

;
; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modifyqemu-system-x86_64
    push si
    push ax
    push bx

.loop:
    lodsb               ; loads next character in al
    cmp al, 0           ; verify if next character is null?
    jz .done

    mov ah, 0x0E        ; call bios interrupt
    ;mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si    
    ret
    

main:
    ; setup data segments

    
    ; setup stack
    mov sp, 0x7C00      

    ; print hello world message


    xor ax, ax    ; make sure ds is set to 0
    mov ds, ax
    cld
    ; start putting in values:
    mov ah, 2h    ; int13h function 2
    mov al, 1    ; we want to read 63 sectors
    mov ch, 0     ; from cylinder number 0
    mov cl, 2     ; the sector number 2 - second sector (starts from 1, not 0)
    mov dh, 0     ; head number 0
    xor bx, bx    
    mov es, bx    ; es should be 0


    mov bx, 0x2000
 ; 512bytes from origin address 7c00h
    int 13h
    cmp ah, 0 
    jnz false
    ;true
    mov si ,msg_load_sucess
    jmp pass
    false:
        mov si,msg_load_fail
        
    pass:
        call puts
    ; mov si, 7e00h
    ; call puts
    in al, 0x92
    or al, 2
    out 0x92, al
    jmp 0x0:0x2000
     ; jump to the next sector


    hlt

.halt:
    jmp .halt



msg_hello: db 'Hello world!',0xa,0xd, 0
msg_load_fail: db 'failed to load',0xa,0xd, 0 
msg_load_sucess: db 'success to load',0xa,0xd, 0 

times 510-($-$$) db 0
dw 0AA55h