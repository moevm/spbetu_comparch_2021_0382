AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 0
	b DW 2
	i DW 2
	k DW 1
	i1 DW 0
	i2 DW 0
	res DW 0
	DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
	push DS
	sub AX,AX
	push AX
	mov AX,DATA
	mov DS,AX

func1:
	mov ax, i
	shl ax, 1 ;2i
	shl ax, 1 ;4i
	mov bx, a
	cmp bx, b ;comparison a & b
	jle func1_2 ;jump to func1_2 if a <= b

    mov bx, ax
	add ax, 3 ;4i+3
	neg ax ;-(4i+3)
    sub bx, 5 ;4i-5
	neg bx ;-(4i-5)
	jmp func1_end

func1_2:
	shr ax, 1 ;2i
	mov bx, ax
	shl ax, 1 ;4i
	add ax, bx ;6i
	sub ax, 10 ;6i-10
	neg bx ;-2i
	sub bx, i ;-3i
	add bx, 10 ;10-3i
	jmp func1_end

func1_end:
	mov i1, ax 
	mov i2, bx 
	
func3:
	mov ax, i1
	sub ax, i2 ;i1-i2
	cmp ax, 0
	jge comp_k ;jump if (i1-i2) >= 0
	neg ax

comp_k:
	cmp k, 0
	jge func3_2

	cmp ax, 2
	jge min ;if |a1-i2|>=2
	mov bx, ax
	jmp func3_res

min:
	mov bx, 2
	jmp func3_res

func3_2:
	neg i2
	cmp i2, -6
	mov bx, i2
	jge func3_res
	mov bx, -6

func3_res:
	mov res, bx
	ret

Main ENDP
CODE ENDS
END Main






	