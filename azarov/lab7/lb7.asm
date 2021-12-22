STACKSG SEGMENT  PARA STACK 'Stack'
        DW       512 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'; SEG DATA
	KEEP_CS DW 0 ;
        MESSAGE1 DB 'Перевод из регистра AX в строку: $'
        MESSAGE2 DB 'Перевод из строки в регистр AX и обратно: $'
	STRING DB 35 DUP('#')
DATASG	ENDS; ENDS DATA


CODE SEGMENT; SEG CODE
ASSUME  DS:DataSG, CS:Code, SS:STACKSG
;-32 768:+32 767





AX_TO_STR PROC NEAR
	jmp start_1
	delete_nul DW 0
start_1:
	mov delete_nul, 0
	mov DI, 0h; DI - индекс текущего символа строки
    cmp AX, 0
	jge positive
			
negative:
	mov STRING[DI], '-'
	add DI, 1 ;инвертируем число и прибавляем единицу
	not AX
	add AX,1
	jmp scan_ax

check_nul:
	cmp delete_nul, 0
	je skip_char
	jmp no_skip_char

positive:
	mov STRING[DI], '+'
	add DI, 1
	cmp AX, 0
	je case_nul

scan_ax:
	mov SI,AX ; записываем в si, ax
	mov	cx, 4		; в слове 4 ниббла (полубайта)

next_char:
	rol	ax, 1		; выдвигаем младшие 4 бита
	rol	ax, 1
	rol	ax, 1
	rol	ax, 1
	push	ax		; сохраним AX
	and	al, 0Fh		; оставляем 4 младших бита AL
	cmp	al, 0Ah		; сравниваем AL со значением 10
	sbb	al, 69h		; целочисленное вычитание с заёмом
	das			; BCD-коррекция после вычитания
	cmp al, '0'
	je check_nul
	mov delete_nul, 1

no_skip_char:
	mov STRING[DI], al
	add DI, 1

skip_char:
	pop	ax		; восстановим AX
	loop next_char
	jmp end_1

case_nul:
	mov STRING[DI], '0'
	add DI, 1

end_1: ; когда прошли все регистры
	mov STRING[DI],'$' ; добавляем в конец строки символ конца строки
	mov DX,offset STRING ; записываем в dx сдвиг строки
	ret
AX_TO_STR ENDP	






STR_TO_AX PROC FAR
	jmp start_2
	IS_NEG DB 0; отвечает за знак числа

start_2:
	mov AX,0; обнуляем ax
	mov CX, 0
	mov SI,0; за индекс строки будет отвечать si
	cmp STRING[SI],'-' ; сравниваем первый элемент строки с минусом
	jne positive_parse; если не равен минусу, то число положительное
	;если равен то отрицательное
	mov IS_NEG,1; в is_neg записываем 1

positive_parse: ; если число положительно
	mov SI,0 ; кладем в SI 0

len_loop: ; считаем длину строки
	add SI,1
	cmp STRING[SI],'$' ; сравниваем элемент строки с $
	jne len_loop ; если не равен $ то возвращаемся в цикл

	mov DI, SI
	lea SI, STRING
	inc SI
	xor cx, cx
	cld

number_construct:
	xor AX, AX
	dec DI ; декреминтим DI
	cmp DI,0 ; сравниваем DI с 0
	jle done ; DI <= 0
	lodsb
	cmp al, 'A'
	jge bukva

continue:
	sub al, '0'
	xchg ax, cx
	mov dx, 10h
    mul dx
	add cx, ax
	jmp number_construct
done:
	mov ax, cx
	cmp IS_NEG, 1
	je check_negative
	jmp end_2

bukva:
	sub al, 7
	jmp continue

check_negative:
	not ax
	add ax, 1

end_2:
	ret
STR_TO_AX ENDP





Main PROC FAR
   	mov  ax, DATASG                     
   	mov  ds, ax   
	
        mov DX, offset MESSAGE1
        mov ah,09h;
	int 21h;
	mov AX, 0h ; задаем регистр AX
	pushf
	call AX_TO_STR
	mov ah,09h;
	int 21h;
	
	mov dl, 10
	mov ah, 02h
	int 21h
	mov dl, 13
	mov ah, 02h
	int 21h

        mov DX, offset MESSAGE2
        mov ah,09h;
	int 21h;
	mov ax, 0
	call STR_TO_AX
	popf
	call AX_TO_STR

	mov ah,09h
	int 21h

	mov ah,4Ch;
	int 21h;
	
Main      ENDP
CODE      ENDS
END Main