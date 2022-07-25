#include <iostream>
#include <fstream>

using namespace std;

char input[85];
char output[170];

int main()
{
    cout << "Kondratov Yurii, group 0382, task: hexadecimal -> decimal" << endl;
    ofstream file;
    file.open(R"(C:\Coding\Assembly\lab4\out.txt)");
    cin.getline(input, 80);
    __asm {
        mov ax, ds
        mov es, ax
        mov esi, offset input
        mov edi, offset output
    loop_start:
        lodsb
        cmp al, '\0'
        je loop_final
    if_a:
        cmp al, 'A'
        jne if_b
        mov ax, '01'
        stosw
        jmp loop_start
    if_b:
        cmp al, 'B'
        jne if_c
        mov ax, '11'
        stosw
        jmp loop_start
    if_c:
        cmp al, 'C'
        jne if_d
        mov ax, '21'
        stosw
        jmp loop_start
    if_d:
        cmp al, 'D'
        jne if_e
        mov ax, '31'
        stosw
        jmp loop_start
    if_e:
        cmp al, 'E'
        jne if_f
        mov ax, '41'
        stosw
        jmp loop_start
    if_f:
        cmp al, 'F'
        jne other
        mov ax, '51'
        stosw
        jmp loop_start
    other:
        stosb
        jmp loop_start
    loop_final:
        stosb
    };
    std::cout << output;
    file << output;
    file.close();
    return 0;
}