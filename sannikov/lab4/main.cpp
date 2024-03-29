#include <iostream>
#include <fstream>

using namespace std;

char input[81];
char output[81];

int main(){
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cout << "Sannikov Vadim 0382, task: delete russian symbols and digits" << endl;
    ofstream file;
    file.open(R"(C:\Users\79081\source\repos\lab_4\lab_4\out.txt)");
    cin.getline(input, 81);
    __asm {
        mov esi, offset input
        mov edi, offset output

        check_symb:
            lodsb
            cmp al, '\0' 
            je finish

            cmp al, 'ё'
            je check_symb
            cmp al, 'Ё' 
            je check_symb
            cmp al, 'А'
            jl is_digit
            cmp al, 'я'
            jg is_digit
            jmp check_symb

        is_digit:
            cmp al, '0'
            jl write_symb
            cmp al, '9'
            jg write_symb
            jmp check_symb

        write_symb:
            stosb
            jmp check_symb

        finish:
    };
    cout << output;
    file << output;
    file.close();
    return 0;
}
