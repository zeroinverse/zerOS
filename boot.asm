org 0x7c00
bits 16

start:
    mov ah, 0eh
    mov al, 'U'
    mov bx, 0
    int 0x10    ; Int 10/AH=0Eh - VIDEO - TELETYPE OUTPUT
    jmp $

times 510-($-$$) db 0
; 510 - (current address - section starting address) times DB 0
dw 0xaa55
; DB - 1 W
; DW - 2 W
; DD - 4 W