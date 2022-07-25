#include <iostream>
#include <fstream>

using namespace std;

char input[80];
char output[80];

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "Осинкин Евгений 0382, формирование выходной строки только из цифр и русских букв входной строки:" << endl;

	ofstream file;
	file.open("result.txt");

	cin.getline(input, 80);

	__asm {
		mov edi, 0
		mov esi, 0

		check_symbl :
			mov al, input[edi]
			inc edi

			cmp al, '\0'
			je finish

			cmp al, '0'
			jb check_symbl

			cmp al, '9'
			jbe write_symbl

			cmp al, 'ё'
			je write_symbl

			cmp al, 'Ё'
			je write_symbl

			cmp al, 'А'
			jb check_symbl

		write_symbl :
			mov output[esi], al
			inc esi
			jmp check_symbl

		finish :
			mov output[esi], al
			inc esi
	};

	cout << output;
	file << output;
	file.close();
	return 0;
}