.MODEL FLAT, C
.CODE

PUBLIC C intervals_distribution
intervals_distribution PROC C intervals: dword, n_int: dword, units: dword, n_units: dword, x_min: dword, res: dword
	mov esi, intervals
	mov edi, res
	mov ecx, n_int
	sub ecx, 1h
start_loop:
	mov eax, [esi]
	add esi, 4h
	mov ebx, [esi]
	sub ebx, eax
	sub eax, x_min

	push ecx
	push esi
	
	mov ecx, ebx
	mov ebx, 0h
	mov esi, units
	start_loop2:
		add ebx, [esi + eax*4]
		add eax, 1
		loop start_loop2
	mov [edi], ebx
	add edi, 4h

	pop esi
	pop ecx

	loop start_loop
	
	mov esi, units
	mov ebx, [esi + eax*4]
	mov [edi], ebx
ret
intervals_distribution ENDP
END
