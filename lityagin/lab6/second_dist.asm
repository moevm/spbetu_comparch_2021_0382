.MODEL FLAT, C
.CODE

PUBLIC C second_dist
second_dist PROC C result1: dword, intervals: dword, n_int:dword, result2: dword, x_min: dword

push esi
push edi

mov esi, intervals
mov edi, result2
mov ecx, n_int

; lgi pgi < x_min => 0
; lgi <= x_min  pgi = x_min => x_min
; lgi >= x_min x_min <= pgi < x_max
;
;

lp:
	mov eax, [esi]
	mov ebx, [esi+4]

	cmp eax, x_min
	jge m2
	mov eax, 0
	sub ebx, x_min
	cmp ebx, 0
	jle m1	
	jmp m6
	m2:
		sub ebx, eax
		cmp ebx, 0
		je m1
		sub eax, x_min
		
		m6:
		push esi
		push ecx

		mov esi, result1
		mov ecx, ebx
		mov ebx, 0
		lp2:
			add ebx, [esi+4*eax]
			inc eax
			loop lp2

		pop ecx
		cmp ecx, 1
		jne m4
		add ebx, [esi+4*eax]
		m4:
			mov [edi], ebx
			pop esi
			jmp m3

	m1:
		mov ebx, 0
		mov [edi], ebx 
	
	m3:
		add edi, 4
		add esi, 4
	loop lp

pop edi
pop esi

ret
second_dist endp
end
