AStack    SEGMENT  STACK
          DW 20 DUP('!')
AStack    ENDS


DATA      SEGMENT

    KEEP_CS DW 0 ; для хранения сегмента
    KEEP_IP DW 0 ; и смещения прерывания

DATA      ENDS


CODE      SEGMENT

ASSUME CS:CODE, SS:AStack, DS:DATA


SUBR_INT  PROC FAR

          jmp handle
          SS_int dw 0
          SP_int dw 0
          int_Stack DW 512 DUP('0')
          
          handle:
          
          mov SS_int, SS
          mov SP_int, SP
          
          mov SP, seg int_Stack
          mov SS, SP
          mov SP, offset handle
                  
          push ax ; сохранение изменяемых регистров
          push cx
          
  
          mov     al, 10110110b
          out     43h, al         
          mov     ax, bx
          out     42h, al 
          mov     al, ah 
          out     42h, al
          
          in      al,61h
          or      al,03h
          out     61h,al
          
          sub cx, cx
          TIME: LOOP TIME
          
	  in      al,61h
	  and     al,0fch
	  out     61h,al
	  
          
          pop cx ; восстановление изменяемых регистров
          pop ax
          
          mov SS, SS_int
          mov SP, SP_int
          
          MOV AL, 20H
          OUT 20H,AL
          
          IRET
SUBR_INT  ENDP

MAIN	  PROC  FAR
	  
	  push  DS      
	  sub   AX,AX   
	  push  AX      
	  mov   AX,DATA 
	  mov   DS,AX               
          
          mov AH, 35h ; функция получения вектора
          mov AL, 08h ; номер вектора
          int 21h
          mov KEEP_IP, bx ; сохраняем смещение
          mov KEEP_CS, es ; сохраняем сегмент
          
          push ds
          mov dx, offset SUBR_INT
          mov ax, seg SUBR_INT
          mov ds, ax
          mov ah, 25h
          mov al, 08h
          int 21h
          pop ds
	  
	  mov bx, 4000 ; частота звука записывается в регистр bx
          
          get_key:
             
             mov ah, 0h
             int 16h
             cmp al, 27
             
          jne get_key
	  
          cli
          push DS
          mov  DX, KEEP_IP
          mov  AX, KEEP_CS
          mov  DS, AX
          mov ah, 25h
          mov al, 08h
          int  21H          ; восстанавливаем вектор
          pop  DS
          sti
	  
          ret                     
                                            
Main      ENDP
CODE      ENDS
          END MAIN     
