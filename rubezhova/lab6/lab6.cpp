#include <iostream>
#include <random>
#include <fstream>
#include <string>

extern "C" void count_hits_in_interval(int* numbers, int n, int* borders, int N_int, int* counters);

int main()
{
	setlocale(LC_ALL, "Russian");
	int n, x_min, x_max, N_int;
	std::cout << "~~~ Равномерное распределение попаданий псевдослучайных чисел в заданные интервалы ~~~\n\n";
	std::cout << "\tКоличество генерируемых псевдослучайных чисел: ";
	std::cin >> n;
	std::cout << "\tДиапазон D_x: [Xmin, Xmax](введите через пробел): ";
	std::cin >> x_min >> x_max;
	std::cout << "\tВведите кол-во интервалов/левых границ  Nint (Nint >= (x_max - x_min) ): ";
	std::cin >> N_int;
	if (N_int < (x_max - x_min)) {
		std::cout << "\tДолжно выполняться условие Nint >= D_x !\n";
		return 0;
	}

	std::cout << "\tВведите через пробел левые границы интервалов (Lg_1 <= x_min) в порядке возрастания: ";
	int* borders = new int[N_int+1]; // N_int+1, так как в последнюю ячейку будем дублировать X_max
	for (int i = 0; i < N_int; i++) {
		std::cin >> borders[i];
	}
	if (borders[0] > x_min) {
		std::cout << "\tДолжно выполняться условие: Lg1 <= X_min !\n";
		return 0;
	}
	borders[N_int] = x_max;

	std::random_device rnd;
	std::mt19937 gen(rnd());
	std::uniform_int_distribution<int>  distribution(x_min, x_max);

	std::cout << std::endl;
	//генерируем рандомные числа
	int* numbers = new int[n];
	std::cout << "Сгенерированные числа: \n";
	for (int i = 0; i < n; i++) {
		numbers[i] = distribution(gen);
		std::cout << numbers[i] << " ";
	}
	std::cout << std::endl;

	//подготовка к подсчету распределения и вызов самой ассемблерной процедуры
	int* counters = new int[N_int];
	for (int i = 0; i < N_int; i++)
		counters[i] = 0;

	count_hits_in_interval(numbers, n, borders, N_int, counters);

	//запись результата
	std::ofstream fres("result_table.txt");
	fres << "Таблица частотного распределения чисел по интервалам\n" << "N_int\tLg[i]\t\tКол-во попаданий" << '\n';
	std::cout << "\nТаблица частоты попадания чисел в интервалы\n" << "N_int\tLg[i]\t\tКол-во попаданий" << '\n';
	for(int i = 0; i < N_int; i++){
		auto str_res = std::to_string(i) + "\t" + std::to_string(borders[i]) + "\t\t   " + std::to_string(counters[i]) + "\n";
		std::cout << str_res;
		fres << str_res;
	}
	return 0;
}
