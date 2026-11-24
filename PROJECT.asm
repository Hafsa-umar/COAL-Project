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
colX dw 0
bTop dw 0

; Ring (circle) variables
ringCX dw 0
ringCY dw 0
ringRo dw 0
ringRi dw 0
ringRo2 dw 0
ringRi2 dw 0
ringY dw 0
ringDy dw 0
ringDy2 dw 0
ringOx dw 0
ringIx dw 0
ringColor db 0

; Slanted bar (arms) variables
slX0 dw 0
slY0 dw 0
slX1 dw 0
slY1 dw 0
slW dw 0
slY dw 0

; Lane divider variables
divY   dw 0
divLen dw 0
divOff dw 0
divW   dw 0

; Building variables
bdX   dw 0
bdY   dw 0
bdW   dw 0
bdH   dw 0
bdClr db 0
bdWin dw 0
bdGap dw 0
bdWx  dw 0
bdWy  dw 0


; Text
textColor db 0Fh
distanceText db 'DIST 420 / 1000 m',0
scoreText db 'SCORE 475',0
timeText db 'Time',0
speedText db '078',0
kmhText db 'km/h',0
fuelText db 'FUEL',0
emptyText db 'E',0
fullText db 'F',0


; ==========================================
; MACROS
; ==========================================

; RECT x,y,w,h,color
%macro RECT 5
    mov word [x],%1
    mov word [y],%2
    mov word [w],%3
    mov word [h],%4
    mov byte [color],%5
    call drawRect
%endmacro

; RING cx,cy,outerRadius,innerRadius,color  (inner=0 -> filled disc)
%macro RING 5
    mov word [ringCX],%1
    mov word [ringCY],%2
    mov word [ringRo],%3
    mov word [ringRi],%4
    mov byte [ringColor],%5
    call drawRing
%endmacro

; SLANT xBottom,yBottom,xTop,yTop,width,color  (x = left edge)
%macro SLANT 6
    mov word [slX0],%1
    mov word [slY0],%2
    mov word [slX1],%3
    mov word [slY1],%4
    mov word [slW],%5
    mov byte [color],%6
    call slant
%endmacro

; TEXT row,col,color,label
%macro TEXT 4
    mov dh,%1
    mov dl,%2
    mov byte [textColor],%3
    mov si,%4
    call printText
%endmacro

; SETPAL index,r,g,b  (6-bit values 0-63)
%macro SETPAL 4
    mov dx,03C8h
    mov al,%1
    out dx,al
    inc dx
    mov al,%2
    out dx,al
    mov al,%3
    out dx,al
    mov al,%4
    out dx,al
%endmacro

; BUILD x,y,w,h,color,windowSize,windowGap
%macro BUILD 7
    mov word [bdX],%1
    mov word [bdY],%2
    mov word [bdW],%3
    mov word [bdH],%4
    mov byte [bdClr],%5
    mov word [bdWin],%6
    mov word [bdGap],%7
    call drawBuilding
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
; BUILDINGS - TIGHTLY PACKED ALONG THE ROAD
; Far (centre) to near (screen edge).
; Alternating tall / short, growing with
; perspective. No gaps between buildings.
; BUILD x,y(top),w,h,color,winSize,winGap
; ==========================================

    ; ---------- LEFT SIDE ----------
    BUILD 130,80,10,14,17h,2,3      ; tall (far)
    BUILD 118,90,12,10,19h,2,3      ; short
    BUILD 104,72,14,35,18h,3,3      ; tall
    BUILD 88,96,16,19,17h,3,4       ; short
    BUILD 68,62,20,63,19h,4,4       ; tall
    BUILD 44,108,24,29,18h,4,5      ; short
    BUILD 16,45,28,106,17h,5,5      ; tall (near)
    BUILD 0,122,16,37,19h,4,4       ; short (edge)

    ; ---------- RIGHT SIDE (mirror) ----------
    BUILD 180,80,10,14,17h,2,3
    BUILD 190,90,12,10,19h,2,3
    BUILD 202,72,14,35,18h,3,3
    BUILD 216,96,16,19,17h,3,4
    BUILD 232,62,20,63,19h,4,4
    BUILD 252,108,24,29,18h,4,5
    BUILD 276,45,28,106,17h,5,5
    BUILD 304,122,16,37,19h,4,4


; ==========================================
; ROAD - PERSPECTIVE (with white edge lines)
; ==========================================

    mov word [roadY],88
    mov word [roadHalf],18

