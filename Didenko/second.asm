.586p
.MODEL FLAT, C
.CODE
PUBLIC C second
second PROC C mod_numbers: dword, numbersSize: dword, xmin: dword, intervals: dword, intervalsSize: dword, result: dword

push esi
push edi
push ebp

mov edi, mod_numbers  
mov esi, intervals  
mov ecx, intervalsSize  


for_intervals:  ; получение индексов от интервалов
	mov eax, [esi]   
	sub eax, xmin
	mov [esi], eax
	add esi, 4
	loop for_intervals

mov esi, intervals
mov eax, [esi]
mov ecx, intervalsSize
mov ebx, 0 ; счетчик для result

for_loop:
	push ecx  
	mov ecx, eax ; в eax - очередной интервал минус предыдущий
	push esi  
	mov esi, result ; в esi записывается результат

    for_array:
		cmp ecx, 0 
		je end_for
        mov eax, [edi]
        add [esi + 4 * ebx], eax
        add edi, 4
        loop for_array; пока интервал не равен 0 (т.е пока не пройдем весь интервал)

end_for:
    inc ebx ; увеличиваем счетчик для result
    pop esi 
	mov eax, [esi] ; запоминаем текущий интервал
	add esi, 4
	sub eax, [esi] 
	neg eax  ; получаем следующий интервал минус предыдущий
	pop ecx
	loop for_loop

mov esi, result
mov ecx, intervalsSize
mov eax, 0 ; всего чисел в result

fin_for: 
	add eax, [esi]
	add esi, 4
	loop fin_for

mov esi, result
sub eax, numbersSize 
neg eax ; получаем число оставшихся необработанных чисел

add [esi + 4 * ebx], eax ; помещаем это число в result

pop ebp
pop edi
pop esi

ret
second ENDP
END  