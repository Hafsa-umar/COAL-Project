[org 0x0100]

jmp start

chars: db 'A', 'B', 'C', 'D', 'E'
result: db 0, 0, 0, 0, 0

start:

    mov al, [chars]
    mov [result], al

    mov al, [chars+1]
    mov [result+1], al

    mov al, [chars+2]
    mov [result+2], al

    mov al, [chars+3]
    mov [result+3], al

    mov al, [chars+4]
    mov [result+4], al

    mov ax, 0x4c00
    int 0x21