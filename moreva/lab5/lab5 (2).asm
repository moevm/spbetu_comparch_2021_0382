AStack SEGMENT STACK
 DW 1024 DUP(0)
AStack ENDS

DATA SEGMENT
	string DB 'GOOD$'
	; хранение сегмента прерывания
	KEEP_CS DW 0 
	; хранение смещения прерывания 
	KEEP_IP DW 0 
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

userInterrupt PROC FAR
	jmp userData
	
	KEEP_SS DW 0
	KEEP_SP DW 0
	procStack DW 100 dup(0)
	
userData:	
	mov KEEP_SP, SP
	mov KEEP_SS, SS
	mov AX, SEG userInterrupt
	mov SS, SP
	mov SP, offset userData
	push ax
	push dx

input:
	in al, 60h 
	cmp al, 01h  
	jne input
	
	;вывод строки
	mov ah, 09h 
	mov dx, offset string 
	int 21h
	
   	pop ax
	pop dx

	mov SS, KEEP_SS 
	mov SP, KEEP_SP 
        mov AL, 20h 
        out 20h,AL 
        iret
	
userInterrupt ENDP

Main PROC FAR
	push DS
	
	mov AX, DATA
	mov DS, AX
	xor ax,ax
	
	MOV AH,35h ; функция получения вектора
	MOV AL,16h ; номер вектора
	INT 21h
	
	; запоминание смещения
	MOV KEEP_IP, BX 
	; и сегмента
	MOV KEEP_CS, ES 
	
	PUSH DS
	MOV DX, offset userInterrupt ; смещение для процедуры в DX
	MOV AX, seg userInterrupt ; сегмент процедуры
	MOV DS, AX ; помещаем в DS
	MOV AH, 25h ; функция установки вектора
	MOV AL, 16h ; номер вектора
	INT 21h ; меняем прерывание
	POP DS

	int 16h
	
	;очистка флага IF (CLEAR IF)
	CLI
   	PUSH DS
  	MOV DX, KEEP_IP
  	MOV AX, KEEP_CS
  	MOV DS, AX
  	MOV AH, 25H
  	MOV AL, 16h
  	INT 21H  ;восстанавливаем вектор
  	POP DS
	
	;установка флага IF(SET IF)
	STI
	MOV AH, 4CH
    	INT 21H
	RET
MAIN ENDP
CODE ENDS	
	END MAIN 