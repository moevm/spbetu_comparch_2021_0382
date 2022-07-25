.586
.MODEL FLAT, C
.CODE
PUBLIC C module2
module2 PROC C distr: dword, interv: dword, min: dword, max: dword, res: dword

push esi
push edi
push eax
push ebx
push ecx 

mov esi, res
mov edi, interv
mov eax, min
mov ebx, 0
mov ecx, 0


Start:
cmp eax, [edi+4*ebx]
jl Act 
add ebx, 1
jmp Start

Act:
	push edi
	push eax
	mov edi, distr
	sub ebx, 1; ")"
	mov eax, [esi+4*ebx] 
	mov edx, [edi+4*ecx] 
	add eax, edx 
	mov [esi+4*ebx], eax
	pop eax
	pop edi
		push ecx
		mov ecx, max
		cmp eax, ecx 
		pop ecx
		je final
	add ecx, 1 
	add eax, 1
	jmp Start

final:
	pop eax
	pop ebx
	pop ecx
	pop edi
	pop esi	
	ret
module2 ENDP
END
