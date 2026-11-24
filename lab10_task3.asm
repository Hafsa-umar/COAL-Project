
[org 0x0100]

jmp Main

screenData: times 4000 db 0

prevIntOff: dw 0
prevIntSeg: dw 0

scanCode: db 0
passFlag: db 0

CopyScreen:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov cx, 4000

    mov ax, 0xb800
    mov ds, ax

    push cs
    pop es

    xor si, si
    mov di, screenData

    cld
    rep movsb

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret


PasteScreen:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov cx, 4000

    mov ax, 0xb800
    mov es, ax

    push cs
    pop ds

    mov si, screenData
    xor di, di

    cld
    rep movsb

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret


KeyboardAck:
    push ax

    in al, 0x61
    mov ah, al

    or al, 0x80
    out 0x61, al

    mov al, ah
    out 0x61, al

    pop ax
    ret


NewISR:

    cmp byte [cs:passFlag], 1
    je OldISR

    push ax

    in al, 0x60
    mov [cs:scanCode], al

    cmp al, 0x2E
    je CopyKey

    cmp al, 0xAE
    je CopyRelease

    cmp al, 0x2F
    je PasteKey

    jmp PassKey


CopyKey:

    call CopyScreen
    call KeyboardAck

    mov al, 0x20
    out 0x20, al

    pop ax
    iret


CopyRelease:

    call KeyboardAck

    mov al, 0x20
    out 0x20, al

    pop ax
    iret


PasteKey:

    call PasteScreen
    jmp PassKey


PassKey:

    mov byte [cs:passFlag], 1

    call KeyboardAck

    mov al, 0xD2
    out 0x64, al

    mov al, [cs:scanCode]
    out 0x60, al

    mov al, 0x20
    out 0x20, al

    pop ax
    iret


OldISR:

    mov byte [cs:passFlag], 0

    jmp far [cs:prevIntOff]


Main:

    mov ax, 0x3509
    int 0x21

    push cs
    pop ds

    mov [prevIntOff], bx
    mov [prevIntSeg], es

    mov dx, NewISR
    mov ax, 0x2509
    int 0x21

    mov dx, (EndResident + 15) / 16
    mov ax, 0x3100
    int 0x21


EndResident:
