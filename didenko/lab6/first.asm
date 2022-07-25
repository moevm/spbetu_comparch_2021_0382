.586p
.MODEL FLAT, C
.CODE
PUBLIC C first
first PROC C numbers: dword, numbersSize: dword, res: dword, xmin: dword, product_res: dword

push esi
push edi

mov edx,1h
mov edi, product_res
mov [edi], edx

fild dword ptr [edi]

mov edx, numbers 
mov ecx, numbersSize
mov esi, res 


for_:
	fild dword ptr [edx]
	fmul
	mov eax, [edx] ; помещаем в eax очередной элемент
	sub eax, xmin ; находим его индекс
	mov ebx, [esi + 4*eax]
	inc ebx ; увеличиваем значение по индексу на 1
	mov [esi + 4*eax], ebx ; помещаем в результ. массив
	add edx, 4 ; переходим к сл.элементу
	loop for_ ; пока ecx != 0

	fst qword ptr [edi]

pop edi
pop esi
ret
first ENDP
END  