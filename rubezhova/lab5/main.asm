DATA SEGMENT
    keep_cs dw 0
    keep_ip dw 0
    message DB 'Message successfully sent!$'
DATA ENDS

AStack SEGMENT STACK
    DW 512 DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
 
SUBR_INT PROC FAR
    push dx ; remember the value of changable register
    push ax;
    mov ah, 09h
    int 21h
    pop ax
    pop dx
    
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
    mov al, 1Ch
    INT 21H ; change interrupt
    POP DS
    
    ;call interrupt
    mov dx, offset message
    int 1Ch

    
    ;restore the old interrupt
    CLI
    PUSH DS
    MOV DX, keep_ip
    MOV AX, keep_cs
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 1CH
    INT 21H ; restore the old interrupt vector
    POP DS
    STI
    
    ret
Main ENDP

CODE ENDS
     END Main
    
    
