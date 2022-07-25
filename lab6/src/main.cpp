#include <iostream>
#include <fstream>
#include <random>
using namespace std;

extern "C" void func1(int* input,int len, int* result,int min);
extern "C" void func2(int* res_1, int* intervals, int* res_2,int right_border,int len,int min);

int cmp(const void* x1,const void* x2){
    return ( *(int*) x1 - *(int*) x2 );

}


int main(){

    cout<<"Number of random numbers: ";
    int len;
    while(true){
        cin >> len;
        if(len > 0)
            break;

        cout<<"Incorrect quantity, enter a new value: ";
    }

   cout<<"Enter the change range: ";
    int min;
    int max;
    while(true){
        cin >> min;
        cin >> max;
        if(min <= max)
            break;
        cout<<"Invalid range, enter new values: ";
    }

    cout<<"Enter the number of intervals: ";
    int intervals_count;
    while(true){
        cin >> intervals_count;
        if(intervals_count > 0)
            break;
        cout<<"invalid quantity, enter a new value: ";
    }
    int intervals[intervals_count];
    int res_2[intervals_count];
    cout<<"Enter the left borders of the intervals: ";
    for(int i=0;i<intervals_count;i++){
        cin >> intervals[i];
        res_2[i]=0;
    }

        


    qsort((void*)intervals,intervals_count,sizeof(int),cmp);
    int right_border;
    cout<<"Enter the right border of the last interval: ";
    while(true){
        cin >> right_border;
        if(right_border >= intervals[intervals_count-1] && right_border <=max+1)
            break;
        cout<<"invalid size, enter a new value: ";
    }


    int* numbers=new int[len];
    random_device rd;
    mt19937 gen(rd());
    float mean=float(max+min)/2;
    float stddev=float(max-min)/6;
    normal_distribution<float> dist(min, max);
        int j=0;
        while(j < len){
            int new_val=round(dist(gen));
            if(new_val <= max && new_val >= min){
                numbers[j] = new_val;
                j++;
            }
        }
   

    if(len < 101){
        cout<<"generated values:\n";
        for(int i=0;i<len;i++)
            cout<<numbers[i]<<", ";
        cout<<'\n';
    }



    int* res_1=new int[max-min+1];
    for(int i=0;i<max-min+1;i++)
        res_1[i]=0;
    func1(numbers,len,res_1,min);

    cout<<"Distribution over intervals of length 1: \n";
    for(int i=0;i<max-min+1;i++){
        cout<<i+min<<':'<<res_1[i]<<' ';
    }
 
    cout<<"\n\n";

    func2(res_1,intervals,res_2,right_border,intervals_count,min);
    ofstream file;
    file.open("result.txt");
    string title= "N\tLeft border\tcount\t\n";
    cout<<title;
    file<<title;
    for(int i=0;i<intervals_count;i++){
        string res_string;
        res_string=res_string+to_string(i)+'\t'+to_string(intervals[i]);
        res_string=res_string+"\t\t"+to_string(res_2[i])+'\n';
        cout<<res_string;
        file<<res_string;
    }
    file.close();
}


