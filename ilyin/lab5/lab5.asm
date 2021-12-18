
ind EQU 5

DATA SEGMENT
    keep_cs dw 0 ;to store the old interrupt
    keep_ip dw 0 ;to store the old interrupt
    simbol db '0'
    mes_end_iter DB 10,13,'End iter$'
DATA ENDS

AStack SEGMENT STACK
    DW 1024  DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
 
SUBR_INT PROC FAR
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

print:   
	mov dl, simbol
	mov ah, 02h ;вывод строки
	int 21h
	sub bx, 1
	cmp bx, 0
    	JNE final
	
	mov ah, 09h
	mov dx, offset mes_end_iter
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
SUBR_INT ENDP
  
Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax
    
    
    mov ah, 01h
    int 21h
    mov simbol, al
    
    mov dl, 10
    mov ah, 02h ;вывод строки
    int 21h
    
    ;remember the old interrupt
    MOV AH, 35H ; function of getting interrupt vector
    MOV AL, 1CH ; number of vector
    INT 21H
    MOV KEEP_IP, BX ; remember offset
    MOV KEEP_CS, ES ; and segment of interrupt vector
    
    ;call interrupt
	mov bx, 5 ; ª®«-¢® ¯®â®à  á®®¡é¥¨ï
    int 08h
    
    ;set a new interrupt
    PUSH DS
    MOV DX, offset SUBR_INT ; offset for procedure into DX
    MOV AX, seg SUBR_INT ; segment of procedure
    MOV DS, AX ; move to DS
    MOV AH, 25H ; function of setting new vector
    mov al, 08h
    INT 21H ; change interrupt
    POP DS
    
aaaaaaa:    
    cmp bx, 0
    JNE aaaaaaa	
    
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
