#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <random>

using namespace std;

extern "C" void func(int* nums, int numsCount, int* leftBorders, int* result);

void output(string A, string B, string C, ofstream& file) {
    cout << setw(6) << right << A << setw(15) << right << B << setw(17) << right << C << endl;
    file << setw(6) << right << A << setw(15) << right << B << setw(17) << right << C << endl;
}

int main(){
    setlocale(LC_ALL, "ru");

    int randNumCount;
    cout << "Введите кол-во псевдослучайных целых чисел: ";
    cin >> randNumCount;
    if (randNumCount <= 0) { cout << "Некорректное кол-во чисел"; return -1; };

    int max, min;
    cout << "Введите границы: ";
    cin >> min >> max;
    if (max <= min) { cout << "Некорректные границы распределения"; return -1; };

    int intervalCount;
    cout << "Введите количество интервалов: ";
    cin >> intervalCount;
    if (randNumCount <= 0) { cout << "Некорректное кол-во интервалов"; return -1; };

    cout << "Введите левые границы: ";
    int* leftBorders = new int[intervalCount];
    int* result = new int[intervalCount];
    for (int i = 0; i < intervalCount; i++) {
        cin >> leftBorders[i];

        int index = i;
        while (index && leftBorders[index] < leftBorders[index - 1]) {
            swap(leftBorders[index--], leftBorders[index]);
        }
        result[i] = 0;
    }
    cout << endl;

    random_device rd{};
    mt19937 gen(rd());

    float mean = float(max+min)/2;
    float stddev = float(max-min)/6;
    normal_distribution<float> dist(mean, stddev);

    int* nums = new int[randNumCount];
    for (int i = 0; i < randNumCount; i++) {
        nums[i] = round(dist(gen));
    }

    func(nums, randNumCount, leftBorders, result);

    ofstream file("output.txt");
    cout << "Результат:\n";
    output("Номер", "Интервал", "Кол-во значений", file);
    for (int i = 0; i < intervalCount-1; i++) {
        output(
            to_string(i + 1), 
            '[' + to_string(leftBorders[i]) + "; " + to_string(leftBorders[i + 1]) + ")", 
            to_string(result[i + 1]), 
            file
        );
    }

    file.close();
    system("pause");
    return 0;
}
