.586
.MODEL FLAT, C
.CODE
FUNC PROC C array:dword, array_size:dword, left_boarders:dword, intervals_size:dword, result_array:dword
push ecx
push esi
push edi
push eax
push ebx ; сохранение регистров

mov ecx, array_size
mov esi, array
mov edi, left_boarders
mov eax, 0     ; индекс рассматриваемого числа
l1:             ; цикл по всем сгенерированным числам в массиве
	mov ebx, 0  ; индекс рассматриваемого интервала
	boarders:   ; цикл нахождения интервала, в который попадает число
 		cmp ebx, intervals_size ; если дошли до последнего интервала, выходим из цикла
		jge boarders_exit
		push eax
		mov eax, [esi+4*eax]
		cmp eax, [edi+4*ebx]
		pop eax
		jl boarders_exit
		inc ebx
		jmp boarders
	boarders_exit:
	dec ebx        ; на выходе получили индекс интервала, в который попало число

	cmp ebx, -1    ; если индекс -1, то число не попало ни в один интервал
	je skip
	mov edi, result_array
	push eax
	mov eax, [edi+4*ebx]
	inc eax
	mov [edi+4*ebx], eax
	pop eax
	mov edi, left_boarders
	skip:
	inc eax       ; переход к следующему числу
loop l1

pop ebx ; восттановление регистров
pop eax
pop edi
pop esi
pop ecx
ret
FUNC ENDP
END