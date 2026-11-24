[org 0x0100]

jmp main
arr: dw 5, 8, 2, 10, 3

sum:
 push bp
 mov bp,sp
 push si
 push cx
 

mov si,[bp+6]
mov cx,[bp+4]
mov ax,0

sum_loop:
 add ax,[si]
 add si,2
 loop sum_loop

 pop cx
 pop si
 pop bp
 ret 4 

main:
push arr
push 5
call sumArray