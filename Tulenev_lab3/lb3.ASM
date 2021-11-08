; Program stack
AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

; Program data
DATA SEGMENT
a DW 4
b DW 3
i DW 2
k DW 1
i1 DW 0
i2 DW 0
res DW 0

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
    jle f12 ; a <= b

    ; i1   a > b
    mov ax, i 
    mov bx, i
    
    mov cl, 03
    shl ax, cl

    shl bx, 1
    sub ax, bx

    mov i1, 4
    sub i1, ax


    ; i2   a > b
    mov ax, i 
	
	mov cl, 02
    shl ax, cl
	
    mov i2, 20
    sub i2, ax
    
    jmp continuation

    f12:
        ; i1   a <= b
		mov ax, i
		mov bx, i
		
		mov cl, 02
        shl ax, cl
		
		sub ax, bx
		
        mov i1, 6
        add i1, ax

        ; i2   a <= b
        mov ax, i 
        mov bx, i
    
        mov cl, 03
        shl ax, cl

        shl bx, 1
        sub ax, bx

        mov i2, 6
        sub i2, ax

    continuation:
        cmp i1, 0 
        jl reversi1 ; i1 < 0
		
		cmp i2, 0
        jl reversi2 ; i2 < 0
		
        jmp f3

    reversi1:
        neg i1
		
		cmp i2, 0
        jl reversi2 ; i2 < 0
		
	reversi2:
		neg i2
	    
    f3:
        cmp k, 0
        jl ff3 ; k < 0
		
		cmp i1, 6 
		jl fff3 ; i1 < 0
		
		mov ax, i1
		mov res, ax
		
		jmp exit

    ff3: 
		mov ax, i1
		mov bx, i2
        mov res, ax
        add res, bx
		
		jmp exit
	
	fff3: 
		mov res, 6
		
    exit:
        ret 
Main ENDP
CODE ENDS
 END Main 