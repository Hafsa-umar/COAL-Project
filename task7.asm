[org 0x100]

mov ax, 0xA5C3      
mov cx, 16        
mov bx, 0        

counting:
    shr ax, 1    
    jnc skip
    inc bx        

skip:
    loop counting

mov [count], bx  

mov ax, 0x4c00
int 0x21

count: dw 0




