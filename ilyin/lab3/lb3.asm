AStack SEGMENT STACK
    DW 32 DUP(?)
AStack ENDS

DATA SEGMENT
    a Dw 5
    b Dw 2
    i Dw -2
    k Dw 1
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
    mov bx, i
    shl bx, 1; bx = 2i
    mov cx, i
    add cx, bx ; cx = 3i
    
    mov ax, a
    cmp ax, b
    jg a_more_b

a_less_b:
    mov bx, cx ; bx = cx = 3i
    neg cx ; cx = -3i
    add bx, 4h ; bx = 3i + 4
    add cx, 0Ch ; cx = -3i + 12
    jmp f1_f2_end
    
a_more_b:
    shl cx, 1; cx = 6i
    add cx, 8h ; cx = 6i + 8
    neg bx ; bx = -2i
    neg cx ; cx = -(6i + 8)
    add bx, 0Fh ; bx = -2i + 15

f1_f2_end:
    mov i1, bx ; i1 = f1(i)
    mov i2, cx ; i2 = f2(i)

f3:
    mov ax, k    
    cmp ax, 0h
    jge k_more_0
k_less_0_1:
    mov ax, i1
    cmp ax, 0h
    jge k_less_0_2
    neg ax
k_less_0_2:
    mov bx, i2
    cmp bx, 0h
    jge k_less_0_3
    neg bx
k_less_0_3:
    add ax, bx
    cmp ax, 0h
    jmp f3_end
    
k_more_0:
    mov ax, i1
    cmp ax, 0h
    jge abs_i1
    neg ax
abs_i1:
    cmp ax, 6h
    jge f3_end
    mov ax, 6h

f3_end:
    mov res, ax
    ret
Main ENDP
CODE ENDS
	END Main
