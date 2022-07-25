.586
.MODEL FLAT, C
.CODE

PUBLIC C pre_func
pre_func PROC C numbers: dword, Num_Ran_Dat: dword, pre_answer: dword, X_min: dword

push esi
push edi

mov ecx, Num_Ran_Dat
mov esi, numbers
mov edi, pre_answer

start:
	mov eax, [esi]
	sub eax, X_min
	mov ebx, [edi+4*eax]
	inc ebx
	mov [edi+4*eax], ebx
	add esi, 4
	loop start

pop edi
pop esi

ret
pre_func endp
END