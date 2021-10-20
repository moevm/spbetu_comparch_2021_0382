AStack SEGMENT STACK
	DW 2 DUP(?)
AStack ENDS

DATA SEGMENT
	a	DW -3
	b	DW 7
	i	DW -2
	k	DW 1
	i1	DW ?
	i2	DW ?
	res	DW ?
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
	Main PROC FAR
		push DS
		sub ax,ax
		push ax
		mov ax,DATA
		mov DS,ax
		
		; f1: i1 = 15-2i if a>b else 3i+4
		; f2: i2 = 4 - 6i if a>b else 3i + 6
		mov ax, i
		;3i
		mov bx, i
		shl bx,1
		shl bx,1
		sub bx,ax
		
		mov cx, a
		cmp cx, b
		jle f_case2
		f_case1:
			;f1
			shl ax,1
			mov i1,15
			sub i1,ax
			;f2
			shl bx,1
			mov i2,4
			sub i2,bx
			jmp f_final
		f_case2:
			;f1
			mov i1,4
			add i1,bx
			;f2
			mov i2,6
			add i2,bx
		f_final:
		
		; f3: res = |i1 + i2| if k == 0 else min(i1,i2)
		mov ax,i1
		mov bx,i2
		mov res, ax
		
		mov cx,k
		cmp k, 0
		jne case2
		case1:
			add res, bx
			cmp res, 0
			jge final
			neg res
			jmp final
		case2:
			cmp res,bx
			jle final
			mov res,bx
		final:
		ret
	Main ENDP
CODE ENDS
END Main