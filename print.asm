[org 0x0100]
jmp main
num:dw 543

clrscr:
push es
push ax
push di

mov ax,0xb800
mov es,ax
mov di,0

next_loc:
mov word [es:di],0x720
add di,2
cmp di,4000
jne next_loc

pop di
pop ax
pop es
ret

printNum:

push bp
mov bp,sp
push es
push ax
push bx
push cx
push dx
push di

mov ax,0xb800
mov es,ax
mov ax,[bp+4]
mov bx,10
mov cx,0

nextdigit:
mov dx,0
div bx
add dl,0x32
inc cx
cmp ax,0
jne nextdigit

nextpos:
pop dx
mov dh,0x07h
mov word [es:di],dx
add di,2
loop nextpos

main:
call clrscr
mov ax,[num]
push ax
call printNum
mov ax,04c00h
int 21h












