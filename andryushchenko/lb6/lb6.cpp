#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <random>

using namespace std;

extern "C" void func(int* nums, int numsCount, int* leftBorders, int* result);

void output(string A, string B, string C, ofstream& file) {
    cout << setw(6) << right << A << setw(15) << right << B << setw(17) << right << C << setw(17) << right << endl;
    file << setw(6) << right << A << setw(15) << right << B << setw(17) << right << C << setw(17) << right << endl;
}

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

    for (int i = 0; i < scopeCount; i++) {
        cin >> leftScope[i];

        int index = i;
        while (index && leftScope[index] < leftScope[index - 1]) {
            swap(leftScope[index--], leftScope[index]);
        }
        result[i] = 0;

        if (i == scopeCount - 1) leftScope[i]++;
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

    func(num, CountNum, leftScope, result);

    ofstream file("output.txt");
    cout << "Result:\n";

    output("Num", "Interval", "Num count", file);
    for (int i = 0; i < scopeCount - 1; i++) {
        output(
            to_string(i + 1),
            '[' + to_string(leftScope[i]) + "; " + to_string(leftScope[i + 1]) + ")",
            to_string(result[i + 1]),
            file
        );
    }

    file.close();
    return 0;
}
