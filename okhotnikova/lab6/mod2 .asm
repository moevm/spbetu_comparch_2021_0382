.MODEL FLAT, C
.CODE

PUBLIC C distribution_2
distribution_2 PROC C boarders: dword, Nint: dword, result1: dword, Xmin: dword, Xmax: dword, res: dword, flag: dword


mov esi, boarders
mov edi, res
mov ecx, Nint


start_loop:
	mov eax, [esi]
	mov ebx, [esi + 4]

	cmp eax, Xmin
	jge label1
	mov eax, 0
	sub ebx, Xmin
	cmp ebx, 0
	jle label2
	jmp label4

	label1:
		sub ebx, eax
		cmp ebx, 0
		je label2
		sub eax, Xmin
		
		label4:
		push esi
		push ecx

		mov esi, result1
		mov ecx, ebx
		mov ebx, 0

		loop_2:
			add ebx, [esi+4*eax]
			inc eax
			loop loop_2

		pop ecx
		cmp ecx, 1
		jne label5
		add ebx, [esi + 4*eax]

		label5:
			mov [edi], ebx
			pop esi
			jmp label3

	label2:
		mov ebx, 0
		mov [edi], ebx 
	
	label3:
		add edi, 4
		add esi, 4
	loop start_loop



ret
distribution_2 ENDP
END