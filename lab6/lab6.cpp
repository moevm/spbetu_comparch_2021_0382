#include <iostream>
#include <fstream>
#include <random>

using namespace std;

extern "C" void distribution_1(int* arr, int len_arr, int* res, int Xmin);
extern "C" void distribution_2(int* boarders, int Nint, int* units, int Xmin, int Xmax, int* res);

int main() {

	int len_arr;
	cout << "Enter the length of the aray: ";
	cin >> len_arr;
	int Xmin, Xmax;
	cout << "Enter Xmin: ";
	cin >> Xmin;
	cout << "Enter Xmax: ";
	cin >> Xmax;
	if (Xmax < Xmin) {
		cout << "Xmax < Xmin";
		return 0;
	}
	int Nint;
	cout << "Enter the number of the intervals: ";
	cin >> Nint;
	if (Nint <= 0 || Nint > 24) {
		cout << "Nint must be > 0 and <= 24";
		return 0;
	}
	if (Nint < Xmax - Xmin) {
		cout << "Nint must be >= Dx";
		return 0;
	}


	int* boarders = new int[Nint+1];
	cout << "Enter the left border of each interval: ";
	cin >> boarders[0];
	for (int i = 1; i < Nint; i++) {
		cin >> boarders[i];
		if (boarders[i] > Xmax) {
			cout << "Boarders must be <= Xmax";
			return 0;
		}
	}
	if (boarders[0] > Xmin) {
		cout << "Lg1 mast be <= Xmin";
		return 0;
	}

	for (int i = 0; i < Nint-1; i++) {
		for (int j = i+1; j < Nint; j++) {
			if (boarders[j] < boarders[i]) {
				swap(boarders[j], boarders[i]);
			}
		}
	}
	
	boarders[Nint] = Xmax;

	random_device rd;
	mt19937 gen(rd());
	double mean = (Xmax + Xmin)/2;
	double stddev = (Xmax - Xmin)/4;
	normal_distribution<double> dis(mean, stddev);

	int* arr = new int[len_arr];
	for (int i = 0; i < len_arr; i++) {
		arr[i] = dis(gen);
		while (arr[i] < Xmin || arr[i] > Xmax) {
			arr[i] = dis(gen);
		}
	}

	ofstream file("out.txt");
	file << "Result: ";
	for (int i = 0; i < len_arr; i++) {
		file << arr[i] << ' ';
	}
	file << '\n';

	cout << "Result: ";
	for (int i = 0; i < len_arr; i++) {
		cout << arr[i] << ' ';
	}
	cout << '\n';

	int* result1 = new int[Xmax - Xmin+1];
	int* result2 = new int[Nint];
	for (int i = 0; i < Xmax-Xmin+1; ++i) {
		result1[i] = 0;
	}
	for (int i = 0; i < Nint; ++i) {
		result2[i] = 0;
	}
	//int array[] = { 1, 2, 3, 4, 5 };
	distribution_1(arr, len_arr, result1, Xmin);
	for (int i = 0; i < Xmax-Xmin+1; i++) {
		cout << i + Xmin << ": " << result1[i] << '\t';
	}
	cout <<'\n';
	distribution_2(boarders, Nint, result1, Xmin, Xmax, result2);

	cout << "\tn_int\tLgi\tnumbers" << '\n';
	file << "n_int\tLgi\tnumbers" << '\n';
	for (int i = 0; i < Nint; i++) {
		cout << "\t" << i + 1 << "\t" << boarders[i] << "\t" << result2[i] << '\n';
		file << "\t" << i + 1 << "\t" << boarders[i] << "\t" << result2[i] << '\n';
	}
	file.close();
	return 0;
}