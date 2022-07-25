.MODEL FLAT, C
.CODE

PUBLIC C distribution_2
distribution_2 PROC C boarders: dword, Nint: dword, result1: dword, Xmin: dword, Xmax: dword, res: dword

	mov esi, boarders
	mov edi, res
	mov ecx, Nint

start_loop:
	mov eax, [esi]

	cmp eax, Xmax
	je last_border

	add esi, 4h
	mov ebx, [esi]

	cmp ebx, Xmin
	jle miss ;пропускаем
	cmp eax, Xmin
	jle left_border

	sub ebx, eax
	sub eax, Xmin 

	push ecx
	push esi

	mov ecx, ebx
	mov ebx, 0h
	mov esi, result1
	loop2:
		add ebx, [esi + eax*4]
		add eax, 1
		loop loop2
	mov [edi], ebx
	add edi, 4h

	pop esi
	pop ecx

	jmp final

	miss:
	    mov eax, 0h
		mov [edi], eax
		add edi, 4h
		jmp final
	    
	left_border:
		mov eax, ebx
		sub eax, Xmin
		sub eax, 1h ;так как вернхняя граница интервала не включается
		
		push ebx
		push esi

		mov ebx, 0h
		mov esi, result1
		loop3:
			add ebx, [esi + eax*4]
			sub eax, 1
			cmp eax, 0
			jge loop3

		mov [edi], ebx
		add edi, 4h

		pop esi
		pop ebx

		jmp final
	   

	final:
		loop start_loop
		;учитываем Xmax, если он не указан как левая граница
		mov esi, result1 
		mov ebx, [esi + eax*4]
		sub edi, 4h
		add [edi], ebx
		jmp f_final
	
	last_border: ;учитываем Xmax, если он указан как левая граница
		sub eax, Xmin 
		mov esi, result1
		mov ebx, [esi + eax*4]
		add [edi], ebx

	f_final:

ret
distribution_2 ENDP
END