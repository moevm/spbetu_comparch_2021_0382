.586
.MODEL FLAT, C
.DATA
	
.CODE

PUBLIC C distribution_1
distribution_1 PROC C arr: dword, len_arr: dword, res: dword, Xmin: dword

push esi
push edi

mov esi, arr
mov edi, res
mov ecx, len_arr
mov edx, 0h

start_loop:
	mov eax, [esi]
	sub eax, Xmin
	mov ebx, [edi + 4*eax]
	add ebx, 1
	mov [edi + 4*eax], ebx
	add esi, 4
	loop start_loop

pop edi
pop esi
	
ret
distribution_1 ENDP
END