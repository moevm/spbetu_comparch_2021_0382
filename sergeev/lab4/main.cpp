#include <iostream>
#include <fstream>
#include <wchar.h>
#include <stdio.h>

char input[81];
char output[161];

int main() {
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    std::cout << "VAR 16: change russian letters into latin\nby Dmitry Sergeev 0382\n";
    fgets(input, 81, stdin);
    input[strlen(input)] = '\0';

    __asm
    {
        push ds
        pop es
        mov esi, offset input
        mov edi, offset output

        MyLoop :
        lodsb

            cmp al, '\0'
            je final

            cmp al, '¨'
            je replace_e

            cmp al, 'À'
            je replace_a

            cmp al, 'Á'
            je replace_b

            cmp al, 'Â'
            je replace_v

            cmp al, 'Ã'
            je replace_g

            cmp al, 'Ä'
            je replace_d

            cmp al, 'Å'
            je replace_e

            cmp al, 'Æ'
            je replace_zh

            cmp al, 'Ç'
            je replace_z

            cmp al, 'È'
            je replace_i

            cmp al, 'É'
            je replace_i

            cmp al, 'Ê'
            je replace_k

            cmp al, 'Ë'
            je replace_l

            cmp al, 'Ì'
            je replace_m

            cmp al, 'Í'
            je replace_n

            cmp al, 'Î'
            je replace_o

            cmp al, 'Ï'
            je replace_p

            cmp al, 'Ð'
            je replace_r

            cmp al, 'Ñ'
            je replace_s

            cmp al, 'Ò'
            je replace_t

            cmp al, 'Ó'
            je replace_u

            cmp al, 'Ô'
            je replace_f

            cmp al, 'Õ'
            je replace_h

            cmp al, 'Ö'
            je replace_c

            cmp al, '×'
            je replace_ch

            cmp al, 'Ø'
            je replace_sh

            cmp al, 'Ù'
            je replace_sc

            cmp al, 'Û'
            je replace_y

            cmp al, 'Ý'
            je replace_e

            cmp al, 'Þ'
            je replace_iu

            cmp al, 'ß'
            je replace_ia

            cmp al,'Ú'
            je skip

            cmp al,'Ü'
            je skip

            stosb
            jmp MyLoop

            skip:
            mov al,'_'
            stosb
            jmp MyLoop

            replace_e:
        mov al, 'E'
            stosb
            jmp MyLoop

            replace_a :
        mov al, 'A'
            stosb
            jmp MyLoop

            replace_b :
        mov al, 'B'
            stosb
            jmp MyLoop

            replace_v :
        mov al, 'V'
            stosb
            jmp MyLoop

            replace_g :
        mov al, 'G'
            stosb
            jmp MyLoop

            replace_d :
        mov al, 'D'
            stosb
            jmp MyLoop

            replace_zh :
        mov al, 'J'
            stosb
            jmp MyLoop

            replace_z :
        mov al, 'Z'
            stosb
            jmp MyLoop

            replace_i :
        mov al, 'I'
            stosb
            jmp MyLoop

            replace_k :
        mov al, 'K'
            stosb
            jmp MyLoop

            replace_l :
        mov al, 'L'
            stosb
            jmp MyLoop

            replace_m :
        mov al, 'M'
            stosb
            jmp MyLoop

            replace_n :
        mov al, 'N'
            stosb
            jmp MyLoop

            replace_o :
        mov al, 'O'
            stosb
            jmp MyLoop

            replace_p :
        mov al, 'P'
            stosb
            jmp MyLoop

            replace_r :
        mov al, 'R'
            stosb
            jmp MyLoop

            replace_s :
        mov al, 'S'
            stosb
            jmp MyLoop

            replace_t :
        mov al, 'T'
            stosb
            jmp MyLoop

            replace_u :
        mov al, 'U'
            stosb
            jmp MyLoop

            replace_f :
        mov al, 'F'
            stosb
            jmp MyLoop

            replace_h :
        mov al, 'H'
            stosb
            jmp MyLoop

            replace_c :
        mov al, 'C'
            stosb
            jmp MyLoop

            replace_ch :
        mov ax, 'HC'
            stosw
            jmp MyLoop

            replace_sh :
        mov ax, 'HS'
            stosw
            jmp MyLoop

            replace_sc :
        mov ax, 'CS'
            stosw
            jmp MyLoop

            replace_y :
        mov al, 'Y'
            stosb
            jmp MyLoop

            replace_iu :
        mov ax, 'UI'
            stosw
            jmp MyLoop

            replace_ia :
        mov ax, 'AI'
            stosw
            jmp MyLoop

            final:
            stosb
    }
    std::ofstream out;
    out.open(R"(C:\Task\log.txt)");
    out << output;
    out.close();
    std::cout << output;
    return 0;
}