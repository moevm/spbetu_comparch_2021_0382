DATA SEGMENT
    sec db 120
    time db 5
    keep_cs dw 0 ;для хранения сегмента
    keep_ip dw 0 ;и смещения прерывания
DATA ENDS

AStack SEGMENT STACK
    DW 512 DUP(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

SUBR_INT PROC FAR ;обработка прерывания
    push ax

    sound_start:
    	mov al, 10110110b
    	out 43h, al
    	mov ax, 4400
    	;устаналиваем частоту
    	out 42h, al
    	mov al, ah
    	out 42h, al
    	;включаем динамик
    	in  al, 61h     ;текущее состояние порта 61h в AL
    	or  al, 00000011b   ;устанавливаем биты 0 и 1 в 1 (разрешаем работу динамика и включить его)
    	out 61h, al ;включаем динамик

    timer:
    	mov ah, 2ch
    	int 21h
    	cmp dh, sec
    	je timer
	mov sec, dh
	dec time
	jnz timer

    ;выключаем динамик
    sound_end:
    	in  al, 61h
    	and al, 11111100b   ;обнуляем младшие два бита
    	out 61h, al 

    pop ax
    mov al, 20h
    out 20h, al
    iret
SUBR_INT ENDP

Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax

read_symbol:
	mov ah, 0
	int 16h
	cmp ah, 46 ;скан-код клавиши "C"
	jne read_symbol
    
    mov ah, 35h ;функция получения вектора
    mov al, 16h ;номер вектора
    int 21h
    mov keep_ip, bx ;запоминание смещения
    mov keep_cs, es ;и сегмента

    push ds
    mov dx, offset SUBR_INT ;смещение для процедура в DX
    mov ax, seg SUBR_INT ;сегмент процедуры
    mov ds, ax ;помещаем в DS
    mov ah, 25h ;функция установки вектора
    mov al, 16h ;номер вектора
    int 21h ;меняем прерывание
    pop ds

    int 16h

    ;восстанавливаем старый вектор прерывания
    CLI
    push ds
    mov dx, keep_ip
    mov ax, keep_cs
    mov ds, ax
    mov ah, 25h
    mov al, 16h
    int 21h ;восстанавливаем вектор
    pop ds
    STI
	
    ret

Main ENDP
CODE ENDS
END Main