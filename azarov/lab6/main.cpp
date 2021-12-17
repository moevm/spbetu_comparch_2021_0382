#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void count_distribution(int* numbers, int n, int* borders, int n_gr, int* units, int n_units, int x_min, int* res);

int main() {
	setlocale(LC_ALL, "Russian");
	int n, x_min, x_max, n_gr;
	cout << "Введите нужное кол-во псевдослучайных целых чисел:" << endl;
	cin >> n;
	cout << "\nВведите диапазон псевдослучайных целых чисел Xmin и Xmax, через пробел:" << endl;
	cin >> x_min >> x_max;
	cout << "\nВведите кол-во интервалов  Nint:" << endl;
	cin >> n_gr;
	n_gr++; // границ на 1 больше чем интервалов 

	// Nint < D_x
	if ((n_gr - 1) < (x_max - x_min)) {
		cout << "\nНекоректные данные: Nint < D_x" << endl;
		return 0;
	}

	cout << "\nВведите " << n_gr <<" границ интервалов, через пробел:" << endl;
	auto borders = new int[n_gr];
	for (int i = 0; i < n_gr; ++i) {
		cin >> borders[i];
	}

	//  Lg1 <= X_min
	if (borders[0] <= x_min) {
		cout <<"\nНекоректные данные: Lg1 <= X_min" << endl;
		return 0;
	}

	// Last_gr <= X_max
	if (borders[n_gr - 1] <= x_max) {
		cout << "\nНекоректные данные: Last_gr <= X_max" << endl;
		return 0;
	}

	//инициализация генератора
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<int>  distr(x_min, x_max);


	//генерация чисел
	auto numbers = new int[n];
	for (int i = 0; i < n; ++i) {
		numbers[i] = distr(gen);

		//показать массив сгенерированных чисел
		//cout << numbers[i] << " ";
		//if ((i + 1) % 50 == 0) cout << "\n";
	}

	cout << endl;

	//посчет попаданий в интергвалы
	int n_units = x_max - x_min + 1;
	auto units = new int[n_units];
	auto result = new int[n_gr - 1];
	for (int i = 0; i < n_units; ++i)
		units[i] = 0;
	for (int i = 0; i < n_gr - 1; ++i)
		result[i] = 0;

	count_distribution(numbers, n, borders, n_gr, units, n_units, x_min, result);

	/*for (int i = 0; i < n_units; ++i) {

		cout << units[i] << " ";

	}*/

	//выввод
	ofstream file("res.txt");
	auto name_table = "Таблица частотного распределения чисел по интервалам\n";
	auto head = "N\tLg[i]\t    Кол-во попаданий";
	file << name_table <<head << endl;
	cout << "\n" << name_table << head << endl;
	for (int i = 0; i < n_gr - 1; i++) {
		auto row = to_string(i) + "\t" + to_string(borders[i]) + "\t\t   " + to_string(result[i]) + "\n";
		file << row;
		cout << row;
	}

	return 0;
}