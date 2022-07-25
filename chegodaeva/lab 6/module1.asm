.586
.MODEL FLAT, C
.CODE
PUBLIC C module1
module1 PROC C arr: dword, n: dword, res: dword, min: dword

push esi
push edi
mov esi, res
mov edi, arr
mov ecx, n

lp:
	mov eax,[edi]
	sub eax,min
	mov ebx,[esi+4*eax]
	add ebx, 1
	mov [esi+4*eax],ebx
	add edi,4
	loop lp

pop edi
pop esi
ret
module1 ENDP
END