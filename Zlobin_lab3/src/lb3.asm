AStack SEGMENT STACK
    DW 32 DUP(?)
AStack ENDS

DATA SEGMENT
    a Dw -5
    b Dw 2
    i Dw -2
    k Dw -1
    i1 Dw 0
    i2 Dw 0
    res Dw 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax

f1_f2:
    mov ax, i
    shl ax, 1; ax = 2i
    mov cx, i
    add cx, ax ; cx = 3i
    mov bx, ax ; bx = 2i
    
    mov ax, a
    cmp ax, b
    jg a_more_b

a_less_b:
    mov bx, cx ; bx = cx = 3i
    neg cx ; cx = -3i
    add bx, 4h ; bx = 3i + 4
    add cx, 0Ah ; cx = -3i + 10
    jmp f1_f2_end
    
a_more_b:
    mov cx, bx ; cx = bx = 2i
    neg bx ; bx = -2i
    shl cx, 1 ; cx = 4i
    neg cx ; cx = -4i
    add bx, 0Fh ; bx = -2i + 15
    add cx, 5h ; cx = -4i + 5

f1_f2_end:
    mov i1, bx ; i1 = f1(i)
    mov i2, cx ; i2 = f2(i)

f3:
    mov ax, k    
    cmp ax, 0h
    jge k_more_0
k_less_0:
    mov ax, i1
    sub ax, i2
    cmp ax, 0h
    jge sub_abs
    neg ax
sub_abs:
    jmp f3_end
k_more_0:
    mov ax, i2
    cmp ax, 0h
    jge abs_i2
    neg ax
abs_i2:
    cmp ax, 7h
    jge f3_end
    mov ax, 7h

f3_end:
    mov res, ax
    ret
Main ENDP
CODE ENDS
	END Main