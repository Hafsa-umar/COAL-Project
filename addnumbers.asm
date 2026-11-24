[org 0x0100]

jmp main
num1: dw 5
num2: dw 6

addnumbers:
push bp
mov bp,sp
mov ax,[bp+6]
mov bx,[bp+2]
add ax,bx

pop bp
pop bx
pop ax

ret 4

main:
push [num1]
push [num2]
call addnumbers

mov ax,0x4c00
int 0x21