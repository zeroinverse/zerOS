org 0
bits 16
; https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:step2

; https://wiki.osdev.org/Exceptions
handle_zero:
    mov ah, 0eh
    mov al, '0'
    mov bx, 0x00
    int 0x10 ; print Z in case this routine is called
    iret

handle_one:
    mov ah, 0eh
    mov al, '1'
    mov bx, 0x00
    int 0x10
    iret

step2:
    cli ; clear interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; enable interrupts
    
    ; provide custom routine for INT 0 exception
    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0
    mov ax, 0x00
    div ax ; divide by zero calls INT 0 exception

    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0
    ; call exception 
    int 1
    
    mov si, string
    call print
    jmp $

print:
    mov bx, 0 ; used for forground and background color
.loop:
    lodsb ; Load SI ot AL and increment SI
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