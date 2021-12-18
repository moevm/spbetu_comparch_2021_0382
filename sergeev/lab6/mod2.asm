.586
.MODEL FLAT, C
.CODE
PUBLIC C mod2
mod2 PROC C res1:dword, intervals:dword, nint:dword, res2:dword, xmin: dword

push esi
push edi

mov esi,res2
mov edi,intervals
mov ecx,xmin ; так как у нас уже есть распределение по еденичным интервалам, то начнём с самого первого
mov eax,0 ; eax - индекс числа в массиве единичных интервалов res1


Cicle:
mov ebx,0 ; индекс текущего интервала в массиве левых границ интервалов

Poisk_int:
cmp ecx, [edi+4*ebx] ; сравниваем текущее число с левой границей интервала
jl Obrabotka ; если число меньше текущей границы, то приступаем к обработке

Incs: ;если число больше текущей левой границы, то двигаемся к следующей границе
	inc ebx
	jmp Poisk_int

Obrabotka:
	dec ebx ; так как текущее ebx - правая граница интервала, в который входит число, то уменьшаем индекс на 1
	push edi
	push ecx
	mov edi,res1
	mov edx, [edi+4*eax] ; получаем количество встреч данного числа
	mov ecx,[esi+4*ebx] ; получаем текущее кол-во попаданий в интервал
	add ecx,edx ; суммируем числа из двух предыдущих шагов
	mov [esi+4*ebx],ecx ; обновляем число в результирующем массиве
	pop ecx
	pop edi
	inc eax ; увеличивам индекс в массиве единичных интервалов res1
	inc ecx ; увеличиваем текущее рассматриваемое число
	push eax
	mov eax,nint
	cmp ecx,[edi+eax*4] ; сравниваем текущее рассматриваемое число с xmax
	pop eax
	jl Cicle
	
pop edi
pop esi

ret
mod2 ENDP
END