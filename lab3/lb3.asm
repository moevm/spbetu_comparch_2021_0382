AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS


DATA SEGMENT
a DW 0
b DW 0
i DW 0
k DW 0
i1 DW 0
i2 DW 0
result DW 0
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
 push DS
 sub AX,AX
 push AX
 mov AX,DATA
 mov DS,AX
 
 ;Entering data
 mov a,0
 mov b,0
 mov i,0
 mov k,0
 
 mov AX, a
 cmp AX, b
 jg f1_first
 jle f1_second

f1_first:
    mov AX, i
    shl AX, 1 ; = 2i
    shl AX, 1 ; = 4i
    mov i1, -3
    sub i1, AX ; = -3 - 4i
    mov AX, k
    cmp AX, 0
    jl f2_first
    jmp f3_second

f1_second:
    mov AX, i
    shl AX, 1 ; = 2i
    add AX, i ; = 3i
    shl AX, 1 ; = 6i
    mov i1, -10
    add i1, AX ; = -10 + 6i
    mov AX, k
    cmp AX, 0
    jl f2_second
    jmp f3_second

f2_first:
    mov AX, i
    shl AX, 1 ; = 2i
    shl AX, 1 ; = 4i
    add AX, i ; = 5i
    add AX, i ; = 6i
    mov i2, 4
    sub i2, AX ; = 4 - 6i
    jmp f3_first

f2_second:
    mov AX, i
    shl AX, 1 ; = 2i
    add AX, i ; = 3i
    mov i2, 6
    add i2, AX ; = 3i + 6
    jmp f3_first
 i1abs:
      neg i1
  i2abs:
      neg i2 ; = |i2|

f3_first:
  js i1abs ; = |i1|
  js i2abs
    mov AX,i1
    add AX,i2 ; = |i1| + |i2|
    mov result, AX
    ret
  
f3_second:
  js i1abs ; = |i1|
    mov AX, i1
    cmp AX, 6
    jge case
    mov result, 6
    ret
 
case:
    mov result, AX
    ret

Main ENDP
CODE ENDS
 END Main