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
	
    mov ax, i 
    mov bx, i
	
    mov cl, 02
    shl ax, cl	; ax=3*i
    sub ax, bx	; bx=i
	
    mov cx, a
    cmp cx, b 
    jle f2 ; a <= b

    ; i1   a > b 	 -(6*i - 4)=4-6*i
	
    mov i1, 4
    sub i1, ax
	sub i1, ax

    ; i2   a > b 	 20 - 4*i
	
    mov i2, 20
    sub i2, ax
    sub i2, bx

    jmp f3

    f2:
        ; i1   a <= b 	 3*(i+2)=6+3*i
		
        mov i1, 6
        add i1, ax

        ; i2   a <= b	-(6*i-6)=6-6*i

        mov i2, 6
        sub i2, ax
	sub i2, ax
	    
    f3:
	
	cmp i1, 0
	jge donext1 ; i1>=0
	neg i1
    donext1:
	
        cmp k, 0
        jl f4 ; k < 0
		
	mov res, 6
		
	cmp i1, 6 
	jl exit ; i1 < 6
		
	mov ax, i1
	mov res, ax
		
	jmp exit

    f4: 
	
	cmp i2, 0
	jge donext2  ; i2>=0
	neg i2
	donext2:
	
	mov ax, i1
	mov bx, i2
        mov res, ax
        add res, bx
	
    exit:
        ret 
Main ENDP
CODE ENDS
 END Main 
