#include <iostream>
#include <fstream>

using namespace std;

char input[81];
char output[81];
int main()
{
    cout << "Gudov Nikita 0382, task: Replace Latin letters with hexadecimal numbers" << endl;
    ofstream file;
    file.open(R"(D:\tools\lab4text.txt)");
    cin.getline(input, 80);
    __asm {
        mov ax, ds
        mov es, ax
        mov esi, offset input
        mov edi, offset output
        loop_start :
        lodsb
            cmp al, '\0'
            je loop_final

            cmp al, 'a'
            jl otherAB
            cmp al, 'z'
            jg otherAB

            cmp al, 'o'
            jg p_z_begin

        a_o_begin :
            cmp al, 'i'
            jg a_o_H

            a_o_L:
                sub al, 48
                mov ah, al
                jmp a_o_end

            a_o_H:
                sub al, 41
                mov ah, al

        a_o_end:
            mov al, '0'
            stosw
            jmp loop_start

        p_z_begin:
            cmp al, 'y'
                jg p_z_H

            p_z_L :
                sub al, 64
                    mov ah, al
                    jmp p_z_end

            p_z_H :
                sub al, 57
                    mov ah, al

        p_z_end :
            mov al, '1'
                stosw
                jmp loop_start

        otherAB :
            cmp al, 'A'
            jl other
            cmp al, 'Z'
            jg other

            add al, 32

            cmp al, 'o'
            jg p_z_begin

            cmp al, 'o'
            jle a_o_begin

            other :
        stosb
            jmp loop_start
            loop_final :
        stosb
    };
    std::cout << output << std::endl;
    file << output;
    file.close();
    system("pause");
    return 0;
}