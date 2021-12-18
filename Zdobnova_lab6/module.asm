.586
.MODEL FLAT, C
.CODE
FUNC PROC C numbers:dword, num_cnt:dword, lgrint:dword, n_int:dword, result:dword
push esi
push edi
push eax
push ebx
push ecx

mov esi, numbers
mov edi, lgrint
mov ecx, num_cnt
mov eax, 0
loop1:
	mov ebx, 0
	finding_border:
		cmp ebx, n_int
		jge exit
		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl exit
		inc ebx
		jmp finding_border
	exit:
	dec ebx
	mov edi, result
	push eax
	mov eax, [edi + 4 * ebx]
	inc eax
	mov [edi + 4 * ebx], eax
	pop eax
	mov edi, lgrint
	inc eax
loop loop1

pop ecx
pop ebx
pop eax
pop edi
pop esi
ret
FUNC ENDP
END