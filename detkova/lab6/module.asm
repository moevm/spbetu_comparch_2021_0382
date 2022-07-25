.586
.MODEL FLAT, C
.CODE

PUBLIC C module
module PROC C res1:dword, GrInt: dword, res3: dword, x_max: dword, x_min: dword, n: dword

push esi
push edi

mov esi, GrInt
mov edi, res3
mov ecx, n

lp:
    mov eax, [esi] ; левая граница интервала
    mov ebx, [esi + 4] ; правая граница

    cmp eax, x_min ; если eax >= x_min
    jge l2
    mov eax, 0 ; иначе, eax = 0, начало массива res2

    sub ebx, x_min ; если длина интервала = 0
    jle l4
    jmp l5

    l2:
        sub ebx, eax ; количество элементов в интервале
        cmp ebx, 0 ; если длина интервала = 0
        je l4
        sub eax, x_min ; индекс первого элемента из текущего интервала в массиве res1

    l5:
        push esi 
        push ecx

        mov ecx, ebx ; количество элементов из res1 по которым нужно пройти
        mov esi, res1 ; массив
        mov ebx, 0 ; считает сумму подходящих элементов

    lp2: ; цикл, считает разность элементов, входящих в интервал
       push ecx
       push eax

       mov ecx, [esi + 4*eax] ; количество чисел
       add eax, x_min ; число

       lp3:
          
          sub ebx, eax
          loop lp3

       pop eax
       pop ecx

       inc eax
       loop lp2

    pop ecx


    cmp ecx, 1 ; если обрабатывали не последний элемент, то записываем сумму в массив результат
    jne l3
    push ecx
    push eax

    mov ecx, [esi + 4*eax] ; количество чисел
    add eax, x_min ; число

    lp4:
          
       sub ebx, eax
       loop lp4

    pop eax
    pop ecx

    l3:

        mov [edi], ebx ; записываем результат
        pop esi
        jmp l1

    l4:
        mov [edi], ebx ; записываем 0, если интервал пустой

    l1:
        add edi, 4 ; двигаемся к след. элементам массивов
        add esi, 4
    
    loop lp
   

pop edi
pop esi

ret
module ENDP
END
