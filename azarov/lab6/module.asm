.MODEL FLAT, C
.CODE


PUBLIC C count_distribution
count_distribution PROC C  numbers: dword, n: dword, borders: dword, n_gr: dword, units: dword, n_units: dword, x_min: dword, res: dword
	mov esi, numbers
	mov edi, units
	mov ecx, n

loop_count_dist:
	mov eax, [esi]
	sub eax, x_min
	mov ebx, [edi + 4*eax]
	add ebx, 1
	mov [edi + 4*eax], ebx
	add esi, 4
	loop loop_count_dist

;----------------------------------------------

	mov esi, borders
	mov edi, res
	sub n_gr, 1
	mov ecx, n_gr
	sub n_units,1 ;делаем из кол-ва эл , мах индекс

start_loop:
	mov eax, [esi]
	add esi, 4h
	mov ebx, [esi]
	sub ebx, eax ; смещение от левой границы до правой границы (не включ)  текущего инт.
	sub eax, x_min ; левая граница текущ. инт.

	push ecx
	push esi
	
	mov ecx, ebx
	mov ebx, 0h ; сумма единичных интервалов в диапазоне [ lg[i], rg[i] )
	mov esi, units

	start_loop2:
		cmp eax, n_units
		jg end_loop2

		add ebx, [esi + eax*4]
		add eax, 1
		loop start_loop2
	end_loop2:

	mov [edi], ebx
	add edi, 4h

	pop esi
	pop ecx

	loop start_loop
	
ret
count_distribution ENDP
END