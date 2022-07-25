#include <iostream>
#include <fstream>
#include <cstdio>

char input_line[81];
char result[161];

int main(){
    std::cout << "Krivencova Lyubov 0382. Var 9. \nConversion of decimal digits entered in the input string to the octal number system.\n";
    fgets(input_line, 81, stdin);
    input_line[strlen(input_line) - 1] = '\0';

    __asm {
    push ds
    pop es
    mov esi, offset input_line
    mov edi, offset result
    readout:
        lodsb
        cmp al, '8'
        jne check
        mov ax, '01'
        stosw
        jmp ongoing

    check:
        cmp al, '9'
        jne save_record
        mov ax, '11'
        stosw
        jmp ongoing

    save_record:
        stosb

    ongoing:
        cmp [esi], '\0'
        jne readout
    }

    std::cout << result << std::endl;
    std::ofstream outfile("asm_result.txt");
    outfile << result;
    return 0;
}