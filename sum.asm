[org 0x0100]
jmp main
num1: dw 5
num2:dw 10
result: dw 0

sum:
push bp
mov bp,sp
mov ax,[bp+6]
mov bx,[bp+4]
add ax,bx
mov word [result],ax

mov sp,bp
pop bp
push word [result]

ret 



main:
mov ax,[num1]
mov bx,[num2]
push ax
push bx
call sum
pop word [result]
mov ax,0x4c00
int 0x21