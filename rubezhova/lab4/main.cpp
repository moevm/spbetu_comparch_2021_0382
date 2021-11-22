#include <iostream>

using namespace std;

char input[81];
int num = -1; //счётчик-номер буквы в алфавите
int arr[33]={0}; //массив номеров позиций первого вхождения буквы русского алфавита во входной строке
int len;

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cout << "Автор: Рубежова Наталия ст.гр.0382 \nФормирование номера введенной русской буквы по алфавиту и номера позиции его первого вхождения во входной строке и выдача их на экран.\nВведите строку: ";

    cin.getline(input, 81);
    len = strlen(input);
     __asm {
            push ds
            pop es

            mov al,'а'
            dec al
        cycle:
            mov edi, offset input
            mov ecx, len
            cmp al, 'ё'
            je ret_to_zh
            cmp al, 'е'
            je symbol_yo
            inc al
        label :
            inc num
            repne scasb
        has_symbol_check :
            cmp ecx,0
            jne get_index
            dec edi 
            cmp ES:[edi],al
            je get_index
            jmp last_iteration_check
        get_index:
            mov ebx, len
            sub ebx, ecx //ebx теперь содержит индекс первого вхождения
            mov esi, num
            mov ES:arr[esi*4],ebx
            jmp last_iteration_check
        last_iteration_check:
            cmp al, 'я'
            je the_end
            jmp cycle

        symbol_yo:
            mov al,'ё'
            jmp label
        ret_to_zh:
            mov al, 'ж'
            jmp label

        the_end:
      };
     int flag = 0;
     for (int i = 0; i < 33; i++) {
         if (arr[i] != 0) {
             cout << i + 1 << ' ' << arr[i] << endl;
             flag = 1;
         }
     }
     if (flag == 0)
         cout << "Буквы кириллицы отсутствуют в введенной строке.";
     return 0;
}

