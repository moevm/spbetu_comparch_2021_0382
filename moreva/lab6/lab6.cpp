#include <iostream>
#include <random>
#include <fstream>

using namespace std;

extern "C" void FUNC(int* numbers, int num_cnt, int* lgrint, int n_int, int* result);

int main()
{
    setlocale(0, "");
    int n, x_min, x_max, n_int, Dx;

    cout << "Введите количество чисел, которые необходимо сгенерировать:" << endl;
    cin >> n;

    cout << "Введите Хmin:" << endl;
    cin >> x_min;

    cout << "Введите Xmax:" << endl;
    cin >> x_max;

    if (x_max < x_min)
    {
        cout << "Неверное введенное значение Хmax" << endl;
        return 0;
    }

    Dx = x_max - x_min;

    cout << "Введите количество интервалов: < " << Dx << ":" << endl;
    cin >> n_int;

    int* lGrInt = new int[n_int];

    cout << "Введите первую левую границу LG1 > " << x_min << endl;

    for (int i = 0; i < n_int; i++)
    {
        cin >> lGrInt[i];

        if (lGrInt[i] <= x_min)
        {
            cout << "Введенная граница некорректна" << endl;
            return 0;
        }

    }



    int j, buffer;
    for (int i = 1; i < n_int; ++i)
    {
        buffer = lGrInt[i];
        j = i - 1;
        while (j >= 0 && lGrInt[j] > buffer)
        {
            lGrInt[j + 1] = lGrInt[j];
            lGrInt[j] = buffer;
            --j;
        }
    }

    lGrInt[n_int] = x_max;
    random_device rand;
    mt19937 gen(rand());
    uniform_int_distribution<> numb(x_min, x_max);
    int* numbers = new int[n];

    for (int i = 0; i < n; i++)
        numbers[i] = numb(gen);

    cout << "Сгенерированные числа:" << endl;
    for (int i = 0; i < n; i++)
        cout << numbers[i] << " ";
    cout << endl;

    int* res = new int[n];


    for (int i = 0; i < n_int; i++)
        res[i] = 0;
    cout << endl;

    FUNC(numbers, n, lGrInt, n_int, res);

    ofstream fout("ResOut.txt");

    cout << "N  Lg  Res" << endl;
    fout << "N   Lg   Res" << endl;

    for (int i = 0; i < n_int; i++)
    {
        cout << i << "   " << lGrInt[i] << "    " << res[i] << endl;
        fout << i << "   " << lGrInt[i] << "    " << res[i] << endl;
    }

    fout.close();
    return 0;
}