EOFLine  EQU  '$'        

ASSUME CS:CODE, SS:AStack

AStack    SEGMENT  STACK
          DW 12 DUP('!')
AStack    ENDS


DATA      SEGMENT

HELLO     DB 'Hello Worlds!', 0AH, 0DH,EOFLine
GREETING  DB 'Student from 0382 - Chegodaeva Elizaveta $'
DATA      ENDS

CODE      SEGMENT
WriteMsg  PROC  NEAR
          mov   AH,9
          int   21h 
          ret
WriteMsg  ENDP

Main      PROC  FAR
          push  DS      
          sub   AX,AX
          push  AX
          mov   AX,DATA            
          mov   DS,AX               
          mov   DX, OFFSET HELLO   
          call  WriteMsg           
          mov   DX, OFFSET GREETING
          call  WriteMsg            
          ret               

Main      ENDP
CODE      ENDS
          END Main
