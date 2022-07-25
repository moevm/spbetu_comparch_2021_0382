#include <iostream>
#include <fstream>

using namespace std;

char input[81];
char output[81];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");

    cout << "Азаров Максим 0382, формирование выходной строки только из цифр и русских букв входной строки:" << endl;

    ofstream file;
    file.open("res.txt");

    cin.getline(input, 81);

    __asm {
        mov esi, offset input
        mov edi, offset output

        check_symbl :
            lodsb

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
            stosb
            jmp check_symbl

        finish :
            stosb
    };

    cout << output;
    file << output;
    file.close();
    return 0;
}