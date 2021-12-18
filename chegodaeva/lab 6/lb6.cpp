#include <iostream>
#include <random>
#include <stdio.h>
#include <fstream>
#include <string>

extern "C" void module1(int* arr, int n, int* res1, int min);
extern "C" void module2(int* distr, int* interv, int min, int max, int* res2);

using namespace std;


int comp(const void* a, const void* b) {
	return (*(int*)a - *(int*)b);
}

int main() {
	setlocale(LC_ALL, "Russian");
	int n;
	int min;
	int max;
	int NInt;
	cout << "\nВведите количество чисел:" << endl;
	cin >> n;
	if (n > 16000) {
		cout << "Слишком большое число" << endl;
		return 0;
	}
	cout << "Введите (через пробел) диапазон чисел: " << endl;
	cin >> min >> max;
	int D = max - min;
	cout << "Введите число интервалов: " << endl;
	cin >> NInt;
	if (NInt >= 24) {
		cout << "Слишком большое число интервалов" << endl;
		return 0;
	}
	if (NInt < abs(D)) {
		cout << "Количество должно быть больше-ровно разности диапазона!!!" << endl;
		return 0;
	}
	int* interv = new int[NInt+1];
	int* result_modul2 = new int[n];
	cout << "Введите " << NInt << " левых границ интервалов: " << endl;


	for (int i = 0; i < NInt; i++) {
		cin >> interv[i];
		result_modul2[i] = 0;
	}
	qsort(interv, NInt, sizeof(int*), comp);

	if (interv[0] > min) {
		cout << "Левая граница первого интервала должна быть меньше первого элемента диапазона!!!" << endl;
		return 0;
	}

	random_device rd;
	mt19937 gen(rd());
	normal_distribution<> conc_gen((min + max) / 2, abs(max - min) / 4);

	interv[NInt] = max + 1;
	int* result_module1 = new int[abs(D) + 1];
	int* arr = new int[n];

	for (int i = 0; i < abs(D) + 1; i++) {
		result_module1[i] = 0;
	}

	cout << "\nМассив прсевдослучайных чисел:" << endl;
	for (int i = 0; i < n; i++) {
		arr[i] = int(conc_gen(gen));
		cout << arr[i] << ' ';
	}
	cout << endl;

	module1(arr, n, result_module1, min);
	
	ofstream file("result.txt");
	string bunner1 = "Таблица 1:\n";
	string head1 = "\nL | Count";

	file << bunner1 << head1 << endl;
	cout << "\n" << bunner1 << head1 << endl;
	for (int i = 0; i < abs(D) + 1; i++) {
		string res1 = (to_string(min + i) + " | " + to_string(result_module1[i]) + "\n");
		file << res1;
		cout << res1;
	}

	module2(result_module1, interv, min, max, result_modul2);

	string bunner2 = "\nТаблица 2:\n";
	string head2 = "\nN | L | Count";

	file << bunner2 << head2 << endl;
	cout << "\n" << bunner2 << head2 << endl;
	for (int i = 0; i < NInt; i++) {
		string res2 = (to_string(i) + " | " + to_string(interv[i]) + " | " + to_string(result_modul2[i]) + "\n");
		file << res2;
		cout << res2;
	}
	
	return 0;
}