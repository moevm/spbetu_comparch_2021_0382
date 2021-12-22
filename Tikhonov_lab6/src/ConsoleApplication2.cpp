#include <iostream>
#include <fstream>
#include <random>

extern "C" void FUNC(int* array, int array_size, int* left_boarders, int intervals_size, int* result_array);
int main() {
	setlocale(0, "");

	int array_size;
	std::cout << "Введите количество чисел: ";
	std::cin >> array_size;
	int xMin, xMax;
	std::cout << "Введите максимальное число: ";
	std::cin >> xMax;
	std::cout << "Введите минимальное число: ";
	std::cin >> xMin;
	if (xMax < xMin) {
		return 0;
	}
	int is;
	std::cout << "Введите количество интервалов: ";
	std::cin >> is;
	if (is <= 0 or is > 24) {
		return 0;
	}
	if (is >= std::abs(xMax - xMin)) {
		return 0;
	}


	int* left = new int[is];
	std::cout << "Введите левые границы: ";
	for (int i = 0; i < is; i++)
		std::cin >> left[i];

	for (int i = 0; i < is - 1; i++) {
		for (int j = i + 1; j < is; j++) {
			if (left[j] < left[i]) {
				std::swap(left[j], left[i]);
			}
		}
	}
	if (is > 0 and left[0] < xMin) {
		return 0;
	}

	std::random_device rd;
	std::mt19937 gen(rd());
	std::normal_distribution<> dis((xMin + xMax) / 2, std::abs(xMax - xMin) / 4); 
	int* array = new int[array_size];
	for (int i = 0; i < array_size; i++) array[i] = std::round(dis(gen));

	std::ofstream file("out.txt");
	file << "Сгенерированные числа: ";
	for (int i = 0; i < array_size; i++) file << array[i] << ' ';
	file << '\n';

	std::cout << "Сгенерированные числа: ";
	for (int i = 0; i < array_size; i++) std::cout << array[i] << ' ';
	std::cout << '\n';

	int* result_array = new int[is];
	for (int i = 0; i < is; i++)
		result_array[i] = 0;

	FUNC(array, array_size, left, is, result_array);

	std::cout << "Номер интервала \tЛевая граница интервала \tКоличество чисел в интервале" << '\n';
	file << "Номер интервала \tЛевая граница интервала \tКоличество чисел в интервале" << '\n';
	for (int i = 0; i < is; i++) {
		std::cout << "\t" << i + 1 << "\t\t\t" << left[i] << "\t\t\t" << result_array[i] << '\n';
		file << "\t" << i + 1 << "\t\t\t" << left[i] << "\t\t\t" << result_array[i] << '\n';
	}
	file.close();
	system("pause");
	return 0;
}