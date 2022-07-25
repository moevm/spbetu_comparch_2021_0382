#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <random>
#include <stdlib.h>

using namespace std;

extern "C" void func(int* nums, int numsCount, int* leftBorders, int* result);

void output(string A, string B, string C, ofstream& file) {    // функция для вывода на экран и в файл
    cout << setw(6) << right << A << setw(15) << right << B << setw(17) << right << C << endl;
    file << setw(6) << right << A << setw(15) << right << B << setw(17) << right << C << endl;}

int comp1(const void* a, const void* b){  // функция необходимая для qsort
    return (*(int*)a - *(int*)b);}

int main() {
    setlocale(LC_ALL, "ru");
    int i;
    int randNumCount;
    int max, min;
    int intervalCount;

    cout << "кол-во чисел: ";                          // ввод необходимых параметров
    cin >> randNumCount;                               //
    cout << "границы(min, max): ";                     //
    cin >> min >> max;                                 //
    cout << "количество интервалов: ";                 //
    cin >> intervalCount;                              //
    cout << "левые границы интервалов: ";              //
                                                       //
    int* leftBorders = new int[intervalCount+1];       //
    int* result = new int[intervalCount+1];            //
    leftBorders[intervalCount] = max+1;                //
    result[intervalCount] = 0;                         //
                                                       //
    for (i = 0; i < intervalCount; i++) {              //
        cin >> leftBorders[i];                         //
        result[i] = 0;}                                //
    cout << endl;                                      // 

    qsort(leftBorders, intervalCount, sizeof(int), comp1);           // сортировка левых границ по возрастанию

    random_device rd{};                                    // генерация случайных чисел (нормальное (гаусовское))
    mt19937 gen(rd());                                     //
    float mean = float(max + min) / 2;                     //
    float stddev = float(max - min) / 6;                   //
    normal_distribution<float> dist(mean, stddev);         //
    int* nums = new int[randNumCount];                     //
    for (i = 0; i < randNumCount; i++) {                   //
        nums[i] = round(dist(gen));}                       //

    if (randNumCount < 101) {                          // вывод сгенерированных чисел (если их меньше 100) 
        for (i = 0; i < randNumCount; i++) {           //
            cout << nums[i] << " ";}}                  //
    cout << endl << endl;

    func(nums, randNumCount, leftBorders, result);          // вызов функции asm

    ofstream file("output.txt");                                                                    // отправка на печать необходимых параметров
    output("номер", "интервал", "вхождения", file);                                          // номер интервала; границы интервала; количество чисел
    for (i = 0; i < intervalCount; i++) {                                                           //
        if (i == intervalCount - 1) {                                                               //
            output(                                                                                 //
                to_string(i + 1),                                                                   //
                '[' + to_string(leftBorders[i]) + "; " + to_string(leftBorders[i + 1]-1) + "]",     //
                to_string(result[i + 1]),                                                           //
                file);}                                                                             //
        else {                                                                                      //
            output(                                                                                 //
                to_string(i + 1),                                                                   //
                '[' + to_string(leftBorders[i]) + "; " + to_string(leftBorders[i + 1]) + ")",       //
                to_string(result[i + 1]),                                                           //
                file);}}                                                                            //
    file.close();                                                                                   //

    return 0;
}