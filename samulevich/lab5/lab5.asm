AStack SEGMENT STACK
    DW 1024 DUP(?)
Astack ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS


CODE SEGMENT
    ASSUME CS:CODE,DS:DATA, SS:AStack


Module PROC FAR ;результат деления-в AX,постоянный остаток - в BX, делитель - в DI
    add DX,BX
    cmp DX,DI
    jb finish
    sub DX,DI
    inc AX
finish:
    ret
Module ENDP


User_interruption PROC FAR
    jmp start
    HIGHT DW 0012h
    LOW  DW  034DCh

    DIVIDER DW 7000

    REMAINDER_HIGHT DW 0
    REMAINDER_LOW DW 0
    TEMP_LOW DW 0  
     
    SS_INT dw 0
    SP_INT dw 0
    INT_STACK DW 512 DUP('0')

start:
    mov SS_INT ,SS
    mov SP_INT,SP
    
    mov SP,SEG INT_STACK
    mov SS,SP
    mov SP,offset start
    
    push AX
    push BX
    push CX
    push DX
    push DI

    mov DX,0
    mov HIGHT,0012h
    mov LOW, 034DCh

    mov DI,DIVIDER
    mov AX,HIGHT
    DIV DI
    mov REMAINDER_HIGHT, DX
    mov HIGHT,AX   
  
    mov AX,0FFFFh
    mov DX,0
    DIV DI
    mov BX,DX
    mov CX,REMAINDER_HIGHT
    mul CX 
    mov DX,0
test:
    call Module
    loop test
    
    mov BX,REMAINDER_HIGHT
    call Module
    mov REMAINDER_LOW,DX
    mov TEMP_LOW,AX

    mov AX,LOW
    mov DX,0
    DIV DI
    mov BX,REMAINDER_LOW
    call Module
    add AX,TEMP_LOW
    adc HIGHT,0000
    mov LOW,AX
    mov REMAINDER_LOW,DX




    mov AL,10110110b
    out 43h,AL
    mov ax,LOW
    out 42h, al
    mov al, ah
    out 42h, al

    in AL,61h
    or AL,00000011b
    out 61h,AL
    mov CX,0007h
    mov DX,0A120h
    mov AH,86h
    int 15h
   
    in AL,61h
    and AL,11111100b
    out 61h,AL
   
    pop DI
    pop DX
    pop CX
    pop BX
    pop AX
    mov SS,SS_INT
    mov SP,SP_INT

IRET
User_interruption ENDP


Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov  AX,DATA
    mov DS,AX

    mov AH,35h
    mov AL,23h
    int 21h
    mov KEEP_IP,BX
    mov KEEP_CS,ES
    
    push DS
    mov AX,SEG User_interruption
    mov DS,AX
    mov DX,OFFSET User_interruption
    mov AH,25h
    mov AL,23h
    int 21h
    pop DS
begin:

    mov ah, 0
    int 16h
    cmp al, 3
    jnz quit
    int 23h
    jmp begin

quit:
        
    CLI
    push DS
    mov AX,KEEP_CS
    mov DS,AX
    mov DX,KEEP_IP
    mov AH,25h
    mov AL,23h
    int 21h
    pop DS
    STI 

ret
Main ENDP

CODE ENDS
    END Main

