#include <iostream>
#include <fstream>

char input[81];
int count_alphabet = -1; 
int output[26] = { 0 }; 
int len;

int main() {
    std::cout << "Okhotnikova Galina from group 0382, lab 4" << std::endl << "Task: Form the number of the"
        "inputted latin letter by using the position of it both in the alphabet" << std::endl <<
        "and the relative position in the given string, then print it out on the screen" << std::endl << std::endl;

    std::cout << "Enter the line: ";
    std::cin.getline(input, 80);
    len = strlen(input);

    __asm {
        mov ax, ds
        mov es, ax
        mov esi, offset output

        mov al, 'a'
        dec al

        loop_start :
        mov edi, offset input
            mov ecx, len
            inc al
            inc count_alphabet
            repne scasb

            check :
        cmp ecx, 0
            jne write_index
            dec edi
            cmp ES : [edi] , al
            je write_index
            jmp last_latter

            write_index :
        mov ebx, len
            sub ebx, ecx
            mov esi, count_alphabet
            mov ES : output[esi * 4], ebx
            jmp last_latter

            last_latter :
        cmp al, 'z'
            je final
            jmp loop_start

            final:
    };

    std::ofstream file;
    file.open("answer.txt");
    for (int i = 0; i < 26; i++) {
        if (output[i] != 0) {
            std::cout << i + 1 << ' ' << output[i] << std::endl;
            file << i + 1 << ' ' << output[i] << std::endl;

        }
    }
    file.close();

    return 0;
}