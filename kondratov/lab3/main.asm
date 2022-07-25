AStack SEGMENT STACK
    DW 32 DUP(?)
AStack ENDS

DATA SEGMENT
    var_a DW 0
    var_b DW 0
    var_i DW 0
    var_k DW 0
    var_i1 DW 0
    var_i2 DW 0
    var_res DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax
f1:
    mov ax, var_i
    shl ax, 1 ;ax = 2i
    shl ax, 1 ;ax = 4i
    mov bx, var_a
    cmp bx, var_b
    jg f1_1
f1_2:
    mov bx, ax ;bx = 4i
    shr bx, 1 ;bx = 2i
    add ax, bx ;ax = 6i
    mov cx, ax ;cx = 6i
    sub ax, 0Ah ;ax = 6i - 10
    neg cx ;cx = -6i
    add cx, 8h ;cx = -6i + 8
    jmp f1_end
f1_1:
    neg ax
    sub ax, 3h ;ax = -4i - 3
    mov cx, ax ;cx = -4i -3
    add cx, 0Ah ;cx = -4i -3 + 10 = -4i + 7
f1_end:
    mov var_i1, ax ; i1 = f1(i)
    mov var_i2, cx ; i2 = f2(i)
f3:
    mov bx, var_i2
    cmp bx, 0h
    jge abs_i2
    neg bx
abs_i2: ; bx = |i2|
    mov ax, var_k    
    cmp ax, 0h
    jl f3_1
f3_2:
    sub bx, 3h ; bx = |i2| - 3
    cmp bx, 4h
    jge max
    mov bx, 4h
max:
    mov ax, bx
    jmp f3_end
f3_1:
    mov ax, var_i1
    cmp ax, 0h
    jge abs_i1
    neg ax
abs_i1: ; ax = |i1|
    sub ax, bx
f3_end:
    mov var_res, ax
    ret
Main ENDP
CODE ENDS
END Main
