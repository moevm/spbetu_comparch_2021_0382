AStack SEGMENT STACK
 DW 512 DUP(0)
AStack ENDS

DATA SEGMENT
	KEEP_CS DW 0 ; хранение сегмента прерывания
	KEEP_IP DW 0 ; хранение смещения прерывания 
	str DB 'DONE$'
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

myINT PROC FAR
	jmp next
	KEEP_SS DW 0
	KEEP_SP DW 0
	MyStack DW 100 dup(0)
next:	
	mov KEEP_SP, SP
	mov KEEP_SS, SS
	mov AX, SEG MyStack
	mov SS, SP
	mov SP, offset next
	push ax
	push dx

input:
	in al, 60h 
	cmp al, 1fh  
	jne input

print:   
	mov ah, 09h ;вывод строки
	mov dx, offset str 
	int 21h
final:
   	pop ax
	pop dx
	pop cx
	mov SS, KEEP_SS 
	mov SP, KEEP_SP 
        mov AL, 20h 
        out 20h,AL 
        iret
	
myINT ENDP

Main PROC FAR
	push DS
	sub AX,AX
	push AX
	mov AX, DATA
	mov DS, AX

	MOV AH,35h ; функция получения вектора
	MOV AL,16h ; номер вектора
	INT 21h
	MOV KEEP_IP, BX ; запоминание смещения
	MOV KEEP_CS, ES ; и сегмента

	PUSH DS
	MOV DX, offset myINT ; смещение для процедуры в DX
	MOV AX, seg myINT ; сегмент процедуры
	MOV DS, AX ; помещаем в DS
	MOV AH, 25h ; функция установки вектора
	MOV AL, 16h ; номер вектора
	INT 21h ; меняем прерывание
	POP DS

	int 16h

	CLI
   	PUSH DS
  	MOV DX, KEEP_IP
  	MOV AX, KEEP_CS
  	MOV DS, AX
  	MOV AH, 25H
  	MOV AL, 16h
  	INT 21H  ;восстанавливаем вектор
  	POP DS
	STI
	MOV AH, 4CH
    	INT 21H
	RET
MAIN ENDP
CODE ENDS	
	END MAIN 
