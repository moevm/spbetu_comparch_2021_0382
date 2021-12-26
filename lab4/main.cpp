#include <iostream>
#include <fstream>
using namespace std;

int main(){ 
    char input[100];
    char output[100];
    cout<<"Самулевич Василий гр. 0382\nВариант 19\nЗаменить введенные во входной строке латинские буквы на десятичные числа,соответствующие их номеру по алфавиту,остальные символы входной строки передать в выходную строку непосредственно.\n";
    cin >> input;
   
    asm(
       ".intel_syntax noprefix\n\t"
    "start:\n\t"
        "mov ax,0\n\t"
        "lodsb\n\t"
        "cmp al,0\n\t"
        "je end\n\t"
        "cmp al,0x41\n\t"
        "jb continue\n\t"
        "cmp al,0x5A\n\t"
        "jbe edit\n\t"
        "cmp al,0x61\n\t"
        "jb continue\n\t"
        "cmp al,0x7A\n\t"
        "ja continue\n\t"
        "sub al,0x20\n\t"
   " edit:\n\t"

        "sub al,0x40\n\t"
        "mov dh,0xA\n\t"
        "idiv dh\n\t"
        "cmp al,0\n\t"
        "je units\n\t"
        "add al,0x30\n\t"
        "stosb\n\t"
    "units:\n\t"

        "mov al,ah\n\t"
        "add al,0x30\n\t"
        "stosb\n\t"
        "jmp start\n\t"
    "continue:\n\t"
        "stosb\n\t"
        "jmp start\n\t" 
    "end:\n\t"
        "stosb\n\t"
    "stop:\n\t"
        :
        :"S" (input),"D" (output)
        :"%rax","%rdx" 
    );

    std::ofstream file;
    file.open("./result.txt");
    file <<output;
    file.close();
    cout<<output; 
    
}
