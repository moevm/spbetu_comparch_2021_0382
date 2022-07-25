#include <iostream>
#include <stdio.h>

char strin[81];
char strout[321];

int main()
{
	std::cout << "Author: Semyon Lityagin, group 0382" << std::endl << "The program outputs a string in which it converts all numbers from decimal ns to binary ns; without changing the remaining characters" << std::endl;
	fgets(strin, 81, stdin);
	strin[strlen(strin) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset strin
		mov edi, offset strout
		line:
			lodsb

			cmp al, '2'
			jne skip1
			mov ax, '01'
			stosw
			jmp final

		skip1:
			cmp al, '3'
			jne skip2
			mov ax, '11'
			stosw
			jmp final

		skip2:
			cmp al, '4'
			jne skip3
			mov ax, '01'
			stosw
			mov al, '0'
			stosb
			jmp final

		skip3:
			cmp al, '5'
			jne skip4
			mov ax, '01'
			stosw
			mov al, '1'
			stosb
			jmp final

		skip4:
			cmp al, '6'
			jne skip5
			mov ax, '11'
			stosw
			mov al, '0'
			stosb
			jmp final

		skip5:
			cmp al, '7'
			jne skip6
			mov ax, '11'
			stosw
			mov al, '1'
			stosb
			jmp final

		skip6:
			cmp al, '8'
			jne skip7
			mov eax, '0001'
			stosd
			jmp final

		skip7:
			cmp al, '9'
			jne skip8
			mov eax, '1001'
			stosd
			jmp final

		skip8:
			stosb

		final:
			mov  ecx, '\0'
			cmp  ecx, [esi]
			je   lineEnd; выход, если был найден конец
			jmp  line
		lineEnd:
	};
	std::cout << strout;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(strout, sizeof(char), strlen(strout), f);
	return 0;
}