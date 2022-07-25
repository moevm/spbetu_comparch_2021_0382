AStack SEGMENT STACK         ;из-за Атрибут комбинирования сегментов STACK - загрузка  AStack в регистр 
	DW 12 DUP('!')			 ;SS будет выполнена автоматически до начала выполнения программы
AStack ENDS

DATA SEGMENT
    a Dw -5
    b Dw 2
    i Dw -2
    k Dw 1
    i1 Dw 0
    i2 Dw 0
    res Dw 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
	
Main PROC FAR
    push  DS       ;\  Сохранение адреса начала PSP в стеке
    sub   AX,AX    ; > для последующего восстановления по
    push  AX       ;/  команде ret, завершающей процедуру.
    mov   AX,DATA             ; Загрузка сегментного
    mov   DS,AX               ; регистра данных.
		  
	
	
f12:
;if a > b	
    mov   ax, i ;ax = i
	shl   ax, 1 ;ax = 2i	
	
	mov   bx, a		
	cmp   bx, b 
	JLE else_f12 ;если a>=b скачок

then_f12:
	mov i1, 15
	sub  i1, ax	
	
	mov i2, -3
	shl   ax, 1 ;ax = 4i
	sub i2, ax
	jmp end_f2
	
else_f12:
	add   ax, i ;ax = 3i
	mov   i1, ax
	add   i1, 4
	
	mov   i2, -10
	shl   ax, 1 ;ax = 6i
	add   i2, ax
end_f2:



regulate:
;if i1 >= i2	
	mov   ax, i1
	mov   bx, i2		
	cmp   ax, bx 
	JL    swap ;  если i1<i2 скачок
	JGE   end_reg ;если i1>=i2 скачок
swap:
	mov   bx, i1
	mov   ax, i2
end_reg:
;теперь ax>bx 		
	

f3:	
;if k==0		
	cmp   k, 0h
	JNE else_f3 ; если k!=0 скачок
	
then_f3:
	mov res, bx
	jmp end_f3
	
else_f3:
	mov res, ax
end_f3:	

	ret

Main ENDP
CODE ENDS
    END Main		  