#include <iostream>
#include <fstream>
#include <random>
using namespace std;
extern "C" void FUNC(int* array, int array_size, int* left_boarders, int intervals_size, int* result_array);
int main() {
	setlocale(0, "");
	std::ofstream file("out.txt");
	int array_size;
	cout << "Введите число генерируемых чисел: ";
	cin >> array_size;
	int xMin, xMax;
	cout << "Введите минимальное значение: ";
	cin >> xMin;
	cout << "Введите максимальное значение: ";
	cin >> xMax;
	if (xMax < xMin) {
		cout << "Неверно введены максимальное и минимальное значения";
		return 0;
	}
	int intervals_size;
	cout << "Введите количество интервалов: ";
	cin >> intervals_size;
	if (intervals_size <= 0) {
		cout << "Неверно введено количество интервалов";
		return 0;
	}

	int* left_boarders = new int[intervals_size];
	cout << "Введите левые границы:";
	for (int i = 0; i < intervals_size; i++)
		cin >> left_boarders[i];

	for (int i = 0; i < intervals_size-1; i++) {
		for (int j = i + 1; j < intervals_size; j++) {
			if (left_boarders[j] < left_boarders[i]) {
				swap(left_boarders[j], left_boarders[i]);
			}
		}
	}

	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<> dis(xMin, xMax);
	int* array = new int[array_size];
	for (int i = 0; i < array_size; i++) array[i] = dis(gen);

	file << "Сгенерированные числа: ";
	for (int i = 0; i < array_size; i++) file << array[i] << ' ';
	file << '\n';

	int* result_array = new int[intervals_size];
	for (int i = 0; i < intervals_size; i++)
		result_array[i] = 0;

	FUNC(array, array_size, left_boarders, intervals_size, result_array);

	cout << "Номер интервала \tЛевая граница интервала \tКоличество чисел в интервале" << '\n';
	file << "Номер интервала \tЛевая граница интервала \tКоличество чисел в интервале" << '\n';
	for (int i = 0; i < intervals_size; i++) {
		cout << "\t" << i + 1 << "\t\t\t" << left_boarders[i] << "\t\t\t\t" << result_array[i] << '\n';
		file << "\t" << i + 1 << "\t\t\t" << left_boarders[i] << "\t\t\t\t" << result_array[i] << '\n';
	}
	system("pause");
    return 0;
}