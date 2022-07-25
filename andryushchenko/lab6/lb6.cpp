#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <random>

using namespace std;

extern "C" void FUNC(int* array, int array_size, int* left_boarders, int intervals_size, int* result_array, int* sum_array);


int main() {
    int CountNum;
    cout << "Count num:";
    cin >> CountNum;
    if (CountNum <= 0) {
        cout << "Error" << endl;
        return -1;
    };

    int maxGateNum, minGateNum;
    cout << "Input min: ";

    cin >> minGateNum;

    cout << "Input max: ";
    cin >> maxGateNum;
    if (maxGateNum <= minGateNum) {
        cout << "Error" << endl;
        return -1;
    };

    int scopeCount;
    cout << "Count scope: ";
    cin >> scopeCount;

    cout << "Input left scope: ";
    int* leftScope = new int[scopeCount];
    int* result = new int[scopeCount];
    int* sum_result = new int[scopeCount];
    for (int i = 0; i < scopeCount; i++) {
        sum_result[i] = 0;
    }

    for (int i = 0; i < scopeCount; i++) {
        cin >> leftScope[i];

        int index = i;
        while (index && leftScope[index] < leftScope[index - 1]) {
            swap(leftScope[index--], leftScope[index]);
        }
        result[i] = 0;


    }
    cout << endl;
   
    random_device rd{};
    mt19937 gen(rd());

    float mean = float(maxGateNum + minGateNum) / 2;
    float stddev = float(maxGateNum - minGateNum) / 6;
    normal_distribution<float> dist(mean, stddev);

    int* num = new int[CountNum];
    for (int i = 0; i < CountNum; i++) {
        num[i] = round(dist(gen));

        int index = i;
        while (index && num[index] < num[index - 1]) {
            swap(num[index--], num[index]);
        }
    }

    cout << "Num: ";
    for (int i = 0; i < CountNum; i++) cout << num[i] << " ";
    cout << endl;

    FUNC(num, CountNum, leftScope, scopeCount, result, sum_result);
    ofstream file("output.txt");
    cout << "Num interval \tleft scope \tNum count \tNum sum" << '\n';
    file << "Num interval \tleft scope \tNum count \tNum sum" << '\n';
    for (int i = 0; i < scopeCount; i++) {
        cout << "\t" << i + 1 << "\t" << leftScope[i] << "\t\t" << result[i] << "\t\t" << sum_result[i] << '\n';
        file << "\t" << i + 1 << "\t" << leftScope[i] << "\t\t" << result[i] << "\t\t" << sum_result[i] << '\n';
    }
    
    file.close();
    return 0;
}