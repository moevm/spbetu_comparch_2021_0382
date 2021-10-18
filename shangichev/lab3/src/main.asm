
; Program stack
AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

; Program data
DATA SEGMENT
a DW 7
b DW 12
i DW 20
k DW 2
i1 DW 0
i2 DW 0
answer DW 0

DATA ENDS


; Program code
CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX

    mov cx, a
    cmp cx, b 
    jle secondcase ; a <= b

    ; calculate i1
    mov ax, i 
    mov bx, i
    
    mov cl, 03
    shl ax, cl ; ax = 8i

    shl bx, 1
    sub ax, bx ; ax = 6i

    mov i1, 4
    sub i1, ax


    ; calculate i2
    mov ax, i 
    sub ax, 1 
    shl ax, 1  
    mov i2, ax
    
    jmp absi1

    secondcase: ; a <= b
        mov bx, i
        mov ax, bx
        mov cl, 02
        shl bx, cl
        sub bx, ax ; bx = 3i

        ; calculate i1
    	mov i1, 6
        add i1, bx

        ; calculate i2
        mov i2, 2
        sub i2, bx

    absi1:
        cmp i1, 0
        jl changesigni1
        jmp absi2    

    changesigni1:
        neg i1

    absi2:
        cmp i2, 0
        jl changesigni2
        jmp f3

    changesigni2:
        neg i2

    f3:
        mov ax, k
        cmp ax, 0
        jl negative ; k < 0

    kge0:        
        mov ax, i2
        sub ax, 3
        cmp ax, 4
        jle write4 
        mov answer, ax
        jmp exit

    write4:
        mov answer, 4
        jmp exit

    negative:
        mov ax, i1
        sub ax, i2
        mov answer, ax

    exit:
        ret 
Main ENDP
CODE ENDS
 END Main














