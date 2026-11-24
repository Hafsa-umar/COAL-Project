[org 0x0100]

jmp start

msg: db 'Assembly Rocks$', 0
buffer: times 16 db 0

start:

    mov si, msg
    mov di, buffer

copy_loop:

    mov al, [si]
    mov [di], al

    cmp al, 0
    je done

    inc si
    inc di

    jmp copy_loop

done:

    mov ax, 0x4c00
    int 0x21