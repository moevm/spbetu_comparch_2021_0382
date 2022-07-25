.586
.MODEL FLAT, C
.CODE
func PROC C NumRamDat:dword, X:dword,  NInt:dword, LGrInt:dword, result:dword
push ESI
push EDI
push EAX
push EBX
push ECX

mov ESI, X
mov EDI, LGrInt
mov ECX, NumRamDat
mov EAX, 0
cycle:
	mov EBX, 0
toborder:
		cmp EBX, NInt
		jge quit
		push EAX
		mov EAX, [esi + 4 * eax]
		cmp EAX, [edi + 4 * ebx]
		pop EAX
		jl quit
		inc EBX
		jmp toborder
quit:
	dec EBX
	mov EDI, result
	push EAX
	mov EAX, [EDI + 4 * ebx]
	inc EAX
	mov [EDI + 4 * ebx], EAX
	pop EAX
	mov EDI, LGrInt
	inc EAX
loop cycle

pop ECX
pop EBX
pop EAX
pop EDI
pop ESI
ret
func ENDP
END