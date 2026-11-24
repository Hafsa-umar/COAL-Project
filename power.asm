[org 0x0100]
jmp main
r:dw 2
n:dw 4
sum:dw 0

series:
push r

series_loop:
mov di,1
push di
call power

add [sum],ax
inc di
cmp di,[n]
jae series_done
jmp series_loop

series_done:
pop di
ret 

power:
push bp
mov bp,sp
mov cx,[bp+4]
mov bx,[bp+6]
mov ax,1

power_loop:

mul bx
loop power_loop

power_done:
pop bp
ret 4

main:

call series