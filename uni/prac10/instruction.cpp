#include <iostream>

using namespace std;
 
int main() {

    int B[9];
    int A[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    int i = 9, sum = 0;

    do {
        sum = sum + A[9 - i];
        B[9 - i] = sum;
        i--;
    } while (i != 0);

    for (int j = 0; j < 9; j++) {
        cout << B[j] << "\t";
    }

    cout << endl;

    for (int j = 0; j < 9; j++) {
        cout << A[j] << "\t";
    }

    return 0;
}