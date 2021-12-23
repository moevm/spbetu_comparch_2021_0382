#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <random>
#include <stdlib.h>

using namespace std;

extern "C" void func(int* nums, int numsCount, int* leftBorders, int* result);

//21 Равн распр. Nint  ?  Dx. Lg1 > Xmin

int cmp(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

void OUT(string A, string B, string C, ofstream& file) {
    cout << setw(5) << right << A << setw(15) << right << B << setw(20) << right << C << endl;
    file << setw(5) << right << A << setw(15) << right << B << setw(20) << right << C << endl;
}

int main() {
    setlocale(LC_ALL, "");
    int i, randNumCount, max, min, intervalCount;

    cout << "Введите кол-во чисел: ";                          
    cin >> randNumCount;                               
    cout << "Введите границу min: ";                     
    cin >> min;     
    cout << "Введите границы max: ";
    cin >> max;
    cout << "Введите количество интервалов: ";                 
    cin >> intervalCount;
    if (intervalCount < (max - min)) {
        cout << "не выполняется Nint >= D_x !\n";
        return 0;
    }
                                                      
    int* leftBorders = new int[intervalCount + 1];       
    int* result = new int[intervalCount + 1];            
    leftBorders[intervalCount] = max + 1;                
    result[intervalCount] = 0;          

    cout << "Введите левые границы интервалов: ";
                                                       
    for (i = 0; i < intervalCount; i++) {              
        cin >> leftBorders[i];                         
        result[i] = 0;
    }                               
    cout << endl; 

    if (leftBorders[0] <= min) {
        cout << "не выполняется Lg1 > X_min !\n";
        return 0;
    }

    qsort(leftBorders, intervalCount, sizeof(int), cmp);           

    random_device rd{};                                    
    mt19937 gen(rd());                                    
    std::uniform_int_distribution<int> dist(min, max);       
    int* nums = new int[randNumCount];                     
    for (i = 0; i < randNumCount; i++) {                   
        nums[i] = round(dist(gen));
    }                       

    if (randNumCount <= 100) {                          
        for (i = 0; i < randNumCount; i++) {           
            cout << nums[i] << " ";
        }
    }                 
    cout << endl << endl;

    func(nums, randNumCount, leftBorders, result);          

    ofstream file("output.txt");                                                                
    OUT("№", "Int", "In", file);                                        
    for (i = 0; i < intervalCount; i++) {                                                          
        if (i == intervalCount - 1) {                                                               
            OUT(                                                                                 
                to_string(i + 1),                                                                   
                '[' + to_string(leftBorders[i]) + "; " + to_string(leftBorders[i + 1] - 1) + "]",     
                to_string(result[i + 1]),                                                           
                file);
        }                                                                             
        else {                                                                                      
            OUT(                                                                                 
                to_string(i + 1),                                                                   
                '[' + to_string(leftBorders[i]) + "; " + to_string(leftBorders[i + 1]) + ")",       
                to_string(result[i + 1]),                                                           
                file);
        }
    }                                                                            
    file.close();                                                                                   

    return 0;
}