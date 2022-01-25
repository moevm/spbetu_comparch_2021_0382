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
	if (n_int >= (x_max - x_min)) {
		cout << "Nint < D_x must be" << endl;
		return 0;
	}
	cout << "Enter Lgi seperated by spaces:" << endl;
	auto intervals = new int[n_int + 1];
	for (int i = 0; i < n_int; ++i) {
		cin >> intervals[i];
	}
	intervals[n_int] = x_max;


	double mean = (x_min + x_max) / 2;
	double sigma = (x_max - x_min) / 4;
	if (!sigma) sigma = 1;
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
		cout << number << " ";
		if ((i + 1) % 50 == 0) cout << "\n";
	}
	cout << endl;


	auto units = new int[x_max - x_min + 1];
	auto result = new int[n_int + 1];
	for (int i = 0; i < x_max - x_min + 1; ++i)
		units[i] = 0;
	for (int i = 0; i < n_int + 1; ++i)
		result[i] = 0;
	float mid = 0.0;
	unit_distribution(numbers, n, units, x_min);

	
	intervals_distribution(intervals, n_int, units, x_max - x_min + 1, x_min, result);
	cout << "\n\n";

	
	auto head = "N\tLeft border\tAmount of numbers";
	cout << head << endl;
	for (int i = 0; i < n_int; i++) {
		auto row = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(result[i]) + "\n";
		cout << row;
	}

	return 0;
}






