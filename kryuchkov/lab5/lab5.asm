data segment
    seconds  db 120
    delay    db 5  ;how many seconds to wait.
    
    keep_cs dw 0 ; для хранения сегмента
    keep_ip dw 0 ; и смещения прерывания
data ends

astack segment stack
    dw 512 dup(0)
astack ends

code segment
    assume cs:code, ss:astack, ds:data
beepstart proc near
	push	ax
	
	mov     al, 10110110b    ; the magic number (use this binary number only)
	out     43h, al          ; send it to the initializing port 43h timer 2.

	mov     ax, bx

  ;---------Устанавливаем частоту звука
	out     42h, al          ; send lsb to port 42h.  
	mov     al, ah           ; move msb into al  
	out     42h, al          ; send msb to port 42h.
  ;---------Устанавливаем частоту звука

  ;---------Включаем динамик---------
  in      al,61h          ;see value of port 61h
  or      al,03h          ;set bits 0 and 1
  out     61h,al          ;update port 61h
  ;---------Включаем динамик---------

	pop	ax
  ret
beepstart endp

beepend proc near
	push	ax
  
  ;---------Выключаем динамик---------
  in      al,61h          ;see value of port 61h
  and     al,0fch         ;reset bits 0 and 1
  out     61h,al          ;update port 61h
  ;---------Выключаем динамик---------

	pop	ax
  ret
beepend endp

; delay proc near
; 	push	ax
; 	push 	dx
    

; 	mov 	dx,10000 ;  
;     mov     ah,86h          ;bios delay func        
;     mov     al, 0                        
;     int     15h             

; 	pop	dx
; 	pop	ax
;     ret
; delay endp

my_delay proc near
push	ax
push 	dx
delaying:   
;get system time.
  mov  ah, 2ch
  int  21h ;return seconds in dh.
;check if one second has passed. 
  cmp  dh, seconds
  je   delaying
;if no jump, one second has passed. very important : preserve
;seconds to use them to compare with next seconds. this is how
;we know one second has passed.
  mov  seconds, dh
  dec  delay   
  jnz  delaying  ;if delay is not zero, repeat.

pop	dx
pop	ax

  ret 
my_delay endp

r proc near ; процедура прерывания
	push bx
	push cx

	mov bx, 20000		; частота звука
	call beepstart

	mov delay, ah; время звучания
	call my_delay
	call beepend

	pop cx
	pop bx

	iret;
r endp

set_int proc near
  mov al,60h;
  mov ah,25h;
  push ds
  mov dx, offset r
  mov ax, seg r
  mov ds, ax
  mov ax, 2560h
  int 21h
  pop ds
  ret
set_int endp

main proc far
  mov  ax, ds
  mov  ds, ax     ;initialize data segment.

;----------Запоминаем вектор---------
  mov  ah, 35h   ; функция получения вектора
  mov  al, 60h   ; номер вектора
  int  21h
  mov  keep_ip, bx  ; запоминание смещения
  mov  keep_cs, es  ; и сегмента
;----------Запоминаем вектор---------

;---------Устанавливаем свой вектор---------
  call set_int 
  mov ah, 5; delay in secodns +- 1 second :c
  int 60h;
;---------Устанавливаем свой вектор---------

;-----Восстанавливаем вектор прерывания-------
  cli
  push ds
  mov  dx, keep_ip
  mov  ax, keep_cs
  mov  ds, ax
  mov  ah, 25h
  mov  al, 1ch
  int  21h          ; восстанавливаем вектор
  pop  ds
  sti  
;-----Восстанавливаем вектор прерывания-------

  mov ax, 4c00h	; выход в dos
  int 21h

main endp;
code ends
end main