;seek=1 count=1
[bits 16]    ; use 16 bits

[org 0x2000] ; sets the start address
jmp main2

m_load: db 'second sector!',0xa,0xd, 0 
m_protected: db 'entering protected!',0xa,0xd, 0 
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
    
main2:

mov si, m_load



call puts
CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

cli
lgdt [GDT_descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode

jmp $
                                    
                                     
GDT_start:                          ; must be at the end of real mode code
    GDT_null:
        dd 0x0
        dd 0x0

    GDT_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    GDT_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

GDT_end:

GDT_descriptor:
    dw GDT_end - GDT_start - 1
    dd GDT_start


[bits 32]
start_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ;Redefine stack pointer to larger value now we have 4GiB of memory to work with
    mov ebp, 0x90000
    mov esp, ebp

    mov al, 'A'
    mov ax, 0x0F
    mov [0xb8000], ax
    jmp $


; start_protected_mode:

