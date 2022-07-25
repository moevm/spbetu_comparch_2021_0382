#include <iostream>
#include <stdio.h>
#include <fstream>
#include <windows.h>

char s[81];
char outstr[161];

int main()
{
	std::cout << "Zlobin Andrew, group 0382, task: invert numbers" << std::endl;
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	fgets(s, 81, stdin);
	s[strlen(s) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset s
		mov edi, offset outstr
		L :
		lodsb

			cmp al, 224
			jl not_uppercase
			cmp al, 255
			jg not_uppercase
			sub al, 32
			stosb
			jmp final

			not_uppercase:

		cmp al, 'ё'
			jne not_yo
			mov al, 'Ё'

			not_yo :

			cmp al, 48
			jl not_between_zero_and_seven
			cmp al, 57
			jg not_between_zero_and_seven
			neg al
			add al, 105
			stosb
			jmp final

			not_between_zero_and_seven:

		stosb

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   LExit
			jmp  L
			LExit :
	};
	std::cout << outstr;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(outstr, sizeof(char), strlen(outstr), f);
	return 0;
}