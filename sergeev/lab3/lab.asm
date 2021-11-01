AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT

    a DW 5
    b DW 5
    i DW -1
    k DW 1
    i1 DW 0  ;f1=2*(i+1)-4 if a>b, if a<=b f1=5-3*(i+1) f1=2i-2 f1=-3i+2
    i2 DW 0  ;f2=-(6*i+8) if a>b, if a<=bx f2=9-3*(i-1) f2=-6i-8 f2=12-3i
    res DW 0 ;f3=min(i1,i2) if k=0, if k!=0 f3=max(i1,i2)

DATA ENDS


CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX

    mov cx,i    ;cx=i
    mov dx,cx   ;dx=i
    shl cx,1    ;cx=2i
    mov di,cx   ;di=2i

    mov ax,a
    cmp ax,b
    jle Label_f1_2

Label_f1_1:
    mov ax,di   ;ax=2i
    sub ax,2    ;ax=2i-2
    mov i1,ax
                ;f2=-(6*i+8) if a>b, if a<=bx f2=9-3*(i-1)
    shl cx,1    ;cx=4i
    add cx,di   ;cx=6i
    add cx,8    ;cx=6i+8
    neg cx      ;cx=-(6i+8)
    mov i2,cx
    jmp Label_res

Label_f1_2:
    mov ax,2    ;ax=2
    sub ax, di  ;ax=2-2i
    sub ax, dx  ;ax=2-3i
    mov i1,ax
    
    add cx,dx  ;cx=3i
    neg cx     ;cx=-3i
    mov ax,12
    add ax,cx
    mov i2,ax

Label_res:    ;f3=min(i1,i2) if k=0, if k!=0 f3=max(i1,i2)
    mov bx,i2
    mov res,ax
    cmp k,0
    jne Label_res_else
    cmp ax,i2
    jle final
    mov res,bx
    jmp final

Label_res_else:
    cmp ax,i2
    jge final
    mov res,bx
    jmp final

final:

Main ENDP
CODE ENDS
    END Main