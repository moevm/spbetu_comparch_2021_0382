#include <iostream>
#include <random>
#include <fstream>


//Перемножить в dowble переменную все сгенерированные числа через мат препроцессор
int comp(const void* a, const void* b){
	return *(int*)a - *(int*)b;
}

class Generator {
	std::mt19937 generator;
	std::normal_distribution<double> distribution;
	double min;
	double max;
public:
	Generator(double min, double max) :
		distribution((min + max) / 2, (max - min) / 6), min(min), max(max)
	{}

	double operator ()() {
		while (true) {
			double number = this->distribution(generator);
			if (number >= this->min && number <= this->max)
				return number;
		}
	}
};

extern "C" void first(int* numbers, int numbers_size, int* result, int xmin, double* product_res);
extern "C" void second(int* array, int array_size, int xmin, int* intervals, int intervals_size, int* result);


const int max_numbers_size = 16000;
const int max_interval_size = 24;

int main() {
	setlocale(LC_ALL, "ru");

	srand(time(NULL));
	std::ofstream file_result("result.txt");

	int numbers_size;
	int Xmin, Xmax;

	std::cout << "Введите количество чисел:" << std::endl;
	std::cin >> numbers_size;
	if (numbers_size > max_numbers_size) {
		std::cout << "Количество чисел должно быть меньше или равно " << max_numbers_size << std::endl;
		return 0;
	}
	std::cout << "Введите Xmin и Xmax:" << std::endl;
	std::cin >> Xmin >> Xmax;
	int Dx = Xmax - Xmin;

	int intervals_size;
	std::cout << "Введите число границ:" << std::endl;
	std::cin >> intervals_size;

	if (intervals_size > max_interval_size) {
		std::cout << "Число интервалов должно быть меньше или равно " << max_interval_size << std::endl;
		return 0;
	}
	if (intervals_size >= Dx) {
		std::cout << "Число интервалов должно быть строго меньше Dx = Xmax - Xmin" << std::endl;
		return 0;
	}
	int* numbers = new int[numbers_size];
	int* intervals = new int[intervals_size];
	int* additional_intervals = new int[intervals_size];

	int len_asm_mod1_res = abs(Xmax - Xmin) + 1;
	int* mod_result = new int[len_asm_mod1_res];
	for (int i = 0; i < len_asm_mod1_res; i++)
		mod_result[i] = 0;


	int* final_result = new int[intervals_size + 1];
	for (int i = 0; i < intervals_size + 1; i++)
		final_result[i] = 0;


	std::cout << "Введите границы:" << std::endl;
	for (int i = 0; i < intervals_size; i++) {
		std::cin >> intervals[i];
		additional_intervals[i] = intervals[i];
	}
	std::qsort(intervals, intervals_size, sizeof(int), comp);
	std::qsort(additional_intervals, intervals_size, sizeof(int), comp);


	Generator genetate(Xmin, Xmax);

	for (int i = 0; i < numbers_size; i++) numbers[i] = genetate();

	std::cout << "Сгенерированные числа" << std::endl;
	file_result << "Сгенерированные числа" << std::endl;
	for (int i = 0; i < numbers_size; i++) {
		std::cout << numbers[i] << " ";
		file_result << numbers[i] << " ";
	}
	std::cout << std::endl;
	file_result << std::endl;

	
	double product_res = 0;
	
	first(numbers, numbers_size, mod_result, Xmin, &product_res);
	second(mod_result, numbers_size, Xmin, intervals, intervals_size, final_result);
	std::cout << product_res << std::endl;

	std::cout << "Результат:" << std::endl;
	file_result << "Результат:" << std::endl;
	std::cout << "№\tГраница\tКоличество чисел" << std::endl;
	file_result << "№\tГраница\tКоличество чисел" << std::endl;

	for (int i = 0; i < intervals_size; i++) {
		std::cout << i << "\t" << additional_intervals[i] << '\t' << final_result[i + 1] << std::endl;
		file_result << i << "\t" << additional_intervals[i] << '\t' << final_result[i + 1] << std::endl;
	}

	delete[] numbers;
	delete[] intervals;
	delete[] additional_intervals;
	delete[] mod_result;
	delete[] final_result;

	file_result.close();

	return 0;
}

