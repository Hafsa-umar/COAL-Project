[org 0x100]

mov cx, 5          
mov ax, 1          

l1:
    cmp cx, 1      
    jle result

    mov bx, ax    
    mov dx, cx    
    dec dx

l2:
    add ax, bx    
    dec dx
    jnz l2

    dec cx        
    jmp l2

result:
    mov [ans], ax

    mov ax, 0x4c00  
    int 0x21

ans: dw 0