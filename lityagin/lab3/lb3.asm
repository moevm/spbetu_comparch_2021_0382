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

	mov AX, i
	add AX, 1 ; i+1
	mov CX, a
	cmp CX, b
	jle AlowerB
AbiggerB:
	shl AX, 1 ; 2*i+2
	sub AX, 4 ; 2*(i+1)-4 = 2i - 2
	mov i2, AX
	shl AX, 1 ; 4i-4
	add AX, 7 ; 4i+3
	neg AX ; -(4i+3)
	mov i1, AX
	jmp abs_i1
AlowerB:
	mov BX, AX
	shl AX, 1
	shl AX, 1
	sub AX, BX ; 3*(i+1)
	neg AX ; -3*(i+1)
	add AX, 5 ; 5-3*(i+1) = -3i+2
	mov i2, AX
	shl AX, 1 ; -6i+4
	add AX, 6 ; -6i+10
	neg AX ; 6i-10
	mov i1, AX
abs_i1:
	mov CX, i1
	cmp CX, 0
	jge f3
	neg i1
f3:
	mov CX, k
	cmp CX, 0
	jne abs_i2
f3_1:
	mov CX, i1
	cmp CX, 6
	jle min
	mov AX, 6
	jmp f3_res
min:
	mov AX, i1
	jmp f3_res
abs_i2:
	mov CX, i2
	cmp CX, 0
	jge f3_2
	neg i2
f3_2:
	mov AX, i1
	add AX, i2
	jmp f3_res
f3_res:
	mov res, AX
	ret
Main ENDP
CODE ENDS	
	END Main