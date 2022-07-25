AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 0
	b DW 0
	i DW 0
	k DW 0
	i1 DW 0
	i2 DW 0
	res DW 0

DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    	push DS
    	sub AX, AX
    	push AX
    	mov AX, DATA
    	mov DS, AX
    
f1_2:
	mov ax, i
	shl ax, 1 ;ax = 2i
	shl ax, 1 ;ax = 4i
	mov bx, a
	cmp bx, b
	jg calc_1 

calc_2: ;if(a <= b)
	mov bx, ax ;bx = ax = 4i	
	shr bx, 1 ;bx = 2i
	add ax, bx ;ax = 6i
	neg ax ;ax = -6i
	mov cx, ax ;cx = ax = -6i
	add cx, 6h ;cx = (6 - 6i)
	add ax, 8h ;ax = (8 - 6i)
	jmp res_f1_f2
	
calc_1: ;if(a > b)
	neg ax ;ax = -4i
	mov cx, ax ;cx = ax = -4i
	add ax, 7h ;ax = (7 - 4i)
	add cx, 14h ;cx = (20 - 4i)
	
res_f1_f2:
	mov i1, ax
	mov i2, cx
	
f3:
	mov bx, k
	cmp bx, 0h
	je calc3_1
	
calc3_2: ;if(k \= 0)
	cmp ax, cx
	jle min_1

min_2: ;if(ax > cx)
	mov res, cx
	jmp exit
	
min_1: ;if(ax <= cx)
	mov res, ax
	jmp exit

calc3_1: ;if(k == 0)
	add ax, cx
	mov res, ax
	cmp ax, 0h
	jge exit
	
abs:
	neg ax
	mov res, ax
	
exit:
	ret

Main ENDP
CODE ENDS
 END Main 
