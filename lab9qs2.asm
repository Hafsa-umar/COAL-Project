[org 0x0100]

jmp start

clrscr:
    push es
    push ax
    push cx
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, 0

    mov ax, 0x0720
    mov cx, 2000

    cld
    rep stosw

    pop di
    pop cx
    pop ax
    pop es
    ret

numberprinting:
    push ax
    push es
    push cx
    push di

    mov ax, 0xb800
    mov es, ax

    mov di, 0
    mov cx, 256
    mov al, 0
    mov ah, 07h

char:
    mov [es:di], ax

    add di, 2
    inc al

    loop char

    pop di
    pop cx
    pop es
    pop ax
    ret

scroolUp:
    push bp
    mov bp, sp
    sub sp, 4000

    push ax
    push cx
    push si
    push di
    push es
    mov ax, 0xb800
    mov es, ax

    xor si, si
    xor di, di
    mov cx, 2000

saveUp:
    mov ax, [es:si]
    mov [bp+di-4000], ax

    add si, 2
    add di, 2
    loop saveUp
    mov si, 800
    xor di, di
    mov cx, 1600

copyUp:
    mov ax, [bp+si-4000]
    mov [es:di], ax

    add si, 2
    add di, 2
    loop copyUp
    xor si, si
    mov di, 3200
    mov cx, 400

copyBottom:
    mov ax, [bp+si-4000]
    mov [es:di], ax

    add si, 2
    add di, 2
    loop copyBottom

    pop es
    pop di
    pop si
    pop cx
    pop ax

    mov sp, bp
    pop bp
    ret

scroolDown:
    push bp
    mov bp, sp
    sub sp, 4000

    push ax
    push cx
    push si
    push di
    push es
    mov ax, 0xb800
    mov es, ax

    xor si, si
    xor di, di
    mov cx, 2000

saveDown:
    mov ax, [es:si]
    mov [bp+di-4000], ax

    add si, 2
    add di, 2
    loop saveDown
    mov si, 3520
    xor di, di
    mov cx, 240

copyDown:
    mov ax, [bp+si-4000]
    mov [es:di], ax

    add si, 2
    add di, 2
    loop copyDown
    xor si, si
    mov di, 480
    mov cx, 1760

copyRest:
    mov ax, [bp+si-4000]
    mov [es:di], ax

    add si, 2
    add di, 2
    loop copyRest

    pop es
    pop di
    pop si
    pop cx
    pop ax

    mov sp, bp
    pop bp
    ret

start:

    call clrscr
    call numberprinting

infinite:

    call scroolUp
    call scroolDown
    jmp infinite