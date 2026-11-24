[org 0x0100]

jmp start

; ==========================================
; DR. DRIVING LITE - PHASE 1
; NASM 8086 | DOSBOX | VGA MODE 13H
; ==========================================

; Drawing variables
x dw 0
y dw 0
w dw 0
h dw 0
color db 0
rowCount dw 0

; Road variables
roadY dw 0
roadHalf dw 0

; Bonnet variables
bonnetY dw 0
bonnetHalf dw 0

; Steering wheel variables
wheelIndex dw 0
wheelWidth dw 0

; Text
distanceText db 'DIST 420 / 1000 m',0
scoreText db 'SCORE 475',0
speedText db '078',0
fuelText db 'FUEL',0

outerWheel db 8,14,19,23,27,30,32,34,35,35,35,35,35,35,35,35,35,34,32,30,27,23,19,14,8

innerWheel db 4,10,14,18,21,24,26,27,28,28,28,28,28,28,28,28,28,27,26,24,21,18,14,10,4


; Rectangle macro
%macro RECT 5
    mov word [x],%1
    mov word [y],%2
    mov word [w],%3
    mov word [h],%4
    mov byte [color],%5
    call drawRect
%endmacro


; ==========================================
; MAIN PROGRAM
; ==========================================

start:

    ; VGA graphics mode
    mov ax,0013h
    int 10h

    mov ax,0A000h
    mov es,ax

    ; Set correct colours
    call setPalette


; ==========================================
; BACKGROUND - SKY
; ==========================================

    RECT 0,0,320,88,09h


; ==========================================
; GRASS
; ==========================================

    RECT 0,88,320,90,02h


; ==========================================
; ROAD - PERSPECTIVE
; ==========================================

    mov word [roadY],88
    mov word [roadHalf],18

roadLoop:

    mov ax,160
    sub ax,[roadHalf]
    mov [x],ax

    mov ax,[roadHalf]
    shl ax,1
    mov [w],ax

    mov ax,[roadY]
    mov [y],ax

    mov word [h],1
    mov byte [color],08h

    call drawRect

    inc word [roadY]
    add word [roadHalf],2

    ; Limit road width
    cmp word [roadHalf],145
    jbe roadContinue

    mov word [roadHalf],145

roadContinue:

    cmp word [roadY],171
    jb roadLoop


; ==========================================
; ROAD EDGES
; ==========================================

    RECT 141,88,2,3,07h
    RECT 177,88,2,3,07h

    RECT 15,168,3,3,07h
    RECT 302,168,3,3,07h


; ==========================================
; LANE DIVIDERS - WHITE DASHES
; ==========================================

    ; Left divider

RECT 153,108,3,7,0Fh
RECT 145,124,3,8,0Fh
RECT 135,142,4,9,0Fh
RECT 125,160,5,10,0Fh

; Right lane divider
RECT 167,108,3,7,0Fh
RECT 175,124,3,8,0Fh
RECT 185,142,4,9,0Fh
RECT 195,160,5,10,0Fh


; ==========================================
; TRAFFIC CAR 1 - LEFT LANE
; BLUE CAR
; ==========================================

    ; Body
    RECT 128,111,23,19,01h

    ; Top
    RECT 132,105,15,8,09h

    ; Windows
    RECT 134,107,5,5,0Bh
    RECT 141,107,4,5,0Bh

    ; Wheels
    RECT 126,124,4,7,00h
    RECT 149,124,4,7,00h


; ==========================================
; TRAFFIC CAR 2 - RIGHT LANE
; GREEN CAR
; ==========================================

    ; Body
    RECT 179,116,22,18,03h

    ; Top
    RECT 183,110,14,8,0Ah

    ; Windows
    RECT 185,112,5,5,0Bh
    RECT 192,112,4,5,0Bh

    ; Wheels
    RECT 177,128,4,7,00h
    RECT 199,128,4,7,00h


; ==========================================
; ORANGE BONNET
; CURVED FRONT VIEW
; ==========================================

    mov word [bonnetY],150
    mov word [bonnetHalf],42

bonnetLoop:

    mov ax,160
    sub ax,[bonnetHalf]
    mov [x],ax

    mov ax,[bonnetHalf]
    shl ax,1
    mov [w],ax

    mov ax,[bonnetY]
    mov [y],ax

    mov word [h],1
    mov byte [color],0Ch

    call drawRect

    inc word [bonnetY]
    add word [bonnetHalf],4

    cmp word [bonnetY],178
    jb bonnetLoop

; ==========================================
; LEFT SIDE MIRROR
; ==========================================

; Mirror stand
RECT 29,143,4,12,00h
RECT 24,151,9,4,08h

; Outer mirror
RECT 14,139,19,13,00h

; Mirror glass
RECT 16,141,15,9,0Bh

; Reflection
RECT 17,142,6,2,0Fh


; ==========================================
; RIGHT SIDE MIRROR
; ==========================================

; Mirror stand
RECT 287,143,4,12,00h
RECT 287,151,9,4,08h

; Outer mirror
RECT 287,139,19,13,00h

; Mirror glass
RECT 289,141,15,9,0Bh

; Reflection
RECT 290,142,6,2,0Fh

; ==========================================
; DASHBOARD
; ==========================================

