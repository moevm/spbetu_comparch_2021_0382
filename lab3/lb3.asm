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
 mov a,1
 mov b,2
 mov i,3
 mov k,4
 
 mov AX, a
 cmp AX, b
 jg f1_first

f1_second:
    mov AX, i
    shl AX, 1 ; = 2i
    add AX, i ; = 3i
    shl AX, 1 ; = 6i
    mov i1, -10
    add i1, AX ; = -10 + 6i
    mov AX, k
    cmp AX, 0
    jge f3_second

f2_second:
    mov AX, i
    shl AX, 1 ; = 2i
    add AX, i ; = 3i
    mov i2, 6
    add i2, AX ; = 3i + 6

i2abs:
      neg i2 ; = |i2|
js i2abs

i1abs:
      neg i1
js i1abs ; = |i1|

f3_first:
    js i2abs
    mov AX,i1
    add AX,i2 ; = |i1| + |i2|
    mov result, AX
    ret

f1_first:
    mov AX, i
    shl AX, 1 ; = 2i
    shl AX, 1 ; = 4i
    mov i1, -3
    sub i1, AX ; = -3 - 4i
    mov AX, k
    cmp AX, 0
    jge f3_second
  
f2_first:
    mov AX, i
    shl AX, 1 ; = 2i
    shl AX, 1 ; = 4i
    add AX, i ; = 5i
    add AX, i ; = 6i
    mov i2, 4
    sub i2, AX ; = 4 - 6i
    jmp f3_first

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