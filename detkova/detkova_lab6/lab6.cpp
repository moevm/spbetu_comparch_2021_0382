#include <iostream>
#include <iomanip>
#include <random>
#include <fstream>

using namespace std;

extern "C" void func1(int* X, int n, int* res1, int x_min);
extern "C" void func2(int* res1, int* GrInt, int* res2, int x_max, int x_min, int n);

int main(){

    setlocale(LC_ALL, "ru");

    int NumRamDat;
    cout << "Введите количество псевдослучайных чисел:\n";
    cin >> NumRamDat;
    if (NumRamDat <= 0 || NumRamDat > 16000) {
        cout << "Количество чисел не может быть меньше нуля и больше 16к\n";
        return 1;
    }

    int Xmax, Xmin;
    cout << "Введите границы распределения сначала Xmin, затем Xmax через пробел:\n";
    cin >> Xmin >> Xmax;
    if (Xmax <= Xmin) {
        cout << "Недопустимые границы\n";
        return 1;
    }

    int NInt;
    cout << "Введите количество интервалов разбиения:\n";
    cin >> NInt;
    if (NInt <= 0 || NInt > 24 || NInt >= abs(Xmax - Xmin)) {
        cout << "Количество интервалов не может быть меньше или равно 0, больше 24, больше или ";
        cout << "равно, чем разность между максимальным и минимальным значением в диапазоне псевднослучайных чисел\n";
        return 1;
    }

    int* LGrInt = new int[NInt + 1];
    cout << "Введите левые границы:\n";
    for (int i = 0; i < NInt; i++) {
        cin >> LGrInt[i];
        
        if (LGrInt[i] > Xmax) {
            cout << "Недопустимое значение интервала\n";
            return 1;
        }

        int ind = i;
        while (ind && LGrInt[ind] < LGrInt[ind - 1]) {
            swap(LGrInt[ind--], LGrInt[ind]);
        }
    }
    LGrInt[NInt] = Xmax;
    //if (LGrInt[0] < Xmin)
      //  LGrInt[0] = Xmin;


    int* X = new int[NumRamDat];
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> distrib(Xmin, Xmax);

    cout << "Массив псевдослучайных чисел:\n";
    for (int i = 0; i < NumRamDat; i++) {
        X[i] = distrib(gen);
        cout << X[i] << ' ';
    }
    cout << '\n';

    int* res_1 = new int[Xmax - Xmin + 1];
    for (int i = 0; i < (Xmax - Xmin + 1); i++)
        res_1[i] = 0;

    int* res_2 = new int[NInt];
    for (int i = 0; i < NInt; i++)
        res_2[i] = 0;

    func1(X, NumRamDat, res_1, Xmin);
    cout << "Распределение исходных чисел по интервалам длины 1:\n";
    for (int i = 0; i < (Xmax - Xmin + 1); i++)
        cout << i + Xmin << ": " << res_1[i] << "; ";
    cout << "\n";

    func2(res_1, LGrInt, res_2, Xmax, Xmin, NInt);
    ofstream out;
    out.open("Result.txt");
    cout << "Распределение чисел по интервалам:\n";
    out << "Распределение чисел по интервалам:\n";
    cout << "Номер интервала Левая граница Количество чисел\n";
    out << "Номер интервала Левая граница Количество чисел\n";
    for (int i = 0; i < NInt; i++) {
        cout << setw(8) << i << setw(14) << LGrInt[i] << setw(16) << res_2[i] << "\n";
        out << setw(8) << i << setw(14) << LGrInt[i] << setw(16) << res_2[i] << "\n";
    }
    out.close();

    return 0;
}
