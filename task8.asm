[org 0x100]

mov al, 10101101b  

and al, 01111111b  

xor al, 00000100b  

mov bl, al
and bl, 00000001b
cmp bl, 1
je set

mov byte [result], 0
jmp exit

set:
    mov byte [result], 1

exit:
    mov ax, 0x4c00
    int 0x21

result: db 0