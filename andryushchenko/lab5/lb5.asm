; Стек программы
AStack SEGMENT STACK
    DW 512 DUP(?) ; выделим 1 Кбайт памяти
AStack ENDS
; Данные программы
DATA SEGMENT
  KEEP_CS DW 0 ; для хранения сегмента
  KEEP_IP DW 0 ; и смещения вектора прерывания

DATA ENDS
; Код программы
CODE SEGMENT
ASSUME CS:CODE, DS:DATA, SS:AStack
SUBR_INT PROC FAR ; звуковое прерывание от таймера
  jmp h_start
  save_ss dw 0000h
  save_sp dw 0000h
  ind_stack dw 512 DUP(?)
  h_start:


    mov save_ss, SS
    mov save_sp, sp
    mov sp, seg ind_stack
    mov ss, sp
    mov sp, OFFSET h_start
    PUSH CX ; сохранение изменяемых регистров
    PUSH AX

  MOV AL, 10110110b 	;цепочка для командного регистра 8253
  out 43h, al
  MOV AX, BX
  OUT 42H, AL ; включение таймера, который будет выдавать импульсы на динамик с заданной частотой 
  
  MOV AH, AL
  OUT 42H, AL 
  IN AL,61H ; получаем состояние динамика
  OR AL, 00000011b 
  OUT 61H, AL ; включить динамик
        
  sub cx, cx ;
  TIME: LOOP TIME ; уменьшает значение в регистре СХ, если СХ != 0, то выполняется переход к метке
  ; флаги не меняются
  
  MOV AL, AH
  OUT 61H, AL ; выключить динамик

  POP AX ; восстановление регистров
  POP CX
    mov ss, save_ss
  mov sp, save_sp
  MOV AL, 20H
  OUT 20H,AL ; вывод на порт
  IRET
  SUBR_INT ENDP
; Головная процедура
Main PROC FAR
  MOV AH, 35H ; функция получения вектора
  MOV AL, 08h ; номер вектора прерывания в соответствии с заданием
  INT 21H ; реализуется процедура прерывания
  MOV KEEP_IP, BX ; запоминание смещения
  MOV KEEP_CS, ES ; и сегмента вектора прерывания
  MOV BX, 500 ; высота звука
  PUSH DS
  MOV DX, OFFSET SUBR_INT ; смещение для процедуры в DX
  MOV AX, SEG SUBR_INT ; сегмент процедуры
  MOV DS, AX ; помещаем в DS
  MOV AH, 25H ; функция установки вектора?
  MOV AL, 08h ; номер вектора
  INT 21H ; меняем прерывание
  POP DS
; Команды для проверки работы программы
 inputKeyBoard:
  mov ah, 0h
  int 16h
  cmp al, 'w'
  je UpVol
  cmp al, 's'
  je DownVol
  jmp endInput
UpVol:
  ;cmp bx, 1000
  ;jge inputKeyBoard
  add bx, 500
  jmp inputKeyBoard
DownVol:
  ;cmp bx, 500
  ;jle inputKeyBoard
  sub bx, 500
  jmp inputKeyBoard

endInput:
  CLI ; Сброс флага прерываний IF - 0
  PUSH DS
  MOV DX, KEEP_IP
  MOV AX, KEEP_CS
  MOV DS, AX
  MOV AH, 25H
  MOV AL, 08h ;
  INT 21H ; восстанавливаем старый вектор прерывания
  POP DS
  STI
  MOV AH, 4Ch
  INT 21h
Main ENDP
CODE ENDS
END Main