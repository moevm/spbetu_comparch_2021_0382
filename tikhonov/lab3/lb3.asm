EOL EQU '$'
ind EQU 2
n1 EQU 500
n2 EQU -50
AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS
DATA SEGMENT
	a DW 2
	b DW 1
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
	mov ax,i ;ax=i
	shl ax,1 ;ax=2i
	mov bx,a
	cmp bx,b
	jg f38_1 ;jmp if a>b
f38_2:
	add ax,i ;ax=3i
	mov bx,12
	sub bx,ax
	mov i2,bx ;i2=12-3i=9-3*(i-1)
	shl ax,1 ;ax=6i
	neg ax;
	add ax,8
	mov i1,ax ;i1=8-6i
	jmp f6
f38_1:
	shl ax,1 ;ax=4i
	mov bx,ax ;bx=4i
	neg ax ;ax=-4i
	add ax,7 ;ax=7-4i
	mov i1,ax ;i1=7-4i
	mov ax,i ;ax=i
	shl ax,1 ;ax=2i
	add ax,bx ;ax=6i
	add ax,8
	neg ax
	mov i2,ax ;i2=-(6i+8)
f6:
	cmp k,0
	jnl case_2 ;k>=0
	mov ax,i1 ;ax=i1
	sub ax,i2 ;ax=i1-i2
	cmp ax,0
	jl neg_sub
	jmp set_res
case_2:
	mov ax,i2
	cmp ax,0
	jnl case_2_2 ;i2>=0
	neg ax
case_2_2:	
	cmp ax,7 ;
	jnl set_res ;if ax>=7
	mov ax,7
	jmp set_res
neg_sub:
	neg ax
set_res:
	mov res,ax
	ret	
	
Main ENDP
CODE ENDS
 	END Main

