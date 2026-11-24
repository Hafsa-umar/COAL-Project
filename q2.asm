[org 0x0100]
jmp start

title       db ' TEXT VIEWER '
keyword     db 'TEXT'
keywordLen  dw 4

line1 db 'Welcome to the text viewer.'
line2 db 'This document demonstrates scrolling.'
line3 db 'Search for TEXT to highlight matches.'
line4 db 'The viewport protects its borders.'

statusMsg db 'Total Matches Found: '
activeMsg db ' | Viewport Status: ACTIVE'

matchCount dw 0

start:
    push cs
    pop ds

    mov ax, 0B800h
    mov es, ax

    call clear_screen
    call draw_border
    call draw_title
    call display_document
    call find_and_highlight
    call draw_status

    mov ax, 0x4c00
    int 0x21

clear_screen:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es

    mov ax, 0B800h
    mov es, ax

    cld
    mov ax, 0720h
    xor di, di
    mov cx, 2000
    rep stosw

    pop es
    pop di
    pop cx
    pop ax
    pop bp
    ret

draw_border:
    push bp
    mov bp, sp
    sub sp, 2

    push ax
    push bx
    push cx
    push di
    push es

    mov ax, 0B800h
    mov es, ax

    mov di, 3*160 + 8*2
    mov ax, 07CDh
    mov cx, 65
    rep stosw

    mov di, 21*160 + 8*2
    mov cx, 65
    rep stosw

    mov bx, 4

vertical_loop:
    cmp bx, 21
    jge vertical_done

    mov di, bx
    imul di, 160
    add di, 8*2
    mov ax, 07BAh
    mov [es:di], ax

    add di, 64*2
    mov [es:di], ax

    inc bx
    jmp vertical_loop

vertical_done:

    mov di, 3*160 + 8*2
    mov ax, 07C9h
    mov [es:di], ax

    mov di, 3*160 + 72*2
    mov ax, 07BBh
    mov [es:di], ax

    mov di, 21*160 + 8*2
    mov ax, 07C8h
    mov [es:di], ax

    mov di, 21*160 + 72*2
    mov ax, 07BCh
    mov [es:di], ax

    pop es
    pop di
    pop cx
    pop bx
    pop ax

    mov sp, bp
    pop bp
    ret


draw_title:
    push bp
    mov bp, sp
    push ax
    push cx
    push si
    push di
    push es

    mov ax, 0B800h
    mov es, ax

    mov si, title
    mov di, 3*160 + 30*2
    mov cx, 13

title_loop:
    lodsb
    mov ah, 1Eh
    stosw
    loop title_loop

    pop es
    pop di
    pop si
    pop cx
    pop ax
    pop bp
    ret




display_document:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    push es

    mov ax, 0B800h
    mov es, ax

    mov si, line1
    mov di, 4*160 + 10*2
    mov cx, 27
    call display_line

   
    mov si, line2
    mov di, 5*160 + 10*2
    mov cx, 38
    call display_line

    mov si, line3
    mov di, 6*160 + 10*2
    mov cx, 39
    call display_line

    
    mov si, line4
    mov di, 7*160 + 10*2
    mov cx, 38
    call display_line

    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret


display_line:
    push ax
    push cx

line_loop:
    jcxz line_done
    lodsb
    mov ah, 07h
    stosw
    loop line_loop

line_done:
    pop cx
    pop ax
    ret


find_and_highlight:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov ax, 0B800h
    mov es, ax


    mov si, line3
    mov di, 6*160 + 10*2

    mov cx, 39
    mov bx, 0

search_loop:
    cmp cx, 4
    jb search_done

    push cx
    push si
    push di

    mov cx, 4
    push ds
    pop es
    mov di, si
    mov si, keyword
    repe cmpsb

    pop di
    pop si
    pop cx

    mov ax, 0B800h
    mov es, ax
    jne next_character

    
    mov dx, di
    mov bx, 4

highlight_loop:
    mov byte [es:di+1], 0CEh
    add di, 2
    dec bx
    jnz highlight_loop

    mov di, dx
    add di, 8

    inc word [matchCount]
    sub cx, 4
    add si, 4
    add di, 8
    jmp search_loop

next_character:
    inc si
    add di, 2
    dec cx
    jmp search_loop

search_done:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

draw_status:
    push bp
    mov bp, sp
    push ax
    push cx
    push si
    push di
    push es

    mov ax, 0B800h
    mov es, ax

    mov si, statusMsg
    mov di, 23*160
    mov cx, 22

status_loop:
    lodsb
    mov ah, 0Ah
    stosw
    loop status_loop

    mov ax, [matchCount]
    push ax
    call printNum

    mov si, activeMsg
    mov cx, 27

active_loop:
    lodsb
    mov ah, 0Ah
    stosw
    loop active_loop

    pop es
    pop di
    pop si
    pop cx
    pop ax
    pop bp
    ret


printNum:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov ax, [bp+4]
    mov bx, 10
    xor cx, cx

divide_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne divide_loop

print_loop:
    pop dx
    add dl, 30h
    mov ah, 0Ah
    mov al, dl

    push es
    mov bx, 0B800h
    mov es, bx

    
    pop es

    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2