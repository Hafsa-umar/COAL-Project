[org 0x0100]

jmp start

obs: dw 0x6552, 0x2C91, 0x7FA3
numObs: db 3

weights: 
db 2, -3, -1, 10 
db 1, 4, 2, 0 
db -2, 5, 4, -5 

numscore:dw 0,0,0
susscore:dw 0,0,0
atkscore:dw 0,0,0
predFlag:db 0,0,0

start:
mov cx,3
mov di,0

loop1:
mov ax,[obs+di]
mov bx,[obs+di]
mov dx,[obs+di]

shr ax,10
and ax,0x003F


shr bx,5
and bx,0x001F

and dx,0x001F

sub ax,20
sub bx,8
sub dx,16
mov bp,ax

normal_score:
mov si,bp
shl si,1

mov ax,bx
shl ax,1
add ax,bx
neg ax
add si,ax

mov ax,dx
neg ax
add si,ax

add si,10

mov word [numscore+di],si

susp_score:

mov si,bp

mov ax,bx
shl ax,1
shl ax,1
add si,ax

mov ax,dx
shl ax,1
add si,ax

mov word [susscore+di],si

Attack_score:

mov si,bp
shl si,1
neg si

mov ax,bx
shl ax,1
shl ax,1
add ax,bx
add si,ax

mov ax,dx
shl ax,1
shl ax,1
add si,ax

sub si,5

mov word [atkscore+di],si

comparison:

mov si,[numscore+di]
mov bl,1

mov ax,[susscore+di]
cmp ax,si

jle attack


mov si,ax
mov bl,2

attack:
mov ax,[atkscore+di]
cmp ax,si

jle prediction

mov si,ax
mov bl,3

prediction:
mov al,bl
mov bx,di
shr bx,1
mov byte [predFlag+bx],al

add di,2
dec cx
jz end
jmp loop1


end:
mov ax,0x4c00
int 0x21


































