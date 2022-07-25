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
		
		; f1: i1 = -(4i+3) if a>b else 6i-10
		; f2: i2 = 20 - 4i if a>b else -(6i-6)
		mov bx, i ; bx = i
		shl bx, 1 ; bx = 2i
        shl bx, 1 ; bx = 4i
        mov ax, bx ; ax = 4i
		mov cx, a
		cmp cx, b ; cmp a b
		jg f_case1
		f_case1:
            ;f1
			add bx, 3 ; bx = 4i + 3
            neg bx ; bx = -(4i+3)
            ;f2
            neg ax ; ax = -4i
            add ax, 20 ; ax = -4i + 20   
			jmp f_final
		f_case2:
			;f1
			sub bx, i; bx = 3i
            shl bx, 1; bx = 6i
            mov ax, bx; ax = 6i !!!
            sub bx, 10 ; bx = 6i - 10
            ;f2 ax = 6i
            sub ax, 6 ; ax = 6i - 6
            neg ax; ax = -(6i - 6)
            
		f_final:
            mov i1, bx ; i1 = f1
            mov i2, ax ; i2 = f2
		; f3: res = |i1 - i2| if k < 0 else max(7, |i2|)
		mov ax,i1
		mov bx,i2
		mov cx,k
		cmp k, 0
		jl case1
		case1:
			sub ax, bx ; ax = i1 - i2
            mov res, ax
			cmp ax, 0
			jge final
			neg res
			jmp final
		case2:
            mov res, bx ;res = i2
			cmp 7, bx ;7 <= i2
			jle final
            neg res
            cmp 7, res ; 7 <= |i2|
			jle final
            mov res, 7 ; res = 7
		final:
		ret
	Main ENDP
CODE ENDS
END Main