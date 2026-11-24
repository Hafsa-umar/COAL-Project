[org 0x0100]

jmp start

number: dw 5
result: dw 0

factorial:
    push bp
    mov bp, sp

    mov ax, [bp+4]

    push ax

    mov ax, 1
    push ax

factorial_loop:
    pop ax
    pop bx

    cmp bx, 1
    je factorial_done

    mul bx

    dec bx

    push bx
    push ax

    jmp factorial_loop

factorial_done:
    push ax

    pop bx
    mov ax, bx

    pop bp
    ret 2

start:
    mov ax, [number]
    push ax

    call factorial

    pop word [result]

    mov ax, 0x4c00
    int 0x21