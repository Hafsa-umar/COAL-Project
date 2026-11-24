
[org 0x0100]

jmp Main

flag: db 0
starPos: dw 0

KeyboardISR:
    push ax

    in al, 0x60

    cmp al, 0x1F
    je ResumeStar

    cmp al, 0x19
    je PauseStar

    jmp ExitISR

ResumeStar:
    mov byte [cs:flag], 1
    jmp ExitISR

PauseStar:
    mov byte [cs:flag], 0

ExitISR:
    in al, 0x61
    mov ah, al
    or al, 0x80
    out 0x61, al
    mov al, ah
    out 0x61, al

    mov al, 0x20
    out 0x20, al

    pop ax
    iret

Move:
    push ax
    push es
    push di
    push cx

    mov ax, 0xB800
    mov es, ax

    mov di, [starPos]
    mov word [es:di], 0x0720

    add word [starPos], 2

    cmp word [starPos], 4000
    jb PrintStar

    mov word [starPos], 0

PrintStar:
    mov di, [starPos]
    mov word [es:di], 0x072A

    mov cx, 0xFFFF

Wait:
    loop Wait

    pop cx
    pop di
    pop es
    pop ax
    ret

Main:
    mov ax, 0xB800
    mov es, ax

    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    rep stosw

    mov word [es:0], 0x072A

    xor ax, ax
    mov es, ax

    cli
    mov word [es:9*4], KeyboardISR
    mov word [es:9*4+2], cs
    sti

L1:
    cmp byte [flag], 1
    jne L1

    call Move
    jmp L1
