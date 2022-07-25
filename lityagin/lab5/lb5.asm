AStack SEGMENT STACK
 DW 30 DUP(?)
AStack ENDS

DATA SEGMENT
        KEEP_CS DW 0 ; для хранения сегмента
        KEEP_IP DW 0 ; и смещения вектора прерывания
DATA ENDS


CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack


IntToStr PROC
    push AX ; сохраняем регистры, что будем использовать
    push DX
    push BX
    push CX

    xor CX, CX ; обнуляем CX для хранения кол-ва символов
    mov BX, 10 ; делитель для 10 с.с.
lp:
    xor DX,DX
    div BX ; деление AX = (DX, AX)/BX, остаток в DX
    add DL, '0' ; перевод цифры в символ
    push DX ; сохраяем остаток в стек 
    inc CX ; увеличиваем счетчик
    test AX, AX ; проверка AX
    jnz lp ; если частное не 0, то повторяем
mov ah, 02h
lp2:
    pop DX ; достаем символ из стека
    int 21h
    loop lp2 ; пока cx не 0 выполняется переход

    pop CX ; возвращаем значения из стека
    pop BX
    pop DX
    pop AX
    ret
IntToStr endp


OutInt PROC FAR
        jmp handle
	KEEP_SS DW 0
	KEEP_SP DW 0
	IStack DB 50 dup(" ")
handle:
    	mov KEEP_SP, SP
	mov KEEP_SS, SS
	mov SP, SEG IStack
	mov SS, SP
	mov SP, offset handle

	push AX    ; сохранение изменяемых регистров
	push CX
	push DX
	
	mov AH, 00h
	int 1Ah
	
	mov AX, CX
	call IntToStr
	mov AX, DX
	call IntToStr
	
	pop DX
	pop CX
	pop AX   ; восстановление регистров

	mov SS, KEEP_SS 
	mov SP, KEEP_SP

	mov AL, 20H
	out  20H,AL
	iret
OutInt ENDP


Main	PROC  FAR
	push DS
	sub AX,AX
	push AX
	mov AX, DATA
	mov DS, AX

	mov AH,35h ; возвращение текущего значения вектора прерывания
	mov AL,60h ; номер вектора
	int 21h
	mov KEEP_IP, BX ; запоминание смещения
	mov KEEP_CS, ES ; запоминание сегмента

	push DS
	mov DX, offset OutInt; смещение для процедуры
	mov AX, seg OutInt ; сегмент процедуры
	mov DS, AX
	mov AH, 25h ; функция установки вектора
	mov AL, 60h ; номер вектора
	int 21h ; устанавливаем вектор прерывания на указанный адрес нового обработчика
	pop DS

	int 60h ; вызываем прерывание пользователя
	
	CLI
	push DS
	mov DX, KEEP_IP
	mov AX, KEEP_CS
	mov DS, AX
	mov AH, 25h
	mov AL, 60h
	int 21h
	pop DS
	STI 

	ret
Main ENDP
CODE ENDS
	END Main