.586
.MODEL FLAT, C
.CODE
	func PROC C nums:dword, numsCount:dword, leftBorders:dword, result:dword
		push eax
		push ebx
		push ecx
		push edx
		push esi
		push edi

		mov ecx, numsCount
		mov esi, nums
		mov edi, leftBorders

		mov edx, 0				      ; индекс текущего номера
		l:
			mov ebx, [esi+4*edx]      ; текущий номер
			cmp ebx, [edi]            ; крайняя левая граница
			jl continue               ; если x < крайняя левая граница
			
			mov eax, 0                ; индекс интервала
			searchInterval:
				cmp ebx, [edi+4*eax]
				jl endSearch
				inc eax
				jmp searchInterval
			endSearch:

			mov edi, result
			mov ebx, [edi+4*eax]      ; интервал в массиве результатов
			inc ebx
			mov [edi+4*eax], ebx
			mov edi, leftBorders

			continue:
			inc edx
			loop l

		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret
	func ENDP
END 