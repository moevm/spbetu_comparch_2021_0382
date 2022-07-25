
AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a   DW 0
	b   DW 0
	i   DW 0
	k   DW 0
	i1  DW 0
	i2  DW 0
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
F_12:
	mov ax, i
	shl ax, 1   ;ax=2i
	mov bx, a
	cmp bx, b
	jle else_12

then_12:
	mov i1, 15
	sub i1, ax  ;15-2i

	mov i2, 7
	shl ax, 1   ;ax=4i
	sub i2, ax  ;7-4i
	jmp F_3

else_12:
	mov i1, 4
	add ax, i  ;ax=3i
	add i1, ax ;4+3i

	mov i2, 8
	shl ax, 1  ;ax=6i
	sub i2, ax ;8-6i

F_3:
	cmp k, 0h
	jnl else_3

then_3:
	mov ax, i1  ;ax=i1                       
	mov bx, 10
	sub bx, i2  ;bx=10-i2
	cmp ax, bx
	jnl max_i1
	mov res, bx
	jmp stop

max_i1:
	mov res, ax
	jmp stop

else_3:
	mov ax, i1
	mov bx, i2 
	sub ax, bx
	cmp ax, 0h
	jnl pos
	sub res, ax 
	jmp stop

pos:	
	add res, ax
	jmp stop
	
stop:
	ret


Main ENDP
CODE ENDS
 	END Main
