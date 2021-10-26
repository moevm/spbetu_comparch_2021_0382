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
 mov a,0
 mov b,0
 mov i,0
 mov k,0
 
 mov AX, a
 cmp AX, b
 
 JG f1_over
 JLE f1_under
f1_over:
 mov AX, i
 shl AX, 1; = 2i
 mov i1, 15
 sub i1, AX; = 15 - 2i
 JMP f2_over
f1_under:
 mov AX, i
 shl AX, 1; = 2i
 add AX, i; = 3i
 add AX, 4 ; = 3i + 4
 mov i1, AX
 JMP f2_under
f2_over:
 mov AX, i
 shl AX, 1 ; = 2i
 shl AX, 1 ; = 4i
 mov i2, 20
 sub i2, AX ; = 20 - 4i
 JMP f3_choice
f2_under:
 mov AX, i
 shl AX, 1; = 2i
 shl AX, 1; = 4i
 add AX, i; = 5i
 add AX, i; = 6i
 mov i2, 6
 sub i2, AX
 JMP f3_choice
f3_choice:
 mov AX, k
 cmp AX, 0
 JL f3_under
 JMP f3_over
  
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
