.586
.MODEL FLAT, C
.CODE

PUBLIC C first_dist
first_dist PROC C numbers: dword, n: dword, result1: dword, x_min: dword

push esi
push edi

mov esi, numbers
mov edi, result1
mov ecx, n

lp:
	mov eax, [esi]
	sub eax, x_min
	mov ebx, [edi+4*eax]
	inc ebx
	mov [edi+4*eax], ebx
	add esi, 4
	loop lp

pop edi
pop esi

ret
first_dist endp
end
