#include <iostream>
#include <stdio.h>
#include <fstream>
#include <string>
#include <random>

using namespace std;

extern "C" void mod1(int* numbers, int n, int* res1, int xmin);
extern "C" void mod2(int* res1, int* intervals, int nint, int* res2, int xmin);

int comp(const void* a, const void* b) {
	return (*(int*)a - *(int*)b);
}

int main() {
	int n, xmin, xmax,nint;
	cin >> n;
	cin >> xmin >> xmax;
	cin >> nint;
	if (nint < (abs(xmax - xmin)))
	{
		cout << "Nint<Dx :O" << endl;
		return 0;
	}
	if (nint < 1 || nint>24) {
		cout << "nint <= 24" << endl;
		return 0;
	}
	int* intervals = new int[nint + 1];
	int* res2 = new int[nint];
	for (int i = 0; i < nint; i++) {
		cin >> intervals[i];
		res2[i] = 0;
	}
	intervals[nint] = xmax+1;
	qsort(intervals, nint+1, sizeof(int*), comp);
	if (intervals[0] > xmin) {
		cout << "Lg1>Xmin :O" << endl;
		return 0;
	}
	int* res1 = new int[abs(xmax - xmin) + 1];
	for (int i = 0; i < abs(xmax - xmin) + 1; i++)
	{
		res1[i] = 0;
	}
	int* numbers = new int[n];
	random_device rd;
	mt19937 gen(rd());
	normal_distribution<> conc_gen((xmin + xmax) / 2,abs(xmax - xmin) / 4);
	for (int i = 0; i < n; i++) {
		numbers[i] = int(conc_gen(gen));
		//cout << numbers[i] << ' ';
	}
	cout << endl;
	mod1(numbers, n, res1, xmin);
	/*for (int i = 0; i < abs(xmax - xmin) + 1; i++) {
		cout << xmin + i << ' ' << res1[i] << endl;
	}*/
	mod2(res1, intervals, nint, res2, xmin);

	ofstream file("result.txt");
	file << "¹\t\tLgi\t\t#\n";
	cout << "¹\t\tLgi\t\t#\n";
	for (int i = 0; i < nint; i++) {
		file << i << "\t\t" << intervals[i] << "\t\t" << res2[i] << endl;
		cout << i << "\t\t" << intervals[i] << "\t\t" << res2[i] << endl;
	}

	/*for (int i = 0; i < nint; i++) {
		if (i == nint - 1)
		{
			cout << "[" << intervals[i] << ":" << intervals[i + 1] - 1 << "]: " << res2[i] << endl;
			break;
		}
		cout << "[" << intervals[i] << ":" << intervals[i + 1] << "): " << res2[i] << endl;
	}*/
	return 0;
}