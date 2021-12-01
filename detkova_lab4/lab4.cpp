#include <iostream>
#include <windows.h>

int main() {
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	std::cout << "Деткова Анна, группа 0382" << std::endl <<
		"Вариант 3: Формирование выходной строки только из русских и латинских букв входной строки" << std::endl;
	char inp[80];
	char res[80] = {80 * '\0'};
	std::cin.getline(inp, 80);

	__asm {
		mov edi, 0
		lea esi, inp // загружаем адрес начала массива в индексный регистр источника - esi

		start:
		mov ah, [esi] // массив букв - байтовый регистр, загружаем в верхнюю
			// половину базового регистра содержимое по адресу
		cmp ah, 0 // если конец  строки
		je end

		cmp ah, 192
		jae firstCondForRus

		cmp ah, 97
		jae firstCondForEngTwo

		cmp ah, 65
		jae firstCondForEngOne

		jmp result

		firstCondForRus :
		cmp ah, 255
		jbe secondCond
		jmp result

		firstCondForEngTwo:
		cmp ah, 122
		jbe SecondCond
		jmp result

		firstCondForEngOne :
		cmp ah, 90
		jbe SecondCond
		jmp result

		secondCond :
		mov res[edi], ah
		inc edi
		
		result :
		inc esi
		jmp start
		end :
	}

	std::cout << std::endl << std::endl;
	std::cout << "Результат:" << std::endl;
	puts(res);
	std::cout << std::endl << std::endl;

	return 0;
}