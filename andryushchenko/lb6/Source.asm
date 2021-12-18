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

		mov edx, 0; index of current number
		l:
			mov ebx, [esi+4*edx]; current number
			cmp ebx, [edi]; most left border
			jl continue; if x < most left border
			
			mov eax, 0; index of interval
			searchInterval:
				cmp ebx, [edi+4*eax]
				jl endSearch
				inc eax
				jmp searchInterval
			endSearch:

			mov edi, result
			mov ebx, [edi+4*eax]; interval in result array
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