; Main dashboard
RECT 0,178,320,22,08h

; Upper border
RECT 0,178,320,2,07h

; Lower dark section
RECT 0,196,320,4,00h

; Dashboard left panel
RECT 5,181,65,16,00h

; Dashboard center panel
RECT 75,181,90,16,00h

; Dashboard right panel
RECT 170,181,75,16,00h

; Dashboard highlights
RECT 5,181,65,1,07h
RECT 75,181,90,1,07h
RECT 170,181,75,1,07h


; ==========================================
; TIME BAR - LEFT SIDE
; ==========================================

    ; Outer bar
    RECT 7,43,9,104,07h

    ; Black background
    RECT 9,45,5,100,00h

    ; Red/orange filled section
    RECT 9,91,5,52,04h


; ==========================================
; SPEED BOX
; ==========================================

    RECT 94,181,67,17,07h
    RECT 97,183,61,13,00h


; ==========================================
; FUEL BAR
; ==========================================

    RECT 174,181,72,17,07h
    RECT 177,188,66,7,00h

    ; Half-full green fuel
    RECT 179,190,32,3,02h


; ==========================================
; STEERING WHEEL
; RIGHT SIDE
; ==========================================

; ======================================
; STEERING WHEEL - CIRCULAR DESIGN
; ======================================


; ======================================
; STEERING WHEEL - REFERENCE POSITION
; ======================================

; Black outer rim
RECT 291,154,29,3,00h
RECT 281,157,39,3,00h
RECT 275,160,45,5,00h
RECT 272,165,48,8,00h
RECT 273,173,47,8,00h
RECT 278,181,42,7,00h
RECT 286,188,34,5,00h

; Inner grey area
RECT 295,159,25,3,08h
RECT 287,162,33,5,08h
RECT 282,167,38,8,08h
RECT 283,175,37,5,08h

; Central hub
RECT 300,166,15,16,07h
RECT 303,169,9,10,08h

; ==========================================
; HANDS HOLDING STEERING WHEEL
; ==========================================

; Left wrist
RECT 277,174,7,10,0Eh

; Left hand
RECT 277,167,10,9,0Eh
RECT 280,165,6,5,0Eh

; Right wrist
RECT 312,174,7,10,0Eh

; Right hand
RECT 310,167,9,9,0Eh
RECT 310,165,6,5,0Eh

; ==========================================
; TEXT INFORMATION
; ==========================================

    ; Distance
    mov dh,1
    mov dl,3
    mov si,distanceText
    call printText

    ; Score
    mov dh,2
    mov dl,3
    mov si,scoreText
    call printText

    ; Speed
    mov dh,23
    mov dl,13
    mov si,speedText
    call printText

    ; Fuel
    mov dh,23
    mov dl,23
    mov si,fuelText
    call printText


; ==========================================
; WAIT FOR KEY
; ==========================================

    xor ah,ah
    int 16h

    ; Restore text mode
    mov ax,0003h
    int 10h

    ; Exit
    mov ax,4C00h
    int 21h


; ==========================================
; DRAW RECTANGLE ROUTINE
; ==========================================

drawRect:

    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov ax,0A000h
    mov es,ax

    cld

    ; Clip rectangle to screen width
    mov ax,[x]
    add ax,[w]

    cmp ax,320
    jbe widthOK

    mov ax,320
    sub ax,[x]
    mov [w],ax

widthOK:

    ; Keep row count separate from DX
    mov ax,[h]
    mov [rowCount],ax

    mov si,[y]

rectRow:

    ; Calculate screen offset
    mov ax,si
    mov bx,320
    mul bx

    add ax,[x]
    mov di,ax

    ; Draw one row
    mov al,[color]
    mov cx,[w]

    rep stosb

    inc si

    dec word [rowCount]
    jnz rectRow

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret


; ==========================================
; PRINT TEXT ROUTINE
; ==========================================

printText:

    push ax
    push bx
    push dx
    push si

    mov ah,02h
    mov bh,0
    int 10h

printLoop:

    lodsb

    cmp al,0
    je printDone

    mov ah,0Eh
    mov bh,0
    mov bl,0Fh

    int 10h

    jmp printLoop

printDone:

    pop si
    pop dx
    pop bx
    pop ax

    ret


; ==========================================
; CUSTOM VGA COLOUR PALETTE
; ==========================================

setPalette:

    push ax
    push dx

    ; Light blue sky
    mov dx,03C8h
    mov al,09h
    out dx,al

    inc dx

    mov al,35
    out dx,al

    mov al,48
    out dx,al

    mov al,63
    out dx,al


   ; Natural green grass
    mov dx,03C8h
    mov al,02h
    out dx,al

    inc dx

    mov al,20
    out dx,al

    mov al,38
    out dx,al

    mov al,15
    out dx,al


    ; Grey road
    mov dx,03C8h
    mov al,08h
    out dx,al

    inc dx

    mov al,23
    out dx,al

    mov al,23
    out dx,al

    mov al,26
    out dx,al


    ; Orange bonnet
    mov dx,03C8h
    mov al,0Ch
    out dx,al

    inc dx

    mov al,63
    out dx,al

    mov al,32
    out dx,al

    mov al,5
    out dx,al

    pop dx
    pop ax

    ret