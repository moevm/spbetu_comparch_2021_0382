#include <iostream>
#include <locale>
#include <fstream>
#include <windows.h>

using namespace std;

char input[85];
char output[170];

int main()
{
    setlocale(LC_ALL, "Russian");
    system("chcp 1251");
    cout << "Михайлова Оксана, гр. 0382\nВариант 24\nИнвертирование введенных во входной строке цифр в шестнадцатиричной СС " 
        "и преобразование строчных русских букв в заглавные." << endl;
    cin.getline(input, 80);
    __asm {
        mov esi, offset input
        mov edi, offset output
        start :
        lodsb
            cmp al, '\0'
            je final

            from_0_to_5:
            cmp al, '0'
            jl symbols_check
            cmp al, '5'
            jg more_5_less_A
            mov ah, 'F'
            sub ah, al
            add ah, 48
            mov al, 'F'
            stosw
            jmp start

            more_5_less_A:
        cmp al, '9'
            jg more_than_9
            mov ah, 'F'
            sub ah, al
            add ah, 41
            mov al, 'F'
            stosw
            jmp start

            more_than_9:
        cmp al, 'F'
            jg symbols_check
            mov ah, 'F'
            sub ah, al
            add ah, 48
            mov al, 'F'
            stosw
            jmp start

            symbols_check:
        cmp al, 224
            jl yo_check
            cmp al, 255
            jg yo_check
            sub al, 32
            stosb
            jmp start

            yo_check:
        cmp al, 'ё'
            jne other
            mov al, 'Ё'
            stosb
            jmp start

            other:
        stosb
            jmp start

            final:
        stosb
    };
    ofstream file;
    file.open(R"(D:\Рабочий стол\универ\ЭВМ\lab4\lab4\res_lab4.txt)");
    file << output;
    file.close();
    cout << output;
    return 0;
}


