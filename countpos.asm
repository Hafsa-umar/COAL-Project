[org 0x0100]

jmp main:
arr: dw 5,-2,7,-8,3


countpos:
mov ax,[arr+si]
cmp ax,0

jg positive

next:
add si,2
loop countpos
jmp done

positive:
inc bx
add si,2

done:
mov ax,bx
ret

main:

mov bx,0
mov si,0
mov cx,5
call countpos

mov ax,0x4c00
int 0x21