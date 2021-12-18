.586p
.MODEL FLAT, C
.CODE
PUBLIC C first
first PROC C numbers: dword, numbersSize: dword, res: dword, xmin: dword

push esi
push edi
mov edi, numbers 
mov ecx, numbersSize
mov esi, res 

for_:
	mov eax, [edi] ; помещаем в eax очередной элемент
	sub eax, xmin ; находим его индекс
	mov ebx, [esi + 4*eax]
	inc ebx ; увеличиваем значение по индексу на 1
	mov [esi + 4*eax], ebx ; помещаем в результ. массив
	add edi, 4 ; переходим к сл.элементу
	loop for_ ; пока ecx != 0

pop edi
pop esi
ret
first ENDP
END  