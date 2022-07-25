#include <iostream>

const int len = 81;
char input[len];
char output[len];

int main()
{
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "Преобразование всех заглавных латинских букв в строчные,а восьмеричных цифр в инверсные." << std::endl;
    std::cout << "Автор: Диденко Данил" << std::endl;
    int check;

    std::cin.getline(input, len);

    __asm {
        mov esi, offset input; адрес исходной строки
        mov edi, offset output; адрес выходной строки

        Check :
        lodsb
            cmp al, '\0'; проверка окончания строки
            je END

            cmp al, '0'; если код символа меньше кода 0, то результат записывается в выходной массив
            jl Rec
            cmp al, '7'; если код символа больше 7, необходима проверка на заглавные латинские буквы
            jg letter
            xor al, 7h; инвертируем цифру
            jmp Rec


            letter:
            cmp al, 'A'; Проверка на
            jl Rec
            cmp al, 'Z'; заглавную латинскую буквы
            jg Rec
            xor al, 20h; преобразование к строчной производится xor с 20h

            Rec :
            stosb; запись в выходную строку
                jmp Check; переходим к следующему символу

            END :
    }

    std::cout << output << std::endl;

    return 0;
}