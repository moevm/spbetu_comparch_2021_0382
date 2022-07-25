#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void unit_distribution(int* numbers, int n, int* res, int x_min, float* mid);
extern "C" void intervals_distribution(int* intervals, int n_int, int* units, int n_units, int x_min, int* res);

int main() {
	int n, x_min, x_max, n_int;
	cout << "Enter amount of numbers:" << endl;
	cin >> n;
	cout << "Enter Xmin and Xmax seperated by space:" << endl;
	cin >> x_min >> x_max;
	cout << "Enter number of intervals:" << endl;
	cin >> n_int;
	if (n_int < (x_max - x_min)) {
		cout << "Nint < D_x" << endl;
		return 0;
	}
	cout << "Enter Lgi seperated by spaces:" << endl;
	auto intervals = new int[n_int + 1];
	for (int i = 0; i < n_int; ++i) {
		cin >> intervals[i];
		if (intervals[i] <= x_min){
			cout << "lg" << i << " <= X_min" << endl;
			return 0;
		}
	}
	intervals[n_int] = x_max;


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

	auto units = new int[x_max - x_min + 1];
	auto result = new int[n_int + 1];
	for (int i = 0; i < x_max - x_min + 1; ++i)
		units[i] = 0;
	for (int i = 0; i < n_int + 1; ++i)
		result[i] = 0;
	float mid = 0.0;
	unit_distribution(numbers, n, units, x_min, &mid);
	intervals_distribution(intervals, n_int, units, x_max - x_min + 1, x_min, result);
	cout << "mid: " << mid << "\n\n";

	ofstream file("table.txt");
	auto head = "N\tLeft border\tAmount of umbers";
	file << head << endl;
	cout << head << endl;
	for (int i = 0; i < n_int; i++) {
		auto row = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(result[i]) + "\n";
		file << row;
		cout << row;
	}

	return 0;
}
