[org 0x100]

mov ax, 12          

mov bx, ax        
shl bx, 1          
mov [mult_res], bx  

mov cx, ax        
shr cx, 1          
mov [div_res], cx  

mov ax, 0x4c00
int 0x21

mult_res: dw 0
div_res:  dw 0