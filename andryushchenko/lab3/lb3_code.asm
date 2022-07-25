; Стек программы
AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS
; Данные программы
DATA SEGMENT
  a   DW 0 ;определяет переменную размером в слово.
  b   DW 0
  i   DW 0
  k   DW 0
  i1  DW 0
  i2  DW 0
  res DW 0
DATA ENDS
; Код программы
CODE SEGMENT
  ASSUME CS:CODE, DS:DATA, SS:AStack
; Головная процедура
Main PROC FAR
  push DS
  sub AX,AX
  push AX
  mov AX,DATA
  mov DS,AX
  mov i, 1 ; задаем значения переменных для тестирования и отладки
  mov a, 2
  mov b, 3
  mov k, -1
f1_and_f2: 
  mov ax, a
  mov bx, i ; bx = i
  shl bx, 1 ; bx = 2i
  mov cx, bx; cx = 2i
  cmp ax, b 
  jg a_more_b ; если a > b выполним блок a_more_b
  add cx, i ; cx = 3i
  mov bx, cx ; bx = 3i
  shl bx, 1 ; bx = 6i
  neg bx ; bx = -6i
  add cx, 4 ; cx = 3i + 4
  add bx, 8 ; bx = 8 - 6i
  jmp f1_f2_result ; безусловный переход к сохранению результата f1_result
a_more_b:
  shl bx, 1 ; bx = 4i
  neg cx ; cx = -2i
  neg bx ; bx = -4i
  add cx, 15 ; cx = -2i + 15
  add bx, 7 ; bx = 7 - 4i
f1_f2_result:
  mov i1, cx ; i1 = f1(i)
  mov i2, bx ; i2 = f2(i)
f3:
  mov ax, i1
  mov bx, i2
  cmp k, 0
  jl f3_k_less_0 ; если k < 0 переход на метку f3_k_less_0
  cmp ax, bx ; i1 >= i2
  jge i1_more_i2
  sub bx, ax
  mov res, bx
  jmp f3_result
i1_more_i2:
  sub ax, bx ; i1 = i1 - i2
  mov res, ax
  jmp f3_result
f3_k_less_0:
  neg bx
  add bx, 10
  cmp ax, bx
  jge max_i1 ; если i1 >= i2 переход к метке max_i1
  mov res, bx
  jmp f3_result
max_i1:
  mov res, ax
f3_result:
  mov dx, res
  ret
Main ENDP
CODE ENDS
END Main