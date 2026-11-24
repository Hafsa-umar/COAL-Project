org 0x100]

mov al, 10110101b  

rol al, 4          

mov [result], al  

mov ax, 0x4c00
int 0x21

result: db 0