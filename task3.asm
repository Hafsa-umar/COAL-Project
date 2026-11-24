[org 0x100]

mov si, 0          
mov di, 0          

l1:
    cmp si, 5      
    jge exit_prog
    mov al, [arrayA + si]
   
    mov bx, 0      

l2:
    cmp bx, 3      
    jge not_found      
    mov dl, [arrayB + bx]
    cmp al, dl
    je next              
    inc bx
    jmp l2

not_found:
    mov [arrayC + di], al
    inc di

next:
    inc si
    jmp l1

exit_prog:
    mov ax, 0x4c00
    int 0x21

arrayA: db 1, 2, 3, 4, 5
arrayB: db 3, 5, 6      
arrayC: db 0, 0, 0, 0, 0