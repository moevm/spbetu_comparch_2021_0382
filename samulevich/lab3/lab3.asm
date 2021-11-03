AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT

a DW 5
b DW 5
i DW -4
k DW 4
i1 DW 0
i2 DW 0
res DW 0
ix2  DW 0
ix3  DW 0

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX

    mov AX,i
    shl AX,1
    mov ix2,AX
    add AX,i
    mov ix3,AX
    mov CX,a
    cmp CX,b
    jg first_path ;a > b

second_path:

f1_2: ;i1=-6-6i

    shl AX,1
    neg AX
    sub AX,6
    mov i1,AX
   

f2_2: ;i2=-3i+2

    mov AX,ix3
    neg AX
    add AX,2
    mov i2,AX
    jmp f3


first_path:

f1_1: ;i1=20-4i

    mov AX,ix2
    shl AX,1
    neg AX
    add AX,20
    mov i1,AX

f2_1: ;i2=2i-2 

    mov AX,ix2
    sub AX,2
    mov i2,AX


f3: 
    neg AX
    mov CX,k
    cmp CX,0
    jl f3_1 ; K<0

f3_2: ;res=max(-6,-i2)

    mov DX,-6   
    cmp AX,DX
    jg f3_res_1 ; -i2 > -6

f3_res_2:
    mov res,DX
    jmp stop

f3_res_1:
    mov res,AX
    jmp stop
    
f3_1: ;res=min (| i1-i2|,2)

    add AX,i1
module:
    neg AX
    js module
    mov DX,2
    cmp AX,DX
    jl f3_res_1
    jmp f3_res_2

stop:
    
    ret
Main ENDP
CODE ENDS
    END Main
