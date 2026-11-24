[org 0x0100]
jmp main
x:dw 5
y:dw 4

power:
push bp
mov bp,sp
push bx
push cx
push dx

mov bx,[bp+6]
mov cx,[bp+4]
mov ax,1

power_loop:
cmp cx,0
je Power_done
mul bx
loop power_loop

Power_done:
pop dx
pop cx
pop bx
pop bp
ret 4


main:
mov ax,[x]
push ax
mov ax,[y]
push ax
call power
mov ax,0x4c00
int 21h
