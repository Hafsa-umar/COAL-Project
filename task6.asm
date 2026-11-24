[org 0x100]

mov al, 11010010b  
mov cx, 8        
mov bl, 0        

reverse:
    shl al, 1    
    rcr bl, 1      
    loop reverse

mov [result], bl  

mov ax, 0x4c00
int 0x21

result: db 0