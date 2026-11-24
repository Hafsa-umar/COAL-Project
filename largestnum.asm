[org 0x0100]
jmp main
num1: dw 7
num2: dw 12

smallest:
cmp ax,bx
jbe done
mov ax,bx

done:
ret



main:
mov ax,[num1]
mov bx,[num2]
call smallest

mov ax,0x4c00
int 0x21