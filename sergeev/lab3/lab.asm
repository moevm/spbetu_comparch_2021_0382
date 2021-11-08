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
    shl cx,1    ;cx=2i

    mov ax,a
    cmp ax,b
    jle Label_f1_2

Label_f1_1:
    sub cx,2    ;cx=2i-2
    mov i1,cx
                ;f2=-(6*i+8) if a>b, if a<=bx f2=9-3*(i-1)
    shl cx,1    ;cx=4i-4
    add cx,i    ;cx=5i-4
    add cx,i    ;cx=6i-4
    add cx,12   ;cx=6i+8
    neg cx      ;cx=-(6i+8)
    mov i2,cx
    jmp Label_res

Label_f1_2:
    sub cx, 2   ;cx=2i-2
    add cx,i    ;cx=3i-2
    neg cx      ;cx=2-3i
    mov i1,cx
    
    add cx, 10  ;cx=12-3i
    mov i2,cx

Label_res:    ;f3=min(i1,i2) if k=0, if k!=0 f3=max(i1,i2)
    mov bx,i1   ;bx=i1
    mov res,cx  ;res=i2
    cmp k,0
    jne Label_res_else  ;if k!=0
    cmp bx,i2   ;i1?i2   
    jge final
    mov res,bx
    jmp final

Label_res_else:
    cmp bx,i2   ;i1?i2
    jle final
    mov res,bx
    jmp final

final:

Main ENDP
CODE ENDS
    END Main