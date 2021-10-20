AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
a DW 2
b DW 4
i DW -3
k DW 5
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
f1:
	mov AX, i
	shl AX, 1 ; 2i
	shl AX, 1 ; 4i
	mov CX, a
	cmp CX, b
	jle f1_2 ; a<=b
f1_1:
	add AX, 3 ; 4i+3
	neg AX ; -(4i+3)
	jmp f1_res
f1_2:
	shl AX, 1 ; 8i
	mov BX, i
	shl BX, 1
	sub AX, BX ; 6i
	sub AX, 10 ; 6i - 10
f1_res:
	mov i1, AX
f2:
	mov AX, i
	add AX, 1 ; i+1
	mov CX, a
	cmp CX, b
	jle f2_2 ; a<=b
f2_1:
	shl AX, 1 ; 2*(i+1)
	sub AX, 4 ; 2*(i+1) - 4
	jmp f2_res
f2_2:
	mov BX, AX; (i+1)
	shl AX, 1 ; 2*(i+1)
	shl AX, 1 ; 4*(i+1)
	sub AX, BX ; 3*(i+1)
	neg AX ; -3*(i+1)
	add AX, 5 ; 5-3*(i+1)
f2_res:
	mov i2, AX
f3:
	mov CX, i2
	cmp CX, 0
	jl abs_i2 ; i2 < 0
	mov CX, i1
	cmp CX, 0
	jl abs_i1 ; i1 < 0
	mov CX, k
	cmp CX, 0
	je f3_1 ; k = 0
	jmp f3_2
abs_i1:
	mov AX, CX
	neg AX
	mov i1, AX ; |i1|
	jmp f3
abs_i2:
	mov AX, CX
	neg AX
	mov i2, AX ; |i2|
	jmp f3
f3_2:
	mov AX, i1
	add AX, i2 ; |i1|+|i2|
	jmp f3_end
f3_1:
	mov CX, i1
	sub CX, 6
	jle res1 ; i1 <= 6
	mov AX, 6 ; 6
	jmp f3_end
res1:
	mov AX, i1 ; i1
	jmp f3_end
f3_end:
	mov res, AX
	ret
Main ENDP
CODE ENDS	
	END Main