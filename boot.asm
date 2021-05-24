org 0
bits 16
; https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:step2

step2:
    cli ; clear interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; enable interrupts
    ; read data from hard disk using Cylinder-head-sector
    mov ah, 2 ; read sector command
    mov al, 1 ; read one sector
    mov ch, 0 ; low eight bits of cylinder number
    mov cl, 2 ; read sector 2
    mov dh, 0 ; head number
    ; drive number is set by default (bit 7 set for hard disk)
    mov bx, buffer ; write read data to buffer
    int 0x13
    jc error
    mov si, buffer
    call print
    jmp $

error:
    mov si, err_message
    call print_char
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

err_message: db 'failed to load sector', 0

times 510 - ($ - $$) db 0
dw 0xAA55; bootloader signature is 0x55aa, written in little endian because Intel 
; buffer points to after first sector
buffer; dummmy variable so that the disk read does not override anything