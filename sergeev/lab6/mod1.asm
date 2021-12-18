.586
.MODEL FLAT, C
.CODE
PUBLIC C mod1
mod1 PROC C numbers:dword, n:dword, res1:dword, xmin:dword

push esi
push edi

mov esi,numbers
mov edi,res1
mov ecx,n

cicle:	
	mov eax,[esi]
	sub eax,xmin
	mov ebx,[edi+4*eax]
	inc ebx
	mov [edi+4*eax],ebx
	add esi,4
	loop cicle

pop edi
pop esi

ret
mod1 ENDP
END