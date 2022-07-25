DATA SEGMENT
    keep_cs dw 0 ;to store the old interrupt
    keep_ip dw 0 ;to store the old interrupt
    message DB 10,13,'Message$'
	mes_end_iter DB 10,13,'End iter$'
DATA ENDS

AStack SEGMENT STACK
    DW 1024  DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
 
SUBR_INT PROC FAR
    push ax
	push bx
	push dx
	push cx
    mov ah, 09h
	
	cmp bx, 0
	JE end_print
	
for_print:	
    int 21h
	sub bx, 1
	
	cmp bx, 0
	JNE for_print
end_print:	

	;mov al, 0
	;mov ah, 86h
	;mov cx, 1
	;mov dx, 2
	;int 15h
	mov cx, 0ffffh
	loop $
	
	mov ah, 09h
	mov dx, offset mes_end_iter
	int 21h
	
	pop cx
	pop dx
	pop bx
    pop ax
    
    mov al, 20h    ;to enable interrupt with
    out 20h, al    ;lower levels
    IRET
SUBR_INT ENDP
  
Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax
    
    ;remember the old interrupt
    MOV AH, 35H ; function of getting interrupt vector
    MOV AL, 1CH ; number of vector
    INT 21H
    MOV KEEP_IP, BX ; remember offset
    MOV KEEP_CS, ES ; and segment of interrupt vector
    
    ;set a new interrupt
    PUSH DS
    MOV DX, offset SUBR_INT ; offset for procedure into DX
    MOV AX, seg SUBR_INT ; segment of procedure
    MOV DS, AX ; move to DS
    MOV AH, 25H ; function of setting new vector
    mov al, 08h
    INT 21H ; change interrupt
    POP DS
    
    ;call interrupt
	mov bx, 5 ; кол-во потора сообщения
    mov dx, offset message
    int 08h

    
    ;restore the old interrupt
    CLI
    PUSH DS
    MOV DX, keep_ip
    MOV AX, keep_cs
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 08H
    INT 21H ; restore the old interrupt vector
    POP DS
    STI
    
    ret
Main ENDP

CODE ENDS
     END Main