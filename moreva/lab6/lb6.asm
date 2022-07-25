.586
.MODEL FLAT, C
.CODE
FUNC PROC C numbers:dword, num_count:dword, lGrInt:dword, n_int:dword, res:dword

;помещаем данный в стек для сохранения состояния
push edi
push esi
push eax
push ebx
push ecx

;передаем переданные данные 
mov esi, numbers
mov edi, lGrInt
mov ecx, num_count
xor eax, eax

next_rand_number:

	xor ebx, ebx
	
	next_lg:
	
		cmp ebx, n_int  
		jge lb1 ;X!=Y
		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl lb1
		inc ebx
		jmp next_lg

	lb1:
	
		dec ebx
		mov edi, res
		push eax
		;увеличение счётчика в текущем интервале
		mov eax, [edi + 4 * ebx]
		inc eax
		mov [edi + 4 * ebx], eax
		pop eax
		mov edi, lGrInt
		inc eax
	
loop next_rand_number;inc ecx

pop ecx
pop ebx
pop eax
pop edi
pop esi
ret

FUNC ENDP
END