roadLoop:

    ; Road row
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

    ; Left white edge
    mov ax,160
    sub ax,[roadHalf]
    mov [x],ax
    mov word [w],3
    mov byte [color],0Fh
    call drawRect

    ; Right white edge
    mov ax,160
    add ax,[roadHalf]
    sub ax,3
    mov [x],ax
    mov word [w],3
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
; LANE DIVIDERS - WHITE DASHES
; ==========================================

    ; Left divider
    RECT 153,108,3,7,0Fh
    RECT 145,124,3,8,0Fh
    RECT 135,142,4,9,0Fh
    RECT 125,160,5,10,0Fh

    ; Right divider
    RECT 167,108,3,7,0Fh
    RECT 175,124,3,8,0Fh
    RECT 185,142,4,9,0Fh
    RECT 195,160,5,10,0Fh


; ==========================================
; TRAFFIC CAR 1 - LEFT LANE (BLUE)
; ==========================================

    RECT 128,111,23,19,01h
    RECT 132,105,15,8,09h
    RECT 134,107,5,5,0Bh
    RECT 141,107,4,5,0Bh
    RECT 126,124,4,7,00h
    RECT 149,124,4,7,00h


; ==========================================
; TRAFFIC CAR 2 - RIGHT LANE (GREEN)
; ==========================================

    RECT 179,116,22,18,03h
    RECT 183,110,14,8,0Ah
    RECT 185,112,5,5,0Bh
    RECT 192,112,4,5,0Bh
    RECT 177,128,4,7,00h
    RECT 199,128,4,7,00h


; ==========================================
; ORANGE BONNET - CURVED / DOMED FRONT
; Each column's top edge follows a parabola:
;   top = 140 + (x-160)^2 / 900
; Highest in the middle, curving down to
; both sides. A light highlight runs along
; the curve and a dark shade sits at the base.
; ==========================================

    mov word [colX],0

bonnetCol:

    mov ax,[colX]
    sub ax,160
    jns bonnetPos
    neg ax

bonnetPos:

    mul ax                  ; dx:ax = dx*dx
    xor dx,dx
    mov bx,900
    div bx
    add ax,140
    cmp ax,168
    jbe bonnetTopOK
    mov ax,168
bonnetTopOK:
    mov [bTop],ax

    ; Orange body
    mov ax,[colX]
    mov [x],ax
    mov ax,[bTop]
    mov [y],ax
    mov ax,168
    sub ax,[bTop]
    mov [h],ax
    mov word [w],1
    mov byte [color],0Ch
    call drawRect

    ; Dark shade at base of bonnet
    cmp word [bTop],162
    jae bonnetNoShade

    mov ax,[colX]
    mov [x],ax
    mov word [y],163
    mov word [h],5
    mov word [w],1
    mov byte [color],11h
    call drawRect

bonnetNoShade:

    ; Light highlight on the curved edge
    mov ax,[colX]
    mov [x],ax
    mov ax,[bTop]
    mov [y],ax
    mov word [h],2
    mov word [w],1
    mov byte [color],0Dh
    call drawRect

    inc word [colX]
    cmp word [colX],320
    jb bonnetCol

    ; Soft shine streak across the dome
    RECT 115,145,90,1,0Dh
    RECT 95,150,130,1,0Dh


; ==========================================
; DASHBOARD
; ==========================================

    RECT 0,168,320,32,13h
    RECT 0,168,320,1,08h


; ==========================================
; TIME BAR - LEFT SIDE
; ==========================================

    RECT 7,43,9,104,07h
    RECT 9,45,5,100,00h
    RECT 9,91,5,52,04h


; ==========================================
; SPEED BOX
; ==========================================

    RECT 96,171,64,27,07h
    RECT 98,173,60,23,00h

    ; Rounded corners
    RECT 96,171,2,2,13h
    RECT 158,171,2,2,13h
    RECT 96,196,2,2,13h
    RECT 158,196,2,2,13h


; ==========================================
; FUEL GAUGE
; ==========================================

    RECT 174,178,58,14,07h
    RECT 176,180,54,10,00h

    ; Half-full green fuel
    RECT 177,182,26,6,0Ah


; ==========================================
; DRIVER'S LEGS (knees under the wheel)
; ==========================================

    ; Left knee
    RECT 246,186,24,2,10h
    RECT 242,188,32,2,10h
    RECT 238,190,38,3,10h
    RECT 236,193,42,7,10h
    RECT 246,186,24,1,15h
    RECT 242,188,3,1,15h

    ; Right knee
    RECT 288,184,26,2,10h
    RECT 284,186,34,2,10h
    RECT 281,188,39,3,10h
    RECT 279,191,41,9,10h
    RECT 288,184,26,1,15h
    RECT 284,186,3,1,15h


; ==========================================
; DRIVER'S ARMS (drawn before the wheel so the
; hands can grip the rim in front of it)
; ==========================================

    ; Left arm: sleeve then bare forearm
    SLANT 228,199,252,173,12,12h

    ; Right arm
    SLANT 310,199,312,173,12,12h
    SLANT 312,172,309,150,8,14h


