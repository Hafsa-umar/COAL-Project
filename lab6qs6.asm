[org 0x0100]

jmp start

msg: db 'HELLO$'
buffer: times 6 db 0

start:

    mov si, msg
    mov di, buffer

    mov cx, 5

    add si, 4

reverse_loop:

    mov al, [si]
    mov [di], al

    dec si
    inc di

    loop reverse_loop

    mov al, '$'
    mov [di], al

    mov ax, 0x4c00
    int 0x21