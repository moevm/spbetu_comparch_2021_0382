EOL EQU '$'
AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
    a   DW 4
    b   DW 3
    i   DW 2
    k   DW 1
    i1  DW 0
    i2  DW 0
    res DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX

    mov AX, a
    cmp AX, b
    jle f2
    
    f1:
    mov AX, i
    shl AX, 1  ; умножаем i на 2 (2i)
    mov BX, AX ; сохраняем значение 2i в BX
    shl AX, 1  ; умножаем 2i на 2 (4i)
    add AX, BX ; получаем 6i в регистре AX
    neg AX      ; вносим в скобку
    mov i1, AX  ; сохраняем значение -6i в i1
    add i1, 4   ; отнимаем 4 от 6i
    mov i2, AX  ; сохраняем значение -6i в i2
    sub i2, 8   ; прибавляем 8 к 6i
    jmp f3
    
    f2:
    mov AX, i
    shl AX, 1   ; умножаем i на 2 (2i)
    mov BX, AX  ; сохраняем значение 2i в BX
    add AX, BX  ; получаем 3i в регистре AX
    mov i1, AX  ; сохраняем значение 3i в i1
    mov i2, AX  ; сохраняем значение 3i в i2
    add i1, 6
    sub i2, 12
    neg i2

    f3:
    mov AX, k
    cmp AX, 0   ; сравниваем K с нулем
    jne f3_2

    f3_1:
    mov AX, i1
    add AX, i2
    cmp AX, 0
    jl negative
    jmp result

    negative:
    neg AX
    jmp result

    f3_2:
    mov BX, i1
    cmp BX, i2
    jle min_i1
    mov AX, i2
    jmp result

    min_i1:
    mov AX, i1
    
    result:
    mov res, AX
    ret

Main ENDP
CODE ENDS
    END Main