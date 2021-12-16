.MODEL FLAT, C
.CODE

PUBLIC C second_dist
second_dist PROC C result1: dword, intervals: dword, n_int:dword, result2: dword, x_min: dword

push esi
push edi

mov esi, intervals
mov edi, result2
mov ecx, n_int

lp:
	mov eax, [esi]
	mov ebx, [esi+4]

	cmp ebx, x_min
	jle m1

	cmp eax, x_min
	jge m2

	sub ebx, x_min
	inc ebx
	mov eax, 0 ; числа от левой границы до x_min не имеет смысла проверять
	jmp m4

	m2:
		sub ebx, eax
		inc ebx
		sub eax, x_min

	m4:
	push esi
	push ecx

	mov esi, result1
	mov ecx, ebx
	mov ebx, 0
	lp2:
		add ebx, [esi+4*eax]
		inc eax
		loop lp2

	mov [edi], ebx
	add edi, 4

	pop ecx
	pop esi
	jmp m3
	m1:
		mov ebx, 0
		cmp ecx, 1
		jne m5
		mov esi, result1
		mov eax, 0
		add ebx, [esi+4*eax]
		m5:
		mov [edi], ebx
		add edi, 4
	m3:
	add esi, 4
	loop lp

pop edi
pop esi

ret
second_dist endp
end
