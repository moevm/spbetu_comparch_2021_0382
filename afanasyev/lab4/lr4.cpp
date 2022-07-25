#include <iostream>
#include <fstream>
#include <stdio.h>

char input[81];
char output[81];

int main(){
    std::cout << "Afanasyev Nazar 0382. \nvar2: input -> numbers & latin\n";

    fgets(input, 81, stdin);
    input[strlen(input)] = '\0';

    __asm {
        push ds
        pop es
        mov esi, offset input
        mov edi, offset output
        read:
            lodsb

            cmp al, '0'
            jl next
            cmp al, '9'
            jle write

            cmp al, 'A'
            jl next
            cmp al, 'Z'
            jle write

            cmp al, 'a'
            jl next
            cmp al, 'z'
            jg next

        write:
            stosb
        next:
            cmp [esi], '\0'
            jne read
    };

    std::cout << output << std::endl;
    std::ofstream file("o.txt");
    file << output;
    return 0;
}
