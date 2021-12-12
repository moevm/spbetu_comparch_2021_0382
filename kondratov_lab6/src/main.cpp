#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void unit_distribution(int* numbers, int n, int* res, int x_min);
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
	auto intervals = new int[n_int];
	for (int i = 0; i < n_int + 1; ++i) {
		cin >> intervals[i];
		if (intervals[i] < x_min){
			cout << "lg" << i << " <= X_min" << endl;
			return 0;
		}
	}
	if (intervals[n_int - 1] > x_max) {
		cout << "RBLast > X_max" << endl;
		return 0;
	}


	double mean = (x_min + x_max) / 2;
	double sigma = (x_max - x_min) / 4;
	cout << "\nNumbers generated with normal distribution (mean = " << mean << ", sigma = " << sigma << ").\n" << endl;
	random_device r_d;
	mt19937 generator(r_d());
	normal_distribution<double> distribution(mean, sigma);

	auto numbers = new int[n];
	for (int i = 0; i < n; ++i) {
		int number = distribution(generator);
		while (number < x_min || number > x_max)
			number = distribution(generator);
		numbers[i] = number;
//		cout << number << " ";
//		if ((i + 1) % 50 == 0) cout << "\n";
	}

	auto units = new int[x_max - x_min];
	auto result = new int[n_int];
	for (int i = 0; i < x_max - x_min; ++i)
		units[i] = 0;
	for (int i = 0; i < n_int; ++i)
		result[i] = 0;
	unit_distribution(numbers, n, units, x_min);
	intervals_distribution(intervals, n_int, units, x_max - x_min, x_min, result);

	ofstream file("table.txt");
	auto head = "N\tLeft border\tAmount of umbers";
	file << head << endl;
	cout << head << endl;
	for (int i = 0; i < n_int; i++) {
		auto row = to_string(i) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(result[i]) + "\n";
		file << row;
		cout << row;
	}

	return 0;
}