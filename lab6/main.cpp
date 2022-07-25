#include <iostream>
#include <fstream>
#include <random>
#include <string>

using namespace std;

extern "C" void pre_func(int* numbers, int Num_Ran_Dat, int* pre_answer, int X_min);
extern "C" void final_func(int* intervals, int N_int, int* pre_answer, int X_min, int* final_answer);

int main() {
	int Num_Ran_Dat, X_min, X_max, N_int;
	cout << "Enter the amount of numbers:" << endl;
	cin >> Num_Ran_Dat;
	cout << "Enter the generation borders for numbers:" << endl;
	cin >> X_min >> X_max;
	cout << "Enter number of intervals:" << endl;
	cin >> N_int;

	if (N_int <= 0 || N_int > 24) {
		cout << "Number of intervals should be from 0 to 24!" << endl;
		system("Pause");
		return 0;
	}

	if (N_int < abs(X_max - X_min)) {
		cout << "Number of intervals more or equal than difference of borders!" << endl;
		system("Pause");
		return 0;
	}

	cout << "Enter left borders:" << endl;
	auto intervals = new int[N_int + 1];
	for (int i = 0; i < N_int; ++i) {
		cin >> intervals[i];
	}
	intervals[N_int] = X_max;

	if (intervals[0] > X_min) {
		cout << "First border should be less or equal X_min" << endl;
		system("Pause");
		return 0;
	}

	for (int i = 0; i < N_int + 1; i++) {
		for (int j = i; j < N_int + 1; j++) {
			if (intervals[i] > intervals[j]) {
				swap(intervals[i], intervals[j]);
			}
		}
	}
	
	if (intervals[N_int] > X_max) {
		cout << "The right border of last interval sould be less or equal than X_max!" << endl;
		system("Pause");
		return 0;
	}

	auto numbers = new int[Num_Ran_Dat];
	random_device rd;
	mt19937 generator(rd());
	uniform_int_distribution<> dist(X_min, X_max);
	for (int i = 0; i < Num_Ran_Dat; i++) {
		numbers[i] = dist(generator);
	}


	auto pre_answer = new int[abs(X_max - X_min) + 1];
	auto final_answer = new int[N_int];
	for (int i = 0; i < abs(X_max - X_min) + 1; i++) {
		pre_answer[i] = 0;
	}
	for (int i = 0; i < N_int; i++) {
		final_answer[i] = 0;
	}

	pre_func(numbers, Num_Ran_Dat, pre_answer, X_min);
	cout << "Pre answer: ";
	for (int i = 0; i < abs(X_max - X_min); i++) {
		cout << i + X_min << ": " << pre_answer[i] << " | ";
	}
	cout << to_string(abs(X_max - X_min) + X_min) << ": " << pre_answer[abs(X_max - X_min)] << endl;
	final_func(intervals, N_int, pre_answer, X_min, final_answer);

	ofstream file("output.txt");
	auto str = "N\tBorders\tThe Amount of numbers";
	file << str << endl;
	cout << str << endl;
	for (int i = 0; i < N_int; i++) {
		auto str_res = to_string(i + 1) + "\t" + to_string(intervals[i]) + "\t\t" + to_string(final_answer[i]) + "\n";
		file << str_res;
		cout << str_res;
	}

	system("pause");
	return 0;
}
