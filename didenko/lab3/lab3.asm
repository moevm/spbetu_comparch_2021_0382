; Стек программы
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
res DW 0
tst DW 6
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
 mov a,5
 mov b,5
 mov i,2
 mov k,-1
 
 mov AX, i
 shl AX,1; = 2i
 mov BX, a
 cmp BX, b
 
 JLE f1_under
 
f1_over:
 mov i1, 15
 sub i1, AX; = 15 - 2i
 mov AX, i1
 
 shl AX,1; = 30 - 4i
 sub AX,10; = 20 - 4i
 mov i2,AX
 
 JMP f3_choice
 
f1_under:
 add AX, i; = 3i
 add AX, 4 ; = 3i + 4
 mov i1, AX

 shl AX,1
 sub AX,14
 neg AX
 mov i2,AX
 
f3_choice:
 mov AX, k
 cmp AX, 0
 JGE f3_over
 
f3_under:
 mov AX,i1
 sub AX,i2; = i1 - i2
 cmp AX, 0
 JGE positive
 NEG AX; abs AX
 positive:
 cmp AX, 2
 JB bigger
 mov res, 2
 ret
  
f3_over:
 mov AX, i2
 NEG AX; -i2
 cmp AX, -6
 JGE bigger
 mov res, -6
 ret
 
bigger:
 mov res, AX
 ret

Main ENDP
CODE ENDS
 END Main
