; Стек программы
AStack SEGMENT STACK
	DW 12 DUP(?)
AStack 		ENDS

; Данные программы
DATA 		SEGMENT
;68 стр
; Директивы описания данных
a 	DW 0
b 	DW 0
i 	DW 0
k 	DW 0
i1 	DW 0
i2 	DW 0
res 	DW 0

DATA 	ENDS

; Код программы
CODE 	SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

; Головная процедура
Main PROC FAR
	push DS
	sub AX,AX
	push AX
	mov AX,DATA
	mov DS,AX
	sub AX,AX
	mov AX,a
	mov BX,b
	mov CX,i
	cmp AX,BX
	JG Above
	JLE Less
	
Above:         ;a > b
	add i1,15  ;i1 = 15
	sal CX,1   ;i = i * 2
	sub i2,2
	add i2,CX  ;тк различие на 2
	neg CX     ;i = - 2 * i
	add i1,CX  ;i = 15 - 2i
	mov CX, i1
	CMP i1,0
	JL Abs1
	JMP F3
	
Less:           ;a <= b
	add i1,CX   ;i1 = i
	sal CX,1    ;i = 2*i
	add CX,i1   ;i = 3*i
	mov i1,CX
	add i1,4
	add i2,2
	neg CX
	add i2,CX
	mov CX, i1
	CMP i1,0
	JL Abs1
	JMP F3
	
Abs1:           ;берем i1 по модулю
	neg i1
	
F3:             
	CMP k,0
	JZ Zero
	add res, CX
	mov CX, i2
	CMP CX,0
	JL Abs2
	add res,CX
	JMP Finish
	
Abs2:         
	neg CX
	add res, CX
	JMP Finish
	
Zero:
	CMP CX,6
	JL MinI
	mov res, 6
	JMP Finish
	
MinI:
	mov res, CX

Finish:
    ret                     
	
Main	ENDP
CODE	ENDS
		END MAIN  