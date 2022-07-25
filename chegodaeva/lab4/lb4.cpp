#include <iostream>
#include <fstream>
#include <stdio.h>

char input[81];
char output[81];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "0382 Chegodaeva Elizaveta.\nVar№3: Only Russian and Latin letters\n";
    fgets(input, 81, stdin);
    input[strlen(input)] = '\0';
    std::ofstream file("result.txt");
    __asm {
        mov esi, offset input
        mov edi, offset output

        Check:
            lodsb
            cmp al, '\0'
            je END

            cmp al, 'Ё'
            je Rec
            cmp al, 'ё'
            je Rec

            cmp al, 'А'
            jl Check
            cmp al, 'я'
            jle Rec

            cmp al, 'A'
            jl Check
            cmp al, 'Z'
            jle Rec
                
            cmp al, 'a'
            jl Check
            cmp al, 'z'
            jle Rec

        Rec:
            stosb
            jmp Check

        END:
           
    };
    std::cout << output;
    file << output;
    return 0;
}
