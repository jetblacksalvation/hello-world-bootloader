;seek=1 count=1
[org 0x2000] ; sets the start address
jmp main2

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
    mov si ,m_load
    call puts
    hlt
    



m_load: db 'second sector!',0xa,0xd, 0 
