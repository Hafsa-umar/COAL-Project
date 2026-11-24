[org 0x0100]
jmp start
arr:dw 3,4,6,1,7
size:dw 5

odd: dw 0
even:dw 0

even_odd:
push bp
mov bp,sp

mov si,0
mov bx,[bp+6]
mov cx,[bp+4]
check:
mov ax,[bx+si]
mov dl,2
div dl

cmp ah,0
je even

odd:
inc word [odd]
jmp next

even:
inc word [even]
jmp next

next:
add si,2
dec cx
cmp cx,0
je end
jmp check

end:
pop bp
ret 4

start:
mov ax,arr
push ax

mov ax,[size]
push ax

call even_odd

mov ax,0x4c00
int 21h