AStack SEGMENT STACK
    DW 1024 DUP(?)
Astack ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS


CODE SEGMENT
    ASSUME CS:CODE,DS:DATA, SS:AStack

User_interruption PROC FAR
    jmp start
    PITCH_OF_SOUND_HIGHT DB 01h
    PITCH_OF_SOUND_LOW  DB 0A0h
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
    push CX
    push DX

    mov AL,10110110b
    out 43h,AL
    mov AL, BYTE PTR PITCH_OF_SOUND_LOW
    out 42h,AL
    mov AL, BYTE PTR PITCH_OF_SOUND_HIGHT
    out 42h,AL

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

    pop DX
    pop CX
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
