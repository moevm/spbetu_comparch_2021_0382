#include <iostream>
#include <fstream>

int main() {
	char inp[80];
	char res[80];
	std::cin.getline(inp, 80);
	__asm {
		mov edi, 0;
		mov esi, 0;

		Processing:
			mov al, inp[edi]
			cmp al, 'a' //определяем, может ли символ быть лат. буквой
			JL Check_num //проверяем, цифра ли
			cmp al, 'z' //определяем, может ли символ быть лат. буквой
			JG Res  //не лат. буква, записываем символ в результат
			sub al, 32 //лат. буква, делаем верхний регистр
			JMP Res //записываем в результат

		Check_num:
			cmp al, 48 //проверяем, больше ли симмвол '0'
			JL Res  //нет, записываем в результат
			cmp al, 57  //проверяем, меньше ли символ '9'
			JG Res
			mov ah, 105 //число для дальнейшей инверсии
			sub ah, al
			mov al, ah
			JMP Res


		Res:
			mov res[esi], al
			cmp al, 0
			JE End
			inc edi
			inc esi
			JMP Processing

		End:
	}
	std::cout << res;
	std::ofstream fout("fout.txt");
	fout << res;
	fout.close();
	return 0;
}