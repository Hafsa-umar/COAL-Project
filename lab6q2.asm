[org 0x0100]

jmp start

number1: dw 10
number2: dw 20
result: dw 0

sum:
    push bp
    mov bp, sp

    mov ax, [bp+4]
    mov bx, [bp+6]

    add ax, bx

    push ax

    pop bx
    mov ax, bx

    pop bp
    ret 4

start:
    mov ax, [number1]
    push ax

    mov ax, [number2]
    push ax

    call sum

    pop word [result]

    mov ax, 0x4c00
    int 0x21