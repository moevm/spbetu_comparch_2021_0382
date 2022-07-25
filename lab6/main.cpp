#include <iostream>
#include <iomanip>
#include <random>
#include <fstream>
#include <clocale>
#include <algorithm>

extern "C" void func(int f_NumRamDat, int* f_X, int f_NInt, int *f_LGrInt, int* result);

int main(){
    int NumRamDat, Xmax, Xmin, NInt, Dx;
    setlocale(LC_ALL, "");
    std::cout << "Длина массива псевдослучайных целых чисел NumRamDat:\n";
    std::cin >> NumRamDat;
    while (!(NumRamDat > 0 && NumRamDat < 16000)) {
        std::cout << "Длина массива псевдослучайных целых чисел должна быть <= 16K\n";
        std::cin >> NumRamDat;
    }
    int* X = new int[NumRamDat];
    std::cout << "Нижняя граница массива Xmin:"<< std::endl;
    std::cin >> Xmin;
    std::cout << "Верхняя граница массива Xmax:"<< std::endl;
    std::cin >> Xmax;
    while (Xmin >= Xmax) {
        std::cout << "Невозможный случай"<< std::endl;
        std::cin >> Xmax;
    }
    Dx = Xmax - Xmin;
    std::cout << "Количество интервалов, на которые разбивается диапазон\n"
            "изменения  массива псевдослучайных целых чисел - NInt:"<< std::endl;
    std::cin >> NInt;
    while (NInt <= 0 || NInt > 24 || NInt >= Dx) {
        std::cout << "Недопустимое значение для NInt";
        std::cin >> NInt;
    }

    int* LGrInt = new int[NInt + 1];
    std::cout << "Массив левых границ интервалов разбиения LGrInt:"<< std::endl;
    for (int i = 0; i < NInt; i++) {
        std::cin >> LGrInt[i];
        while (LGrInt[i] > Xmax || LGrInt[i] <= Xmin) {
            std::cout << "Недопустимое значение для LGrInt"<< std::endl;
            std::cin >> LGrInt[i];
        }
        while (i > 0 && LGrInt[i] < LGrInt[i - 1]) {
            std::swap(LGrInt[i--], LGrInt[i]);
        }
    }
    //LGrInt[NInt] = Xmax;

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(Xmin, Xmax);

    std::cout << "Массив псевдослучайных целых чисел {Xi}:"<< std::endl;
    for (int index = 0; index < NumRamDat; index++) {
        X[index] = distrib(gen);
        std::cout << X[index] << ' ';
    }
    std::cout << std::endl;

    auto result = new int[NumRamDat];
    for (int i = 0; i < NInt; i++) {
        result[i] = 0;
    }
    func( NumRamDat, X,  NInt, LGrInt, result);
    for (int i = 0; i < NInt; i++) {
        std::cout << result[i] << " ";
    }
    std::cout << std::endl;
    std::ofstream fout("ASM_output.txt");
    std::cout << "Index LGrInt Result" << std::endl;
    fout << "Index LGrInt Result" << std::endl;
    for (int i = 0; i < NInt; i++) {
        std::cout << i << "   " << LGrInt[i] << "    " << result[i] << std::endl;
        fout << i << "   " << LGrInt[i] << "    " << result[i] << std::endl;
    }
    fout.close();
    return 0;
}