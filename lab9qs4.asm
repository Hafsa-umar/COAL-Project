
[org 0x0100]

jmp start

msg1 db 'Hi, You pressed a', 0
msg2 db 'Hi, You pressed b', 0
msg3 db 'Hi, You entered wrong credentials', 0
clrscr:

    mov ax, 0xb800
    mov es, ax
    mov ax, 0x0720
    mov di, 0
    mov cx, 2000

    cld
    rep stosw

    ret
print_string:

    lodsb

    cmp al, 0
    je finish

    mov ah, 0eh
    mov bh, 0
    int 10h

    jmp print_string

finish:
    ret
start:

    push cs
    pop ds

 
    mov ah, 00h
    int 16h

    call clrscr

    mov ah, 00h
    int 16h
    cmp al, 'a'
    je pressed_a
    cmp al, 'b'
    je pressed_b
    mov si, msg3
    jmp display


pressed_a:

    mov si, msg1
    jmp display


pressed_b:

    mov si, msg2
display:

    call print_string
    mov ax, 4c00h
    int 21h
