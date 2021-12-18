.MODEL FLAT, C
.DATA
	
.CODE

PUBLIC C unit_distribution
unit_distribution PROC C numbers: dword, n: dword, res: dword, xmin: dword, mid: dword 
	mov esi, numbers
	mov edi, res
	mov ecx, n
	mov edx, 0h

start_loop:
	add edx, [esi]
	mov eax, [esi]
	sub eax, xmin
	mov ebx, [edi + 4*eax]
	add ebx, 1
	mov [edi + 4*eax], ebx
	add esi, 4
	loop start_loop

	mov edi, mid
	mov [edi], edx

	fild dword ptr [edi]
	fild dword ptr n
	fdivp
	fst dword ptr [edi]
ret
unit_distribution ENDP
END
