#include <iostream>
#include <fstream>

using namespace std;

char input[85];
char output[170];

int main()
{
    cout << "Tulenev Tumofey, group 0382, task: Replace Latin letters with decimal numbers" << endl;
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
        cmp al, 'a'
        jne if_b
        mov ax, '10'
        stosw
        jmp loop_start
    if_b:
        cmp al, 'b'
        jne if_c
        mov ax, '20'
        stosw
        jmp loop_start
    if_c:
        cmp al, 'c'
        jne if_d
        mov ax, '30'
        stosw
        jmp loop_start
    if_d:
        cmp al, 'd'
        jne if_e
        mov ax, '40'
        stosw
        jmp loop_start
    if_e:
        cmp al, 'e'
        jne if_f
        mov ax, '50'
        stosw
        jmp loop_start
    if_f:
        cmp al, 'f'
        jne if_g
        mov ax, '60'
        stosw
        jmp loop_start
    if_g:
        cmp al, 'g'
        jne if_h
        mov ax, '70'
        stosw
        jmp loop_start
    if_h:
        cmp al, 'h'
        jne if_i
        mov ax, '80'
        stosw
        jmp loop_start
    if_i:
        cmp al, 'i'
        jne if_j
        mov ax, '80'
        stosw
        jmp loop_start
    if_j:
        cmp al, 'j'
        jne if_k
        mov ax, '90'
        stosw
        jmp loop_start
    if_k:
        cmp al, 'k'
        jne if_l
        mov ax, '01'
        stosw
        jmp loop_start
    if_l:
        cmp al, 'l'
        jne if_m
        mov ax, '11'
        stosw
        jmp loop_start
    if_m:
        cmp al, 'm'
        jne if_n
        mov ax, '21'
        stosw
        jmp loop_start
    if_n:
        cmp al, 'n'
        jne if_o
        mov ax, '31'
        stosw
        jmp loop_start
    if_o:
        cmp al, 'o'
        jne if_p
        mov ax, '41'
        stosw
        jmp loop_start
    if_p:
        cmp al, 'p'
        jne if_q
        mov ax, '51'
        stosw
        jmp loop_start
    if_q:
        cmp al, 'q'
        jne if_r
        mov ax, '61'
        stosw
        jmp loop_start
    if_r:
        cmp al, 'r'
        jne if_s
        mov ax, '71'
        stosw
        jmp loop_start
    if_s:
        cmp al, 's'
        jne if_t
        mov ax, '81'
        stosw
        jmp loop_start
     if_t:
        cmp al, 't'
        jne if_u
        mov ax, '91'
        stosw
        jmp loop_start
     if_u:
        cmp al, 'u'
        jne if_v
        mov ax, '02'
        stosw
        jmp loop_start
     if_v:
        cmp al, 'v'
        jne if_x
        mov ax, '12'
        stosw
        jmp loop_start
     if_x:
        cmp al, 'x'
        jne if_y
        mov ax, '22'
        stosw
        jmp loop_start
     if_y:
        cmp al, 'y'
        jne if_z
        mov ax, '32'
        stosw
        jmp loop_start
     if_z:
        cmp al, 'z'
        jne other
        mov ax, '42'
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