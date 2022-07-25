AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
    a DW -3
    b DW 2
    i DW 2
    k DW 1
    i1 DW 0
    i2 DW 0
    res DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push ds
    sub ax,ax
    push ax
    mov ax,DATA
    mov ds,ax

f12:
    mov ax,i
    shl ax,1 ;ax=2i
    add ax,i ;ax=3i
    neg ax ;ax=-3i
    mov cx,a
    cmp cx,b
    jle f12_case2 ;if a<=b

;f12_case1
    sub ax,i ;ax=-4i
    add ax,5 ;ax=-4i+5
    mov bx,ax ;bx=-(4i-5)
    add ax,15 ;ax=-4i+20
    jmp f12_end

f12_case2:
    mov bx,ax ;bx=-3i
    shl ax,1 ;ax=-6i
    add ax,6 ;ax=-6i+6
    add bx,10 ;bx=-3i+10

f12_end:
    mov i1,ax ;i1=-(6i-6)
    mov i2,bx ;i2=-3i+10

f3:
    cmp i1,0
    jge abs_i1 ;if i1>=0

    ;if i1<0
    neg i1

abs_i1:
    cmp k,0
    jne k_not_0 ;if k!=0
   
;k=0
    cmp i1,6
    jge min_6 ;if i1>=6
    
;min_i1
    mov ax,i1 ;ax=i1
    jmp f3_end

min_6:
    mov ax,6 ;ax=6
    jmp f3_end

k_not_0:
    cmp i2,0
    jge abs_i2 ;if i2>=0

    ;if i2<0
    neg i2

abs_i2: 
    mov ax,i1 ;ax=|i1|
    add ax,i2 ;ax=|i1|+|i2|
    
f3_end:
    mov res,ax ;res=ax
    ret

Main ENDP
CODE ENDS
END Main
