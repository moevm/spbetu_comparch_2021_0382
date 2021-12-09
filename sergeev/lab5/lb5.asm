AStack SEGMENT STACK
    DW 512 DUP(?) ; выделим 1 Кбайт памяти
AStack ENDS
; Данные программы
DATA SEGMENT
  KEEP_CS DW 0 ; для хранения сегмента
  KEEP_IP DW 0 ; и смещения вектора прерывания
DATA ENDS
; Код программы
CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

SUBR_INT PROC FAR
    jmp subr_int_start
    old_SP dw 0
    old_SS dw 0
    subr_int_stack dw 64 dup(0)
subr_int_start:
    mov old_SS,SS
    mov old_SP,SP
    mov ax,seg subr_int_stack
    mov ss,ax
    mov sp, offset subr_int_start

    push cx
    push ax
    mov al,10110110b
    out 43h,al
    mov ax, bx
    out 42h,al

    mov ah,al
    out 42h,al
    in al,61h
    or al, 00000011b 
    out 61h, al
    sub cx,cx
    Kill_time:
        loop Kill_time
    mov al,ah
    out 61h,al
    pop ax
    pop cx
    mov al,20h
    out 20h,al
    mov ss,old_SS
    mov sp,old_SP
    IRET
SUBR_INT ENDP

; Головная процедура
Main PROC FAR
    mov ah,35h  ;функция получения вектора
    mov al,23h
    int 21h
    mov KEEP_CS,ES
    mov KEEP_IP,BX
    mov bx,8000

    push DS
    mov dx,offset SUBR_INT
    mov ax,seg SUBR_INT
    mov ds,ax
    mov ah,25h
    mov al,23h
    int 21h
    pop ds

Input:
    mov ah, 0
    int 16h
    cmp al, 3  ;код символа после нажатия 
    jne Input

    INT 23H

    CLI ; Сброс флага прерываний IF - 0
    PUSH DS
    MOV DX, KEEP_IP
    MOV AX, KEEP_CS
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 23h ;
    INT 21H ; восстанавливаем старый вектор прерывания
    POP DS
    STI

    MOV AH, 4Ch
    INT 21h
Main ENDP
CODE ENDS
END Main