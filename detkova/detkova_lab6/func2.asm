.586
.MODEL FLAT, C
.CODE

PUBLIC C func2
func2 PROC C res1:dword, GrInt: dword, res2: dword, x_max: dword, x_min: dword, n: dword

push esi
push edi

mov esi, GrInt
mov edi, res2
mov ecx, n

lp:
    mov eax, [esi]
    mov ebx, [esi + 4]

    cmp eax, x_min
    ja l2
    mov eax, 0

    l2:
        sub ebx, eax
        cmp ebx, 0
        jz l1

        push ecx
        push esi

        mov ecx, ebx
        sub eax, x_min
        mov esi, res1
        mov ebx, 0

    lp2:
       add ebx, [esi + 4*eax]
       inc eax
       loop lp2

    pop esi
    pop ecx

    mov [edi], ebx

    cmp ecx, 2
    je l3
    jmp l1

    l3:
        add edi, 4
        add esi, 4
        mov eax, [esi]
        mov ebx, x_max
        mov ecx, 1
        jmp l2

    l1:
        add edi, 4
        add esi, 4
    
    loop lp
   

pop edi
pop esi

ret
func2 ENDP
END
