#include <iostream>
#include <fstream>
#include <stdio.h>
#include <windows.h>
#include <tchar.h>
using namespace std;
#define INPUT_FILENAME "C:\\Users\\Xenia\\Desktop\\prog\\file1.txt"
char str_input[81];
char str_out[81];
int main()
{
    setlocale(LC_ALL, "Russian");


    wchar_t initial_msg[] = L"Студент гр.0382 Андрющенко К.С \n2) Формирование выходной строки только из цифр и латинских букв входной строки.";

    wcout << initial_msg << endl;
    
    cin.getline(str_input, 81);

    __asm {
        push  ds;  Сохранение адреса начала PSP в стеке
        pop es
        mov esi, offset str_input
        mov edi, offset str_out
        

        symbol_selection:
            lodsb; копирует один байт из памяти по адресу DS : ESI(32) в AL
            cmp al, '\0'
            je end_line
            cmp al, 0x7A; Расширенные символы ASCII Win - 1251 кириллица + спец.символы
            jbe number_or_latin_character; если символ не является символом русского языка и спец.символами
            jmp symbol_selection; выбираем следующий символ

        number_or_latin_character :
            cmp al, 0x61
            jae write_symbol; строчные символы английского языка
            cmp al, 0x5A
            ja symbol_selection; выбираем следующий символ
            cmp al, 0x41
            jae write_symbol; строчные символы английского языка
            cmp al, 0x39
            ja symbol_selection; выбираем следующий символ
            cmp al, 0x30
            jae write_symbol; числа
            ; иначе
            jmp symbol_selection; выбираем следующий символ

        write_symbol:
            stosb; сохраняет регистр AL в ячейке памяти по адресу ES : EDI.После выполнения команды, регистр EDI увеличивается на 1, если флаг DF = 0, или уменьшается на 1, если DF = 1.
            cmp  ecx, [esi]
            je end_line
            jmp symbol_selection; выбираем следующий символ

        end_line:
    };
    ofstream file(INPUT_FILENAME);
    file << str_out;
    cout << str_out;
    return 0;
}