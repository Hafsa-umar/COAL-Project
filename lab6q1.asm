[org 0x0100]

jmp start

number: dw 5
result: dw 0

square:
    push bp
    mov bp, sp

    mov ax, [bp+4]
    mov bx, ax
    mul bx

    push ax

    pop bx
    mov ax, bx

    pop bp
    ret 2

start:
    mov ax, [number]
    push ax

    call square

    mov [result],ax

    mov ax, 0x4c00
    int 0x21