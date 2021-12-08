#include <iostream>
#include <fstream>
using namespace std;
extern "C" void copy(char* output,char* input);



int main(){ 
    char input[100];
    char output[100];
    cout<<"Самулевич Василий гр. 0382\nВариант 19\nЗаменить введенные во входной строке латинские буквы на десятичные числа,соответствующие их номеру по алфавиту,остальные символы входной строки передать в выходную строку непосредственно.\n";
    cin >> input;
    copy(output,input);
    std::ofstream file;
    file.open("./result.txt");
    file <<output;
    file.close();
    cout<<output; 
    
}
