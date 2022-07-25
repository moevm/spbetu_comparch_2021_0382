.586
.MODEL FLAT, C
.CODE

PUBLIC C first_dist
first_dist PROC C numbers: dword, n: dword, result1: dword, x_min: dword, mid: dword

push esi
push edi

mov esi, numbers
mov edi, result1
mov ecx, n

;fild dword ptr mid ; ST(0) = 0

lp:
	mov eax, [esi]
	sub eax, x_min
	mov ebx, [edi+4*eax]
	inc ebx
	mov [edi+4*eax], ebx
	add esi, 4
	loop lp

mov ecx, n
mov esi, numbers
sub ecx, 1
mov edi, mid

fild dword ptr [esi] ; ST(1) = 0; ST(0) = number
fild dword ptr n ;  ; ST(2) = 0; ST(1) = number; ST(0) = n
fdiv
add esi, 4

lp2:
	fild dword ptr [esi] ; ST(1) = 0; ST(0) = number
	fild dword ptr n ;  ; ST(2) = 0; ST(1) = number; ST(0) = n
	fdiv
	fadd
	add esi, 4
	loop lp2
	
fst dword ptr [edi]

pop edi
pop esi

ret
first_dist endp
end
