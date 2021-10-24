; Стек  программы


AStack    SEGMENT  STACK
          DW 12 DUP('!')    ; Отводится 12 слов памяти
AStack    ENDS

; Данные программы

DATA      SEGMENT

;  Директивы описания данных

A	  DW 0
B	  DW 0
I	  DW 4
K	  DW 0 
I1	  DW 0
I2	  DW 0
RES	  DW 0

DATA      ENDS

; Код программы

CODE      SEGMENT

ASSUME CS:CODE, SS:AStack, DS:DATA

F3	   PROC NEAR
	   CMP K,0 ; Compare k and 0
	   JZ IfKzero
	   JNZ IfKnzero
  IfKzero:
           mov AX,I2
           CMP I1,AX
           JG absI1moreI2
           JLE absI1lessI2
  absI1moreI2:
           mov AX,I1 ; AX = I1
           SUB AX,I2 ; AX = I1 - I2
           mov RES,AX ; RES - res f3, res = I1 - I2, I1>I2
           ret	   
  absI1lessI2:
           mov AX,I2 ; AX = I2
           SUB AX,I1 ; AX = I2 - I1
           mov RES,AX ; RES - res f3, res = I2 - I1, I2>=I1
           ret
  IfKnzero:
           mov AX,I2
           CMP I1,AX
           JL minI1lessI2
           JGE minI1moreI2
  minI1lessI2:
           mov AX,I1
           mov RES,AX ; RES - res f3, RES = I1, I1 - min(I1,I2)
           ret
  minI1moreI2:
           mov AX,I2
           mov RES,AX ; RES - res f3, RES = I2, I2 - min(I1,I2) or I2==I1
           ret
           
F3	   ENDP

; Головная процедура
MAIN	  PROC  FAR
	  
	  push  DS       ;\  Сохранение адреса начала PSP в стеке
	  sub   AX,AX    ; > для последующего восстановления по
	  push  AX       ;/  команде ret, завершающей процедуру.
	  mov   AX,DATA             ; Загрузка сегментного
	  mov   DS,AX               ; регистра данных.
           
	  mov AX,B
	  CMP A,AX
	  JG IFAmoreB
	  JLE IFAlessB
	  
  IFAmoreB:
	  mov AX,I ; AX = I
	  SAL AX,1 ; AX = I*2
	  NEG AX ; AX = -I*2
	  ADD AX,15 ; AX = -I*2+15
	  mov I1,AX ; I1 - res f1, I1 = 15-2*I
	  
	  mov AX,I ; AX = I
	  SAL AX,1 ; AX = I*2
	  MOV BX,AX ; BX = AX
	  ADD AX,BX ; AX = AX*2 = I*4
	  ADD AX,BX ; AX = AX*3 = I*6
	  SUB AX,4 ; AX = I*6-4
	  NEG AX ; AX = -(I*6-4)
	  mov I2,AX ; I2 - res f2, I2 = -(6*I-4)
	  
	  JMP Continue ; return to code
	  
  IFAlessB:
	  mov AX,I ; AX = I
	  mov BX, AX ; BX = AX
	  ADD AX,BX ; AX = AX*2
	  ADD AX,BX ; AX = AX*3 = I*3
	  ADD AX,4 ; AX = I*3+4
	  mov I1,AX ; I1 - res f1, I1 = I*3+4
	  
	  mov AX,I ; AX = I
	  ADD AX,2 ; AX = I+2
	  mov BX,AX ; BX = AX
	  ADD AX,BX ; AX = 2*(I+2)
	  ADD AX,BX ; AX = 3*(I+2)
	  mov I2,AX ; I2 - res f2, I2 = 3*(I+2)
	  
  Continue: 
	  CALL F3
	  
	  
          ret                       ; Выход в DOS по команде,
                                    ; находящейся в 1-ом слове PSP.
Main      ENDP
CODE      ENDS
          END MAIN         

