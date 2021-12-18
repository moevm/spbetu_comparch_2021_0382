.MODEL FLAT, C
.CODE

PUBLIC C final_func
final_func PROC C intervals: dword, N_int: dword, pre_answer:dword, X_min: dword, final_answer: dword

push esi
push edi

mov esi, intervals
mov edi, final_answer
mov ecx, N_int

start:
	mov eax, [esi]
	mov ebx, [esi+4]

	cmp ebx, X_min
	jle mark1

	cmp eax, X_min
	jge mark2

	sub ebx, X_min
	inc ebx
	mov eax, 0 
	jmp mark4

	mark2:
		sub ebx, eax
		inc ebx
		sub eax, X_min

	mark4:
		push esi
		push ecx

		mov esi, pre_answer
		mov ecx, ebx
		mov ebx, 0
	start2:
		add ebx, [esi+4*eax]
		inc eax
		loop start2

	mov [edi], ebx
	add edi, 4

	pop ecx
	pop esi
	jmp mark3
	mark1:
		mov ebx, 0
		cmp ecx, 1
		jne mark5
		mov esi, pre_answer
		mov eax, 0
		add ebx, [esi+4*eax]
		mark5:
			mov [edi], ebx
			add edi, 4
	mark3:
		add esi, 4
		loop start

pop edi
pop esi

ret
final_func endp
end
