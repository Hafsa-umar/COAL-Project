[org 0x100]

mov si, 0          
mov di, 0        

l1:
    cmp si, 5    
    jge end
    mov al, [arrayA + si]
   
    mov bx, 0  

l2:
    cmp bx, 5      
    jge next
    mov dl, [arrayB + bx]
    cmp al, dl
    je intersection
    inc bx
    jmp l2

intersection:
    mov [arrayC + di], al
    inc di
    jmp next

next:
    inc si
    jmp l1

end:
    mov ax, 0x4c00
    int 0x21

arrayA: db 1, 2, 3, 4, 5
arrayB: db 3, 4, 6, 7, 8
arrayC: db 0, 0, 0, 0, 0