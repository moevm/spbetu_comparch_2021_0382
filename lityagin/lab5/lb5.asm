siz equ 1 ; кол-во символов в строке для ввода

AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
 KEEP_CS DW 0 ; для хранения сегмента
 KEEP_IP DW 0 ; и смещения прерывания
 message DB 0Dh, 0Ah,siz dup("$"), '$' ; строка для ввода-вывода
 message2 DB 0Dh, 0Ah,'End!', '$' ; строка о завершении
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

InOut PROC FAR
	push AX ; сохранение изменяемых регистров
	push CX
	push DX

	mov ax, siz
	mov cx, ax ; помещаем число вводов символов для цикла
	mov di, offset message ; получаем смещение на начало нашего сообщения ввода-вывода
	add di, 2 ; смещаемся на 2 из-за двух первых символов, который делают красиво
lp:	
	mov ah, 01h ; функция ввода с клавиатуры (символ => al)
	int 21h ; вызываем прерывание
	mov [di], al ; помещаем символ в строку
	inc di ; увеличиваем смещение на следующий символ, доступный к записи
	loop lp ; повторяем процесс, пока не введут нужное число символов
	
	mov ah, 09h ; функция вывода строки
	mov dx, offset message ; указываем смещение строки
	int 21h ; вывели
	mov dx, offset message2
	int 21h ; вывели

	pop DX ; счастливые восстановлеваем регистры
	pop CX  
        pop AX
        mov AL, 20h ; для разрешения обрабоки прерываний
        out 20h,AL ; с более низкими уровнями, чем только что обработанное
        iret
InOut ENDP


Main PROC FAR
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
	mov DX, offset InOut ; смещение для процедуры
	mov AX, seg InOut ; сегмент процедуры
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