; ==========================================
; STEERING WHEEL - circular, right side
; centre (299,178), clipped by the screen edge
; ==========================================

    ; Black outer rim
    RING 299,178,41,32,00h

    ; Thin grey grip line on the rim
    RING 299,178,38,37,08h

    ; Left spoke
    RECT 266,175,22,6,00h

    ; Hub
    RING 299,178,12,0,00h
    RING 299,178,10,0,08h
    RING 299,178,5,0,07h


; ==========================================
; LEFT FOREARM (in front of the rim) + HANDS
; ==========================================

    SLANT 252,172,272,150,8,14h


    ; Left hand (about 10 o'clock)
    RECT 273,141,10,2,14h
    RECT 271,143,14,9,14h
    RECT 273,152,10,2,14h
    RECT 275,144,1,7,16h
    RECT 278,144,1,7,16h
    RECT 281,144,1,7,16h
    RECT 284,147,4,3,14h

    ; Right hand (about 1 o'clock)
    RECT 306,137,10,2,14h
    RECT 304,139,14,9,14h
    RECT 306,148,10,2,14h
    RECT 308,140,1,7,16h
    RECT 311,140,1,7,16h
    RECT 314,140,1,7,16h
    RECT 300,142,4,3,14h


; ==========================================
; TEXT INFORMATION
; ==========================================

    TEXT 1,3,0Fh,distanceText
    TEXT 2,3,0Eh,scoreText
    TEXT 4,0,0Fh,timeText

    TEXT 22,14,0Eh,speedText
    TEXT 23,14,07h,kmhText

    TEXT 21,22,0Fh,fuelText
    TEXT 24,22,07h,emptyText
    TEXT 24,28,07h,fullText


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
; DRAW RECTANGLE ROUTINE (clips to screen)
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

    ; Reject empty / off-screen rectangles
    cmp word [h],0
    je rectDone
    cmp word [w],0
    je rectDone
    cmp word [x],320
    jae rectDone
    cmp word [y],200
    jae rectDone

    ; Clip width
    mov ax,[x]
    add ax,[w]
    cmp ax,320
    jbe widthOK

    mov ax,320
    sub ax,[x]
    mov [w],ax

widthOK:

    ; Clip height
    mov ax,[y]
    add ax,[h]
    cmp ax,200
    jbe heightOK

    mov ax,200
    sub ax,[y]
    mov [h],ax

heightOK:

    mov ax,[h]
    mov [rowCount],ax

    mov si,[y]

rectRow:

    mov ax,si
    mov bx,320
    mul bx

    add ax,[x]
    mov di,ax

    mov al,[color]
    mov cx,[w]

    rep stosb

    inc si

    dec word [rowCount]
    jnz rectRow

rectDone:

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    ret


; ==========================================
; INTEGER SQUARE ROOT
; in: AX = n    out: AX = floor(sqrt(n))
; ==========================================

isqrt:

    push bx
    push cx
    push dx

    mov bx,ax
    xor cx,cx

isqrtNext:

    mov ax,cx
    inc ax
    mul ax
    cmp ax,bx
    ja isqrtDone
    inc cx
    jmp isqrtNext

isqrtDone:

    mov ax,cx

    pop dx
    pop cx
    pop bx

    ret

    ; ==========================================
; DRAW RING / DISC ROUTINE
; Uses ringCX, ringCY, ringRo, ringRi, ringColor
; ringRi = 0 gives a filled disc
; ==========================================

drawRing:

    push ax
    push bx
    push dx

    mov ax,[ringRo]
    mul ax
    mov [ringRo2],ax

    mov ax,[ringRi]
    mul ax
    mov [ringRi2],ax

    mov ax,[ringCY]
    sub ax,[ringRo]
    mov [ringY],ax

ringRow:

    ; Stop once we are below the screen
    cmp word [ringY],200
    jl ringBodyOK
    jmp near ringEnd

ringBodyOK:

    ; dy = |y - cy|
    mov ax,[ringY]
    sub ax,[ringCY]
    jns ringAbs
    neg ax

ringAbs:

    mov [ringDy],ax
    mul ax
    mov [ringDy2],ax

    ; Outer half-width
    mov ax,[ringRo2]
    sub ax,[ringDy2]
    call isqrt
    mov [ringOx],ax

    ; Inner half-width (0 when the row misses the hole)
    mov word [ringIx],0
    mov ax,[ringDy]
    cmp ax,[ringRi]
    jae ringDraw

    mov ax,[ringRi2]
    sub ax,[ringDy2]
    call isqrt
    mov [ringIx],ax

ringDraw:

    mov ax,[ringY]
    mov [y],ax
    mov word [h],1
    mov al,[ringColor]
    mov [color],al

    cmp word [ringIx],0
    je ringSolid

    ; Left piece
    mov ax,[ringCX]
    sub ax,[ringOx]
    mov [x],ax
    mov ax,[ringOx]
    sub ax,[ringIx]
    mov [w],ax
    call drawRect

    ; Right piece
    mov ax,[ringCX]
    add ax,[ringIx]
    inc ax
    mov [x],ax
    mov ax,[ringOx]
    sub ax,[ringIx]
    mov [w],ax
    call drawRect

    jmp ringNext

ringSolid:

    mov ax,[ringCX]
    sub ax,[ringOx]
    mov [x],ax
    mov ax,[ringOx]
    shl ax,1
    inc ax
    mov [w],ax
    call drawRect

ringNext:

    inc word [ringY]
    mov ax,[ringCY]
    add ax,[ringRo]
    cmp [ringY],ax
    jg ringEnd
    jmp near ringRow

ringEnd:

    pop dx
    pop bx
    pop ax
    ret

; ==========================================
; DRAW BUILDING ROUTINE
; Body rectangle plus a grid of windows.
; Uses bdX,bdY,bdW,bdH,bdClr,bdWin,bdGap
; ==========================================

drawBuilding:

    push ax
    push bx

    ; Body
    mov ax,[bdX]
    mov [x],ax
    mov ax,[bdY]
    mov [y],ax
    mov ax,[bdW]
    mov [w],ax
    mov ax,[bdH]
    mov [h],ax
    mov al,[bdClr]
    mov [color],al
    call drawRect

    ; First window row
    mov ax,[bdY]
    add ax,3
    mov [bdWy],ax

bdRowLoop:

    ; Stop when the window would pass the building bottom
    mov ax,[bdWy]
    add ax,[bdWin]
    mov bx,[bdY]
    add bx,[bdH]
    cmp ax,bx
    jb bdRowBody
    jmp near bdDone

bdRowBody:

    mov ax,[bdX]
    add ax,2
    mov [bdWx],ax

bdColLoop:

    ; Stop when the window would pass the right edge
    mov ax,[bdWx]
    add ax,[bdWin]
    mov bx,[bdX]
    add bx,[bdW]
    dec bx
    cmp ax,bx
    ja bdNextRow

    ; Draw one window
    mov ax,[bdWx]
    mov [x],ax
    mov ax,[bdWy]
    mov [y],ax
    mov ax,[bdWin]
    mov [w],ax
    mov [h],ax
    mov byte [color],1Ah
    call drawRect

    mov ax,[bdWin]
    add ax,[bdGap]
    add [bdWx],ax
    jmp bdColLoop

bdNextRow:

    mov ax,[bdWin]
    add ax,[bdGap]
    add [bdWy],ax
    jmp near bdRowLoop

bdDone:

    pop bx
    pop ax
    ret


; ==========================================
; SLANTED BAR ROUTINE (arms)
; Draws a bar of width slW from the bottom point
; (slX0,slY0) up to the top point (slX1,slY1).
; x values are the LEFT edge of the bar.
; ==========================================

slant:

    push ax
    push bx
    push dx

    mov ax,[slY1]
    mov [slY],ax

slantRow:

    mov ax,[slY]
    sub ax,[slY1]           ; t = rows from top
    mov bx,[slX0]
    sub bx,[slX1]           ; signed x travel
    imul bx                 ; dx:ax = t * travel
    mov bx,[slY0]
    sub bx,[slY1]           ; total rows
    idiv bx
    add ax,[slX1]
    mov [x],ax

    mov ax,[slY]
    mov [y],ax
    mov ax,[slW]
    mov [w],ax
    mov word [h],1
    call drawRect

    inc word [slY]
    mov ax,[slY]
    cmp ax,[slY0]
    jbe slantRow

    pop dx
    pop bx
    pop ax

    ret


; ==========================================
; PRINT TEXT ROUTINE
; DH = row, DL = column, SI = text, [textColor]
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
    mov bl,[textColor]

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

    SETPAL 09h,35,48,63     ; light blue sky
    SETPAL 02h,20,38,15     ; natural green grass
    SETPAL 08h,23,23,26     ; grey road
    SETPAL 0Ch,63,32,5      ; orange bonnet
    SETPAL 0Dh,63,48,24     ; bonnet highlight
    SETPAL 11h,48,20,2      ; bonnet shade
    SETPAL 13h,13,13,15     ; dashboard
    SETPAL 14h,60,46,34     ; skin
    SETPAL 16h,46,32,22     ; skin (finger lines)
    SETPAL 10h,8,14,34      ; jeans
    SETPAL 15h,16,26,52     ; jeans highlight
    SETPAL 12h,24,30,46     ; shirt sleeve
    SETPAL 17h,50,42,34     ; building beige
    SETPAL 18h,45,20,16     ; building brick
    SETPAL 19h,28,34,44     ; building blue-grey
    SETPAL 1Ah,63,60,35     ; lit window

    pop dx
    pop ax

    ret
