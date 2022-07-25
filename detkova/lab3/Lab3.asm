AStack    SEGMENT  STACK
          DW 12 DUP('!')
AStack    ENDS


DATA      SEGMENT


A	  DW 0
B	  DW 0
I	  DW 4
K	  DW 0
I1	  DW 0
I2	  DW 0
RES	  DW 0

DATA      ENDS


CODE      SEGMENT

ASSUME CS:CODE, SS:AStack, DS:DATA


MAIN	  PROC  FAR
	  
	  push  DS      
	  sub   AX,AX   
	  push  AX      
	  mov   AX,DATA 
	  mov   DS,AX               
           
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
	  
	  SAL AX,1 ; AX = 30-4*I
	  SUB AX,I ; AX = 30-5*I
	  SUB AX,I ; AX = 30-6*I
	  SUB AX,26 ; AX = 4-6*I
	  mov I2,AX ; I2 - res f2, I2 = -(6*I-4)
	  
	  JMP Continue ; return to code
	  
  IFAlessB:
	  mov AX,I ; AX = I
	  SAL AX,1 ; AX = 2*I
	  ADD AX,I ; AX = 3*I
	  ADD AX,4 ; AX = I*3+4
	  mov I1,AX ; I1 - res f1, I1 = I*3+4
	  
	  ADD AX,2 ; AX = I*3+6
	  mov I2,AX ; I2 - res f2, I2 = 3*(I+2)
	  
  Continue: 
  
	  CMP K,0 ; Compare k and 0
	  JZ IfKzero
	  mov AX,I2
          CMP I1,AX
          JL minI1lessI2
          mov RES,AX ; RES - res f3, RES = I2, I2 - min(I1,I2) or I2==I1
          JMP Finish
  IfKzero:
          mov AX,I1 ; AX = I1
          SUB AX,I2 ; AX = I1-I2
          CMP AX,0
          JL Abs
          mov RES,AX
          JMP Finish
  Abs:
          NEG AX
          mov RES,AX
          JMP Finish
  minI1lessI2:
           mov AX,I1
           mov RES,AX ; RES - res f3, RES = I1, I1 - min(I1,I2)
  Finish:
          ret                     
                                            
Main      ENDP
CODE      ENDS
          END MAIN         

