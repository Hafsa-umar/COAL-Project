[org 0x0100]
jmp start
arr: dw 1,2,3,4,5
key: dw 3
size:dw 5

start:
mov si,0
mov di,4

search:
cmp si,di
jg notfound

mov ax,si
add ax,di
mov bl,2
div bl

middle:
mov dl,al
mov dh,0

mov bx,dx
shl bx,1

mov ax,[arr+bx]
cmp ax,[key]
je found
jb rightside

mov al,dl
mov ah,0
dec ax
mov dl,ax
jmp search

rightside:
mov al,dl
mov ah,0
inc ax
mov si,ax
jmp search

found:
mov ax,0x4c00
int 0x21

notfound:
mov ax,0x4c00
int 0x21

