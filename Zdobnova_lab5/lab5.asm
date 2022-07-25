AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    ;для хранения сегмента вектора прерывания
    KEEP_IP DW 0    ;для хранения смещения вектора прерывания
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
.186
SUBR_INT PROC FAR

    jmp H_start

    SAVE_SS DW 0
    SAVE_SP DW 0
    SAVE_AX DW 0
    MY_STACK DW 1024 DUP(?)
    
    H_start:
    mov SAVE_SP, sp
    mov SAVE_AX, ax
    mov SAVE_SS, ss
    mov sp, OFFSET H_start
    mov ax, SEG MY_STACK
    mov ss, ax
    mov ax, SAVE_AX
    ;сохранение изменяемых регистров
	push ax 
    push ds

    mov ax, SEG SUBR_INT
    mov ds, ax
    mov ax, SAVE_AX
	mov ah,29h ;заносим функцию вывода строки 
    
	mov al,0Bh               ; CMOS OBh - управляющий регистр В
    out 70h,al               ; порт 70h - индекс CMOS
    in al,71h               ; порт 71h - данные CMOS
    and al,11111011b         ; обнулить бит 2 (форма чисел - BCD)
    out 71h,al               ; и записать обратно
	mov al,4               ; CMOS 04h - час
    call Print_cmos	
    mov al,':'               ;двоеточие
    int 29h
    mov al,2                 ;CMOS 02h - минута
    call Print_cmos
    mov al,':'               ;двоеточие
    int 29h
    mov al,0                ;CMOS 00h - секунда
    call Print_cmos
	mov al,' '               ;пробел
    int 29h
	
	;восстановление регистров
    pop ds
	pop ax 
    
    mov sp, SAVE_SP
    mov ax, SAVE_SS
    mov ss, ax
    mov ax, SAVE_AX
	mov al,20h  ;разрешение обработки прерываний 
	out 20h,al  ;с более низкими уровнями
	iret ;выход из прерывания
SUBR_INT ENDP

Print_cmos proc near
    out 70h,al               ; послать AL в индексный порт CMOS
    in al,71h               ; прочитать данные
    push ax
    shr al,4               ; выделить старшие четыре бита
    add al,'0'               ; добавить ASCII-код цифры 0
    int 29h                  ; вывести на экран
    pop ax
    and al,0Fh               ; выделить младшие четыре бита
    add al,30h               ; добавить ASCII-код цифры 0
    int 29h                  ; вывести на экран
    ret
Print_cmos endp

MAIN PROC FAR

    mov ax, DATA
    mov ds, ax
    ;сохраняем вектор прерывания
    mov ah, 35h     ;функция получения вектора
    mov al, 08h     ;номер вектора
    int 21h
    mov KEEP_CS, es
    mov KEEP_IP, bx

	;устанавливаем новый вектор прерывания
    push ds
    mov dx, OFFSET SUBR_INT
    mov ax, SEG SUBR_INT
    mov ds, ax
    mov ah, 25h ;функция установки вектора
    mov al, 08h ;номер вектора
    int 21h
    pop ds
	
	int 8h
    Restoring_the_vector:  ;восстанавливаем старый вектор прерывания
    cli
    push ds
    mov dx, KEEP_IP
    mov ax, KEEP_CS
    mov ds, ax
    mov ah, 25h ;функция установки вектора
    mov al, 08h ;номер вектора
    int 21h
    pop ds
    sti

    mov ah, 4ch ;завершение программы
    int 21h

MAIN ENDP
CODE ENDS
END MAIN