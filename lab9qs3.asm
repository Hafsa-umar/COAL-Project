[org 0x0100]

jmp start

message db 'hello world', 0
clrscr:
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184fh
    int 10h
    ret
print_string:
    push ax
    push bx
    push si

    mov si, message

next_char:

    lodsb

    cmp al, 0
    je done_print

    mov ah, 0eh
    mov bh, 00h
    int 10h

    jmp next_char

done_print:

    pop si
    pop bx
    pop ax
    ret
waitkey:
    mov ah, 00h
    int 16h
    ret
start:

    push cs
    pop ds
    call clrscr

    mov ah, 02h
    mov bh, 00h
    mov dh, 00h
    mov dl, 00h
    int 10h

    call print_string

    call waitkey

    call clrscr


    mov ah, 02h
    mov bh, 00h
    mov dh, 09h
    mov dl, 44
    int 10h

    call print_string

    call waitkey

    call clrscr
    mov cx, 3
    mov dh, 00h

three_lines:

    push cx
    push dx

    mov ah, 02h
    mov bh, 00h
    mov dl, 00h
    int 10h

    call print_string

    call waitkey

    pop dx
    pop cx

    inc dh

    loop three_lines


    call clrscr

    mov ax, 4c00h
    int 21h