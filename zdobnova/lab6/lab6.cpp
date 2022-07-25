#include <iostream>
#include <fstream>
#include <random>
#include <algorithm>

extern "C" void FUNC(int* numbers, int num_cnt, int *lgrint, int n_int, int* result);

int comp(const void* a, const void* b) {
	return (*(int*)a - *(int*)b);
}

int main() {
	int n, x_min, x_max, n_int, d_x;
	std::cout << "Size of array:" << std::endl;
	std::cin >> n;
	std::cout << "X_min:" << std::endl;
	std::cin >> x_min;
	std::cout << "X_max:" << std::endl;
	std::cin >> x_max;
	if (x_max < x_min) {
		std::cout << "Wrong value of x_max" << std::endl;
		return 0;
	}
	d_x = x_max - x_min;
	std::cout << "Number of intervals, n_int < " << d_x << ":" << std::endl;
	std::cin >> n_int;
	auto lgrint = new int[n_int + 1];
	std::cout << "LG1 <= " << x_min << std::endl;
	for(int i = 0; i < n_int; i++) {
		std::cin >> lgrint[i];
		if (lgrint[0] > x_min){
			return 0;
		}
	}
	qsort(lgrint, n_int, sizeof(int*), comp);
	lgrint[n_int] = x_max;
	std::random_device rand;
	std::mt19937 gen(rand());
	std::uniform_int_distribution<> numb(x_min, x_max);
	auto numbers = new int[n];
	for (int i = 0; i < n; i++) {
		numbers[i] = numb(gen);
	}
	for (int i = 0; i < n; i++) {
		std::cout << numbers[i] << " ";
	}
	std::cout << std::endl;
	auto result = new int[n];
	for (int i = 0; i < n_int; i++) {
		result[i] = 0;
	}
	FUNC(numbers, n, lgrint, n_int, result);
	for (int i = 0; i < n_int; i++) {
		std::cout << result[i] << " ";
	}
	std::cout << std::endl;
	std::ofstream fout("fout.txt");
	std::cout << "N  Lg  Res" << std::endl;
	fout << "N   Lg   Res" << std::endl;
	for (int i = 0; i < n_int; i++) {
		std::cout << i << "   " << lgrint[i] << "    " << result[i] << std::endl;
		fout << i << "   " << lgrint[i] << "    " << result[i] << std::endl;
	}
	fout.close();
	return 0;
}