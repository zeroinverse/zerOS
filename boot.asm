org 0x7c00
bits 16

start:
    mov si, string
    call print

print:
    mov bx, 0; used for forground and background color
.loop:
    lodsb; Load SI ot AL and increment SI
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

string: db 'Hello World!', 0

times 510 - ($ - $$) db 0
dw 0xAA55; bootloader signature is 0x55aa, written in little endian because Intel