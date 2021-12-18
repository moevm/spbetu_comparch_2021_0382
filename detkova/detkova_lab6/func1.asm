.586
.MODEL FLAT, C
.CODE

PUBLIC C func1
func1 PROC C X:dword, n: dword, res1: dword, x_min: dword

push esi
push edi

mov esi, X
mov edi, res1
mov ecx, n

change:
    mov eax, [esi]
    sub eax, x_min
    mov ebx, [edi + 4*eax]
    inc ebx
    mov [edi + 4*eax], ebx
    add esi, 4
    loop change

pop edi
pop esi

ret
func1 ENDP
END