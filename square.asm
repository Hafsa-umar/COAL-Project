[org 0x0100]
jmp main
num: dw 5
result: dw 0

square:

push bp
mov bp,sp

mov ax,[bp+4]
mov bx,ax
mul bx
mov [result],ax


mov sp,bp
pop bp
push word [result]


ret 

main:
mov ax,[num]
call square
pop word [result]
mov ax,0x4c00
int 0x21