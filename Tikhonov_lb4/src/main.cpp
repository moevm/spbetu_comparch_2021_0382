#include <iostream>
#include <fstream>

using namespace std;

char input[81];
char output[81];
int main()
{
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cout << "Тихонов Сергей группа 0382. Замена русских букв на их номер" << endl;
    ofstream file;
    file.open(R"(C:\Coding\Assembly\lab4\out.txt)");
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
            cmp al, 'ё'
            je io
            cmp al, 'Ё'
            je io

            cmp al, 'а'
            jl otherAB
            cmp al, 'я'
            jg otherAB


            cmp al, 'ж'
            jl a_e
            cmp al, 'и'
            jl j_i
            cmp al, 'т'
            jl i_t
            cmp al, 'ь'
            jl t_b
            cmp al, 'я'
            jle b_ia

            io:
                mov ah, '7'
                mov al, '0'
                stosw
                jmp loop_start
            a_e :
                sub al, 175
                mov ah, al
                mov al, '0'
                stosw
                jmp loop_start
            j_i :
                sub al, 175
                mov ah, al
                add ah,1
                mov al, '0'
                stosw
                jmp loop_start
            i_t :
                sub al, 175
                sub al, 10
                mov ah, al
                add ah,1    
                mov al, '1'
                stosw
                jmp loop_start
            t_b :
                sub al, 175
                sub al, 20
                mov ah, al
                add ah,1
                mov al, '2'
                stosw
                jmp loop_start
           b_ia :
                sub al, 175
                    sub al, 30
                    mov ah, al
                    add ah, 1
                    mov al, '3'
                    stosw
                    jmp loop_start

            otherAB :
        cmp al, 'А'
            jl other
            cmp al, 'Я'
            jg other

            add al, 32
          
          
            cmp al, 'ж'
            jl a_e
            cmp al, 'и'
            jl j_i
            cmp al, 'т'
            jl i_t
            cmp al, 'ь'
            jl t_b
            cmp al, 'я'
            jle b_ia
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