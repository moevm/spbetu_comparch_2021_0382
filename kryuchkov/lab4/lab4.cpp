#include <iostream>
#include <stdio.h>

char s[81];
char outstr[321];

int main()
{
	fgets(s, 81, stdin);
	s[strlen(s) - 1] = '\0';
    std::cout << "Kryuchkov Artem. Hex -> bin" // Указал автора и что делает программа
	__asm {
push ds
pop es
mov esi, offset s
mov edi, offset outstr
next :
    lodsb;
    cmp al, '0'
    jl writeSymbol
    cmp al, 'F'
    jg writeSymbol
    cmp al, '9'
    jle digit
    cmp al, 'A'
    jge letter
    jmp writeSymbol
    digit :
        sub al, '0'
        jmp tobin
    letter :
        sub al, 'A'
        add al, 10
        jmp tobin
    tobin :
        mov bl, al
        mov cl, 8
        and cl, bl; 1000 and ?XXX
        jnz writeOne1
        mov al, '0'
        jmp checkSecondBit
        writeOne1:
        mov al, '1'
        checkSecondBit :
        stosb
        mov cl, 4
        and cl, bl; 0100 and X?XX
        jnz writeOne2
        mov al, '0'
        jmp checkThirdBit
        writeOne2 :
        mov al, '1'
        checkThirdBit :
        stosb
        mov cl, 2
        and cl, bl; 0010 and XX?X
        jnz writeOne3
        mov al, '0'
        jmp checkFourthBit
        writeOne3 :
        mov al, '1'
        checkFourthBit :
        stosb
        mov cl, 1
        and cl, bl; 0001 and XXX?
        jnz writeOne4
        mov al, '0'
        stosb
        jmp checkNewSymbol
        writeOne4 :
        mov al, '1'
        stosb
        jmp checkNewSymbol
    writeSymbol :
        stosb; кладем в выходную строку байт из al
    checkNewSymbol :
        mov  ecx, '\0'
        cmp  ecx, [esi]
        je   Exit; выход из цикла, если текущий символ завершающий
        jmp  next
Exit :
	};
	std::cout << outstr;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(outstr, sizeof(char), strlen(outstr), f);
	return 0;
}
